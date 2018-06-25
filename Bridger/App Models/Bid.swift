//
//  Bid.swift
//  BridgeScoring
//
//  A Bid object keeps track of all the properties of a single Bid. This includes
//  the declarer of the bid, how many tricks they bid, the trump suit they chose, etc.
//  It also keeps track of the result of the bid, including its success relative to the
//  declarer, as well as the number of tricks that were won by the declarer.
//
//  It has the capability of calculating its own score once there is enough information
//  to do so. Score calculation is triggered by calling the method calculateContractScore()
//  which updates the overTheLineScore and underTheLineScore properties.
//
//  Most variables are set by the user during the Bid creation process, and some are set
//  during the Bid editing process (after a round is finished). The only variable that is dependent
//  on the Game state in rubber bridge is vulnerability.
//
//  Created by Eduard Lev on 4/23/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

class Bid: NSObject, Codable {

    /// Unique identifier of this bid
    private(set) var uuid: UUID!

    /// The Game object that this Bid is a part of.
    weak var parentGame: Game?

    // Bid state properties. Set by the PLAYER when creating a bid.
    /// The *real* number of tricks bid, from 0 to 14
    private(set) var tricksBid: Int
    private(set) var trumpSuit: Card.Suit
    private(set) var declarer: Player
    private(set) var doubled: DoubleStatus

    /// Bid state property. Set by the user (player) when updating a bid after the round is over.
    var tricksWon: Int? {
        didSet { calculateContractScore() }
    }

    /// Whether or not this particular bid was successful for the declarer.
    /// - Remark: This property has no knowledge of whether the declarer is WE or THEY
    var wasSuccessful: Bool? {
        guard let tricksWon = tricksWon else { return nil }
        return tricksWon >= tricksBid
    }

    // Bid state properties. Set by the Game based on the results thus far.
    var weVulnerable: Bool = false
    var theyVulnerable: Bool = false

    // Bid score properties.
    var underTheLineScore: Int = 0
    var overTheLineScore: Int = 0

    enum CodingKeys: CodingKey { case tricksBid, tricksWon, trumpSuit, declarer, weVulnerable,
        theyVulnerable, doubled, underTheLineScore, overTheLineScore, uuid }

    init(tricksBid: Int, trumpSuit: Card.Suit, declarer: Player, doubled: DoubleStatus) {
        self.tricksBid = tricksBid
        self.trumpSuit = trumpSuit
        self.declarer = declarer
        self.doubled = doubled
    }

    func setTricksWon(to tricksWonInput: Int) {
        self.tricksWon = tricksWonInput
        self.parentGame?.updateBid(self)
    }

    fileprivate func calculateContractScore() {
        guard let success = wasSuccessful else { fatalError() }
        guard let tricksWon = tricksWon else { fatalError() }

        let equalityToAssert = success ? tricksWon >= tricksBid : tricksBid > tricksWon
        assert(equalityToAssert, "Calculating the incorrect contract score")

        let tricksDifference = abs(tricksWon - tricksBid)
        success ? calculateSuccessfulContractScore(withOvertricks: tricksDifference) :
            calculateFailedContractScore(withUndertricks: tricksDifference)
    }

    fileprivate func calculateSuccessfulContractScore(withOvertricks overtricks: Int) {
        var multiplier = 0

        // If trumps are clubs or diamonds, 20 per trick
        // If trumps are hearts or spades, 30 per trick
        // If notrump, 40 for 1st trick and 30 for each subsequent tricks
        switch trumpSuit {
        case .clubs, .diamonds: multiplier = 20
        case .hearts, .spades: multiplier = 30
        case .notrump: multiplier = 30; underTheLineScore += 10
        }

        underTheLineScore += multiplier * (tricksBid - 6)

        switch doubled {
        case .doubled: underTheLineScore *= 2; multiplier = 100
        case .redoubled: underTheLineScore *= 4; multiplier = 200
        default: break
        }

        // fix we vs they
        if weVulnerable { multiplier *= 2 }
        overTheLineScore += multiplier * overtricks
    }

    fileprivate func calculateFailedContractScore(withUndertricks undertricks: Int) {
        var multiplier = 0

        if doubled == .regular {
            // fix for we vs they
            multiplier = weVulnerable ? 100 : 50
            overTheLineScore += multiplier * undertricks
        } else { // doubled or redoubled
            var score = [100, 300, 500, 800, 1100, 1400, 1700, 2000, 2300, 2600, 2900, 3200, 3500]
            // fix for we vs they
            if weVulnerable {
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
