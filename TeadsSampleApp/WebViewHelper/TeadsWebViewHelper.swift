//
//  TeadsWebViewHelper.swift
//  TeadsSDK
//
//  Created by Paul NICOLAS on 29/04/2021.
//  Copyright © 2021 Teads. All rights reserved.
//

/// ⚠️ This helper has been provided to give you a hand in your integration webview.
/// It's not designed to work on every integration, it may need to be customised to suit your needs

import TeadsSDK
import UIKit
import WebKit

/// Follow slot javascript lyfecycle
///
/// Methods will be triggered on mainThread or thead from original call
///
@objc public protocol TeadsWebViewHelperDelegate {
    /// This is called when the teads slot is shown.
    @objc optional func webViewHelperSlotStartToShow()

    /// This is called when the teads slot is hidden.
    @objc optional func webViewHelperSlotStartToHide()

    /// This is called when the html element slot has been found.
    /// - Note
    /// This indicates slot specified with `selector` on ``TeadsWebViewHelper/init(webView:selector:delegate:)`` has been found in webview html DOM.
    @objc optional func webViewHelperSlotFoundSuccessfully()

    /// This is called when no slot is found.
    /// - Note
    /// This indicates slot specified with `selector` on ``TeadsWebViewHelper/init(webView:selector:delegate:)`` has **NOT** been found in webview html DOM.
    @objc optional func webViewHelperSlotNotFound()

    /// This is called when an error occured with the reason.
    /// - Parameters:
    ///   - error: Description of issue encountered.
    @objc optional func webViewHelperOnError(error: String)
}

/// Helper to add TeadsInReadAd inside your webView
/// Helper add AdView over webView allowing Teads' rich display ads
@objc public class TeadsWebViewHelper: NSObject, WKScriptMessageHandler {
    private weak var delegate: TeadsWebViewHelperDelegate?
    private weak var webView: WKWebView?

    private let selector: String
    private var noSlotTimer: Timer?

    // only webView.scrollView should retain adView as subView
    weak var adView: UIView?
    weak var containerView: UIView?

    private var adViewConstraints = [NSLayoutConstraint]()

    // latest slot position updated
    private var slotPosition: SlotPosition?
    private var isSlotNotFound: Bool {
        return slotPosition == nil
    }

    // width of element in Web content, needed to compute ratio
    public var adViewHTMLElementWidth: CGFloat {
        if let slotPosition = slotPosition {
            return slotPosition.right - slotPosition.left
        }
        return .zero
    }

    private var webViewObservation: NSKeyValueObservation?

    private var isJsReady = false

    private var slotOpener: (() -> Void)?
    private var slotOpportunity: ((WKWebView, SlotPosition) -> Void)?

    private static let urlKeyPath = NSExpression(forKeyPath: \WKWebView.url).keyPath

    /// Init the Teads webView helper
    ///
    /// - Note: handles slot position injection from TeadsSDK
    ///
    /// - Parameters:
    ///   - webView: webView where you want to add your ad. The receiver holds a weak reference only.
    ///   - selector: name of the html identifier where you want your slot to open `#mySelector` will pick the first [CSS Selector](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors) found in the DOM
    ///   - delegate: optional delegate to follow slot javascript lyfecycle
    ///
    /// - Important: should be called from **main Thread**
    @objc public init(webView: WKWebView, selector: String, delegate: TeadsWebViewHelperDelegate? = nil) {
        self.webView = webView
        self.selector = selector
        self.delegate = delegate
        super.init()

        // URL Change observer
        webView.addObserver(self, forKeyPath: Self.urlKeyPath, options: .new, context: nil)

        // add message handler method name to communicate with the wkwebview
        JSBootstrapOutput.allCases.map(\.rawValue).forEach {
            webView.configuration.userContentController.add(WKWeakScriptHandler(delegate: self), name: $0)
        }
    }

    deinit {
        closeSlot()
        Self.mainThread { [weak webView] in
            JSBootstrapOutput.allCases.map(\.rawValue).forEach {
                webView?.configuration.userContentController.removeScriptMessageHandler(forName: $0)
            }
        }
        webViewObservation = nil
        NotificationCenter.default.removeObserver(self)
    }

    /// Track url requests change in order to reset adView and position tracking
    /// When position is located a new time, alert through ``TeadsWebViewHelperDelegate/webViewHelperSlotFoundSuccessfully()``
    override public func observeValue(forKeyPath keyPath: String?, of _: Any?, change: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        if keyPath == Self.urlKeyPath,
           let _ = change?[NSKeyValueChangeKey.newKey] {
            adView?.removeFromSuperview()
            containerView?.removeFromSuperview()
            slotPosition = nil
        }
    }

    /// Inject Teads' bootstrap in the webview
    /// make sure bootstrap.js file is present in same the bundle of this file
    @objc public func injectJS() {
        guard let webView = webView,
              let bootStrapURL = Bundle(for: Self.self).url(forResource: "bootstrap", withExtension: "js"),
              let data = try? Data(contentsOf: bootStrapURL) else {
            delegate?.webViewHelperOnError?(error: "Unable to load bootstrap.js file, make sure to append to bundle")
            return
        }

        let bootStrap64 = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

        let javascript = """
        javascript:(function() { var scriptElement = document.getElementById('teadsbootstrap'); if(scriptElement) scriptElement.remove();
        var script = document.createElement('script');
        script.innerHTML = window.atob('\(bootStrap64)');
        script.setAttribute('id', 'teadsbootstrap');
        script.setAttribute('type', 'text/javascript');
        document.body.appendChild(script);})()
        """
        webView.evaluateJavaScript(javascript) { [weak delegate, weak self] _, error in
            if error != nil {
                delegate?.webViewHelperOnError?(error: "injection of JS failed")
            }
            self?.isJsReady = true
        }
    }

    /// the bootstrap calls this when it is ready
    /// insert the slot in the webview with the selector
    private func insertSlot() {
        // add a timeout in case we are not able to find the slot
        let timer = Timer(timeInterval: 4, repeats: false) { [weak self] _ in
            self?.slotOpener = nil
            self?.delegate?.webViewHelperSlotNotFound?()
        }
        noSlotTimer = timer
        RunLoop.main.add(timer, forMode: .common)

        evaluateBootstrapInput(JSBootstrapInput.insertPlaceholder(selector)) { [weak self] _, error in
            if error != nil {
                self?.slotOpener = nil
                self?.delegate?.webViewHelperOnError?(error: "insertSlot failed")
                self?.delegate?.webViewHelperSlotNotFound?()
                self?.noSlotTimer?.invalidate()
            }
        }
    }

    /// Call the bootstrap to open the slot
    ///
    /// - Parameters:
    ///   - ad: inRead ad
    ///   - adRatio: ratio of the ad
    ///   - topOffset: topOffset of the View is 0 in most cases,  useful if your website display a top bar and don't want the ad to overlap it
    ///   - bottomOffset: bottomOffset of the View is 0 in most cases,  useful if your website display a bottom bar and don't want the ad to overlap it
    /// - Note:
    ///   should be called from
    ///   ```TeadsInReadAdPlacementDelegate.didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio)```
    @objc public func openSlot(ad: TeadsInReadAd, adRatio: TeadsAdRatio, topOffset: CGFloat = 0.0, bottomOffset: CGFloat = 0.0) {
        openSlot(adView: TeadsInReadAdView(bind: ad), adRatio: adRatio, topOffset: topOffset, bottomOffset: bottomOffset)
    }

    @objc public func openSlot(adView: UIView, adRatio: TeadsAdRatio = .default, topOffset: CGFloat = 0.0, bottomOffset: CGFloat = 0.0) {
        slotOpener = { [self] in
            guard let slotPosition = self.slotPosition else {
                return
            }

            // update slot with the right ratio
            self.updateSlot(adRatio: adRatio)

            // in case openSlot is called multiple times
            self.adView?.removeFromSuperview()
            self.containerView?.removeFromSuperview()

            adView.isHidden = true
            adView.translatesAutoresizingMaskIntoConstraints = false
            self.containerView = createContainerView(topOffset: topOffset, bottomOffset: bottomOffset)
            self.containerView?.addSubview(adView)
            self.adView = adView
            self.updateAdViewPosition(position: slotPosition)
            self.evaluateBootstrapInput(JSBootstrapInput.showPlaceholder(0)) { [weak delegate] _, error in
                if error != nil {
                    delegate?.webViewHelperOnError?(error: "openSlot failed")
                }
            }
            self.slotOpener = nil
        }
        slotOpener?()
    }

    private func createContainerView(topOffset: CGFloat, bottomOffset: CGFloat) -> UIView {
        let container = PassthroughView()
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        if let webView = webView,
           let slotPosition = slotPosition {
            webView.scrollView.addSubview(container)
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: webView.topAnchor, constant: topOffset),
                container.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: -bottomOffset),
                container.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: slotPosition.left),
                container.widthAnchor.constraint(equalToConstant: slotPosition.right - slotPosition.left),
            ])
        }
        return container
    }

    /// Update the slot height with the given ad ratio
    /// - Parameters:
    ///   - adRatio: ratio of the ad
    ///
    /// - Note:
    ///   sould be called from
    ///   ```TeadsInReadAdPlacementDelegate.didUpdateRatio(ratio: TeadsAdRatio)```
    @objc public func updateSlot(adRatio: TeadsAdRatio) {
        guard isJsReady else {
            return
        }
        guard let webView = webView,
              adRatio != .zero else {
            delegate?.webViewHelperOnError?(error: "Webview can't be nil, ratio can't be equals to zero")
            return
        }

        var ratio = adRatio.value(for: adViewHTMLElementWidth)

        // prevent the ad from being bigger than the screen or the webview
        let visibleHeight = min(UIScreen.main.bounds.height, webView.frame.height)
        let heightFromWidthRatio = adRatio.calculateHeight(for: adViewHTMLElementWidth)
        if heightFromWidthRatio > visibleHeight {
            ratio = adViewHTMLElementWidth / visibleHeight
        }

        evaluateBootstrapInput(JSBootstrapInput.updatePlaceholder(offsetHeight: 0, ratioVideo: ratio)) { [delegate] _, error in
            if error != nil {
                delegate?.webViewHelperOnError?(error: "updateSlot failed")
            }
        }
    }

    /// Call the bootstrap to close the slot
    ///
    /// - Note:
    ///   sould be called from
    ///   ```TeadsAdDelegate.onError(ad: TeadsAd, error: Error)```
    @objc public func closeSlot() {
        Self.mainThread { [weak adView] in
            adView?.removeFromSuperview()
        }
        noSlotTimer?.invalidate()
        evaluateBootstrapInput(JSBootstrapInput.hidePlaceholder(0.25)) { [weak delegate] _, error in
            if error != nil {
                delegate?.webViewHelperOnError?(error: "closeSlot failed")
            }
        }
    }

    // MARK: JS Interface

    /// the bootstrap calls this when the slot is updated: slot found or moved to another position due to runtime evolution of the HTML content
    ///
    /// - Parameter position: json describing the position with top/bottom/right/left
    private func onSlotUpdated(position: String?) {
        guard let data = position?.data(using: .utf8),
              let slotPosition = try? JSONDecoder().decode(SlotPosition.self, from: data) else {
            delegate?.webViewHelperOnError?(error: "The json is malformed")
            return
        }
        noSlotTimer?.invalidate()

        if isSlotNotFound {
            // triggered once: only when slot is found
            delegate?.webViewHelperSlotFoundSuccessfully?()
        }

        self.slotPosition = slotPosition
        guard let webView = webView else {
            return
        }
        slotOpportunity?(webView, slotPosition)
        slotOpener?()
        updateAdViewPosition(position: slotPosition)
    }

    // MARK: WKScriptMessageHandler

    public func userContentController(_: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let interface = JSBootstrapOutput(rawValue: message.name) else {
            delegate?.webViewHelperOnError?(error: "WKMessage not supported")
            return
        }
        switch interface {
            case .onTeadsJsLibReady:
                insertSlot()
            case .onSlotStartShow:
                adView?.isHidden = false
                // the bootstrap calls this when the slot starts to show
                delegate?.webViewHelperSlotStartToShow?()
            case .onSlotUpdated:
                onSlotUpdated(position: message.body as? String)
            case .onSlotStartHide:
                adView?.isHidden = true
                // the bootstrap calls this when the slot starts to hide
                delegate?.webViewHelperSlotStartToHide?()
            case .handleError:
                guard let errorString = message.body as? String else {
                    delegate?.webViewHelperOnError?(error: "Unknown error occured")
                    return
                }
                delegate?.webViewHelperOnError?(error: errorString)
        }
    }

    /// Change the constraint of the ad so it follows DOM position
    ///
    /// - Parameters:
    ///   - position: top/bottom/right/left position of the slot
    private func updateAdViewPosition(position: SlotPosition) {
        guard let webView = webView, let adView = adView else {
            return
        }

        let adViewHTMLElementHeight = position.bottom - position.top
        // when the adView is from Admob we can't update the frame without having a new request, so the update is done with an Admob method in the controller
        var shouldUpdateAdViewFrame: Bool {
            if let gadClass = NSClassFromString("GADBannerView"), adView.isKind(of: gadClass) {
                return false
            }
            return true
        }

        NSLayoutConstraint.deactivate(adViewConstraints)
        adViewConstraints.removeAll()
        adViewConstraints.append(adView.leadingAnchor.constraint(equalTo: webView.scrollView.leadingAnchor, constant: position.left))
        adViewConstraints.append(adView.topAnchor.constraint(equalTo: webView.scrollView.topAnchor, constant: position.top))

        if shouldUpdateAdViewFrame {
            adViewConstraints.append(adView.widthAnchor.constraint(equalToConstant: adViewHTMLElementWidth))
            adViewConstraints.append(adView.heightAnchor.constraint(equalToConstant: adViewHTMLElementHeight))
        }

        NSLayoutConstraint.activate(adViewConstraints)
    }

    /// `adOpportunity` is a key metrics to evaluate the performance of your inventory. It builds the visibility score of your placement in publisher dashboards.
    ///
    /// - Parameters:
    ///   - adOpportunityTrackerView: the view that will monitor your inventory
    ///
    @objc public func setAdOpportunityTrackerView(_ adOpportunityTrackerView: TeadsAdOpportunityTrackerView) {
        slotOpportunity = { [weak self] webView, position in
            adOpportunityTrackerView.frame = CGRect(x: position.left, y: position.top, width: 1, height: 1)
            webView.scrollView.addSubview(adOpportunityTrackerView)

            adOpportunityTrackerView.translatesAutoresizingMaskIntoConstraints = false

            adOpportunityTrackerView.topAnchor.constraint(equalTo: webView.scrollView.topAnchor, constant: position.top).isActive = true
            adOpportunityTrackerView.leadingAnchor.constraint(equalTo: webView.scrollView.leadingAnchor, constant: position.left).isActive = true
            adOpportunityTrackerView.widthAnchor.constraint(equalToConstant: 1).isActive = true
            adOpportunityTrackerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            self?.slotOpportunity = nil
        }

        if let position = slotPosition,
           let webView = webView {
            slotOpportunity?(webView, position)
        }
    }
}

// MARK: JSBootstrap I/O

extension TeadsWebViewHelper {
    enum JSBootstrapInput {
        private static let prefix = "javascript:window.teads."

        case insertPlaceholder(String)
        case updatePlaceholder(offsetHeight: CGFloat, ratioVideo: CGFloat)
        case showPlaceholder(CGFloat)
        case hidePlaceholder(CGFloat)

        var command: String {
            switch self {
                case let .insertPlaceholder(value):
                    let method = "insertPlaceholder('%@');"
                    return String(format: Self.prefix + method, value)
                case let .updatePlaceholder(offsetHeight, ratioVideo):
                    let method = "updatePlaceholder({" + "'offsetHeight':%f," + "'ratioVideo':%f" + "});"
                    return String(format: Self.prefix + method, offsetHeight, ratioVideo)
                case let .showPlaceholder(value):
                    let method = "showPlaceholder('%f');"
                    return String(format: Self.prefix + method, value)
                case let .hidePlaceholder(value):
                    let method = "hidePlaceholder('%f');"
                    return String(format: Self.prefix + method, value)
            }
        }
    }

    // js interface
    // method name that will be called by the boostrap
    enum JSBootstrapOutput: String, CaseIterable {
        case onTeadsJsLibReady
        case handleError
        case onSlotUpdated
        case onSlotStartShow
        case onSlotStartHide
    }
}

// MARK: Helpers

extension TeadsWebViewHelper {
    static func mainThread(execute work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }

    /// perform javascript evalutation on main Thread from JSBootstrapInput script
    func evaluateBootstrapInput(_ bootstrap: JSBootstrapInput, completionHandler: ((Any?, Error?) -> Void)? = nil) {
        let script = bootstrap.command
        Self.mainThread { [weak webView] in
            webView?.evaluateJavaScript(script, completionHandler: completionHandler)
        }
    }
}

// MARK: Models

extension TeadsWebViewHelper {
    /// When registering WKWeakScriptHandler, WKWebView create a strong reference to handler
    /// This leads to retain cycle between webView <-> owner and webView <-> scriptHandler
    /// In order to avoid retain cycle
    class WKWeakScriptHandler: NSObject, WKScriptMessageHandler {
        weak var delegate: WKScriptMessageHandler?

        init(delegate: WKScriptMessageHandler) {
            self.delegate = delegate
            super.init()
        }

        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            delegate?.userContentController(userContentController, didReceive: message)
        }
    }

    /// Position of the slot described from Javascript
    struct SlotPosition: Decodable {
        let top: CGFloat
        let bottom: CGFloat
        let right: CGFloat
        let left: CGFloat
    }
}

// MARK: PassthroughView

class PassthroughView: UIView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for view in subviews {
            if point.y > 0,
               point.y < bounds.size.height,
               view.isUserInteractionEnabled,
               view.point(inside: convert(point, to: view), with: event) {
                return true
            }
        }
        return false
    }
}
