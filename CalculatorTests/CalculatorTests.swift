//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Ehab Hanna on 9/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

import XCTest


class CalculatorTests: XCTestCase {
    
    private var brain:CalculatorBrain = CalculatorBrain()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        brain = CalculatorBrain()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testBinaryOpNoPending(){
        brain.setOperand(7.0)
        brain.performOperation("+")
        XCTAssert(brain.description == "7.0 + ")
    }
    
    func testBinaryOpPendingBeforeEquals(){
        brain.setOperand(7.0)
        brain.performOperation("+")
        brain.setOperand(9.0)
        XCTAssert(brain.description == "7.0 + ")
    }
    
    func testBinaryOpPendingAfterEquals() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        testBinaryOpPendingBeforeEquals()
        brain.performOperation("=")
        XCTAssert(brain.description == "7.0 + 9.0")
        
    }
    
    func testUnaryOpAfterBinaryOP(){
        
        testBinaryOpPendingAfterEquals()
        brain.performOperation("√")
        XCTAssert(brain.description == "√(7.0 + 9.0)")
    }
    
    func testChainBinaryUnaryPendingBinary(){
        testUnaryOpAfterBinaryOP()
        brain.performOperation("+")
        XCTAssert(brain.description == "√(7.0 + 9.0) + ", "your description is \(brain.description!)")
        
    }
    
    func testChainBinaryUnaryPendingBinarybeforeEqual(){
        
        testChainBinaryUnaryPendingBinary()
        brain.setOperand(2.0)
        XCTAssert(brain.description == "√(7.0 + 9.0) + ", "your description is \(brain.description!)")
    }
    
    func testChainBinaryUnaryPendingBinaryAfterEqual(){
        testChainBinaryUnaryPendingBinarybeforeEqual()
        brain.performOperation("=")
        XCTAssert(brain.description == "√(7.0 + 9.0) + 2.0", "your description is \(brain.description!)")
    }
    
    func testBinaryOpWithResultOfUnaryOp(){
        
        brain.setOperand(7.0)
        brain.performOperation("+")
        brain.setOperand(9.0)
        brain.performOperation("√")
        XCTAssert(brain.description == "7.0 + √(9.0)", "your description is \(brain.description!)")
    }
    
    func testChainBinaries(){
        testBinaryOpPendingAfterEquals()
        brain.performOperation("+")
        brain.setOperand(6.0)
        brain.performOperation("=")
        brain.performOperation("+")
        brain.setOperand(3.0)
        brain.performOperation("=")
        XCTAssert(brain.description == "7.0 + 9.0 + 6.0 + 3.0", "your description is \(brain.description!)")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
