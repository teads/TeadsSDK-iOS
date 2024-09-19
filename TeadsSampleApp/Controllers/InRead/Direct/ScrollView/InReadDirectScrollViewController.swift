//
//  InReadDirectScrollViewController.swift
//  TeadsSampleApp
//
//  Created by Jérémy Grosjean on 28/09/2017.
//  Copyright © 2018 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

class InReadDirectScrollViewController: TeadsViewController {
    @IBOutlet var scrollDownImageView: TeadsGradientImageView!
    @IBOutlet var teadsAdView: TeadsInReadAdView!
    @IBOutlet var teadsAdHeightConstraint: NSLayoutConstraint!
    var adRatio: TeadsAdRatio?
    var placement: TeadsPrebidAdPlacement?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Prebid placement
        let adPlacementSettings = TeadsAdPlacementSettings { settings in
            settings.enableDebug() // remove in production
        }
        placement = Teads.createPrebidPlacement(settings: adPlacementSettings, delegate: self)

        // Get the ad request data
        let adRequestSettings = TeadsAdRequestSettings { settings in
            // Ensure to inform your article url or domain url for brand safety matters
            settings.pageUrl("https://www.your.url.com")

            // Add this extra to enable your standalone integration
            settings.addExtras("1", for: TeadsAdapterSettings.prebidStandaloneKey)
        }
        let teadsBidRequestExtraData = try? placement?.getData(requestSettings: adRequestSettings)

        // Prebid request with the getData
        print(teadsBidRequestExtraData)

        // Load ad
        placement?.loadAd(adResponse: PrebidAdResponse.FAKE_TAMEDIA_ADM_RESPONSE, requestSettings: adRequestSettings)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func rotationDetected() {
        if let adRatio = adRatio {
            resizeTeadsAd(adRatio: adRatio)
        }
    }

    func resizeTeadsAd(adRatio: TeadsAdRatio) {
        self.adRatio = adRatio
        teadsAdHeightConstraint.constant = adRatio.calculateHeight(for: teadsAdView.frame.width)
    }

    func closeAd() {
        // be careful if you want to load another ad in the same page don't remove the observer
        NotificationCenter.default.removeObserver(self)
        teadsAdHeightConstraint.constant = 0
    }
}

extension InReadDirectScrollViewController: TeadsInReadAdPlacementDelegate {
    func adOpportunityTrackerView(trackerView: TeadsAdOpportunityTrackerView) {
        teadsAdView.addSubview(trackerView)
    }

    func didReceiveAd(ad: TeadsInReadAd, adRatio: TeadsAdRatio) {
        teadsAdView.bind(ad)
        ad.delegate = self
        resizeTeadsAd(adRatio: adRatio)
    }

    func didFailToReceiveAd(reason _: AdFailReason) {
        closeAd()
    }

    func didUpdateRatio(ad _: TeadsInReadAd, adRatio: TeadsAdRatio) {
        resizeTeadsAd(adRatio: adRatio)
    }
}

extension InReadDirectScrollViewController: TeadsAdDelegate {
    func willPresentModalView(ad _: TeadsAd) -> UIViewController? {
        return self
    }

    func didCatchError(ad _: TeadsAd, error _: Error) {
        closeAd()
    }

    func didClose(ad _: TeadsAd) {
        closeAd()
    }

    func didRecordImpression(ad _: TeadsAd) {}

    func didRecordClick(ad _: TeadsAd) {}

    func didExpandedToFullscreen(ad _: TeadsAd) {}

    func didCollapsedFromFullscreen(ad _: TeadsAd) {}
}

enum PrebidAdResponse {
    // Ad that will evoke resizing callbacks
    static let FAKE_VAST_URL = "https://s8t.teads.tv/vast/a7165340-d714-11ee-9d18-8d6ab288a268"

    static let FAKE_VAST_CONTENT = "<VAST xmlns:xsi=\\\\\\\"http://www.w3.org/2001/XMLSchema-instance\\\\\\\" version=\\\\\\\"2.0\\\\\\\"><Ad id=\\\\\\\"5766402401632256\\\\\\\"><InLine><AdSystem>Brainient8</AdSystem><AdTitle><![CDATA[Brainient8 6833-5766402401632256]]></AdTitle><Impression><![CDATA[https://studio-t.teads.tv/track?action=studio_impression&studio_cid=5766402401632256&random=[CACHEBUSTING]&]]></Impression><Creatives><Creative sequence=\\\\\\\"1\\\\\\\"><Linear><Duration>00:00:15</Duration><MediaFiles><MediaFile id=\\\\\\\"brhtml5\\\\\\\" delivery=\\\\\\\"progressive\\\\\\\" width=\\\\\\\"960\\\\\\\" height=\\\\\\\"540\\\\\\\" type=\\\\\\\"application/javascript\\\\\\\" apiFramework=\\\\\\\"VPAID\\\\\\\"><![CDATA[https://s8t.teads.tv/vpaid/5766402401632256]]></MediaFile></MediaFiles></Linear></Creative></Creatives></InLine></Ad></VAST>"

    static let XML_TYPE = "VastXml"
    static let URL_TYPE = "VastUrl"

    static let VAST_TYPE = URL_TYPE
    static let VAST_CONTENT = FAKE_VAST_URL

    static let FAKE_ADM_CONTENT = "{\\\"ads\\\":[{\\\"settings\\\":{\\\"values\\\":{\\\"animations\\\":{\\\"expand\\\":0,\\\"collapse\\\":0.5},\\\"placementId\\\":84242,\\\"adType\\\":\\\"video\\\",\\\"placementFormat\\\":\\\"inread\\\",\\\"allowedPlayer\\\":\\\"any\\\",\\\"threshold\\\":50,\\\"pageId\\\":77781},\\\"components\\\":{\\\"closeButton\\\":{\\\"display\\\":false,\\\"countdown\\\":0},\\\"label\\\":{\\\"display\\\":true,\\\"text\\\":\\\"\\\"},\\\"credits\\\":{\\\"display\\\":false},\\\"soundButton\\\":{\\\"display\\\":true,\\\"countdown\\\":0,\\\"type\\\":\\\"equalizer\\\"},\\\"slider\\\":{\\\"closeButtonDisplay\\\":false}},\\\"behaviors\\\":{\\\"smartPosition\\\":{\\\"top\\\":false,\\\"corner\\\":false,\\\"mustBypassWhitelist\\\":true},\\\"slider\\\":{\\\"enable\\\":false},\\\"playerClick\\\":\\\"fullscreen\\\",\\\"soundStart\\\":{\\\"type\\\":\\\"mute\\\"},\\\"soundMute\\\":\\\"threshold\\\",\\\"soundOver\\\":\\\"over\\\",\\\"launch\\\":\\\"auto\\\",\\\"videoStart\\\":\\\"threshold\\\",\\\"videoPause\\\":\\\"threshold\\\",\\\"secure\\\":false,\\\"friendly\\\":false}},\\\"type\\\":\\\"\(VAST_TYPE)\\\",\\\"content\\\":\\\"\(VAST_CONTENT)\\\",\\\"connection_id\\\":460794,\\\"scenario_id\\\":18603,\\\"dsp_campaign_id\\\":\\\"590162\\\",\\\"ad_source_id\\\":200,\\\"dsp_creative_id\\\":\\\"625187\\\",\\\"insertion_id\\\":590162,\\\"placement_id\\\":84242,\\\"portfolio_item_id\\\":1,\\\"early_click_protection_duration\\\":0,\\\"exclusiveAdOnScreen\\\":false}],\\\"wigoEnabled\\\":false,\\\"placementMetadata\\\":{\\\"84242\\\":{\\\"auctionId\\\":\\\"a9995fbe-1cb5-4e1a-858f-266903d7d772\\\"}},\\\"viewerId\\\":\\\"b1aefcc416eb3116e70d52e5ac0618abcf6645f4\\\"}"

    static let FAKE_TAMEDIA_ADM_RESPONSE = "{\"id\":\"58343531-5f75-4b9b-889a-2b069390bdc0\",\"impid\":\"2348926d-ba31-4fc3-a092-6b68f3daa264\",\"price\":5.14,\"nurl\":\"https://a.teads.tv/prebid-server/win-notice?data=CgQIuLwMEgQImvcHGgQIq5EBIgQI%2Bo8cKgQIq5EBMgQI%2Bo8cOgQI9bdCQgQIo5QmSggKBjYyNTE4N1IJCgcxMDg4NTAxWvkBCiYKJDAwMDAwMDAwLTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMRK9AQq6AVJhdyhNb3ppbGxhLzUuMCAoTGludXg7IEFuZHJvaWQgOTsgQW5kcm9pZCBTREsgYnVpbHQgZm9yIGFybTY0IEJ1aWxkL1BTUjEuMjEwMzAxLjAwOS5CMTsgd3YpIEFwcGxlV2ViS2l0LzUzNy4zNiAoS0hUTUwsIGxpa2UgR2Vja28pIFZlcnNpb24vNC4wIENocm9tZS82Ni4wLjMzNTkuMTU4IE1vYmlsZSBTYWZhcmkvNTM3LjM2KRoPCg05MS4xMjYuMjE4LjI0YnIKcDIzNDg5MjZkLWJhMzEtNGZjMy1hMDkyLTZiNjhmM2RhYTI2NF9fMjM0ODkyNmQtYmEzMS00ZmMzLWEwOTItNmI2OGYzZGFhMjY0X19kNWNlYzQ1Yi05ZjFjLTQxODktYjRiMS0wNDEyYzNjODllYzJqCAoGMjA0MzQ0egsKCXNkay1pbmFwcIIBAggBkgFQCiQKIm9yZy5wcmViaWQubW9iaWxlLnJlbmRlcmluZ3Rlc3RhcHASHgocUHJlYmlkIFJlbmRlcmluZyBLb3RsaW4gRGVtbxoICgZnb29nbGWiAQUKA1VTRKoBIwoaChhjamExNW9HQ1J4dHYxdm90clR1bEZhRWkSBQoDVVNE&clearingPrice=5.14&clearingPriceCurr=CHF\",\"adm\":\"{\\\"ads\\\":[{\\\"settings\\\":{\\\"values\\\":{\\\"animations\\\":{\\\"expand\\\":0,\\\"collapse\\\":0.5},\\\"placementId\\\":84242,\\\"adType\\\":\\\"video\\\",\\\"placementFormat\\\":\\\"inread\\\",\\\"allowedPlayer\\\":\\\"any\\\",\\\"threshold\\\":50,\\\"pageId\\\":77781},\\\"components\\\":{\\\"closeButton\\\":{\\\"display\\\":false,\\\"countdown\\\":0},\\\"label\\\":{\\\"display\\\":true,\\\"text\\\":\\\"\\\"},\\\"credits\\\":{\\\"display\\\":false},\\\"soundButton\\\":{\\\"display\\\":true,\\\"countdown\\\":0,\\\"type\\\":\\\"equalizer\\\"},\\\"slider\\\":{\\\"closeButtonDisplay\\\":false}},\\\"behaviors\\\":{\\\"smartPosition\\\":{\\\"top\\\":false,\\\"corner\\\":false,\\\"mustBypassWhitelist\\\":true},\\\"slider\\\":{\\\"enable\\\":false},\\\"playerClick\\\":\\\"fullscreen\\\",\\\"soundStart\\\":{\\\"type\\\":\\\"mute\\\"},\\\"soundMute\\\":\\\"threshold\\\",\\\"soundOver\\\":\\\"over\\\",\\\"launch\\\":\\\"auto\\\",\\\"videoStart\\\":\\\"threshold\\\",\\\"videoPause\\\":\\\"threshold\\\",\\\"secure\\\":false,\\\"friendly\\\":false}},\\\"type\\\":\\\"VastUrl\\\",\\\"content\\\":\\\"https://s8t.teads.tv/vast/a7165340-d714-11ee-9d18-8d6ab288a268\\\",\\\"connection_id\\\":460794,\\\"scenario_id\\\":18603,\\\"dsp_campaign_id\\\":\\\"590162\\\",\\\"ad_source_id\\\":200,\\\"dsp_creative_id\\\":\\\"625187\\\",\\\"insertion_id\\\":590162,\\\"placement_id\\\":84242,\\\"portfolio_item_id\\\":1,\\\"early_click_protection_duration\\\":0,\\\"exclusiveAdOnScreen\\\":false}],\\\"wigoEnabled\\\":false,\\\"placementMetadata\\\":{\\\"84242\\\":{\\\"auctionId\\\":\\\"a9995fbe-1cb5-4e1a-858f-266903d7d772\\\"}},\\\"viewerId\\\":\\\"b1aefcc416eb3116e70d52e5ac0618abcf6645f4\\\"}\",\"adid\":\"625187\",\"adomain\":[\"teads.com\"],\"cid\":\"1088501\",\"crid\":\"625187\",\"cat\":[\"IAB12\"],\"ext\":{\"prebid\":{\"meta\":{\"rendererName\":\"teads\",\"rendererVersion\":\"1.0.0\",\"rendererData\":{\"resize\":true,\"sdkEngineVersion\":\"189\"}}}}}"

    static let FAKE_WINNING_BID_RESPONSE = "{\"id\":\"prebid-demo-response-video-outstream\",\"impid\":\"03ec3cdd-e144-40bd-98cc-1947235ce897\",\"price\":0.11701999999468729,\"nurl\":\"https://localhost:8080/prebid-server/win-notice?data=base64&clearingPrice=${1000}\",\"adm\":\"\(FAKE_ADM_CONTENT)\",\"adid\":\"test-ad-id-12345\",\"adomain\":[\"prebid.org\"],\"crid\":\"test-creative-id-1\",\"cid\":\"test-cid-1\",\"ext\":{\"prebid\":{\"type\":\"video\",\"targeting\":{\"hb_pb\":\"0.10\",\"hb_env\":\"mobile-app\",\"hb_size_prebid\":\"300x250\",\"hb_pb_prebid\":\"0.10\",\"hb_bidder_prebid\":\"prebid\",\"hb_size\":\"300x250\",\"hb_bidder\":\"prebid\",\"hb_env_prebid\":\"mobile-app\"},\"meta\":{\"renderername\":\"SampleRendererName\",\"rendererversion\":\"1.0\"}},\"origbidcpm\":0.11701999999468729,\"origbidcur\":\"USD\"}}"
}
