//
//  Bid.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/23/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

class Bid: NSObject, Codable {

    // private(set)
    private(set) var tricksBid: Int!
    private(set) var trumpSuit: Card.Suit!
    private(set) var declarer: Player! 
    private(set) var doubled: DoubleStatus!
    private(set) var uuid: UUID!

    private let tricksWon: Int?
    var wasSuccessful: Bool?
    private let vulnerable: Bool!
    private let opponentVulnerable: Bool!

    enum BidKeys: CodingKey { case tricksBid, tricksWon, trumpSuit, success, declarer, vulnerable, oppVulnerable, doubled, uuid }

    init(tricksBid: Int, tricksWon: Int?, trumpSuit: Card.Suit, success: Bool?, declarer: Player, vulnerable: Bool, oppVulnerable: Bool, doubled: DoubleStatus, uuid: UUID) {
        self.tricksBid = tricksBid
        self.tricksWon = tricksWon
        self.trumpSuit = trumpSuit
        self.wasSuccessful = success
        self.declarer = declarer
        self.vulnerable = vulnerable
        self.opponentVulnerable = oppVulnerable
        self.doubled = doubled
        self.uuid = uuid
    }

    convenience init(tricksBid: Int, trumpSuit: Card.Suit, declarer: Player, doubled: DoubleStatus, uuid: UUID) {
        self.init(tricksBid: tricksBid, tricksWon: 0, trumpSuit: trumpSuit, success: nil, declarer: declarer, vulnerable: false, oppVulnerable: false, doubled: doubled, uuid: uuid)
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
