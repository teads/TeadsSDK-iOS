//
//  WebViewArticleHTML.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import Foundation

/// Shared HTML article scaffold used by the WebView samples (Direct and AdMob).
///
/// Contains a `#teads-placement-slot` element that `TeadsWebViewHelper` discovers to inject
/// the Teads ad container.
enum WebViewArticleHTML {
    static let document = """
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
        <style>
            :root { color-scheme: light dark; }
            body { font-family: -apple-system, sans-serif; margin: 16px; }
            h1 { font-size: 26px; }
            p { font-size: 17px; line-height: 1.5; }
            .spacer { height: 60vh; }
        </style>
    </head>
    <body>
        <h1>The Future of Digital Advertising</h1>
        <p>InRead ads live inside the article flow, delivering higher engagement and better brand recall.</p>
        <div class="spacer"></div>
        <div id="teads-placement-slot"></div>
        <div class="spacer"></div>
        <p>End of article 👋</p>
    </body>
    </html>
    """
}
