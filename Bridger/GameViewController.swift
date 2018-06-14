//
//  GameViewController.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/24/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class GameViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        prepareTabItem()
        prepareNewBidButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Game viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Game viewDidAppear")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Game viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Game viewDidDisappear")
    }
}

extension GameViewController {
    fileprivate func prepareTabItem() {
        tabItem.title = "Game"
        tabItem.image = Icon.home
        tabItem.pulseAnimation = .backing
    }

    fileprivate func prepareNewBidButton() {

    }
}
