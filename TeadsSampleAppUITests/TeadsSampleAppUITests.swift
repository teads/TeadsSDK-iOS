//
//  TeadsSampleAppUITests.swift
//  TeadsSampleAppUITests
//
//  Created by Antoine Barrault on 14/01/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import XCTest

class TeadsSampleAppUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testInReadIntegrationInScrollView() throws {
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.otherElements.containing(.staticText, identifier: "Creatives").element.swipeUp()
        app.collectionViews.cells.staticTexts["ScrollView"].tap()
        let scrollViewsQuery = XCUIApplication().scrollViews.firstMatch
        let articleElement = scrollViewsQuery.otherElements.containing(.staticText, identifier:"ARTICLE").element
        let elementsQuery = scrollViewsQuery.otherElements
        while !elementsQuery.otherElements["teads-player"].exists {
            articleElement.swipeUp()
        }
        let player = elementsQuery.otherElements["teads-player"]
        XCTAssert(player.frame.height > 80)
    }
    
}
