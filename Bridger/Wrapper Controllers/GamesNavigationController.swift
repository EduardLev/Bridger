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

        guard let v = navigationBar as? NavigationBar else {
            return
        }

        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten2
    }

}
