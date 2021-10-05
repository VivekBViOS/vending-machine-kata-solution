//
//  ViewModel.swift
//  VendingMachine
//
//  Created by Brainvire on 20/09/21.
//

import Foundation
import UIKit

enum CentsCount: Float {
    case Nickle = 5.0
    case Dime = 10.0
    case Quarter = 25.0
    case Penny = 1.0
}

public protocol SelectProductDelegate {
    func coinChangeValue(isCoinsCollected: Bool, collectedCoins: Float)
    func isExactChangeOrInsertCoin(strLbl: String, itemQty: Int)
}

final class ViewModel: NSObject {
    
    //    MARK:- Variable
    var delegate: SelectProductDelegate?
    var isSelectProduct = true

    private var selectedItemPrice : Float = 0.0
    private var extraCents : Float = 0.0
    var selectItemIndex = 0
    var arrProductItems = [ProductItemsModel]()
    var objMachineCoinModel = MachineCoinModel()
    var objCurrentTransCoin = CurrentTransactionCoinModel()
    
    
//    MARK:- Set Up Data
    override init() {
        super.init()
        self.arrProductItems = [ProductItemsModel(name: "cola", amount: "$1.0", qty: 2),ProductItemsModel(name: "chips", amount: "$0.5", qty: 2),ProductItemsModel(name: "candy", amount: "$0.65", qty: 2)]
    }
    
    //MARK:- Click on Coins button
    
    func actionCoinClick(index: Int) {
        let addedCentsForItem = self.objCurrentTransCoin.addCoinInCurrentTrans(index: index)
        if addedCentsForItem.totalDoller >= self.selectedItemPrice {
            self.extraCents = addedCentsForItem.extraCents
            self.delegate?.coinChangeValue(isCoinsCollected: true, collectedCoins: addedCentsForItem.totalDoller)
            
        } else {
            self.delegate?.coinChangeValue(isCoinsCollected: false, collectedCoins: addedCentsForItem.totalDoller)
        }
    }
    
    //MARK:- Click on submit button
    func actionSubmit() -> String{

        var message = ""
        if extraCents > 0 {
            let extraChangeWithMsg = self.objMachineCoinModel.extraCentsgreaterthanZero(extraCent: self.extraCents, currentTransCoin: self.objCurrentTransCoin)
            
            // Item successfully purchase
            if extraChangeWithMsg.isItemPurchase == true {
                self.arrProductItems[selectItemIndex].removeQuantityFromProducts()
            }
            message = extraChangeWithMsg.msg
        } else {
            self.objMachineCoinModel.addCoinInMachine(nickle: self.objCurrentTransCoin.nickle, dime: self.objCurrentTransCoin.dime, quarter: self.objCurrentTransCoin.quarter)
            self.arrProductItems[selectItemIndex].removeQuantityFromProducts()
            message = "\(self.objCurrentTransCoin.selectedItem?.name ?? "")"
        }
        return message
    }
    
    func actionReturnCoin() -> String {
        let message = "Nickle : \(self.objCurrentTransCoin.nickle) \nDime : \(self.objCurrentTransCoin.dime) \nQuarter : \(self.objCurrentTransCoin.quarter) \nReturn Please Collect Your Coin"
        
        return message
    }
        
    func selectProduct(item: ProductItemsModel) {
        self.extraCents = 0
        var msg = ""
        let itemDetails = item.checkSelectItemQuantity()
        self.objCurrentTransCoin.selectedItem = item
        self.objMachineCoinModel.selectedItem = item
        if itemDetails.qty == 0 {
            msg = itemDetails.msg
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.arrProductItems[self.selectItemIndex].isSelected = false
                self.isSelectProduct = true
            }
        } else {
            self.selectedItemPrice = replaceStringToFloat(amountString: item.amount)
            msg = self.objMachineCoinModel.availableCentsDetails()
        }
        delegate?.isExactChangeOrInsertCoin(strLbl: msg, itemQty: itemDetails.qty)
    }
    
    //MARK:- Other Functions
    func resetSelectedItemData() {
        self.arrProductItems[selectItemIndex].isSelected = false
        self.isSelectProduct = true
        self.selectedItemPrice = 0
        self.selectItemIndex = 0
        self.objCurrentTransCoin.resetCurrentCoinAfterPurchase()
        self.objMachineCoinModel.selectedItem = nil
        
    }
}

// Convert Coin To Cents
public func returnTotalCoinsValue(nickle : Float, dime : Float, quarter : Float) -> Float{
    return (nickle * CentsCount.Nickle.rawValue) + (dime * CentsCount.Dime.rawValue) + (quarter * CentsCount.Quarter.rawValue)
}

// Convert String To Float
public func replaceStringToFloat(amountString : String ) -> Float{
    let replacedStr = amountString.replacingOccurrences(of: "$", with: "")
    return Float(replacedStr) ?? 0.0
}
