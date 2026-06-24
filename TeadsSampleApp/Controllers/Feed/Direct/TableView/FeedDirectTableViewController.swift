//
//  FeedDirectTableViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Direct Feed placement inserted as a row inside a UITableView article.
class FeedDirectTableViewController: TeadsViewController {
    private enum Row: Equatable {
        case article
        case ad
    }

    private let tableView = UITableView()
    private let rows: [Row] = [.article, .article, .ad, .article, .article]

    private var placement: TeadsAdPlacementFeed?
    private var adView: UIView?
    private var adHeight: CGFloat = 250

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed — Direct"
        view.backgroundColor = .systemBackground
        setupTable()
        loadFeed()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.register(ArticleTextTableViewCell.self, forCellReuseIdentifier: ArticleTextTableViewCell.reuseId)
        tableView.register(AdHostTableViewCell.self, forCellReuseIdentifier: AdHostTableViewCell.reuseId)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func loadFeed() {
        let config = TeadsAdPlacementFeedConfig(
            articleUrl: URL(string: PID.outbrainArticleUrl)!,
            widgetId: PID.feedWidgetId,
            installationKey: PID.outbrainInstallationKey,
            widgetIndex: 0
        )
        placement = Teads.createPlacement(with: config, delegate: self)
        adView = try? placement?.loadAd()
        reloadAdRow()
    }

    private func reloadAdRow() {
        guard let index = rows.firstIndex(of: .ad) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

extension FeedDirectTableViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { rows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
            case .article:
                return tableView.dequeueReusableCell(withIdentifier: ArticleTextTableViewCell.reuseId, for: indexPath)
            case .ad:
                let cell = tableView.dequeueReusableCell(withIdentifier: AdHostTableViewCell.reuseId, for: indexPath) as! AdHostTableViewCell
                if let adView { cell.host(adView, height: adHeight) }
                return cell
        }
    }
}

extension FeedDirectTableViewController: TeadsAdPlacementEventsDelegate {
    func adPlacement(_: TeadsAdPlacementIdentifiable?, didEmitEvent event: TeadsAdPlacementEventName, data: [String: Any]?) {
        if event == .heightUpdated, let height = data?["height"] as? CGFloat {
            adHeight = height
            reloadAdRow()
        }
    }
}
