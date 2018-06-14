//
//  Animator.swift
//  Bridger
//
//  Created by Eduard Lev on 6/4/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation
import UIKit

/// Animation helper

struct Animator {
/**
 Animates the look of a button for 'touch down' events on button by a user.

 - parameter sender: The button selected by the user
 */
public func animatePressDown(forButton sender: UIButton) {
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
public func animateSpringBackUp(_ sender: UIButton) {
    UIView.animate(withDuration: 0.1,
                   delay: 0,
                   options: UIViewAnimationOptions.curveLinear,
                   animations: {
                    sender.transform = CGAffineTransform.identity
                    sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }, completion: { _ in UIView.animate(withDuration: 0.1,
                                               delay: 0,
                                               options: .curveEaseInOut,
                                               animations: {
                                                sender.transform = CGAffineTransform.identity
    }, completion: nil) })
}

}

private struct Animation {
    static let buttonPressDownScale: CGFloat = 0.8
}
