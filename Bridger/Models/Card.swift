//
//  Card.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/23/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

struct Card {
    var suit: Suit
    var rank: Rank

    /// Stores the suit (spades, hearts, diamonds, clubs, notrump) of the card
    enum Suit: String, CustomStringConvertible {
        var description: String {
            return rawValue
        }

        case spades = "Spades"
        case hearts = "Hearts"
        case diamonds = "Diamonds"
        case clubs = "Clubs"
        case notrump = "No Trump"

        static var all = [Suit.spades, .hearts, .diamonds, .clubs, .notrump]
        static var allRawValues =
            Suit.all.map() { $0.rawValue } 
    }

    enum Rank: CustomStringConvertible {
        var description: String {
            switch self {
            case .ace: return "A"
            case .face(let kind): return kind
            case .numeric(let pips): return String(pips)
            }
        }

        case ace
        case face(String)
        case numeric(Int)

        var order: Int {
            switch self {
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }

        static var all: [Rank] {
            var allRanks: [Rank] = [.ace]
            for pips in 2...10 {
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            return allRanks
        }
    }

}
