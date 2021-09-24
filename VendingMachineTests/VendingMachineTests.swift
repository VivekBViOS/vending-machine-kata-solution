//
//  VendingMachineTests.swift
//  VendingMachineTests
//
//  Created by Brainvire on 20/09/21.
//

import XCTest
@testable import VendingMachine

class VendingMachineTests: XCTestCase {
    
    //MARK:- Declare Variables
    var viewModelObj : ViewModel!
    
    
    //MARK:- initial Data Setup
    override func setUp() {
        viewModelObj = ViewModel()
        viewModelObj.setUpData()
    }
    
    
    //MARK:- Business Logic UnitTest
    
    //Select the product at specific index
    func testSelectProductAtIndex(index : Int){
        viewModelObj.selectProduct(item: viewModelObj.productItems[index])
    }
    
    //  Select the product from list
    func testSelectProduct(){
        testSelectProductAtIndex(index: 0)
    }
    
    //  Action Nickle Coin Click
    func testNickleCoinAction(){
        viewModelObj.actionCointClick(ind: 0)
        XCTAssertEqual(viewModelObj.nickle, 1.0)
        
    }
    
    //  Action Dime Coin Click
    func testDimeCoinAction(){
        viewModelObj.actionCointClick(ind: 1)
        XCTAssertEqual(viewModelObj.dime, 1.0)
        
    }
    
    //  Action Quarter Coint Click
    func testQuarterCoinAction(){
        viewModelObj.actionCointClick(ind: 2)
        XCTAssertEqual(viewModelObj.quarter, 1.0)
        
    }
    
    //  Action Penny Coin Click
    func testPennyCoinAction(){
        viewModelObj.actionCointClick(ind: 3)
        XCTFail("Penny is not allowed")
        
    }
    
    //  When Product has been sold out
    func testSoldOutProduct(){
        testSelectProductAtIndex(index: 0)
        XCTAssertEqual(viewModelObj.productItems[0].Qty, 0, "Product has been Sold Out")
        
    }
    
    //  When Inserted coins are lesser than selected product price
    func testLesserCoinsThanPrice(){
        testSelectProductAtIndex(index: 2)
        
        let totalCent = viewModelObj.returnTotalCoinsValue(nickle: 2.0, dime: 1.0, quarter: 0.0)
        
        let amount = viewModelObj.replaceStringToFloat(amountString: viewModelObj.productItems[2].amount)
        
        XCTAssertLessThan(amount, totalCent, "user has inserted lesser coin than selcted product price")
    }
    
    //  When Inserted coins are greater than selected product price
    func testGreaterCoinsThanPrice(){
        testSelectProductAtIndex(index: 2)
        
        let totalCent = viewModelObj.returnTotalCoinsValue(nickle: 3.0, dime: 1.0, quarter: 2.0)
        
        let amount = viewModelObj.replaceStringToFloat(amountString: viewModelObj.productItems[2].amount)
        
        XCTAssertGreaterThan(totalCent, amount, "user has inserted greater coin than selcted product price")
        
    }
    
    //  When Inserted coins are equal selected product price
    func testEqualCoinsThanPrice(){
        testSelectProductAtIndex(index: 2)
        let totalCent = viewModelObj.returnTotalCoinsValue(nickle: 1.0, dime: 1.0, quarter: 2.0)
        let amount = viewModelObj.replaceStringToFloat(amountString: viewModelObj.productItems[2].amount)
        XCTAssertLessThan(amount, totalCent, "user has inserted exact cents")
    }
    
    //  Return Coins
    func testReturnCoins(){
        testSelectProductAtIndex(index: 1)
        testNickleCoinAction()
        let msg = viewModelObj.actionReturnCoint()
        XCTAssertEqual(msg != "", true)
    }
    
    
    //   Reset the nickle coins values
    func testResetNickleCoins(){
        testSelectProductAtIndex(index: 1)
        viewModelObj.actionCointClick(ind: 0)
        viewModelObj.resetData()
        XCTAssertEqual(0.0, viewModelObj.nickle, "Return Nickle Coin Succesfully ")
    }
    
    //   Reset the dime coins values
    func testResetDimeCoins(){
        testSelectProductAtIndex(index: 1)
        viewModelObj.actionCointClick(ind: 1)
        viewModelObj.resetData()
        XCTAssertEqual(0.0, viewModelObj.dime, "Return Dime Coin Succesfully ")
    }
    
    //  Reset the quarter coins values
    func testResetQuarterCoins(){
        testSelectProductAtIndex(index: 1)
        viewModelObj.actionCointClick(ind: 2)
        viewModelObj.resetData()
        XCTAssertEqual(0.0, viewModelObj.quarter, "Return Quarter Coin Succesfully ")
    }
    
    //When change is availble to go give change
    func testCoinChangeReturn(){
        let expectedStr = "Nickle : 1 "
                 + "\nReturn coin please collect with candy item"
        testSelectProductAtIndex(index: 2)
        
        let totalCent : Float = viewModelObj.returnTotalCoinsValue(nickle: 2.0, dime: 1.0, quarter: 2.0)
        let amount : Float = viewModelObj.replaceStringToFloat(amountString: viewModelObj.productItems[2].amount)
        let extraCents : Float = totalCent - (amount * 100)
        
        viewModelObj.machineNickle = 2.0
        viewModelObj.machineDime = 1.0
        viewModelObj.machineQuarter = 2.0
        let str = viewModelObj.extraCentsgreaterthanZero(extraCent: extraCents)
        XCTAssertEqual(str,expectedStr)
        
    }
    
    //   When change is not availble to machine
    func testChangeNotAvailble(){
        let expectedStr = "Item not placed please collect \nNickle : 0.0 \nDime : 2.0 \nQuarter : 2.0"
        testSelectProductAtIndex(index: 2)
        
        let totalCent = viewModelObj.returnTotalCoinsValue(nickle: 0.0, dime: 2.0, quarter: 2.0)
        let amount = viewModelObj.replaceStringToFloat(amountString: viewModelObj.productItems[2].amount)
        let extraCents = totalCent - (amount * 100)
        
        viewModelObj.machineNickle = 0.0
        viewModelObj.machineDime = 2.0
        viewModelObj.machineQuarter = 2.0
        
        viewModelObj.nickle = 0.0
        viewModelObj.dime = 2.0
        viewModelObj.quarter = 2.0
        
        let str = viewModelObj.extraCentsgreaterthanZero(extraCent: extraCents)
        XCTAssertEqual(str, expectedStr)
        
    }
    
    
    
    //MARK:- Make obj nil
    override func tearDown() {
        viewModelObj = nil
    }
    
}
