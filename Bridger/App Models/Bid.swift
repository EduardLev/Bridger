//
//  Bid.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/23/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

class Bid: NSObject, Codable {

    // Properties set by user when inputting bid
    private(set) var tricksBid: Int!
    private(set) var trumpSuit: Card.Suit!
    private(set) var declarer: Player!
    private(set) var doubled: DoubleStatus!

    // Properties set by user after bid is over
    var tricksWon: Int? {
        didSet {
            if let success = wasSuccessful {
                if success {
                    calculateContractScore()
                } else {
                    calculateFailedContractScore()
                }
            }
        }
    }

    // Properties calculated based on game state
    var wasSuccessful: Bool? {
        if let numberBid = tricksBid, let numberWon = tricksWon {
            return numberWon >= (numberBid + 6)
        }
        return nil
    }

    private(set) var vulnerable: Bool!
    private let opponentVulnerable: Bool!

    // NIL if no tricks won yet
    // Positive if the contract was successful
    // 0 if the contract was not successful
    private var underTheLineScore: Int?
    private var overTheLineScore: Int?

    private(set) var uuid: UUID!
    weak var parentGame: Game? = Game(name: "", uuid: UUID(), bids: [], weOverScore: [], weUnderScore: [:], theyOverScore: [], theyUnderScore: [:])

    enum CodingKeys: CodingKey { case tricksBid, tricksWon, trumpSuit, declarer, vulnerable, opponentVulnerable, doubled, uuid }

    init(tricksBid: Int, tricksWon: Int?, trumpSuit: Card.Suit, declarer: Player, vulnerable: Bool, oppVulnerable: Bool, doubled: DoubleStatus, uuid: UUID) {
        self.tricksBid = tricksBid
        self.tricksWon = tricksWon
        self.trumpSuit = trumpSuit
        self.declarer = declarer
        self.vulnerable = vulnerable
        self.opponentVulnerable = oppVulnerable
        self.doubled = doubled
        self.uuid = uuid
    }

    convenience init(tricksBid: Int, trumpSuit: Card.Suit, declarer: Player, doubled: DoubleStatus, uuid: UUID) {
        self.init(tricksBid: tricksBid, tricksWon: nil, trumpSuit: trumpSuit, declarer: declarer, vulnerable: false, oppVulnerable: false, doubled: doubled, uuid: uuid)
    }

    func setTricksWon(to tricksWonInput: Int) {
        self.tricksWon = tricksWonInput
        self.parentGame?.updateTricksWon(forBid: self)
    }

    fileprivate func calculateContractScore() {
        guard let trumpSuit = trumpSuit else { fatalError() }
        guard let doubled = doubled else { fatalError() }
        guard let tricksWon = tricksWon else { fatalError() }
        guard let vulnerable = vulnerable else { fatalError() }
        assert(tricksWon >= tricksBid + 6, "Calculating contract score even though not enough tricks were won!")

        var multiplier = 0
        var underTheLineScore = 0
        var overTheLineScore = 0
        let overtricks = tricksWon - tricksBid - 6

        // If trumps are clubs or diamonds, 20 per trick
        // If trumps are hearts or spades, 30 per trick
        // If notrump, 40 for 1st trick and 30 for each subsequent tricks
        switch trumpSuit {
        case .clubs, .diamonds: multiplier = 20
        case .hearts, .spades: multiplier = 30
        case .notrump: multiplier = 30; underTheLineScore += 10
        }

        // The tricks bid goes from 1 to 7, so a successful contract
        // will have a score of only the tricks entered into the contract.
        underTheLineScore += multiplier * tricksBid

        switch doubled {
        case .doubled:
            underTheLineScore *= 2
            multiplier = 100
        case .redoubled:
            underTheLineScore *= 4
            multiplier = 200
        default: break
        }

        if vulnerable { multiplier *= 2 }
        overTheLineScore += multiplier * overtricks
    }

    fileprivate func calculateFailedContractScore() {
        guard let doubled = doubled else { fatalError() }
        guard let tricksWon = tricksWon else { fatalError() }
        guard let vulnerable = vulnerable else { fatalError() }

        assert(tricksBid + 6 > tricksWon, "Calculating failed contract score even though enough tricks were won!")

        var multiplier = 0
        var overTheLineScore = 0
        let undertricks = tricksBid + 6 - tricksWon

        if doubled == .regular {
            multiplier = vulnerable ? 100 : 50
            overTheLineScore += multiplier * undertricks
        } else { // doubled or redoubled
            var score = [100, 300, 500, 800, 1100, 1400, 1700, 2000, 2300, 2600, 2900, 3200, 3500]
            if vulnerable {
                score = [200, 500, 800, 1100, 1400, 1700, 2000, 2300, 2600, 2900, 3200, 3500, 3800]
            }
            overTheLineScore += score[undertricks - 1]
            if doubled == . redoubled { overTheLineScore *= 2 }
        }
    }
}

extension Bid {
    public enum DoubleStatus: String, Codable {
        case regular
        case doubled
        case redoubled
    }

    public enum InvalidBidType: String {
        case declarer
        case trumpSuit
        case tricks
    }
}
