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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func prepare(declarer: String, tricks: Int, trump: String) {
        declarerLabel.text = declarer
        tricksLabel.text = String(tricks)
        trumpImageView.image = UIImage(named: trump)

        declarerLabel.adjustsFontSizeToFitWidth = true
        declarerLabel.font = labelFont
        tricksLabel.adjustsFontSizeToFitWidth = true
        tricksLabel.font = labelFont
    }

    fileprivate func prepareViews() {
        contentView.addSubview(trumpImageView)
        contentView.addSubview(declarerLabel)
        contentView.addSubview(tricksLabel)

        trumpImageView.translatesAutoresizingMaskIntoConstraints = false
        declarerLabel.translatesAutoresizingMaskIntoConstraints = false
        tricksLabel.translatesAutoresizingMaskIntoConstraints = false

        let margins = contentView.layoutMarginsGuide

        declarerLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 5).isActive = true
        declarerLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        declarerLabel.heightAnchor.constraint(equalTo: margins.heightAnchor).isActive = true
        declarerLabel.widthAnchor.constraint(equalTo:
            margins.heightAnchor).isActive = true

        tricksLabel.leadingAnchor.constraint(equalTo: declarerLabel.trailingAnchor, constant: -20).isActive = true
        tricksLabel.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        tricksLabel.heightAnchor.constraint(equalTo: margins.heightAnchor).isActive = true
        tricksLabel.widthAnchor.constraint(equalTo:
            margins.heightAnchor).isActive = true

        // TRUMP SUIT VIEW ON TRAILING EDGE
        trumpImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 10).isActive = true
        trumpImageView.centerYAnchor.constraint(equalTo:
            margins.centerYAnchor).isActive = true
        trumpImageView.heightAnchor.constraint(equalTo: margins.heightAnchor, constant: 0).isActive = true
        trumpImageView.widthAnchor.constraint(equalTo: margins.heightAnchor, constant: 0).isActive = true
    }
}

extension BidTableViewCell {
    private var labelFont: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(80.0))
    }
}
