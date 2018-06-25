//
//  InputBidTableViewController.swift
//  Bridger
//
//  Created by Eduard Lev on 4/26/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class InputBidTableViewController: UITableViewController {

    // MARK: - View Properties
    public var game = Store.shared.rootGame
    fileprivate let animator = Animator()

    /// View outlet for the N/E/W/S buttons which determine declarer
    @IBOutlet var declarerButtons: [UIButton]!

    /// View outlet for the Trump suit buttons
    @IBOutlet var trumpButtons: [UIButton]!

    /// View outlets for the segmented control pickers
    @IBOutlet weak var tricksTakenSegmentedControl: UISegmentedControl!
    @IBOutlet weak var doubledStatusSegmentedControl: UISegmentedControl!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This view should not make itself visible if the Game's last Bid object has not yet been scored.
        if game.bids.count != 0 {
            if game.bids[0].wasSuccessful == nil {
                self.dismiss(animated: true, completion: nil)
                self.showAlert(withMessage: "Wait! I can't enter a new Bid until the previous Bid has been scored.",
                               title: "Incomplete Bid!",
                               returnTitle: "Go Back")
            }
        }
    }

    // MARK: - Target Action

    /** Links all buttons 'touch Down' event to a "press down" animation. */
    @IBAction func touchDownButton(_ sender: UIButton) {
        animator.animatePressDown(forButton: sender)
    }

    /** Links all buttons 'touch Up Outside' event to the required action. */
    @IBAction func touchUpOutsideButton(_ sender: UIButton) {
        selectButtonClicked(asButton: sender)
    }

    /** Links all buttons 'touch Up Inside' event to the required action. */
    @IBAction func touchUpInsideButton(_ sender: UIButton) {
        selectButtonClicked(asButton: sender)
    }

    /** Links 'enter bid' button to the required action. */
    @IBAction func enterBidDidTouchUpInside(_ sender: RaisedButton) {
        checkUserInput()
    }

    /**
     Selects a declarer - involves deselecting other buttons that were not pressed, along
     with animating the selected button to "spring" into place.

     - parameter sender: The button selected by the user
    */
    @IBAction func selectButtonClicked(asButton sender: UIButton) {
        toggleButtonsEnabledStatus(sender)
        animator.animateSpringBackUp(sender)
    }

    /**
     Loops through the declarer buttons and disables those that were selected by the user.
     Changes the background color of the selected & unselected buttons corresponding
     to their status.

     - parameter sender: The button selected by the user
    */
    fileprivate func toggleButtonsEnabledStatus(_ sender: UIButton) {
        var selectedGroupOfButtons = [UIButton]()

        // If it does, then it is a suit type button
        if let buttonTitle = sender.titleLabel?.text {
            if Card.Suit.allRawValues.contains(buttonTitle) {
                selectedGroupOfButtons = trumpButtons
            } else {
                selectedGroupOfButtons = declarerButtons
            }
        }

        for button in selectedGroupOfButtons {
            button.alpha = (button == sender) ? 1 : 0.5
            button.isSelected = button == sender
        }
    }

    // MARK: - User Input Validation

    /** */
    fileprivate func checkUserInput() {
        let declarer: Player? = getSelectedDeclarer()
        let trumpSuit: Card.Suit? =  getSelectedTrump()
        let tricks: Int = getSelectedTricks()
        let doubledStatus: Bid.DoubleStatus = getSelectedDoubledStatus()

        guard declarer != nil else { self.showInvalidBidAlert(ofType: .declarer); return }
        guard trumpSuit != nil else { self.showInvalidBidAlert(ofType: .trumpSuit); return }
        guard tricks != -1 else { self.showInvalidBidAlert(ofType: .tricks); return }

        let bid = Bid(tricksBid: tricks, trumpSuit: trumpSuit!, declarer: declarer!, doubled: doubledStatus)
        game.addNewBid(bid) // update model

        self.dismiss(animated: true, completion: nil)
    }

    fileprivate func getSelectedDeclarer() -> Player? {
        for button in declarerButtons where button.isSelected {
            if let buttonStringSelected = button.titleLabel?.text {
                let playerSelected = Player(rawValue: buttonStringSelected)
                return playerSelected
            }
            }
        // No button selected
        return nil
    }

    fileprivate func getSelectedTrump() -> Card.Suit? {
        for button in trumpButtons where button.isSelected {
            if let buttonStringSelected = button.titleLabel?.text {
                let trumpSelected = Card.Suit(rawValue: buttonStringSelected)
                return trumpSelected
            }
        }
        // No button selected
        return nil
    }

    fileprivate func getSelectedTricks() -> Int {
        // explain why 6
        return tricksTakenSegmentedControl.selectedSegmentIndex + 1 + 6
    }

    fileprivate func getSelectedDoubledStatus() -> Bid.DoubleStatus {
        switch doubledStatusSegmentedControl.selectedSegmentIndex {
        case 1: return Bid.DoubleStatus.doubled
        case 2: return Bid.DoubleStatus.redoubled
        default: return Bid.DoubleStatus.regular
        }
    }
}
