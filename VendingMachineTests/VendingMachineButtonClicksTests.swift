//
//  VendingMachineButtonClicksTests.swift
//  VendingMachineTests
//
//  Created by Brainvire on 23/09/21.
//

import XCTest
@testable import VendingMachine

class VendingMachineButtonClicksTests: XCTestCase {
    
    //MARK:- Declare Variables
    var controller: ViewController!
    
    
    //MARK:- Initial Set Up
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateInitialViewController() as? ViewController
        controller.loadViewIfNeeded()
    }
    
    //MARK:- Button Click UnitTest
    
    
    //   Check all coins button action click
    func testAllCoinsButtonClick(){
        controller.btnNickle.sendActions(for: .touchUpInside)
        controller.btnDime.sendActions(for: .touchUpInside)
        controller.btnQuarter.sendActions(for: .touchUpInside)
        controller.btnPenny.sendActions(for: .touchUpInside)
        XCTAssertTrue(true)
    }
    
    //  Check all coins button has correct tags
    func testAllCoinsButtonTags(){
        XCTAssertEqual(controller.btnNickle.tag, 0, "Button Nickle have correct tag")
        XCTAssertEqual(controller.btnDime.tag, 1, "Button dime have correct tag")
        XCTAssertEqual(controller.btnQuarter.tag, 2, "Button quarter have correct with correct tag")
        XCTAssertEqual(controller.btnPenny.tag, 3, "Button penny have correct with correct tag")
    }
     
    //  Check if Controller has NickleButton property
    func testIfNickleButtonHasAction() {
        
        //Check if Controller has UIButton property
        let nickleButton: UIButton = controller.btnNickle
        XCTAssertNotNil(nickleButton, "View Controller does not have UIButton property")
        
        // Attempt Access UIButton Actions
        guard let nickleButtonActions = nickleButton.actions(forTarget: controller, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        
        // Assert UIButton has action with a method name
        //nickleButtonActions
        XCTAssertTrue(nickleButtonActions.contains("actionCoinClick:"))
        
    }
    
    //  Check if Controller has DimeButton property
    func testIfDimeButtonHasAction() {
        
        //Check if Controller has UIButton property
        let DimeButton: UIButton = controller.btnDime
        XCTAssertNotNil(DimeButton, "View Controller does not have UIButton property")
        
        // Attempt Access UIButton Actions
        guard let DimeButtonActions = DimeButton.actions(forTarget: controller, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        
        // Assert UIButton has action with a method name
        //nickleButtonActions
        XCTAssertTrue(DimeButtonActions.contains("actionCoinClick:"))
        
    }
    
    //  Check if Controller has QuarterButton property
    func testIfQuarterButtonHasAction() {
        
        //Check if Controller has UIButton property
        let quarterButton: UIButton = controller.btnQuarter
        XCTAssertNotNil(quarterButton, "View Controller does not have UIButton property")
        
        // Attempt Access UIButton Actions
        guard let quarterButtonActions = quarterButton.actions(forTarget: controller, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        
        // Assert UIButton has action with a method name
        XCTAssertTrue(quarterButtonActions.contains("actionCoinClick:"))
        
    }
    
    //  Check if Controller has PennyButton property
    func testIfPennyButtonHasAction() {
        
        //Check if Controller has UIButton property
        let pennyButton: UIButton = controller.btnPenny
        XCTAssertNotNil(pennyButton, "View Controller does not have UIButton property")
        
        // Attempt Access UIButton Actions
        guard let nickleButtonActions = pennyButton.actions(forTarget: controller, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        
        // Assert UIButton has action with a method name
        XCTAssertTrue(nickleButtonActions.contains("actionCoinClick:"))
        
    }
    
    //  Check if Controller has SubmitButton property
    func testIfSubmitButtonHasAction() {
        
        //Check if Controller has UIButton property
        let submitButton: UIButton = controller.btnSubmit
        XCTAssertNotNil(submitButton, "View Controller does not have UIButton property")
        
        // Attempt Access UIButton Actions
        guard let actionSubmitActions = submitButton.actions(forTarget: controller, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        
        // Assert UIButton has action with a method name
        XCTAssertTrue(actionSubmitActions.contains("actionSubmit:"))
        
    }
    
    //  Check if Controller has ReturnButton property
    func testIfReturntButtonHasAction() {
        
        //Check if Controller has UIButton property
        let returnButton: UIButton = controller.btnReturn
        XCTAssertNotNil(returnButton, "View Controller does not have UIButton property")
        
        // Attempt Access UIButton Actions
        guard let returnButtonActions = returnButton.actions(forTarget: controller, forControlEvent: .touchUpInside) else {
            XCTFail("UIButton does not have actions assigned for Control Event .touchUpInside")
            return
        }
        
        // Assert UIButton has action with a method name
        XCTAssertTrue(returnButtonActions.contains("actionReturn:"))
        
    }
    
    
    //MARK:- Make obj nil
    override func tearDown() {
        controller = nil
    }

}
