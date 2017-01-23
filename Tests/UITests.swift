//
//  UITests.swift
//  NumPad
//
//  Created by Lasha Efremidze on 5/27/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        if #available(iOS 9.0, *) {
            XCUIApplication().launch()
        } else {
            // Fallback on earlier versions
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if #available(iOS 9.0, *) {
            let app = XCUIApplication()
            
            let textField = app.textFields["0"]
            XCTAssert(textField.exists)
            
            let buttons = app.collectionViews.buttons
            buttons["1"].tap()
            buttons["2"].tap()
            buttons["3"].tap()
            buttons["4"].tap()
            buttons["5"].tap()
            buttons["6"].tap()
            buttons["7"].tap()
            buttons["8"].tap()
            buttons["9"].tap()
            buttons["0"].tap()
            buttons["00"].tap()
            buttons["C"].tap()
            buttons["0"].tap()
        } else {
            // Fallback on earlier versions
        }
    }
    
}
