//
//  NativeAdView.swift
//
//  Copyright 2018-2020 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

import UIKit

import MoPubSDK

/**
 Provides a common native ad view.
 */
@IBDesignable
class MoPubNativeAdView: UIView {
    // IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var mainTextLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var callToActionButton: UIButton!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var sponsoredByLabel: UILabel!
    
    // IBInspectable
    @IBInspectable var nibName: String? = "MoPubNativeAdView"
    
    // Content View
    private(set) var contentView: UIView? = nil
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNib()
    }
    
    /**
     The function is essential for supporting flexible width. The native view content might be
     stretched, cut, or have undesired padding if the height is not estimated properly.
     */
    static func estimatedViewHeightForWidth(_ width: CGFloat) -> CGFloat {
        // The numbers are obtained from the constraint defined in the xib file
        let padding: CGFloat = 8
        let iconImageViewWidth: CGFloat = 50
        let estimatedNonMainContentCombinedHeight: CGFloat = 72 // [title, main text, call to action] labels
        
        let mainContentWidth = width - padding * 3 - iconImageViewWidth
        let mainContentHeight = mainContentWidth / 2 // the xib has a 2:1 width:height ratio constraint
        return floor(mainContentHeight + estimatedNonMainContentCombinedHeight + padding * 2)
    }
    
    func setupNib() -> Void {
        guard let view = loadViewFromNib(nibName: nibName) else {
            return
        }
        
        // Size the nib's view to the container and add it as a subview.
        view.frame = bounds
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        }
        addSubview(view)
        contentView = view
        
        // Pin the anchors of the content view to the view.
        let viewConstraints = [view.topAnchor.constraint(equalTo: topAnchor),
                               view.bottomAnchor.constraint(equalTo: bottomAnchor),
                               view.leadingAnchor.constraint(equalTo: leadingAnchor),
                               view.trailingAnchor.constraint(equalTo: trailingAnchor)]
        NSLayoutConstraint.activate(viewConstraints)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupNib()
        contentView?.prepareForInterfaceBuilder()
    }
}

extension MoPubNativeAdView: MPNativeAdRendering {
    // MARK: - MPNativeAdRendering
    
    func nativeTitleTextLabel() -> UILabel! {
        return titleLabel
    }
    
    func nativeMainTextLabel() -> UILabel! {
        return mainTextLabel
    }
    
    func nativeCallToActionTextLabel() -> UILabel! {
        return callToActionButton.titleLabel
    }
    
    func nativeIconImageView() -> UIImageView! {
        return iconImageView
    }
    
    func nativeMainImageView() -> UIImageView! {
        return mainImageView
    }
    
    func nativeSponsoredByCompanyTextLabel() -> UILabel! {
        return sponsoredByLabel
    }
}

extension UIView {
    func loadViewFromNib(nibName: String?) -> UIView? {
        guard let nibName = nibName else {
            return nil
        }
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func sizeFitting(view: UIView) -> CGSize {
        var fittingSize: CGSize = .zero
        if #available(iOS 11, *) {
            fittingSize = CGSize(width: view.bounds.width - (view.safeAreaInsets.left + view.safeAreaInsets.right), height: 0)
        }
        else {
            fittingSize = CGSize(width: view.bounds.width, height: 0)
        }
        
        let size = systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return size
    }
}
