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

    fileprivate let declarerLabel = UILabel()
    fileprivate let tricksWonLabel = UILabel()
    fileprivate let tricksLabel = UILabel()
    fileprivate let trumpImageView = UIImageView()
    fileprivate let doubledLabel = UILabel()
    fileprivate let vulnerableLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func prepare(declarer: String, tricks: Int, trump: String, vulnerable: Bool, doubled: Bid.DoubleStatus,
                        tricksWon: Int?) {
        // Set Up Declarer Label
        declarerLabel.text = declarer
        declarerLabel.adjustsFontSizeToFitWidth = true
        declarerLabel.font = largeLabelFont

        // Set Up Tricks Label
        tricksLabel.text = String(tricks - 6)
        tricksLabel.adjustsFontSizeToFitWidth = true
        tricksLabel.font = largeLabelFont

        // Set Up Doubled Label
        switch doubled {
        case .regular: doubledLabel.text = "Not Doubled"; doubledLabel.textColor = Color.green.base
        case .doubled: doubledLabel.text = "Doubled"; doubledLabel.textColor = Color.red.base
        case .redoubled: doubledLabel.text = "Redoubled"; doubledLabel.textColor = Color.red.accent3
        }
        doubledLabel.font = smallLabelFont

        // Set Up Vulnerable Label
        if vulnerable {
            vulnerableLabel.text = "Vulnerable"
            vulnerableLabel.textColor = Color.red.base
        } else {
            vulnerableLabel.text = "Not Vulnerable"
            vulnerableLabel.textColor = Color.green.base
        }
        vulnerableLabel.font = smallLabelFont

        // Set up Trump Image View
        trumpImageView.image = UIImage(named: trump)

        // Set up Tricks Won Label
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
        contentView.addSubview(trumpImageView)
        contentView.addSubview(tricksWonLabel)

        trumpImageView.translatesAutoresizingMaskIntoConstraints = false
        tricksWonLabel.translatesAutoresizingMaskIntoConstraints = false
        declarerLabel.translatesAutoresizingMaskIntoConstraints = false
        tricksLabel.translatesAutoresizingMaskIntoConstraints = false
        vulnerableLabel.translatesAutoresizingMaskIntoConstraints = false
        doubledLabel.translatesAutoresizingMaskIntoConstraints = false

        let smallStackView = UIStackView(arrangedSubviews: [doubledLabel, vulnerableLabel])
        smallStackView.axis = .vertical
        smallStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(smallStackView)

        let largeStackView = UIStackView(arrangedSubviews: [declarerLabel, tricksLabel])
        largeStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(largeStackView)
        contentView.layout(largeStackView).left(10).centerVertically()

        smallStackView.leadingAnchor.constraint(equalTo: largeStackView.trailingAnchor, constant: 10)
            .isActive = true
        smallStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
            .isActive = true

        tricksWonLabel.leadingAnchor.constraint(equalTo: largeStackView.trailingAnchor, constant: 10)
            .isActive = true
        tricksWonLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
            .isActive = true

        contentView.layout(trumpImageView)
            .right(30)
            .centerVertically()
            .height(bounds.size.height)
            .width(bounds.size.height)
        trumpImageView.contentMode = .scaleAspectFill
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
