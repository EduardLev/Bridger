//
//  Game.swift
//  BridgeScoring
//
//  A Game object keeps track of all the properties in a single Game. This includes
//  the total over scores for both WE and THEY, as well as the won / lost statuses for each
//  rubber. Of course, it keeps track of all the Bids made in the game in order to be able to calculate
//  the score.
//
//  It is capable of adding, removing and updating Bids. Since the vulnerability property
//  of a Bid is based on Game state, a Game also updates this value for all Bids when a Bid is added,
//  removed or updated. A Game object will also keep track of the score for bot WE and THEY
//  and manage win/lose conditions.
//
//  Created by Eduard Lev on 4/23/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

class Game: Codable {

    // A game has a unique identifier, a name and an array of Bid objects.
    let uuid: UUID
    private(set) var name: String
    private(set) var bids: [Bid]

    /// Reference to the Store helper object that will initialize and save the game object.
    weak var store: Store?

    // Game state properties
    private(set) var weOverScore = [Int]()
    private(set) var weUnderScore = [[Int]]()
    private(set) var theyOverScore = [Int]()
    private(set) var theyUnderScore = [[Int]]()

    // Rubber bridge "games" properties
    private var rubberOneCompleted = false
    private var rubberTwoCompleted = false
    private var rubberThreeCompleted = false

    private var weHaveWonARubber = false
    private var theyHaveWonARubber = false

    init(name: String, uuid: UUID) {
        self.name = name
        self.uuid = uuid
        self.bids = []
        self.store = nil
    }

    enum GameKeys: CodingKey { case name, uuid, bids, weOverScore, weUnderScore, theyOverScore,
        theyUnderScore, rubberOneCompleted, rubberTwoCompleted, rubberThreeCompleted,
        weHaveWonARubber, theyHaveWonARubber }
    enum BidKeys: CodingKey { case bid }

    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: GameKeys.self)
        let uuid = try container.decode(UUID.self, forKey: .uuid)
        let name = try container.decode(String.self, forKey: .name)
        let weOverScore = try container.decode([Int].self, forKey: .weOverScore)
        let weUnderScore = try container.decode([[Int]].self, forKey: .weUnderScore)
        let theyOverScore = try container.decode([Int].self, forKey: .theyOverScore)
        let theyUnderScore = try container.decode([[Int]].self, forKey: .theyUnderScore)
        let rubberOneCompleted = try container.decode(Bool.self, forKey: .rubberOneCompleted)
        let rubberTwoCompleted = try container.decode(Bool.self, forKey: .rubberTwoCompleted)
        let rubberThreeCompleted = try container.decode(Bool.self, forKey: .rubberThreeCompleted)
        let weHaveWonARubber = try container.decode(Bool.self, forKey: .weHaveWonARubber)
        let theyHaveWonARubber = try container.decode(Bool.self, forKey: .theyHaveWonARubber)

        var nested = try container.nestedUnkeyedContainer(forKey: .bids)
        var bids = [Bid]()
        bids = try nested.decode([Bid].self)

        self.init(name: name, uuid: uuid)
        self.bids = bids
        self.weOverScore = weOverScore
        self.weUnderScore = weUnderScore
        self.theyUnderScore = theyUnderScore
        self.theyOverScore = theyOverScore
        self.rubberOneCompleted = rubberOneCompleted
        self.rubberTwoCompleted = rubberTwoCompleted
        self.rubberThreeCompleted = rubberThreeCompleted
        self.weHaveWonARubber = weHaveWonARubber
        self.theyHaveWonARubber = theyHaveWonARubber

        for bid in bids { bid.parentGame = self }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GameKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(weOverScore, forKey: .weOverScore)
        try container.encode(weUnderScore, forKey: .weUnderScore)
        try container.encode(theyOverScore, forKey: .theyOverScore)
        try container.encode(theyUnderScore, forKey: .theyUnderScore)
        try container.encode(rubberOneCompleted, forKey: .rubberOneCompleted)
        try container.encode(rubberTwoCompleted, forKey: .rubberTwoCompleted)
        try container.encode(rubberThreeCompleted, forKey: .rubberThreeCompleted)
        try container.encode(weHaveWonARubber, forKey: .weHaveWonARubber)
        try container.encode(theyHaveWonARubber, forKey: .theyHaveWonARubber)

        var nested = container.nestedUnkeyedContainer(forKey: .bids)
        try nested.encode(bids)
    }

    func addNewBid(_ bid: Bid) {
        assert(bids.contains {$0 === bid} == false )
        bids.insert(bid, at: 0)
        bid.parentGame = self
        let newIndex = bids.index(of: bid)!

        do {
            try store?.save(object: bid, userInfo: [Game.changeReasonKey: Game.added,
                                                    Game.newValueKey: newIndex])
            // When a bid is added, the game knows everything it needs to know
            // to set whether or not the bid is in a vulnerable state.
            setVulnerabilityOfBid(bid)
        } catch let error {
            // Remove the bid because it wasn't able to be saved in the store.
            bids.remove(at: 0)
            print(error.localizedDescription)
        }
    }

    func removeBid(_ bid: Bid) {
        guard let index = bids.index(of: bid) else { return }
        bids.remove(at: index)

        do {
            try store?.save(object: bid, userInfo: [Game.changeReasonKey: Game.removed,
                                                    Game.oldValueKey: index])
            resetGameState()
            reloadGameStateBasedOnBids()
        } catch let error {
            // Add the bid back because it wasn't able to be saved in the store.
            bids.insert(bid, at: index)
            print(error.localizedDescription)
        }
    }

    func updateBid(_ bid: Bid) {
        guard let index = bids.index(of: bid) else { return }

        // Update view controller to change the row as well (todo)
        do { try store?.save(object: bid, userInfo: [Game.changeReasonKey: Game.updatedTricksTaken,
                                                    Game.oldValueKey: index])
            // Now that the Bid has been scored, the Game score can be updated / calculated.
            updateGameScoreForUpdatedBid(bid)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    /// Sets the scoring to 0 so the Game scores can be recalculated
    fileprivate func resetGameState() {
        weOverScore = []
        weUnderScore = [[], [], []]
        theyOverScore = []
        theyUnderScore = [[], [], []]

        rubberOneCompleted = false
        rubberTwoCompleted = false
        rubberThreeCompleted = false

        weHaveWonARubber = false
        theyHaveWonARubber = false
    }

    /// Cycles through all bids started with the first bid (which is at the end of the array)
    /// The call to updateBid will ensure that the Game Score is updated for each subsequent Bid.
    fileprivate func reloadGameStateBasedOnBids() {
        for bid in bids.reversed() {
            setVulnerabilityOfBid(bid)
            updateBid(bid)
        }
    }
}

extension Game {
    /// This function depends on the *current* game state at the time.
    /// There is no intermediate game state!
    /// Calling this function on a Bid in the middle of the bids array will incorrectly
    /// set that Bid's vulnerability based on the state of the Game after the most recent Bid!
    /// - Parameter bid: The *most recent* Bid added / updated in the game.
    fileprivate func setVulnerabilityOfBid(_ bid: Bid) {
        bid.theyVulnerable = weHaveWonARubber
        bid.weVulnerable = theyHaveWonARubber
    }

    fileprivate func updateGameScoreForUpdatedBid(_ bid: Bid) {
        guard let bidSuccess = bid.wasSuccessful else { fatalError() }

        
        if bid.declarer == .east || bid.declarer == .west { // WE DECLARED
            if bidSuccess {
                updateGameScoreForSuccessfulBid(bid: bid,
                                                withOverScore: &weOverScore,
                                                andUnderScore: &weUnderScore,
                                                andWinner: "WE")
            } else {
                updateGameScoreForUnsuccessfulBid(bid: bid,
                                                  withOverScore: &theyOverScore)
            }
        } else if bid.declarer == .north || bid.declarer == .south { // THEY DECLARED
            if bidSuccess {
                updateGameScoreForSuccessfulBid(bid: bid,
                                                withOverScore: &theyOverScore,
                                                andUnderScore: &theyUnderScore,
                                                andWinner: "THEY")
            } else {
                updateGameScoreForUnsuccessfulBid(bid: bid,
                                                  withOverScore: &weOverScore)
            }
        }

        checkGameOver()
    }

    fileprivate func checkGameOver() {
        if rubberOneCompleted && rubberTwoCompleted && rubberThreeCompleted {
            gameOver()
        }
    }

    fileprivate func updateGameScoreForSuccessfulBid(bid: Bid,
                                                     withOverScore overScore: inout [Int],
                                                     andUnderScore underScore: inout [[Int]],
                                                     andWinner winner: String) {
        overScore.append(bid.overTheLineScore)

        if !rubberOneCompleted {
            underScore[0].append(bid.underTheLineScore)
            let gameOneScore = underScore[0].reduce(0, +)
            rubberOneCompleted = gameOneScore >= 100
            if rubberOneCompleted { updateRubberWinStatus(withWinner: winner) }
        } else if !rubberTwoCompleted {
            underScore[1].append(bid.underTheLineScore)
            let gameTwoScore = underScore[1].reduce(0, +)
            rubberTwoCompleted = gameTwoScore >= 100
            if rubberTwoCompleted { updateRubberWinStatus(withWinner: winner) }
        } else if !rubberThreeCompleted {
            underScore[2].append(bid.underTheLineScore)
            let gameThreeScore = underScore[2].reduce(0, +)
            rubberThreeCompleted = gameThreeScore >= 100
            if rubberThreeCompleted { updateRubberWinStatus(withWinner: winner) }
        } else {
            // game over!
        }
    }

    fileprivate func updateGameScoreForUnsuccessfulBid(bid: Bid, withOverScore overScore: inout [Int]) {
        overScore.append(bid.overTheLineScore)
    }

    fileprivate func updateRubberWinStatus(withWinner winner: String) {
        switch winner {
        case "WE": weHaveWonARubber = true
        case "THEY": theyHaveWonARubber = true
        default: break
        }
    }
}

extension Game {
    fileprivate func gameOver() {
        let weTotalScore = calculateTotalPlayerScore(withOver: weOverScore, andUnder: weUnderScore)
        let theyTotalScore = calculateTotalPlayerScore(withOver: theyOverScore, andUnder: theyUnderScore)
        if weTotalScore > theyTotalScore {
            print("WE WIN")
        } else {
            print("THEY WIN")
        }
    }

    fileprivate func calculateOneRubberScore(withRubber rubber: [Int]) -> Int {
        return rubber.reduce(0, +)
    }

    fileprivate func calculateTotalPlayerScore(withOver over: [Int], andUnder under: [[Int]]) -> Int {
        return (over + under.flatMap {$0}).lazy.reduce(0, +)
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
