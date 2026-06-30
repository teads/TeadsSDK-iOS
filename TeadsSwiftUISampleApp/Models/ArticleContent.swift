//
//  ArticleContent.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import Foundation

enum ArticleContent {
    static let title = "The Future of Digital Advertising"

    static let lead = """
    The digital advertising landscape is undergoing a profound transformation. \
    As privacy regulations tighten and third-party cookies phase out, publishers \
    and advertisers are rethinking how they connect with audiences.
    """

    static let previewParagraph = """
    The digital advertising landscape is undergoing a profound transformation. \
    As privacy regulations tighten and third-party cookies phase out, publishers \
    and advertisers are rethinking how they connect with audiences. New formats \
    like interstitial ads offer immersive, full-screen experiences that capture \
    attention while respecting user choice.
    """

    static let lockedParagraphs = paragraphs

    static let paragraphs = [
        """
        InRead ads have emerged as one of the most effective formats for mobile content. \
        Unlike banners competing for attention within a crowded interface, InRead placements \
        live inside the article flow, delivering higher engagement and better brand recall.
        """,
        """
        Publishers who integrate ads at natural content breaks see significantly improved \
        monetization without sacrificing user experience. The key lies in timing and relevance.
        """,
        """
        Combined with server-side optimization for ad quality and frequency capping, premium \
        formats achieve the delicate balance between revenue and user satisfaction that every \
        publisher seeks.
        """,
        """
        Looking ahead, the convergence of contextual targeting, first-party data, and premium \
        ad formats will define the next era of digital advertising.
        """,
        """
        Publishers who invest in these capabilities today will be best positioned to thrive in a \
        privacy-first world where user trust is the ultimate currency.
        """,
    ]
}
