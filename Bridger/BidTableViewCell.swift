//
//  BidTableViewCell.swift
//  Bridger
//
//  Created by Eduard Lev on 5/21/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class BidTableViewCell: UITableViewCell {

    // View Properties
    fileprivate let declarerLabel = UILabel()
    fileprivate let tricksWonLabel = UILabel()
    fileprivate let tricksLabel = UILabel()
    fileprivate let trumpImageView = UIImageView()
    fileprivate let doubledLabel = UILabel()
    fileprivate let vulnerableLabel = UILabel()

    fileprivate var largeStackView: UIStackView!
    fileprivate var smallStackView: UIStackView!

    fileprivate lazy var viewOutletCollection = [declarerLabel, tricksWonLabel, tricksLabel,
                                            trumpImageView, doubledLabel, vulnerableLabel]

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Preparation

    public func prepare(declarer: String, tricks: Int, trump: String, vulnerable: Bool,
                        doubled: Bid.DoubleStatus, tricksWon: Int?) {
        setupDeclarerLabel(withDeclarer: declarer)
        setupTricksLabel(withTricks: tricks)
        setupDoubledLabel(withDoubledStatus: doubled)
        setupVulnerableLabel(withVulnerableStatus: vulnerable)
        setupTrumpImageView(withTrump: trump)
        setupTricksWonLabel(withTricksWon: tricksWon, andTricks: tricks)
    }

    fileprivate func setupDeclarerLabel(withDeclarer declarer: String) {
        declarerLabel.text = declarer
        declarerLabel.adjustsFontSizeToFitWidth = true
        declarerLabel.font = largeLabelFont
    }

    fileprivate func setupTricksLabel(withTricks tricks: Int) {
        tricksLabel.text = String(tricks - 6)
        tricksLabel.adjustsFontSizeToFitWidth = true
        tricksLabel.font = largeLabelFont
    }

    fileprivate func setupDoubledLabel(withDoubledStatus doubled: Bid.DoubleStatus) {
        switch doubled {
        case .regular: doubledLabel.text = "Not Doubled"; doubledLabel.textColor = Color.green.base
        case .doubled: doubledLabel.text = "Doubled"; doubledLabel.textColor = Color.red.base
        case .redoubled: doubledLabel.text = "Redoubled"; doubledLabel.textColor = Color.red.accent3
        }
        doubledLabel.font = smallLabelFont
    }

    fileprivate func setupVulnerableLabel(withVulnerableStatus vulnerable: Bool) {
        if vulnerable {
            vulnerableLabel.text = "Vulnerable"
            vulnerableLabel.textColor = Color.red.base
        } else {
            vulnerableLabel.text = "Not Vulnerable"
            vulnerableLabel.textColor = Color.green.base
        }
        vulnerableLabel.font = smallLabelFont
    }

    fileprivate func setupTrumpImageView(withTrump trump: String) {
        trumpImageView.image = UIImage(named: trump)
    }

    fileprivate func setupTricksWonLabel(withTricksWon tricksWon: Int?, andTricks tricks: Int) {
        if let tricksWon = tricksWon {
            if tricksWon >= tricks {
                tricksWonLabel.text = "Successful: \(tricksWon) tricks"
                tricksWonLabel.textColor = Color.green.base
            } else {
                tricksWonLabel.text = "Failed: \(tricksWon) Tricks"
                tricksWonLabel.textColor = Color.red.base
            }
        } else {
            tricksWonLabel.text = "Contract in progress"
            tricksWonLabel.textColor = UIColor.black
        }
        tricksWonLabel.font = smallLabelFont
    }

    fileprivate func prepareViews() {
        viewOutletCollection.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        prepareTrumpImageView()
        prepareLargeStackView()
        prepareSmallStackView()
        prepareTricksWonLabel()
    }

    fileprivate func prepareTricksWonLabel() {
        contentView.addSubview(tricksWonLabel)

        tricksWonLabel.leadingAnchor
            .constraint(equalTo: largeStackView.trailingAnchor, constant: 10).isActive = true
        tricksWonLabel.bottomAnchor
            .constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }

    fileprivate func prepareTrumpImageView() {
        contentView.addSubview(trumpImageView)
        contentView.layout(trumpImageView).right(30).centerVertically().height(bounds.size.height)
            .width(bounds.size.height)
        trumpImageView.contentMode = .scaleAspectFill
    }

    fileprivate func prepareSmallStackView() {
        smallStackView = UIStackView(arrangedSubviews: [doubledLabel, vulnerableLabel])
        smallStackView.translatesAutoresizingMaskIntoConstraints = false
        smallStackView.axis = .vertical
        contentView.addSubview(smallStackView)

        smallStackView.leadingAnchor
            .constraint(equalTo: largeStackView.trailingAnchor, constant: 10).isActive = true
        smallStackView.topAnchor
            .constraint(equalTo: self.topAnchor, constant: 10).isActive = true
    }

    fileprivate func prepareLargeStackView() {
        largeStackView = UIStackView(arrangedSubviews: [declarerLabel, tricksLabel])
        largeStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(largeStackView)
        contentView.layout(largeStackView).left(10).centerVertically()
    }
}

extension BidTableViewCell {
    private var smallLabelFont: UIFont {
        return UIFontMetrics(forTextStyle: .body)
            .scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(15))
    }

    private var largeLabelFont: UIFont {
        return UIFontMetrics(forTextStyle: .body)
            .scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(80))
    }
}
