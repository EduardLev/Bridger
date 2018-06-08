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

    /*required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BidKeys.self)
        let tricksBid = try container.decode(Int.self, forKey: .tricksBid)
        let tricksWon = try container.decode(Int.self, forKey: .tricksWon)
        let trumpSuit = try container.decode(Card.Suit.self, forKey: .trumpSuit)
        let success = try? container.decode(Bool.self, forKey: .success)
        let declarer = try container.decode(Player.self, forKey: .declarer)
        let vulnerable = try container.decode(Bool.self, forKey: .vulnerable)
        let oppVulnerable = try container.decode(Bool.self, forKey: .oppVulnerable)
        let doubled = try container.decode(DoubleStatus.self, forKey: .doubled)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        self.init(tricksBid: tricksBid, tricksWon: tricksWon, trumpSuit: trumpSuit, success: success, declarer: declarer, vulnerable: vulnerable, oppVulnerable: oppVulnerable, doubled: doubled, uuid: uuid)
    }*/

    /*func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BidKeys.self)
        try container.encode(numberOfTricksBid, forKey: .tricksBid)
        try container.encode(numberOfTricksWon, forKey: .tricksWon)
        try container.encode(trumpSuit, forKey: .trumpSuit)
        try? container.encode(wasSuccessful, forKey: .success)
        try container.encode(declarer, forKey: .declarer)
        try container.encode(vulnerable, forKey: .vulnerable)
        try container.encode(opponentVulnerable, forKey: .oppVulnerable)
        try container.encode(doubled, forKey: .doubled)
        try container.encode(uuid, forKey: .uuid)
    }*/
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
