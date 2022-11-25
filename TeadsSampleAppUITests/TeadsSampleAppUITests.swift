//
//  TeadsSampleAppUITests.swift
//  TeadsSampleAppUITests
//
//  Created by Antoine Barrault on 14/01/2022.
//  Copyright © 2022 Teads. All rights reserved.
//

import XCTest

class TeadsSampleAppUITests: XCTestCase {
    private let mediaViewIdentifier = "teads-mediaView"

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
        let articleElement = scrollViewsQuery.otherElements.containing(.staticText, identifier: "ARTICLE").element
        let elementsQuery = scrollViewsQuery.otherElements
        while !elementsQuery.otherElements[mediaViewIdentifier].exists {
            articleElement.swipeUp()
        }
        let player = elementsQuery.otherElements[mediaViewIdentifier]
        XCTAssert(player.frame.height > 80)
    }

    func testInReadIntegrationVerticalInScrollView() throws {
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        app.collectionViews.cells.staticTexts["Vertical"].tap()
        collectionViewsQuery.otherElements.containing(.staticText, identifier: "Creatives").element.swipeUp()
        app.collectionViews.cells.staticTexts["ScrollView"].tap()
        let scrollViewsQuery = XCUIApplication().scrollViews.firstMatch
        let articleElement = scrollViewsQuery.otherElements.containing(.staticText, identifier: "ARTICLE").element
        let elementsQuery = scrollViewsQuery.otherElements
        while !elementsQuery.otherElements[mediaViewIdentifier].exists {
            articleElement.swipeUp()
        }
        let player = elementsQuery.otherElements[mediaViewIdentifier]
        XCTAssert(player.frame.height > 80)
    }
}
