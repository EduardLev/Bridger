//
//  AppToolbarController.swift
//  BridgeScoring
//
//  Created by Eduard Lev on 4/25/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import UIKit
import Material

class AppToolbarController: ToolbarController {
    fileprivate var menuButton: IconButton!
    fileprivate var starButton: IconButton!
    fileprivate var searchButton: IconButton!

    open override func prepare() {
        super.prepare()
        prepareMenuButton()
        prepareStarButton()
        prepareSearchButton()
        prepareStatusBar()
        prepareToolbar()
    }
}

extension AppToolbarController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu, tintColor: .white)
        menuButton.pulseColor = .white
    }

    fileprivate func prepareStarButton() {
        starButton = IconButton(image: Icon.cm.star, tintColor: .white)
        starButton.pulseColor = .white
    }

    fileprivate func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.search, tintColor: .white)
        searchButton.pulseColor = .white
    }

    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.green.base
    }

    fileprivate func prepareToolbar() {
        toolbar.depthPreset = .depth2
        toolbar.backgroundColor = Color.green.base

        toolbar.title = "Bridger"
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center

        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
        toolbar.detailLabel.text = "A bridge scoring application"

        toolbar.leftViews = [menuButton]
        toolbar.rightViews = [starButton, searchButton]
    }

}
