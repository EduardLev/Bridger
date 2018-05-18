//
//  Bid.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/23/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

/**
 Holds the properties of one 'Bid' action
 */
struct Bid {
    /// Stores the number of tricks declared in the bid
    private let numberOfTricksBid: Int!

    /// Stores the number of tricks won in the bid.
    /// A nil value indicates that the bid was not completed and the Game is ongoing
    private let numberOfTricksWon: Int?

    /// Stores the suit of the trump in the bid.
    /// Possible values are .hearts, .diamonds, .clubs, .spades, .notrump
    private let trumpSuit: Card.Suit!

    /// Whether or not the bid was successful for the declarer.
    /// A nil value indicates that the bid was not completed and the Game is ongoing
    var wasSuccessful: Bool?

    /// The declarer of this bid.
    private let declarer: Player!

    /// Whether or not the declaring side was vulnerable at the time of the bid
    private let vulnerable: Bool!

    /// Whether or not the opposing side was vulnerable at the time of the bid
    private let opponentVulnerable: Bool!

    /// The doubling status of the current bid
    private let doubled: DoubleStatus!

    init(numberOfTricksBid: Int, trumpSuit: Card.Suit, declarer: Player, isVulnerable: Bool,
         isOpponentVulnerable: Bool, doubled: DoubleStatus) {
        self.numberOfTricksBid = numberOfTricksBid
        self.trumpSuit = trumpSuit
        self.declarer = declarer
        self.vulnerable = isVulnerable
        self.opponentVulnerable = isOpponentVulnerable
        self.doubled = doubled

        // These values are set to nil when a bid is first created
        self.wasSuccessful = nil
        self.numberOfTricksWon = nil
    }
}

extension Bid {
    enum DoubleStatus {
        case regular
        case doubled
        case redoubled
    }
}
