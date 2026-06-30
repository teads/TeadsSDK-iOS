//
//  NativeAppLovinTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import AppLovinSDK
import SwiftUI
import TeadsAppLovinAdapter
import TeadsSDK

struct NativeAppLovinTableViewSample: View {
    let pid: String

    @State private var loadedAdView: MANativeAdView?
    @State private var loaderHolder = AppLovinNativeLoaderHolder()
    @State private var showSimulatorWarning = false

    private static let articleCount = 8
    private static let adIndex = 3

    var body: some View {
        List {
            ArticleHeaderImage()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            ForEach(0 ..< Self.articleCount, id: \.self) { index in
                Group {
                    if index == Self.adIndex, let adView = loadedAdView {
                        AppLovinNativeAdHost(adView: adView)
                            .frame(height: 400)
                            .padding(.horizontal, 10)
                    } else {
                        FakeNativeArticleRow()
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .teadsBrandNavigationBar()
        .onAppear {
            #if targetEnvironment(simulator)
            showSimulatorWarning = true
            #endif
            loaderHolder.load(adUnitID: pid) { adView in loadedAdView = adView }
        }
        .alert("Warning", isPresented: $showSimulatorWarning) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Teads AppLovin adapter does not work on simulator.")
        }
    }
}

@MainActor
private final class AppLovinNativeLoaderHolder: NSObject, MANativeAdDelegate {
    private var loader: MANativeAdLoader?
    private var adView: MANativeAdView?
    private var onAd: ((MANativeAdView) -> Void)?

    func load(adUnitID: String, completion: @escaping (MANativeAdView) -> Void) {
        onAd = completion
        let loader = MANativeAdLoader(adUnitIdentifier: adUnitID)
        let settings = TeadsAdapterSettings { settings in
            settings.enableDebug()
            settings.pageUrl("https://www.teads.com")
        }
        loader.register(teadsAdSettings: settings)
        loader.nativeAdDelegate = self

        let view = MANativeAdView()
        view.bindViews(with: MANativeAdViewBinder { builder in
            builder.titleLabelTag = 1
            builder.advertiserLabelTag = 2
            builder.bodyLabelTag = 3
            builder.iconImageViewTag = 4
            builder.optionsContentViewTag = 5
            builder.mediaContentViewTag = 6
            builder.callToActionButtonTag = 7
        })
        adView = view
        loader.loadAd(into: view)
        self.loader = loader
    }

    nonisolated func didLoadNativeAd(_ nativeAdView: MANativeAdView?, for _: MAAd) {
        guard let nativeAdView else { return }
        Task { @MainActor in onAd?(nativeAdView) }
    }

    nonisolated func didFailToLoadNativeAd(forAdUnitIdentifier _: String, withError error: MAError) {
        print("AppLovin native failed: \(error.message)")
    }

    nonisolated func didClickNativeAd(_: MAAd) {}
}

private struct AppLovinNativeAdHost: UIViewRepresentable {
    let adView: MANativeAdView
    func makeUIView(context _: Context) -> UIView { adView }
    func updateUIView(_: UIView, context _: Context) {}
}

#Preview {
    NavigationStack {
        NativeAppLovinTableViewSample(pid: SamplePID.appLovinNativeDisplay)
    }
}
