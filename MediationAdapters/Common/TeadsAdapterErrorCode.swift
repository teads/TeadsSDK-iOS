//
//  TeadsAdapterErrorCode.swift
//  MediationAdapters
//
//  Created by Antoine Barrault on 16/07/2021.
//

import Foundation

/// Enumeration defining possible errors in Teads adapter.
public enum TeadsAdapterErrorCode: Int {
    case pidNotFound
    case serverParameterError
    case loadError
}

extension TeadsAdapterErrorCode: CustomNSError {
    var localizedDescription: String {
        switch self {
        case .pidNotFound:
            return "No valid PID has been provided to load Teads ad."
        case .serverParameterError:
            return "serverParameterString is not a jSON"
        case .loadError:
            return "Teads ad can't be initialized"
        }
    }

    public static var errorDomain: String {
        return "tv.teads.adapter"
    }

    public var errorCode: Int {
        return rawValue
    }

    public var errorUserInfo: [String: Any] {
        return [NSLocalizedDescriptionKey: localizedDescription, NSLocalizedFailureReasonErrorKey: localizedDescription]
    }
}
