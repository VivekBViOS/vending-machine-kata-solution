//
//  ViewModel.swift
//  VendingMachine
//
//  Created by Brainvire on 20/09/21.
//

import Foundation
import UIKit

struct ProductItems {
    var name: String
    var amount: String
    var Qty: Int
    var isSelected: Bool = false
    var productNo: Int
}

enum CoinType {
    case Nickle
    case Dime
    case Quarter
    case Penny
}

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

public class ViewModel: NSObject {
    weak var tblView: UITableView!
    var viewController: ViewController!
    var productItems: [ProductItems]!
    var delegate: SelectProductDelegate?
    var isSelectProduct = true
    
    //    MARK:- Variable
    //    var productItems: [ProductItems]!
    var cointType = CoinType.Dime
    var centsCount = CentsCount.Dime
    var totalCents : Float = 0.0
    var selecrtProductItem: ProductItems?
    var nickle : Float = 0.0
    var dime : Float = 0.0
    var quarter: Float  = 0.0
    var machineNickle : Float = 0.0
    var machineDime : Float = 0.0
    var machineQuarter: Float  = 0.0
    var selectedItemPrice : Float = 0.0
    var extraCents : Float = 0.0
        
    //MARK:- Set UP Data
    func setUpData() {
        tblView?.register(UINib(nibName: "ProductListCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        self.tblView?.tableFooterView = UIView()
        self.tblView?.dataSource = self
        self.tblView?.delegate = self
        self.tblView?.rowHeight = UITableView.automaticDimension
        self.tblView?.estimatedRowHeight = 0
        
        self.productItems = [ProductItems(name: "cola", amount: "$1.0", Qty: 2, productNo: 0),ProductItems(name: "chips", amount: "$0.5", Qty: 2, productNo: 1),ProductItems(name: "candy", amount: "$0.65", Qty: 2, productNo: 2)]
        
    }
    
    //MARK:- Click on Coins button
    func actionCointClick(ind: Int) {
        if ind == 0 {
            self.nickle += 1
        } else if ind == 1 {
            self.dime += 1
        } else if ind == 2 {
            self.quarter += 1
        }
        
        self.totalCents = returnTotalCoinsValue(nickle: nickle, dime: dime, quarter: quarter)
        print("toata cents = \(totalCents)")
        
        let floatTotalCents : Float = self.totalCents/100
        
        if floatTotalCents >= self.selectedItemPrice {
            self.extraCents = self.totalCents - (self.selectedItemPrice * 100)
            self.delegate?.coinChangeValue(isCoinsCollected: true, collectedCoins: floatTotalCents)
        } else {
            self.delegate?.coinChangeValue(isCoinsCollected: false, collectedCoins: floatTotalCents)
        }
    }
    
    func actionSubmit() -> String{
        
        var str = ""
        self.machineNickle += self.nickle
        self.machineDime += self.dime
        self.machineQuarter += self.quarter
        
        let avaCents = returnTotalCoinsValue(nickle: machineNickle, dime: machineDime, quarter: machineQuarter)
        
        print("Extra - \(extraCents), Available - \(avaCents)")
        
        if extraCents > 0 {
            str = extraCentsgreaterthanZero(extraCent: extraCents)
        } else {
            let oldQty = self.productItems[self.selecrtProductItem!.productNo].Qty
            self.productItems[self.selecrtProductItem!.productNo].Qty = oldQty - 1
            str = "\(self.selecrtProductItem?.name ?? "")"
        }
        return str
    }
    
    func actionReturnCoint() -> String {
        let str = "Nickle : \(self.nickle) \nDime : \(self.dime) \nQuarter : \(self.quarter) \nReturn Please Collect Your Coin"
        
        return str
    }
    
    func selectProduct(item: ProductItems) {
        self.extraCents = 0
        if item.Qty == 0 {
            delegate?.isExactChangeOrInsertCoin(strLbl: "SOLD OUT", itemQty: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.selecrtProductItem = nil
                //                for (ind,_) in self.productItems.enumerated() {
                self.productItems[item.productNo].isSelected = false
                //                }
                self.isSelectProduct = true
                //                self.viewModel.productItems = self.productItems
                self.tblView.reloadData()
            }
        } else {
            self.selecrtProductItem = item
            self.selectedItemPrice = replaceStringToFloat(amountString: item.amount)
            
            if machineNickle >= 1 {
                if machineDime >= 2 || machineNickle >= 4 {
                    delegate?.isExactChangeOrInsertCoin(strLbl: "Insert Coin", itemQty: item.Qty)
                } else {
                    delegate?.isExactChangeOrInsertCoin(strLbl: "EXACT CHANGE ONLY", itemQty: item.Qty)
                }
            } else {
                delegate?.isExactChangeOrInsertCoin(strLbl: "EXACT CHANGE ONLY", itemQty: item.Qty)
            }
        }
    }
    
    
    //MARK:- Other Functions
    func resetData() {
        self.productItems[self.selecrtProductItem!.productNo].isSelected = false
        self.isSelectProduct = true
        self.selectedItemPrice = 0
        self.totalCents = 0
        self.nickle = 0
        self.dime = 0
        self.quarter = 0
        self.selecrtProductItem = nil
    }
    
    func returnTotalCoinsValue(nickle : Float, dime : Float, quarter : Float) -> Float{
        return (nickle * CentsCount.Nickle.rawValue) + (dime * CentsCount.Dime.rawValue) + (quarter * CentsCount.Quarter.rawValue)
    }
    
    func replaceStringToFloat(amountString : String ) -> Float{
        let replacedStr = amountString.replacingOccurrences(of: "$", with: "")
        return Float(replacedStr) ?? 0.0
    }
    
    func extraCentsgreaterthanZero(extraCent : Float) -> String{
        var str = ""
        var extCents : Float = extraCent
        var mQ = self.machineQuarter
        var mD = self.machineDime
        var mN = self.machineNickle
        var sentMQ = 0
        var sentMD = 0
        var sentMN = 0
        for _ in 0..<Int(extCents) {
            if mQ > 0 && extCents >= 25 {
                for _ in 0..<Int(machineQuarter) {
                    if extCents >= 25 {
                        mQ -= 1
                        sentMQ += 1
                        extCents -= 25
                    }
                }
            }
        }
        for _ in 0..<Int(extCents) {
            if mD > 0 && extCents >= 10 {
                for _ in 0..<Int(machineDime) {
                    if extCents >= 10 {
                        mD -= 1
                        sentMD += 1
                        extCents -= 10
                    }
                }
            }
        }
        for _ in 0..<Int(extCents) {
            if mN > 0 && extCents >= 5 {
                for _ in 0..<Int(machineNickle) {
                    if extCents >= 5 {
                        mN -= 1
                        sentMN += 1
                        extCents -= 5
                    }
                }
            }
        }
        
        if extCents != 0 {
            self.machineNickle -= self.nickle
            self.machineDime -= self.dime
            self.machineQuarter -= self.quarter
            str = "Item not placed please collect \nNickle : \(self.nickle) \nDime : \(self.dime) \nQuarter : \(self.quarter)"
        } else {
            self.machineNickle = mN
            self.machineDime = mD
            self.machineQuarter = mQ
            
            if sentMQ != 0 {
                str += "Quarter : \(sentMQ) \n"
            }
            if sentMD != 0 {
                str += "Dime : \(sentMD) \n"
            }
            if sentMN != 0 {
                str += "Nickle : \(sentMN) "
            }
            str += "\nReturn coin please collect "
            
            str += "with \(self.selecrtProductItem?.name ?? "") item"
            let oldQty = self.productItems[self.selecrtProductItem!.productNo].Qty
            self.productItems[self.selecrtProductItem!.productNo].Qty = oldQty - 1
            
        }
        return str
    }
    
    
}

//MARK:- TableView Delegate & DataSource Method

extension ViewModel: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
        cell.productData = self.productItems[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSelectProduct == true {
            self.selectProduct(item: productItems[indexPath.row])
            self.isSelectProduct = false
            for (ind,_) in self.productItems.enumerated() {
                if ind == indexPath.row {
                    self.productItems[ind].isSelected = true
                } else {
                    self.productItems[ind].isSelected = false
                }
            }
            self.tblView.reloadData()
        }
    }
}
