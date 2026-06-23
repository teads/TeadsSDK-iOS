//
//  TeadsAdMobErrorMapper.swift
//  TeadsAdMobAdapter
//

import Foundation
import GoogleMobileAds
@_spi(Adapters) import TeadsSDK

/// Maps Teads failure reasons to GMA-native `RequestError` codes, reported in the
/// adapter's own `tv.teads.adapter` domain (never `GADErrorDomain`) with the precise
/// Teads reason preserved in userInfo.
///
/// No-fill is load-phase only: a show-phase failure never maps to no-fill.
/// The mediation-core codes (`.mediationDataError` / `.mediationAdapterError` /
/// `.mediationInvalidAdSize`) are never emitted.
enum TeadsAdMobErrorMapper {
    enum Phase {
        case load
        case show
    }

    enum PreRequestFailure {
        case serverParameters
        case placementIdentifierMissing
        case appIdentifierMissing
    }

    static func error(from reason: AdFailReason) -> NSError {
        makeError(code: gadCode(reason.loaderErrorType, fallback: reason.code), message: reason.description)
    }

    static func error(reason: String?, errorCode: AdErrorCode?, phase: Phase) -> NSError {
        let code: RequestError.Code
        if phase == .show {
            // The SDK emits no typed code at show, so this exact reason is the only
            // TTL-timeout signal. A typed show-signal would remove it.
            code = reason == expiredReason ? .timeout : .internalError
        } else {
            code = errorCode.map(gadCode(for:)) ?? .internalError
        }
        return makeError(code: code, message: reason ?? "Unknown error")
    }

    static func error(preRequest failure: PreRequestFailure) -> NSError {
        switch failure {
            case .serverParameters:
                return makeError(code: .invalidArgument, message: "Server parameters are missing or not valid JSON")
            case .placementIdentifierMissing:
                return makeError(code: .invalidRequest, message: "Placement identifier (PID) is missing")
            case .appIdentifierMissing:
                return makeError(code: .applicationIdentifierMissing, message: "Application bundle identifier is missing")
        }
    }

    /// Guards the host app's bundle id (GMA validates its own app id separately). nil when present.
    static func appIdentifierError() -> NSError? {
        (Bundle.main.bundleIdentifier ?? "").isEmpty ? error(preRequest: .appIdentifierMissing) : nil
    }

    private static let expiredReason = "Ad expired"

    // MARK: - Private

    private static func makeError(code: RequestError.Code, message: String) -> NSError {
        NSError(
            domain: TeadsAdapterErrorCode.errorDomain,
            code: code.rawValue,
            userInfo: [
                NSLocalizedDescriptionKey: message,
                NSLocalizedFailureReasonErrorKey: message,
            ]
        )
    }

    private static func gadCode(_ type: AdLoaderErrorType?, fallback: AdErrorCode) -> RequestError.Code {
        guard let type else { return gadCode(for: fallback) }
        switch type {
            case .notFilled, .noResponse, .fraud:
                return .noFill
            case .networkError, .timeout:
                return .networkError
            case .serverError, .statusCode:
                return .serverError
            case .badResponse, .richParsingError, .incompatibleAdReceived, .incompatibilityContext, .vastError:
                return .receivedInvalidAdString
            @unknown default:
                return .internalError
        }
    }

    private static func gadCode(for code: AdErrorCode) -> RequestError.Code {
        switch code {
            case .errorNotFilled:
                return .noFill
            case .errorNetwork:
                return .networkError
            case .errorBadResponse, .errorVastError:
                return .receivedInvalidAdString
            case .errorNoSlot, .errorUserIdMissing, .disabledApp:
                return .invalidRequest
            case .errorAdRequest:
                return .serverError
            case .errorInternal:
                return .internalError
            @unknown default:
                return .internalError
        }
    }
}
