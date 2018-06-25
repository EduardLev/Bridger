//
//  UIViewController+Alert.swift
//  Bridger
//
//  Created by Eduard Lev on 6/4/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit

extension UIViewController {
    /// Helper function that sends along required information for an alert Controller
    ///
    /// - Parameter type: an instance of an invalid bid
    func showInvalidBidAlert(ofType type: Bid.InvalidBidType) {
        let invalidString = """
                             I can't keep track of the bids if you don't select a \(type.rawValue)!
                             Please select one.
                             """
        let invalidBid = "Invalid Bid"
        showAlert(withMessage: invalidString, title: invalidBid)
    }

    /// Creates and displays an alert popup.
    ///
    /// - Parameters:
    ///   - message: The message displayed to the user
    ///   - title: The title of the alert popup displayed to the user
    ///   - returnTitle: What the user presses to dismiss the popup
    func showAlert(withMessage message: String, title: String, returnTitle: String = "Go Back") {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let returnAction = UIAlertAction(title: returnTitle, style: .cancel, handler: nil)
        alertController.addAction(returnAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
