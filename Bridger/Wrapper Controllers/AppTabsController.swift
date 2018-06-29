//
//  AppTabsController.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/24/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class AppTabsController: TabsController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }

    open override func prepare() {
        super.prepare()

        // Sets the tab bar selection line to green
        tabBar.setLineColor(Color.green.base, for: .selected)

        // Sets the normal/selected/highlighted colors of the tab bar items.
        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
        tabBar.setTabItemsColor(Color.green.base, for: .selected)
        tabBar.setTabItemsColor(Color.blue.base, for: .highlighted)

        tabBar.tabBarStyle = .auto
        tabBar.lineAlignment = .bottom
        tabBar.lineHeight = 5
    }
}
