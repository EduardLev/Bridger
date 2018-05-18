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

    // MARK: View Properties

    /// View outlet for the N/E/W/S buttons which determine
    /// the declarer for this particular bid.
    /// Buttons will be circles since the cornerRadius is 1/2 of the width of the button
    @IBOutlet var declarerButtons: [UIButton]! {
        didSet {
            for button in declarerButtons {
                button.layer.cornerRadius = button.frame.size.width/2
            }
        }
    }

    /// View outlet for the "Trump" Buttons
    @IBOutlet var trumpButtons: [UIButton]!

    /** Links all buttons 'touch Down' event to a "press down" animation. */
    @IBAction func touchDownButton(_ sender: UIButton) {
        animatePressDown(forButton: sender)
    }

    // MARK: Declarer Buttons Target - Action Events

    /** Links the N/E/W/S buttons 'touch Up Outside' event to the required action. */
    @IBAction func touchUpOutsideButton(_ sender: UIButton) {
        selectButtonClicked(asButton: sender)
    }

    /** Links the N/E/W/S buttons 'touch Up Inside' event to the required action. */
    @IBAction func touchUpInsideButton(_ sender: UIButton) {
        selectButtonClicked(asButton: sender)
    }

    // MARK: Trump Buttons Target - Action Events

    // MARK: Animation Methods

    /**
     Animates the look of a button for 'touch down' events on button by a user.

     - parameter sender: The button selected by the user
    */
    func animatePressDown(forButton sender: UIButton) {
        UIView.animate(withDuration: 0.02,
                       delay: 0,
                       options: UIViewAnimationOptions.curveLinear,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: Animation.buttonPressDownScale,
                                                             y: Animation.buttonPressDownScale)
        })
    }

    /**
     Resizes the button back to its original size and changes the background color
     so the user can see that this button is selected.
     Also adds a "spring" action.

     - parameter sender: The button selected by the user
     */
    fileprivate func animateSpringBackUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: UIViewAnimationOptions.curveLinear,
                       animations: {
                        sender.transform = CGAffineTransform.identity
                        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { success in UIView.animate(withDuration: 0.1,
                                                   delay: 0,
                                                   options: .curveEaseInOut,
                                                   animations: {
                                                    sender.transform = CGAffineTransform.identity
        }, completion: nil) })
    }

    // MARK: Target Action Methods

    /**
     Selects a declarer - involves deselecting other buttons that were not pressed, along
     with animating the selected button to "spring" into place.

     - parameter sender: The button selected by the user
    */
    @IBAction func selectButtonClicked(asButton sender: UIButton) {
        toggleButtonsEnabledStatus(sender)
        animateSpringBackUp(sender)
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
        }
    }
}

// MARK: Private Constants

extension InputBidTableViewController {
    private struct Colors {
        static let selectedButtonColor = UIColor(red: 38/255, green: 220/255, blue: 40/255, alpha: 1.0)
        static let unselectedButtonColor = UIColor(red: 38/255, green: 128/255, blue: 40/255, alpha: 1.0)
    }

    private struct Animation {
        static let buttonPressDownScale: CGFloat = 0.8
    }
}
