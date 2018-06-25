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

    var game: Game = Store.shared.rootGame

    var weOverTableView: UITableView!
    var weUnderTableView: UITableView!
    var theyOverTableView: UITableView!
    var theyUnderTableView: UITableView!

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        prepareTabItem()
        prepareNewBidButton()
        prepareTableViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        weOverTableView.reloadData()
        weUnderTableView.reloadData()
        theyOverTableView.reloadData()
        theyUnderTableView.reloadData()
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

    fileprivate func prepareTableViews() {
        weOverTableView = UITableView()
        weUnderTableView = UITableView()
        theyOverTableView = UITableView()
        theyUnderTableView = UITableView()

        weOverTableView.delegate = self
        weOverTableView.dataSource = self

        weUnderTableView.delegate = self
        weUnderTableView.dataSource = self

        theyOverTableView.delegate = self
        theyOverTableView.dataSource = self

        theyUnderTableView.delegate = self
        theyUnderTableView.dataSource = self

        self.view.addSubview(weOverTableView)
        view.layout(weOverTableView).top().left().right(self.view.bounds.size.width/2).bottom(self.view.bounds.size.height/2)

        self.view.addSubview(weUnderTableView)
        view.layout(weUnderTableView).bottom().left().right(self.view.bounds.size.width/2).top(self.view.bounds.size.height/2)

        self.view.addSubview(theyOverTableView)
        view.layout(theyOverTableView).top().right().left(self.view.bounds.size.width/2).bottom(self.view.bounds.size.height/2)

        self.view.addSubview(theyUnderTableView)
        view.layout(theyUnderTableView).bottom().right().left(self.view.bounds.size.width/2).top(self.view.bounds.size.height/2)
    }
}

extension GameViewController: UITableViewDelegate {

}

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == weOverTableView { return game.weOverScore.count
        } else if tableView == weUnderTableView { return game.weUnderScore.count
        } else if tableView == theyOverTableView { return game.theyOverScore.count
        } else if tableView == theyUnderTableView { return game.theyUnderScore.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
