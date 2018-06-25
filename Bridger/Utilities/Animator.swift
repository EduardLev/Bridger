//
//  Animator.swift
//  Bridger
//
//  Animation helper
//  Created by Eduard Lev on 6/4/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit

struct Animator {
/// Animation that simulates a button push.
///
/// - Parameter sender: The UIButton to be animated
public func animatePressDown(forButton sender: UIButton) {
    UIView.animate(withDuration: 0.02, delay: 0, options: UIViewAnimationOptions.curveLinear,
                   animations: {
                    sender.transform = CGAffineTransform(scaleX: Animation.buttonPressDownScale,
                                                         y: Animation.buttonPressDownScale)
    })
}

/// Animation that simulates button springing back up after a button push
///
/// - Parameter sender: The UIButton to be animated
/// - Note: see `animatePressDown`.
public func animateSpringBackUp(_ sender: UIButton) {
    UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveLinear,
                   animations: {
                    sender.transform = CGAffineTransform.identity
                    sender.transform = CGAffineTransform(scaleX: Animation.buttonSpringBackUpScale,
                                                         y: Animation.buttonSpringBackUpScale) },
                   completion: { _ in UIView.animate(withDuration: 0.1,
                                                     delay: 0,
                                                     options: .curveEaseInOut,
                                                     animations: {
                                                        sender.transform = CGAffineTransform.identity
                                                     }, completion: nil) })
}
}

private struct Animation {
    // Adjust the ratio at which the button becomes smaller on press down
    static let buttonPressDownScale: CGFloat = 0.8

    // Adjust the ratio at which the button becomes larger on spring back up
    static let buttonSpringBackUpScale: CGFloat = 1.2
}
