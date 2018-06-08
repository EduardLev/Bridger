//
//  Store.swift
//  Bridger
//
//  Created by Eduard Lev on 6/4/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

// Class that represents the saved game
final class Store {

    // Singleton instance for the app. Linked to documents directory
    static let shared = Store(url: documentDirectory)

    let baseURL: URL?
    private(set) var rootGame: Game // the game fetched by the store

    init(url: URL?) {
        self.baseURL = url

        if let u = url,
            let data = try? Data(contentsOf:
                u.appendingPathComponent(.storeLocation)),
            let game = try? JSONDecoder().decode(Game.self, from: data) {
            self.rootGame = game
        } else {
            self.rootGame = Game(name: "", uuid: UUID(), bids: [])
        }

        self.rootGame.store = self
    }

    func save(_ notifying: Bid, userInfo: [AnyHashable: Any]) {
        if let url = baseURL, let data = try? JSONEncoder().encode(rootGame) {
            try! data.write(to: url.appendingPathComponent(.storeLocation))
            // error handling ommitted
        }

        // Send a notification to all registered observers that the store has changed. Users should update accordingly.
        NotificationCenter.default.post(name: Store.changedNotification, object: notifying, userInfo: userInfo)
    }

}

extension Store {
    // All notifications from the store will be this name
    static let changedNotification = Notification.Name("StoreChanged")

    // Simple reference to the document directory
    static private let documentDirectory = try!
        FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
}

fileprivate extension String {
    // Filename for the saved store
    static let storeLocation = "store.json"
}
