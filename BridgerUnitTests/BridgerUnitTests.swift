//
//  BridgerUnitTests.swift
//  BridgerUnitTests
//
//  Created by Eduard Lev on 6/27/18.
//  Copyright © 2018 Eduard Levshteyn. All rights reserved.
//

import XCTest
@testable import Bridger

class BridgerUnitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func constructStoreForTesting() -> Store {
        let testingStore = Store(url: nil)

        // Create some bids
        let testingBid1 = Bid(tricksBid: 5, trumpSuit: .clubs, declarer: .east, doubled: .doubled)
        let testingBid2 = Bid(tricksBid: 2, trumpSuit: .diamonds, declarer: .north, doubled: .regular)
        testingStore.rootGame.addNewBid(testingBid1)
        testingStore.rootGame.addNewBid(testingBid2)

        return testingStore
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
