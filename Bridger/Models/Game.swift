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
class Game {
    /// The number of players in this game of Bridge.
    var numberOfPlayers = Int()

    /// The rule convention used in this game.
    var type: ScoringRules = .chicago

    /// The bids made in this game by all players.
    var bids = [Bid]()
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
