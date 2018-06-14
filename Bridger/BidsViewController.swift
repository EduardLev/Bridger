//
//  BidsViewController.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/24/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class BidsViewController: UIViewController {

    // View Outlets.
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var emptyInstructionsLabel: UILabel!
    @IBOutlet var stackView: UIStackView!

    // View Model
    var game: Game = Store.shared.rootGame {
        didSet {
            tableView.reloadData()
            title = game.name
        }
    }

    var selectedBid: Bid? {
        if let indexPath = tableView.indexPathForSelectedRow {
            return game.bids[indexPath.row]
        }
        return nil
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white

        prepareTabItem()
        prepareTableView()
        prepareImageView()
        prepareLabels()

        tableView.dataSource = self
        tableView.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(handleChangeNotification(_:)), name: Store.changedNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func handleChangeNotification(_ notification: Notification) {
        // handles changes to contents
        guard let userInfo = notification.userInfo else { return }

        if let changeReason = userInfo[Game.changeReasonKey] as? String {
            let oldValue = userInfo[Game.newValueKey]
            let newValue = userInfo[Game.oldValueKey]
            switch (changeReason, newValue, oldValue) {
            case let (Game.removed, _, (oldIndex as Int)?):
                tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .bottom)
            case let (Game.added, (newIndex as Int)?, _):
                tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .left)
            default: tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
}

extension BidsViewController {
    fileprivate func prepareTableView() {
        tableView = UITableView()
        tableView.frame = view.bounds
        tableView.register(BidTableViewCell.self, forCellReuseIdentifier: BidsViewController.updateBidViewController)
        view.addSubview(tableView)
        view.layout(tableView).bottom().top().left().right()
    }

    // Configures the look of the tab button corresponding to this view controller.
    fileprivate func prepareTabItem() {
        tabItem.title = "Bids"
        tabItem.image = Icon.history
        tabItem.pulseAnimation = .backing
        tabItem.pulseColor = Color.green.base
    }

    // Configure the image view that is shown on screen when there are no bids in the current Game.
    fileprivate func prepareImageView() {
        let image = UIImage(named: "Hold Screen")
        imageView = UIImageView(image: image)
    }

    fileprivate func prepareLabels() {
        prepareEmptyLabel()
        prepareEmptyInstructionsLabel()
        prepareStackView()
    }

    fileprivate func prepareEmptyLabel() {
        emptyLabel = UILabel()
        emptyLabel.textColor = Color.green.darken2
        emptyLabel.text = "   Empty..."
        emptyLabel.font = font
        emptyLabel.adjustsFontForContentSizeCategory = true
    }

    fileprivate func prepareEmptyInstructionsLabel() {
        emptyInstructionsLabel = UILabel()
        emptyInstructionsLabel.textColor = Color.green.darken2
        emptyInstructionsLabel.text = "To add a bid to this game, press the '+' button on the top right."
        emptyInstructionsLabel.font = font
        emptyInstructionsLabel.numberOfLines = 2
        //emptyInstructionsLabel.lineBreakMode = .byWordWrapping
        emptyInstructionsLabel.adjustsFontSizeToFitWidth = true
        emptyInstructionsLabel.adjustsFontForContentSizeCategory = true
    }

    fileprivate func prepareStackView() {
        stackView = UIStackView()

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(emptyLabel)
        stackView.addArrangedSubview(emptyInstructionsLabel)

        stackView.spacing = Layout.stackViewSpacing
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalToConstant: textLabelWidth).isActive = true

        view.addSubview(stackView)
        view.layout(stackView).center()
    }

    fileprivate func pushUpdateBidViewController() {
        guard let selectedBid = selectedBid else { return }
        if let updateBidViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "updateBidViewController") as? UpdateBidViewController {
            updateBidViewController.bid = selectedBid
            self.present(updateBidViewController, animated: true, completion: nil)
        }
    }
}

extension BidsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if game.bids.count > 0 {
            stackView.isHidden = true
            tableView.separatorStyle = .singleLine
            return 1
        } else {
            stackView.isHidden = false
            tableView.separatorStyle = .none
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.bids.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bid = game.bids[indexPath.row] // gets the bid from the modelcell.prepare(
        let cell = tableView.dequeueReusableCell(withIdentifier: BidsViewController.updateBidViewController, for: indexPath) as! BidTableViewCell // swiftlint:disable:this force_cast
        cell.prepare(declarer: bid.declarer.rawValue, tricks: bid.tricksBid, trump: bid.trumpSuit.rawValue, vulnerable: bid.vulnerable, doubled: bid.doubled)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true // OK
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        game.removeBid(game.bids[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushUpdateBidViewController()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BidsViewController {
    private struct Layout {
        static let offsetX: CGFloat = 10
        static let offsetY: CGFloat = 20
        static let emptyTextWidth: CGFloat = 150
        static let stackViewSpacing: CGFloat = 15
        static let textLabelDimensionRatio: CGFloat = 0.7
    }

    private var textLabelWidth: CGFloat {
        return self.view.frame.size.width * Layout.textLabelDimensionRatio
    }

    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(24.0))
    }

    private static let bidCellReuseIdentifier = "Bid Cell"
    private static let updateBidViewController = "UpdateBidViewController"
}
