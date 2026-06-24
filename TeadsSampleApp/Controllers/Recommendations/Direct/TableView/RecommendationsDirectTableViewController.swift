//
//  RecommendationsDirectTableViewController.swift
//  TeadsSampleApp
//
//  Copyright © 2026 Teads. All rights reserved.
//

import TeadsSDK
import UIKit

/// Direct Recommendations placement rendered as UITableView rows.
class RecommendationsDirectTableViewController: TeadsViewController {
    private let tableView = UITableView()
    private var recommendations: [OBRecommendation] = []
    private var placement: TeadsAdPlacementRecommendations?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recommendations — Direct"
        view.backgroundColor = .systemBackground
        setupTable()
        loadRecommendations()
    }

    private func setupTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecoCell")
        let header = SampleArticleViews.titleLabel("You may also like")
        header.frame = CGRect(x: 16, y: 0, width: view.bounds.width - 32, height: 50)
        tableView.tableHeaderView = header
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func loadRecommendations() {
        let config = TeadsAdPlacementRecommendationsURLConfig(
            articleUrl: URL(string: PID.outbrainArticleUrl)!,
            widgetId: PID.recommendationsWidgetId
        )
        let placement = TeadsAdPlacementRecommendations(config, delegate: nil)
        self.placement = placement
        placement.loadAd { [weak self] response in
            DispatchQueue.main.async {
                guard let self, response.error == nil else { return }
                self.recommendations = response.recommendations
                self.tableView.reloadData()
            }
        }
    }
}

extension RecommendationsDirectTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int { recommendations.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecoCell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.selectionStyle = .none
        let recommendation = recommendations[indexPath.row]
        let card = RecommendationCardView(recommendation: recommendation) { url in
            if let url { UIApplication.shared.open(url) }
        }
        card.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(card)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 6),
            card.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -6),
        ])
        return cell
    }
}
