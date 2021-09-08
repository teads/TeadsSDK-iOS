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
    case loadingFailure
}

extension NSError {

    static func from(code: TeadsAdapterErrorCode,
                     description: String,
                     domain: String) -> Error {

        let userInfo = [NSLocalizedDescriptionKey: description,
                        NSLocalizedFailureReasonErrorKey: description]

        return NSError(domain: domain,
                       code: code.rawValue,
                       userInfo: userInfo)
    }
}
