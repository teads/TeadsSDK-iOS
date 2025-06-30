//
//  TeadsPBMPluginError.swift
//  TeadsPBMPluginRenderer
//
//  Refactored by Richard Dépierre on 18/06/2025.
//

import Foundation

// MARK: - Teads Plugin Error

/// Defines all errors emitted by the Teads Prebid plugin renderer.
public enum TeadsPBMPluginError: Int, CustomNSError {
    /// Prebid placement initialization failed.
    case placementInitialization = 1
    /// String encoding of bid response failed.
    case stringEncoding = 2
    /// JSON serialization of bid response failed.
    case jsonSerialization = 3

    case viewMissing = 4

    case adLoadError = 5

    // MARK: - CustomNSError Conformance

    /// The error domain for all `TeadsPluginError` values.
    public static var errorDomain: String { "tv.teads.prebid.error" }

    /// Numeric error code (same as raw value).
    public var errorCode: Int { rawValue }

    /// A human-readable description of the error.
    public var errorDescription: String {
        switch self {
            case .placementInitialization:
                return "Teads Prebid placement not initialized"
            case .stringEncoding:
                return "Unable to encode bid response to string"
            case .jsonSerialization:
                return "JSON serialization failed"
            case .viewMissing:
                return "Ad placement container view is missing"
            case .adLoadError:
                return "Failed to load ad from Teads Prebid placement"
        }
    }

    /// Additional user info for NSError compatibility.
    public var errorUserInfo: [String: Any] {
        [
            NSLocalizedDescriptionKey: errorDescription,
            NSLocalizedFailureReasonErrorKey: errorDescription,
        ]
    }
}
