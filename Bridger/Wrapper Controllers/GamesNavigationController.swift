//
//  GamesNavigationController.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/25/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class GamesNavigationController: NavigationController {

    open override func prepare() {
        super.prepare()
        isMotionEnabled = true

        guard let navigationBar = navigationBar as? NavigationBar else {
            return
        }

        navigationBar.depthPreset = .none
        navigationBar.dividerColor = Color.grey.lighten2
    }

}
