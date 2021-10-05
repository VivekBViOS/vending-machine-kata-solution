//
//  CurrentCoinTransaction.swift
//  VendingMachine
//
//  Created by Brainvire on 01/10/21.
///

import Foundation

class CurrentTransactionCoinModel {
    
    
    var nickle: Float
    var dime: Float
    var quarter : Float

    private var totalCents : Float = 0.0
    var selectedItem:ProductItemsModel?
    
    init(nickle:Float = 0.0, dime:Float = 0.0, quarter:Float = 0.0) {
        self.nickle = nickle
        self.dime = dime
        self.quarter = quarter
    }

    func addCoinInCurrentTrans(index:Int) -> (extraCents:Float, totalDoller: Float) {
        
        if index == 0 {
            self.nickle += 1
        } else if index == 1 {
            self.dime += 1
        } else if index == 2 {
            self.quarter += 1
        }
        
        self.totalCents = returnTotalCoinsValue(nickle: nickle, dime: dime, quarter: quarter)
        print("toata cents = \(totalCents)")

        let addedTotalDoller : Float = self.totalCents/100
        var extraCents:Float = 0.0
        let selectedItemAmount = replaceStringToFloat(amountString: selectedItem?.amount ?? "0.0")
        if addedTotalDoller >= selectedItemAmount {
            extraCents = totalCents - (selectedItemAmount * 100)
        } else {
            extraCents = 0.0
        }
        return (extraCents:extraCents,totalDoller:addedTotalDoller)
    }
    
    func resetCurrentCoinAfterPurchase() {
        self.nickle = 0
        self.dime = 0
        self.quarter = 0
        self.selectedItem = nil
    }
}
