//
//  GameViewController.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/24/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class GameViewController: UIViewController {

    /// Local reference to the shared root game
    var game: Game = Store.shared.rootGame

    // UITableView objects
    var weOverTableView = UITableView()
    var weUnderTableView = UITableView()
    var theyOverTableView = UITableView()
    var theyUnderTableView = UITableView()

    // Labels
    let weLabel = UILabel()
    let theyLabel = UILabel()
    var labelStackView: UIStackView!

    /// Convenience variable for reference to all table views.
    lazy var tableViewCollection =
        [weOverTableView, weUnderTableView, theyOverTableView, theyUnderTableView]

    open override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTabItem()
        prepareLabels()
        prepareLabelsStackView()
        prepareTableViews()
        tableViewCollection.forEach { $0.reloadData() }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableViewCollection.forEach { $0.reloadData() }
    }
}

// MARK: - UI Preparation

extension GameViewController {
    fileprivate func prepareView() {
        // Change back to white (todo)
        view.backgroundColor = Color.green.darken1
    }

    fileprivate func prepareLabels() {
        weLabel.text = "WE"
        theyLabel.text = "THEY"
        setLabelDetails(for: weLabel)
        setLabelDetails(for: theyLabel)
    }

    fileprivate func prepareLabelsStackView() {
        labelStackView = UIStackView(arrangedSubviews: [weLabel, theyLabel])
        labelStackView.axis = .horizontal
        labelStackView.distribution = .fillEqually
        view.addSubview(labelStackView)
        view.layout(labelStackView).top(8).left().right()
    }

    fileprivate func setLabelDetails(for label: UILabel) {
        label.textColor = Color.white
        label.font = font
        label.textAlignment = .center
    }

    fileprivate func prepareTabItem() {
        tabItem.title = "Game"
        tabItem.image = Icon.home
        tabItem.pulseAnimation = .backing
    }

    fileprivate func prepareTableViews() {
        _ = tableViewCollection.map { [unowned self] in
            $0.delegate = self
            $0.dataSource = self
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(UITableViewCell.self, forCellReuseIdentifier: self.reuseIdentifier)
            self.view.addSubview($0)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = Color.green.accent3.cgColor
            //$0.layer.cornerRadius = 0
        }

        layoutTableViews()
    }

    /// Places the table views in the 4 corners
    fileprivate func layoutTableViews() {
        // swiftlint:disable line_length

        view.layout(weOverTableView).left(5).right(view.frame.size.width/2 + 2.5)
        view.addConstraint(NSLayoutConstraint(item: weOverTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.5, constant: 5))
        view.addConstraint(NSLayoutConstraint(item: weOverTableView, attribute: .top, relatedBy: .equal, toItem: labelStackView, attribute: .bottom, multiplier: 1.0, constant: 8))

        view.layout(weUnderTableView).bottom(5).left(5).right(self.view.bounds.size.width/2 + 2.5)
        view.addConstraint(NSLayoutConstraint(item: weUnderTableView, attribute: .top, relatedBy: .equal, toItem: weOverTableView, attribute: .bottom, multiplier: 1, constant: 5))

        view.layout(theyOverTableView)
            .right(5).left(self.view.bounds.size.width/2+2.5)
        view.addConstraint(NSLayoutConstraint(item: theyOverTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.5, constant: 5))
        view.addConstraint(NSLayoutConstraint(item: theyOverTableView, attribute: .top, relatedBy: .equal, toItem: labelStackView, attribute: .bottom, multiplier: 1.0, constant: 8))

        view.layout(theyUnderTableView).bottom(5).right(5)
            .left(self.view.bounds.size.width/2+2.5)
        view.addConstraint(NSLayoutConstraint(item: theyUnderTableView, attribute: .top, relatedBy: .equal, toItem: theyOverTableView, attribute: .bottom, multiplier: 1, constant: 5))
        // swiftlint:enable line_length

        // The top table views should be upside down!
        weOverTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        theyOverTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}

// MARK: - Table View Delegate

extension GameViewController: UITableViewDelegate {
}

// MARK: - Table View Data Source

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case weOverTableView: return game.weOverScore.count
        case weUnderTableView: return game.weUnderScore.count
        case theyOverTableView: return game.theyOverScore.count
        case theyUnderTableView: return game.theyUnderScore.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        if tableView == weOverTableView {
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.textLabel?.text = String(game.weOverScore[indexPath.row])
            return cell
        } else if tableView == weUnderTableView {
            cell.textLabel?.text = String(game.weUnderScore.flatMap({$0})[indexPath.row])
            return cell
        } else if tableView == theyOverTableView {
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.textLabel?.text = String(game.theyOverScore[indexPath.row])
            return cell
        } else if tableView == theyUnderTableView {
            cell.textLabel?.text = String(game.theyUnderScore.flatMap({$0})[indexPath.row])
            return cell
        }

        return cell
    }
}

extension GameViewController {
    private var reuseIdentifier: String { return "gameScoreCell" }

    private var viewWidth: CGFloat {
        return self.view.frame.size.width/2 + 2.5
    }

    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body)
            .scaledFont(for: UIFont.preferredFont(forTextStyle: .body)
                .withSize(30.0))
    }
}
