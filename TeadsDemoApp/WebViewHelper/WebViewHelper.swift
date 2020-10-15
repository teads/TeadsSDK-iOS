//
//  WebViewHelper.swift
//  TeadsSDK
//
//  Created by Jérémy Grosjean on 14/09/2017.
//  Copyright © 2017 Teads. All rights reserved.
//

import UIKit
import WebKit

@objc public protocol WebViewHelperDelegate {
    /// is called when the teads bootstrap is ready
    func webViewHelperJSIsReady()
    /// is called when the teads slot is shown
    func webViewHelperSlotStartToShow()
    /// is called when the teads slot is hidden
    func webViewHelperSlotStartToHide()
    /// is called when the teadsAd position is updated
    func webViewHelperUpdatedSlot(left: Int, top: Int, right: Int, bottom: Int)
    /// is called when no slot is found
    func webViewHelperSlotNotFound()
    /// is called when an error occured with the reason
    func webViewHelperOnError(error: String)
}

public class WebViewHelper: NSObject, WKScriptMessageHandler {
    
    private static let insertSlotJSMethod = "javascript:window.utils.insertPlaceholder('%@');"
    private static let updateSlotJSMethod = "javascript:window.utils.updatePlaceholder({" +
        "'offsetHeight':%f," +
        "'ratioVideo':%f" +
    "});"
    private static let openSlotJSMethod = "javascript:window.utils.showPlaceholder('%f');"
    private static let closeSlotJSMethod = "javascript:window.utils.hidePlaceholder('%f');"
    
    // js interface
    private static let onTeadsJsLibReady = "onTeadsJsLibReady"
    private static let handleError = "handleError"
    private static let onSlotUpdated = "onSlotUpdated"
    private static let onSlotStartShow = "onSlotStartShow"
    private static let onSlotStartHide = "onSlotStartHide"
    
    private var noSlotTimer: Timer?
    
    public weak var delegate: WebViewHelperDelegate?
    weak var userContentController: WKUserContentController?
    
    //method name that will be called by the boostrap
    let webViewHelperMethods = ["debug", WebViewHelper.onTeadsJsLibReady, WebViewHelper.handleError, WebViewHelper.onSlotUpdated, WebViewHelper.onSlotStartShow, WebViewHelper.onSlotStartHide]
    
    weak var webView: WKWebView?
    let selector: String
    
    /// Init the webView helper
    ///
    /// - Parameters:
    ///   - webView: webView where you want to add your ad
    ///   - selector: name of the selector where you want your slot to open
    public init(webView: WKWebView, selector: String) {
        self.webView = webView
        self.selector = selector
        super.init()
        
        self.userContentController = self.webView?.configuration.userContentController
        //add message handler method name to communicate with the wkwebview
        if let userContentController = self.userContentController {
            for methodName in self.webViewHelperMethods {
                userContentController.add(self, name: methodName)
            }
        }
        
    }
    
    //remove all scripts message handler to prevent leak
    func clean() {
        if let userContentController = self.userContentController {
            for methodName in webViewHelperMethods {
                userContentController.removeScriptMessageHandler(forName: methodName)
            }
        }
    }
    
    /// Inject Teads' bootstrap in the webview
    public func injectJS() {
        guard let webView = self.webView,
            let bootStrapPath = Bundle.main.path(forResource: "bootstrap", ofType: "js"),
            let bootStrapString = try? String(contentsOfFile: bootStrapPath) else {
                return
        }
        let data = (bootStrapString).data(using: String.Encoding.utf8)
        let bootStrap64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        let javascript = """
        javascript:(function() { var scriptElement = document.getElementById('teadsbootstrap'); if(scriptElement) scriptElement.remove();
        var script = document.createElement('script');
        script.innerHTML = window.atob('\(bootStrap64)');
        script.setAttribute('id', 'teadsbootstrap');
        script.setAttribute('type', 'text/javascript');
        document.body.appendChild(script);})()
        """
        webView.evaluateJavaScript(javascript, completionHandler: { (_, error) in
            if error != nil {
                self.delegate?.webViewHelperOnError(error: "injection of JS failed")
            }
        })
    }
    
    /// insert the slot in the webview with the selector
    public func insertSlot() {
        if let webView = self.webView {
            //add a timeout in case we are not able to find the slot
            self.noSlotTimer = Timer(timeInterval: 4, target: self, selector: #selector(self.noSlotTimeout), userInfo: nil, repeats: false)
            
            #if swift(>=4.2)
                RunLoop.main.add(self.noSlotTimer!, forMode: RunLoop.Mode.common)
            #else
                RunLoop.main.add(self.noSlotTimer!, forMode: RunLoopMode.commonModes)
            #endif
            
            let openSlotWithSelectorMethod = String(format: WebViewHelper.insertSlotJSMethod, self.selector)
            webView.evaluateJavaScript(openSlotWithSelectorMethod) { (_, error) in
                if error != nil {
                    self.delegate?.webViewHelperOnError(error: "insertSlot failed")
                    self.delegate?.webViewHelperSlotNotFound()
                    self.noSlotTimer?.invalidate()
                }
            }
        }
    }
    
    @objc private func noSlotTimeout() {
        self.delegate?.webViewHelperSlotNotFound()
    }
    
    /// Update the slot height with the given ad ratio
    /// - Parameters:
    ///   - adRatio: ratio of the ad
    public func updateSlot(adRatio: CGFloat) {
        if let webView = self.webView {
            
            //prevent the ad from being bigger than the screen or the webview
            var correctedRatio = adRatio
            let visibleHeight = min(UIScreen.main.bounds.height, webView.frame.height)
            let heightWithRatio = webView.frame.width/adRatio
            if heightWithRatio > visibleHeight {
                correctedRatio = webView.frame.width/visibleHeight
            }
            
            let updateSlotMethod = String(format: WebViewHelper.updateSlotJSMethod, 0.0, correctedRatio)
            webView.evaluateJavaScript(updateSlotMethod) { (_, error) in
                if error != nil {
                    self.delegate?.webViewHelperOnError(error: "updateSlot failed")
                }
            }
        }
    }
    
    /// Call the bootstrap to open the slot
    public func openSlot() {
        if let webView = self.webView {
            let openSlotMethod = String(format: WebViewHelper.openSlotJSMethod, 0)
            webView.evaluateJavaScript(openSlotMethod) { (_, error) in
                if error != nil {
                    self.delegate?.webViewHelperOnError(error: "openSlot failed")
                }
            }
        }
    }
    
    /// Call the bootstrap to close the slot
    public func closeSlot() {
        if let webView = self.webView {
            let closeSlotMethod = String(format: WebViewHelper.closeSlotJSMethod, 0.25)
            webView.evaluateJavaScript(closeSlotMethod) { (_, error) in
                if error != nil {
                    self.delegate?.webViewHelperOnError(error: "closeSlot failed")
                }
            }
        }
    }
    
    // MARK: JS Interface
    
    //the bootstrap calls this when it is ready
    func teadsJSIsLibReady() {
        self.insertSlot()
    }
    
    //the bootstrap calls this when the slot starts to hide
    func onSlotStartToHide() {
        self.delegate?.webViewHelperSlotStartToHide()
    }
    
    //the bootstrap calls this when the slot starts to show
    func onSlotStartToShow() {
        self.delegate?.webViewHelperSlotStartToShow()
    }
    
    ///the bootstrap calls this when the slot is updated
    ///
    /// - Parameter position: json of the position with top/bottom/right/left
    func onSlotUpdated(position: String?) {
        if let positionString = position,
            let data = positionString.data(using: .utf8),
            let positionDict = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
            guard let top = positionDict["top"] as? Int,
                let bottom = positionDict["bottom"] as? Int,
                let right = positionDict["right"] as? Int,
                let left = positionDict["left"] as? Int else {
                    return
            }
            self.noSlotTimer?.invalidate()
            self.delegate?.webViewHelperUpdatedSlot(left: left, top: top, right: right, bottom: bottom)
        } else {
            self.delegate?.webViewHelperOnError(error: "The json is malformed")
        }
    }
    
    // MARK: WKScriptMessageHandler
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        switch message.name {
        case WebViewHelper.onTeadsJsLibReady:
            self.teadsJSIsLibReady()
            self.delegate?.webViewHelperJSIsReady()

        case WebViewHelper.handleError:
            guard let errorString = message.body as? String else {
                return
            }
            self.delegate?.webViewHelperOnError(error: errorString)
            
        case WebViewHelper.onSlotStartHide:
            self.onSlotStartToHide()
            
        case WebViewHelper.onSlotStartShow:
            self.onSlotStartToShow()
            
        case WebViewHelper.onSlotUpdated:
            self.onSlotUpdated(position: message.body as? String)
            
        default:
            break
        }
    }
}
