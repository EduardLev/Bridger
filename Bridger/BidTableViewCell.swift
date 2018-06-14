//
//  BidTableViewCell.swift
//  Bridger
//
//  Created by Eduard Lev on 5/21/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit

class BidTableViewCell: UITableViewCell {

    fileprivate let declarerLabel = UILabel()
    fileprivate let bidWonLabel = UILabel()
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

    public func prepare(declarer: String, tricks: Int, trump: String, vulnerable: Bool, doubled: Bid.DoubleStatus) {
        declarerLabel.text = declarer
        tricksLabel.text = String(tricks)
        trumpImageView.image = UIImage(named: trump)

        switch doubled {
        case .regular: doubledLabel.text = "Not Doubled"; doubledLabel.textColor = UIColor.green
        case .doubled: doubledLabel.text = "Doubled"; doubledLabel.textColor = UIColor.red
        case .redoubled: doubledLabel.text = "Redoubled"; doubledLabel.textColor = UIColor.red
        }

        if vulnerable {
            vulnerableLabel.text = "Vulnerable"
            vulnerableLabel.textColor = UIColor.red
        } else {
            vulnerableLabel.text = "Not Vulnerable"
            vulnerableLabel.textColor = UIColor.green
        }

        doubledLabel.font = smallLabelFont
        vulnerableLabel.font = smallLabelFont

        declarerLabel.adjustsFontSizeToFitWidth = true
        declarerLabel.font = largeLabelFont
        tricksLabel.adjustsFontSizeToFitWidth = true
        tricksLabel.font = largeLabelFont
    }

    fileprivate func prepareViews() {
        contentView.addSubview(trumpImageView)

        trumpImageView.translatesAutoresizingMaskIntoConstraints = false
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

        smallStackView.leadingAnchor.constraint(equalTo: largeStackView.trailingAnchor, constant: 10).isActive = true
        smallStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true

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
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(15))
    }

    private var largeLabelFont: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(80))
    }
}
