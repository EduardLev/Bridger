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

    private var weOverScore = [Int]()
    private var weUnderScore = [String: [Int]]()
    private var theyOverScore = [Int]()
    private var theyUnderScore = [String: [Int]]()

    weak var store: Store?

    init(name: String, uuid: UUID) {
        bids = []
        self.name = name
        self.uuid = uuid
        self.store = nil
    }

    convenience init(name: String, uuid: UUID, bids: [Bid], weOverScore: [Int], weUnderScore: [String: [Int]], theyOverScore: [Int], theyUnderScore: [String: [Int]]) {
        self.init(name: name, uuid: uuid)
        self.bids = bids
        self.weUnderScore = weUnderScore
        self.weOverScore = weOverScore
        self.theyUnderScore = theyUnderScore
        self.theyOverScore = theyOverScore
    }

    enum GameKeys: CodingKey { case name, uuid, bids, weOverScore, weUnderScore, theyOverScore, theyUnderScore }
    enum BidKeys: CodingKey { case bid }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GameKeys.self)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let name = try container.decode(String.self, forKey: .name)
        let weOverScore = try container.decode([Int].self, forKey: .weOverScore)
        let weUnderScore = try container.decode([String: [Int]].self, forKey: .weUnderScore)
        let theyOverScore = try container.decode([Int].self, forKey: .theyOverScore)
        let theyUnderScore = try container.decode([String: [Int]].self, forKey: .theyUnderScore)

        var nested = try container.nestedUnkeyedContainer(forKey: .bids)
        var bids = [Bid]()
        bids = try nested.decode([Bid].self)

        self.init(name: name, uuid: uuid, bids: bids, weOverScore: weOverScore, weUnderScore: weUnderScore, theyOverScore: theyOverScore, theyUnderScore: theyUnderScore)

        for bid in bids {
            bid.parentGame = self
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GameKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(uuid, forKey: .uuid)

        var nested = container.nestedUnkeyedContainer(forKey: .bids)
        try nested.encode(bids)
    }

    func addNewBid(_ bid: Bid) {
        assert(bids.contains {$0 === bid} == false )

        // analyze game here

        bids.insert(bid, at: 0)
        bid.parentGame = self

        let newIndex = bids.index(of: bid)!
        store?.save(bid, userInfo: [Game.changeReasonKey: Game.added,
                                    Game.newValueKey: newIndex])
    }

    func removeBid(_ bid: Bid) {
        guard let index = bids.index(of: bid) else { return }
        bids.remove(at: index)

        // analyze game here, and we have to reset all the bids because they may have different scores now!
        // more complicated than add new bid.

        store?.save(bid, userInfo: [Game.changeReasonKey: Game.removed,
                                    Game.oldValueKey: index])
    }

    func updateTricksWon(forBid bid: Bid) {
        guard let index = bids.index(of: bid) else { return }
        // Update view controller to change the row as well (todo)
        store?.save(bid, userInfo: [Game.changeReasonKey: Game.updatedTricksTaken, Game.oldValueKey: index])
    }
}

extension Game {
    // pseudocode
    // when new bid is added, we have available the over score and under score.
    // first we have to determine whether or not the bid is vulnerable
    // then we have to update the bid with that information, which will inform its score
    // then we have to add the score to the total game arrays
    // then we have to determine if a rubber was won by either team
    // if so, then go on to the next rubber to determine if that was won
    // finally, if all 3 rubbers won, game is over and calculate final score

}

extension Game {
    fileprivate func calculateOneRubberScore(withRubber rubber: [Int]) -> Int {
        return rubber.reduce(0, +)
    }

    fileprivate func calculateTotalPlayerScore(withOver over: [Int], andUnder under: [String: [Int]]) -> Int {
        return (over + under.reduce([], {$0 + $1.value})).reduce(0, +)
    }
}

extension Game {
    /// The scoring rules available for a single game of Bridge
    /// For future versions. Current is only rubber bridge
    enum ScoringRules: String, CustomStringConvertible {
        var description: String {
            return rawValue
        }

        case duplicate
        case rubber
        case chicago
    }

    static let rubberOne = "RubberOne"
    static let rubberTwo = "RubberTwo"
    static let rubberThree = "RubberThree"
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
