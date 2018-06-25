//
//  Store.swift
//  Bridger
//
//  Stores the location of the documents directory, as well as provides functions
//  for saving, initializing, and sending notifications regarding changes in a Game.
//  Created by Eduard Lev on 6/4/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import Foundation

/// Allows access to the saved games through the documents directory.
final class Store {

    /// Singleton instance for the app. Linked to documents directory.
    /// - note: Access throughout the app using Store.shared
    static let shared = Store(url: documentDirectory)

    // This is set on initialization. If nil, it means the file was not yet created.
    let baseURL: URL?

    // The base game connected to this store.
    private(set) var rootGame: Game

    init(url: URL?) {
        self.baseURL = url

        if let url = url,
            let data = try? Data(contentsOf:
                url.appendingPathComponent(.storeFilename)),
            let game = try? JSONDecoder().decode(Game.self, from: data) {
            self.rootGame = game
        } else {
            // Create new, blank game
            // Allow user to set the name (todo)
            self.rootGame = Game(name: "", uuid: UUID())
        }

        self.rootGame.store = self
    }

    /// Saves the root game associated with this store object to the documents directory.
    /// Also posts a notification to observers about how the game changed, so they can
    /// react as necessary.
    ///
    /// - Parameters:
    ///   - notifying: The Bid object that was changed (added / removed / updated)
    ///   - userInfo: A Dictionary object that contains information about the change.
    func save(object: Bid, userInfo: [String: Any]) throws {
        if let url = baseURL, let data = try? JSONEncoder().encode(rootGame) {
            do {
                try data.write(to: url.appendingPathComponent(.storeFilename))
            } catch let error { throw error }
        }

        NotificationCenter.default.post(name: Store.changedNotification,
                                        object: object,
                                        userInfo: userInfo)
    }
}

extension Store {
    // All notifications from the store will be this name
    static let changedNotification = Notification.Name("StoreChanged")

    // Simple reference to the document directory
    static private let documentDirectory = try?
        FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
}

fileprivate extension String {
    static let storeFilename = "store.json"
}
