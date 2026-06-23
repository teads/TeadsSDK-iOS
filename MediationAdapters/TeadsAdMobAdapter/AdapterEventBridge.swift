//
//  AdapterEventBridge.swift
//  TeadsAdMobAdapter
//

import Foundation
import GoogleMobileAds
import TeadsSDK

// Mirrors TeadsSDK's internal payload-key contract
private enum PayloadKey {
    static let reason = "reason"
    static let errorCode = "errorCode"
}

enum AdapterEventBridge {
    static func handle(
        event: TeadsAdPlacementEventName,
        data: [String: Any]?,
        delegate: MediationAdEventDelegate?,
        resolveLoad: inout ((Result<Void, Error>) -> Void)?
    ) {
        switch event {
            // GMA drops failure callbacks once load has succeeded, so resolve on `.loaded`
            // (real fill) not `.ready` (widget alive only).
            case .loaded:
                guard let resolve = resolveLoad else { return }
                resolveLoad = nil
                resolve(.success(()))

            case .failed:
                let reason = data?[PayloadKey.reason] as? String
                let errorCode = data?[PayloadKey.errorCode] as? AdErrorCode
                if let resolve = resolveLoad {
                    resolveLoad = nil
                    resolve(.failure(TeadsAdMobErrorMapper.error(reason: reason, errorCode: errorCode, phase: .load)))
                } else {
                    delegate?.didFailToPresentWithError(TeadsAdMobErrorMapper.error(reason: reason, errorCode: errorCode, phase: .show))
                }

            case .clicked:
                delegate?.reportClick()

            case .viewed:
                delegate?.reportImpression()

            default:
                break
        }
    }
}
