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
    }
    
    
    //MARK:- Business Logic UnitTest
    
    //Select the product at specific index
    func testSelectProductAtIndex(index : Int){
        viewModelObj.selectProduct(item: viewModelObj.arrProductItems[index])
    }

    
    //  Select the product from list
    func testSelectProduct(){
        testSelectProductAtIndex(index: 0)
    }
    
    //  Action Nickle Coin Click
    func testNickleCoinAction(){
        viewModelObj.actionCoinClick(index: 0)
        XCTAssertEqual(viewModelObj.objCurrentTransCoin.nickle, 1.0)
        
    }
    
    //  Action Dime Coin Click
    func testDimeCoinAction(){
        viewModelObj.actionCoinClick(index: 1)
        XCTAssertEqual(viewModelObj.objCurrentTransCoin.dime, 1.0)
        
    }
    
    //  Action Quarter Coin Click
    func testQuarterCoinAction(){
        viewModelObj.actionCoinClick(index: 2)
        XCTAssertEqual(viewModelObj.objCurrentTransCoin.quarter, 1.0)
        
    }
    
    //  Action Penny Coin Click
    func testPennyCoinAction(){
        viewModelObj.actionCoinClick(index: 3)
        XCTFail("Penny is not allowed")
        
    }
    
    //  When Product has been sold out
    func testSoldOutProduct(){
        testSelectProductAtIndex(index: 0)
        XCTAssertEqual(viewModelObj.objCurrentTransCoin.selectedItem!.qty, 0, "Product has been Sold Out")
        
    }
   
    //  When Inserted coins are lesser than selected product price
    func testLesserCoinsThanPrice(){
        testSelectProductAtIndex(index: 2)
        
        let totalCent = returnTotalCoinsValue(nickle: 2.0, dime: 1.0, quarter: 0.0)
        
        let amount = replaceStringToFloat(amountString: viewModelObj.objCurrentTransCoin.selectedItem!.amount)
        
        XCTAssertLessThan(amount, totalCent, "user has inserted lesser coin than selcted product price")
    }
    
    //  When Inserted coins are greater than selected product price
    func testGreaterCoinsThanPrice(){
        testSelectProductAtIndex(index: 2)
        
        let totalCent = returnTotalCoinsValue(nickle: 3.0, dime: 1.0, quarter: 2.0)
        
        let amount = replaceStringToFloat(amountString: viewModelObj.objCurrentTransCoin.selectedItem!.amount)
        
        XCTAssertGreaterThan(totalCent, amount, "user has inserted greater coin than selcted product price")
        
    }
    
    //  When Inserted coins are equal selected product price
    func testEqualCoinsThanPrice(){
        testSelectProductAtIndex(index: 2)
        let totalCent = returnTotalCoinsValue(nickle: 1.0, dime: 1.0, quarter: 2.0)
        let amount = replaceStringToFloat(amountString: viewModelObj.objCurrentTransCoin.selectedItem!.amount)
        XCTAssertLessThan(amount, totalCent, "user has inserted exact cents")
    }
    
    //  Return Coins
    func testReturnCoins(){
        //when none coin is selected
        let msg = viewModelObj.actionReturnCoin()
        XCTAssertEqual(msg, "Nickle : 0.0 \nDime : 0.0 \nQuarter : 0.0 \nReturn Please Collect Your Coin")
    }
    
    // When Select Nickle Coin and return Nickle Coins
    func testReturnNickleCoins(){
        //when none coin is selected
        testSelectProductAtIndex(index: 1)
        testNickleCoinAction()
        let msg = viewModelObj.actionReturnCoin()
        XCTAssertEqual(msg, "Nickle : 1.0 \nDime : 0.0 \nQuarter : 0.0 \nReturn Please Collect Your Coin")
    }
    
    // When Select Dime Coin and return Dime Coins
    func testReturnDimeCoins(){
        //when none coin is selected
        testSelectProductAtIndex(index: 1)
        testDimeCoinAction()
        let msg = viewModelObj.actionReturnCoin()
        XCTAssertEqual(msg, "Nickle : 0.0 \nDime : 1.0 \nQuarter : 0.0 \nReturn Please Collect Your Coin")
    }
    
    // When Select Quarter Coin and return Quarter Coins
    func testReturnQuarterCoins(){
        //when none coin is selected
        testSelectProductAtIndex(index: 1)
        testQuarterCoinAction()
        let msg = viewModelObj.actionReturnCoin()
        XCTAssertEqual(msg, "Nickle : 0.0 \nDime : 0.0 \nQuarter : 1.0 \nReturn Please Collect Your Coin")
    }
    
    
    //   Reset the nickle coins values
    func testResetNickleCoins(){
        testSelectProductAtIndex(index: 1)
        viewModelObj.actionCoinClick(index: 0)
        viewModelObj.resetSelectedItemData()
        XCTAssertEqual(0.0, viewModelObj.objCurrentTransCoin.nickle, "Return Nickle Coin Succesfully ")
    }
    
    //   Reset the dime coins values
    func testResetDimeCoins(){
        testSelectProductAtIndex(index: 1)
        viewModelObj.actionCoinClick(index: 1)
        viewModelObj.resetSelectedItemData()
        XCTAssertEqual(0.0, viewModelObj.objCurrentTransCoin.dime, "Return Dime Coin Succesfully ")
    }
    
    //  Reset the quarter coins values
    func testResetQuarterCoins(){
        testSelectProductAtIndex(index: 1)
        viewModelObj.actionCoinClick(index: 2)
        viewModelObj.resetSelectedItemData()
        XCTAssertEqual(0.0, viewModelObj.objCurrentTransCoin.quarter, "Return Quarter Coin Succesfully ")
    }

    //When change is availble to go give change
    func testCoinChangeReturn(){
        let expectedStr = "Nickle : 1 "
                 + "\nReturn coin please collect with candy item"
        testSelectProductAtIndex(index: 2)
        
        let totalCent : Float = returnTotalCoinsValue(nickle: 2.0, dime: 1.0, quarter: 2.0)
        let amount : Float = replaceStringToFloat(amountString: viewModelObj.objCurrentTransCoin.selectedItem!.amount)
        let extraCents : Float = totalCent - (amount * 100)
        
        viewModelObj.objMachineCoinModel.machineNickle = 2.0
        viewModelObj.objMachineCoinModel.machineDime = 1.0
        viewModelObj.objMachineCoinModel.machineQuarter = 2.0
        let str = viewModelObj.objMachineCoinModel.extraCentsgreaterthanZero(extraCent: extraCents, currentTransCoin: viewModelObj.objCurrentTransCoin)
        XCTAssertEqual(str.msg,expectedStr)
        
    }
    
    //   When change is not availble to machine
    func testChangeNotAvailble(){
        let expectedStr = "Item not placed please collect \nNickle : 0.0 \nDime : 2.0 \nQuarter : 2.0"
        testSelectProductAtIndex(index: 2)
        
        let totalCent = returnTotalCoinsValue(nickle: 0.0, dime: 2.0, quarter: 2.0)
        let amount = replaceStringToFloat(amountString: viewModelObj.objCurrentTransCoin.selectedItem!.amount)
        let extraCents = totalCent - (amount * 100)
        
        viewModelObj.objMachineCoinModel.machineNickle = 0.0
        viewModelObj.objMachineCoinModel.machineDime = 2.0
        viewModelObj.objMachineCoinModel.machineQuarter = 2.0
        
        viewModelObj.objCurrentTransCoin.nickle = 0.0
        viewModelObj.objCurrentTransCoin.dime = 2.0
        viewModelObj.objCurrentTransCoin.quarter = 2.0
        
        let str = viewModelObj.objMachineCoinModel.extraCentsgreaterthanZero(extraCent: extraCents, currentTransCoin: viewModelObj.objCurrentTransCoin)
        XCTAssertEqual(str.msg, expectedStr)
        
    }
    
    
    
    //MARK:- Make obj nil
    override func tearDown() {
        viewModelObj = nil
    }
    
}
