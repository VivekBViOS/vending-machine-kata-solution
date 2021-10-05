//
//  Products.swift
//  VendingMachine
//
//  Created by Brainvire on 01/10/21.
//

import Foundation

class ProductItemsModel {
    
    var name: String
    var amount: String
    var qty: Int
    var isSelected: Bool

    init(name:String, amount:String, qty:Int, isSelected:Bool = false) {
        self.name = name
        self.amount = amount
        self.qty = qty
        self.isSelected = isSelected
    }
    
    func removeQuantityFromProducts(){
        self.qty -= 1
    }
    
    func checkSelectItemQuantity() -> (msg:String, qty:Int) {
        var msg = ""
        if self.qty == 0 {
            msg = "SOLD OUT"
        } else {
            msg = ""
        }
        return (msg,self.qty)
    }
}
