//
//  Bid.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/23/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

class Bid: NSObject, Codable {

    private(set) var tricksBid: Int!
    private(set) var trumpSuit: Card.Suit!
    private(set) var declarer: Player! 
    private(set) var doubled: DoubleStatus!
    private(set) var uuid: UUID!
    var wasSuccessful: Bool?
    private(set) var vulnerable: Bool!
    private let opponentVulnerable: Bool!
    var tricksWon: Int?

    weak var parentGame: Game? = Game(name: "", uuid: UUID(), bids: [])

    enum CodingKeys: CodingKey { case tricksBid, tricksWon, trumpSuit, wasSuccessful, declarer, vulnerable, opponentVulnerable, doubled, uuid }

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
        self.init(tricksBid: tricksBid, tricksWon: nil, trumpSuit: trumpSuit, success: nil, declarer: declarer, vulnerable: false, oppVulnerable: false, doubled: doubled, uuid: uuid)
    }

    func setTricksWon(to tricksWonInput: Int) {
        self.tricksWon = tricksWonInput
        self.parentGame?.store?.save(self, userInfo: [Game.changeReasonKey: Game.updatedTricksTaken])
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
