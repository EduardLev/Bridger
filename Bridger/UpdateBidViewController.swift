//
//  UpdateBidViewController.swift
//  Bridger
//
//  Created by Eduard Lev on 6/12/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class UpdateBidViewController: UIViewController {

    // Model object that is shown here
    var bid: Bid?

    @IBOutlet var tricksTakenCollection: [RaisedButton]!
    @IBOutlet weak var completeInputButton: RaisedButton!
    fileprivate let animator = Animator()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDisplayForBid()
    }

    var selectedButton: RaisedButton? {
        return tricksTakenCollection.filter( {$0.isSelected} ).first
    }

    // touch up Inside
    @IBAction func didSelectTricksTaken(_ sender: RaisedButton) {
        selectTricks(forButton: sender)
    }

    // touch up outside
    @IBAction func didTouchUpOutsideTricksTakenButton(_ sender: RaisedButton) {
        selectTricks(forButton: sender)
    }

    // touch down
    @IBAction func didTouchDownButton(_ sender: RaisedButton) {
        animator.animatePressDown(forButton: sender)
    }

    fileprivate func selectTricks(forButton button: RaisedButton) {
        toggleButtonsEnabledStatus(button)
        animator.animateSpringBackUp(button)
    }

    fileprivate func toggleButtonsEnabledStatus(_ sender: RaisedButton) {
        _ = tricksTakenCollection.map {
            $0.alpha = ($0 == sender) ? 1 : 0.5
            $0.isSelected = ($0 == sender)
        }
        enableCompleteInputButton()
    }

    fileprivate func enableCompleteInputButton() {
        if selectedButton != nil {
            completeInputButton.isUserInteractionEnabled = true
            completeInputButton.alpha = 1
        }
    }

    fileprivate func updateDisplayForBid() {
        if let bid = bid, let tricksWon = bid.tricksWon {
            selectTricks(forButton: tricksTakenCollection[tricksWon - 1])
            completeInputButton.setTitle("Update Tricks", for: .normal)
        }
    }

    @IBAction func inputTricksDidTouchUpInside(_ sender: RaisedButton) {
        if let selectedButton = selectedButton,
            let bid = bid,
                let tricksWon = Int((selectedButton.titleLabel?.text)!) {
            bid.setTricksWon(to: tricksWon)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
