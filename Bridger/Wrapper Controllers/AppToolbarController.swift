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
    fileprivate var addButton: IconButton!

    open override func prepare() {
        super.prepare()
        prepareMenuButton()
        prepareAddButton()
        prepareStatusBar()
        prepareToolbar()
    }
}

// MARK: - View Preparation

extension AppToolbarController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu, tintColor: .white)
        menuButton.pulseColor = .white
    }

    fileprivate func prepareAddButton() {
        addButton = IconButton(image: Icon.cm.add, tintColor: .white)
        addButton.pulseColor = .white
        addButton.addTarget(self, action: AppToolbarController.addButtonTapped, for: .touchUpInside)
    }

    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
        statusBar.backgroundColor = Color.green.base
    }

    fileprivate func prepareToolbar() {
        prepareTitle()
        prepareSubTitle()
        toolbar.depthPreset = .depth2
        toolbar.backgroundColor = Color.green.base
        toolbar.leftViews = [menuButton]
        toolbar.rightViews = [addButton]
    }

    fileprivate func prepareTitle() {
        toolbar.title = .title
        toolbar.titleLabel.textColor = .white
        toolbar.titleLabel.textAlignment = .center
    }

    fileprivate func prepareSubTitle() {
        toolbar.detailLabel.text = .detailTitle
        toolbar.detailLabel.textColor = .white
        toolbar.detailLabel.textAlignment = .center
    }
}

// MARK: - Target Actions

fileprivate extension AppToolbarController {
    @objc
    fileprivate func addNewBid() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let inputBidTableViewController = storyboard
            .instantiateViewController(withIdentifier: AppToolbarController.inputBidVCIdentifier)
            as? InputBidTableViewController else { return }
        self.toolbarController?.present(inputBidTableViewController, animated: true, completion: nil)
    }
}

// MARK: - Statics

fileprivate extension AppToolbarController {
    static let addButtonTapped = #selector(addNewBid)
    static let inputBidVCIdentifier = "InputBid"
}

fileprivate extension String {
    static let detailTitle = NSLocalizedString("Rubber Bridge Scoring", comment: "Subheading for the Game view.")
    static let title = NSLocalizedString("Bridger", comment: "The name of the app, displayed as the title.")
}
