//
//  NativeSASTableViewSample.swift
//  TeadsSwiftUISampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

@preconcurrency import SASDisplayKit
import SwiftUI
import TeadsSASAdapter

struct NativeSASTableViewSample: View {
    @State private var nativeAd: SASNativeAd?
    @State private var adManagerHolder = SASNativeAdHolder()

    private static let articleCount = 8
    private static let adIndex = 3

    var body: some View {
        List {
            ArticleHeaderImage()
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)

            ForEach(0 ..< Self.articleCount, id: \.self) { index in
                Group {
                    if index == Self.adIndex, let ad = nativeAd {
                        SASNativeAdHost(ad: ad)
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
        .onAppear { adManagerHolder.load { ad in nativeAd = ad } }
    }
}

@MainActor
private final class SASNativeAdHolder {
    private var manager: SASNativeAdManager?

    func load(completion: @escaping (SASNativeAd) -> Void) {
        let settings = TeadsAdapterSettings { settings in
            settings.pageUrl("https://example.com/article1")
        }
        var keywords = "yourkw=something"
        keywords = TeadsSASAdapterHelper.concatAdSettingsToKeywords(keywordsStrings: keywords, adSettings: settings)
        let placement = SASAdPlacement(
            siteId: SamplePID.sasSiteId,
            pageId: SamplePID.sasPageId,
            formatId: SamplePID.sasNativeDisplay,
            keywordTargeting: keywords
        )
        let manager = SASNativeAdManager(placement: placement)
        self.manager = manager

        DispatchQueue.global(qos: .background).async {
            manager.requestAd { ad, error in
                if let ad {
                    DispatchQueue.main.async { completion(ad) }
                } else if let error {
                    print("SAS native ad failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

private struct SASNativeAdHost: UIViewRepresentable {
    let ad: SASNativeAd

    func makeUIView(context _: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBackground
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 0.5
        container.layer.borderColor = UIColor.systemGray4.cgColor

        let titleLabel = UILabel()
        titleLabel.text = ad.title
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        let subtitleLabel = UILabel()
        subtitleLabel.text = ad.subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 3
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(subtitleLabel)

        let mediaView = UIView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(mediaView)
        if ad.hasMedia {
            let sasMediaView = SASNativeAdMediaView()
            sasMediaView.translatesAutoresizingMaskIntoConstraints = false
            sasMediaView.registerNativeAd(ad)
            mediaView.addSubview(sasMediaView)
            NSLayoutConstraint.activate([
                sasMediaView.topAnchor.constraint(equalTo: mediaView.topAnchor),
                sasMediaView.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor),
                sasMediaView.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor),
                sasMediaView.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor),
            ])
        }

        let cta = UIButton(type: .system)
        cta.setTitle(ad.callToAction, for: .normal)
        cta.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        cta.backgroundColor = UIColor.systemBlue
        cta.setTitleColor(.white, for: .normal)
        cta.layer.cornerRadius = 6
        cta.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(cta)

        NSLayoutConstraint.activate([
            mediaView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            mediaView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            mediaView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            mediaView.heightAnchor.constraint(equalToConstant: 200),

            titleLabel.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),

            cta.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            cta.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            cta.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -8),
            cta.heightAnchor.constraint(equalToConstant: 36),
            cta.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
        ])

        DispatchQueue.main.async { [weak container] in
            guard let container, let rootVC = container.window?.rootViewController else { return }
            ad.register(container, modalParentViewController: rootVC)
        }
        return container
    }

    func updateUIView(_: UIView, context _: Context) {}
}

#Preview {
    NavigationStack {
        NativeSASTableViewSample()
    }
}
