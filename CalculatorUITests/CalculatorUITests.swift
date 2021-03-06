//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Ehab Hanna on 9/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {
    
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMinimalExistanceOfDigits() {
        for i in 0...9
        {
            XCTAssertTrue(app.buttons["\(i)"].exists, "There should be a button for \(i)")
        }
    }
    
    func testMinimalExistanceOfOps() {
        XCTAssertTrue(app.buttons["+"].exists, "App should support addition")
        XCTAssertTrue(app.buttons["-"].exists, "App should support subtraction")
        XCTAssertTrue(app.buttons["/"].exists, "App should support division")
        XCTAssertTrue(app.buttons["*"].exists, "App should support multiplication")
    }
    
    func testUserEntry() {
        app.buttons["7"].tap()
        XCTAssertTrue(app.staticTexts["7"].exists, "App should have shown 7 on a display somewhere")
        app.buttons["9"].tap()
        XCTAssertTrue(app.staticTexts["79"].exists, "App should have shown 79 on a display somewhere")
        app.buttons["2"].tap()
        XCTAssertTrue(app.staticTexts["792"].exists, "App should have shown 792 on a display somewhere")
        
    }
    
    func testPendingBinaryOp() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        let opDisplay = app.staticTexts["7.0 + ..."]
        XCTAssertTrue(opDisplay.exists)
        
    }
    
    func testBinaryOpPendingBeforeEquals(){
        testPendingBinaryOp()
        XCUIApplication().buttons["9"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["7.0 + ..."].exists)
    }
    
    func testBinaryOpPendingAfterEquals() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        testBinaryOpPendingBeforeEquals()
        XCUIApplication().buttons["="].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["7.0 + 9.0="].exists)
        
    }
    
    func testUnaryOpAfterBinaryOP(){
        
        testBinaryOpPendingAfterEquals()
        XCUIApplication().buttons["√"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["√(7.0 + 9.0)="].exists)
    }
    
    func testChainBinaryUnaryPendingBinary(){
        testUnaryOpAfterBinaryOP()
        XCUIApplication().buttons["+"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["√(7.0 + 9.0) + ..."].exists)
        
    }
    
    func testChainBinaryUnaryPendingBinarybeforeEqual(){
        
        testChainBinaryUnaryPendingBinary()
        XCUIApplication().buttons["2"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["√(7.0 + 9.0) + ..."].exists)
        
    }
    
    func testChainBinaryUnaryPendingBinaryAfterEqual(){
        testChainBinaryUnaryPendingBinarybeforeEqual()
        XCUIApplication().buttons["="].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["√(7.0 + 9.0) + 2.0="].exists)
    }
    
    func testBinaryOpWithResultOfUnaryOp(){
        
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["√"].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["7.0 + √(9.0)..."].exists)
    }
    
    func testChainBinaries(){
        let app = XCUIApplication()
        app.buttons["7"].tap()
        app.buttons["+"].tap()
        app.buttons["9"].tap()
        app.buttons["+"].tap()
        app.buttons["6"].tap()
        app.buttons["="].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["="].tap()
        XCTAssertTrue(XCUIApplication().staticTexts["7.0 + 9.0 + 6.0 + 3.0="].exists)
    }
    
    
}
