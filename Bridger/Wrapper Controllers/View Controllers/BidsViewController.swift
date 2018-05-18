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

    private var Font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(24.0))
    }

    // View Outlets.
    @IBOutlet var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var emptyInstructionsLabel: UILabel!
    @IBOutlet var stackView: UIStackView!

    private var bids = [Bid]() {
        didSet {
            imageView.isHidden = (bids.count > 0 ? true : false)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white

        prepareTabItem()
        prepareTableView()
        prepareImageView()
        prepareLabels()
        /*v1.motionIdentifier = "v1"
        v1.backgroundColor = Color.red.base
        view.layout(v1).width(100).vertically().right()*/
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Bids viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Bids viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Bids viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Bids viewDidDisappear")
    }
}

extension BidsViewController {
    fileprivate func prepareTableView() {
        tableView = UITableView()
        tableView.frame = view.bounds
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
        emptyLabel.font = Font
        emptyLabel.adjustsFontForContentSizeCategory = true
    }

    fileprivate func prepareEmptyInstructionsLabel() {
        emptyInstructionsLabel = UILabel()
        emptyInstructionsLabel.textColor = Color.green.darken2
        emptyInstructionsLabel.text = "To add a bid to this game, press the '+' button on the top right bar!"
        emptyInstructionsLabel.font = Font
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
}

extension BidsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
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
}

