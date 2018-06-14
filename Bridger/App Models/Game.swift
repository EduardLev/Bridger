//
//  Game.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/23/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

/**
 Holds the status of one Bridge game, either ongoing or completed.
 */
class Game: Codable {
    let uuid: UUID
    private(set) var name: String
    private(set) var bids: [Bid]

    weak var store: Store?

    init(name: String, uuid: UUID) {
        bids = []
        self.name = name
        self.uuid = uuid
        self.store = nil
    }

    convenience init(name: String, uuid: UUID, bids: [Bid]) {
        self.init(name: name, uuid: uuid)
        self.bids = bids
    }

    enum GameKeys: CodingKey { case name, uuid, bids }
    enum BidKeys: CodingKey { case bid }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GameKeys.self)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let name = try container.decode(String.self, forKey: .name)

        var nested = try container.nestedUnkeyedContainer(forKey: .bids)
        var bids = [Bid]()
        bids = try nested.decode([Bid].self)

        self.init(name: name, uuid: uuid, bids: bids)

        for bid in bids {
            bid.parentGame = self
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: GameKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(uuid, forKey: .uuid)

        var nested = c.nestedUnkeyedContainer(forKey: .bids)
        try nested.encode(bids)
    }

    func addNewBid(_ bid: Bid) {
        assert(bids.contains {$0 === bid} == false )
        bids.insert(bid, at: 0)
        bid.parentGame = self

        let newIndex = bids.index(of: bid)!
        store?.save(bid, userInfo: [Game.changeReasonKey: Game.added,
                                    Game.newValueKey: newIndex])
    }

    func removeBid(_ bid: Bid) {
        guard let index = bids.index(of: bid) else { return }
        bids.remove(at: index)
        store?.save(bid, userInfo: [Game.changeReasonKey: Game.removed,
                                    Game.oldValueKey: index])
    }
}

extension Game {
    /// The scoring rules available for a single game of Bridge
    enum ScoringRules: String, CustomStringConvertible {
        var description: String {
            return rawValue
        }

        case duplicate = "duplicate"
        case rubber = "rubber"
        case chicago = "chicago"
    }
}

extension Game {
    static let changeReasonKey = "reason"
    static let newValueKey = "newValue"
    static let oldValueKey = "oldValue"
    static let renamed = "renamed"
    static let added = "added"
    static let removed = "removed"
    static let updatedTricksTaken = "updatedTricksTaken"
}
