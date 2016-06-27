//
//  Tests.swift
//  NumPad
//
//  Created by Lasha Efremidze on 5/27/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import XCTest
@testable import NumPad

class Tests: XCTestCase {
    
    private var viewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIViewController()
        viewController.view.frame = UIScreen.mainScreen().bounds
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewController = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let numPad = DefaultNumPad()
        numPad.frame = viewController.view.bounds
        viewController.view.addSubview(numPad)
        
        viewController.view.setNeedsLayout()
        viewController.view.layoutIfNeeded()
        
        let cell = numPad.collectionView.visibleCells().flatMap { $0 as? Cell }.first!
        cell._buttonTapped(cell.button)
    }
    
}
