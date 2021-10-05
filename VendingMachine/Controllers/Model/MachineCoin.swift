//
//  MachineCoin.swift
//  VendingMachine
//
//  Created by Brainvire on 01/10/21.
//

import Foundation

class MachineCoinModel {
    
    var machineNickle: Float
    var machineDime: Float
    var machineQuarter: Float
    
    var selectedItem: ProductItemsModel?
    
    init(machineNickle:Float = 0.0, machineDime:Float = 0.0, machineQuarter:Float = 0.0) {
        self.machineNickle = machineNickle
        self.machineDime = machineDime
        self.machineQuarter = machineQuarter
    }
    
    func addCoinInMachine(nickle:Float, dime:Float, quarter:Float){
        self.machineNickle += nickle
        self.machineDime += dime
        self.machineQuarter += quarter
    }
    
    private func returnCoinFromMachine(nickle:Float, dime:Float, quarter:Float) -> String {
        return "Item not placed please collect \nNickle : \(nickle) \nDime : \(dime) \nQuarter : \(quarter)"
    }
    
    private func updateCoinInMachine(nickle:Float, dime:Float, quarter:Float) {
        self.machineNickle = nickle
        self.machineDime = dime
        self.machineQuarter = quarter
        
    }
    
    func availableCentsDetails() -> String {
        var msg = ""
        if self.machineNickle >= 1 {
            if self.machineDime >= 2 || self.machineNickle >= 4 {
                msg = "Insert Coin"
            } else {
                msg = "EXACT CHANGE ONLY"
            }
        } else if self.machineDime >= 2 {
            if self.machineNickle >= 1 {
                msg = "Insert Coin"
            } else {
                msg = "EXACT CHANGE ONLY"
            }
        } else {
            msg = "EXACT CHANGE ONLY"
        }
        
        return msg
    }
    
    func extraCentsgreaterthanZero(extraCent : Float, currentTransCoin: CurrentTransactionCoinModel) -> (msg:String, isItemPurchase:Bool) {
        var msg = ""
        var isItemPurchase = false
        var extCents : Float = extraCent
        
        let quarterVal = sentQuarterCoin(extraCents: extCents)
        extCents = quarterVal.extraCents
        let machineQuarter = quarterVal.availableQuarter
        let sentMQ = quarterVal.sentQuarter
        
        let dimeVal = sentDimeCoin(extraCents: extCents)
        extCents = dimeVal.extraCents
        let machineDime = dimeVal.availableDime
        let sentMD = dimeVal.sentDime
        
        let nickleVal = sentNickleCoin(extraCents: extCents)
        extCents = nickleVal.extraCents
        let machineNickle = nickleVal.availableNickle
        let sentMN = nickleVal.sentNickle
        
        
        if extCents != 0.0 {
            msg = self.returnCoinFromMachine(nickle: currentTransCoin.nickle, dime: currentTransCoin.dime, quarter: currentTransCoin.quarter)
            isItemPurchase = false
        } else {
            self.updateCoinInMachine(nickle: machineNickle, dime: machineDime, quarter: machineQuarter)
            self.addCoinInMachine(nickle: currentTransCoin.nickle, dime: currentTransCoin.dime, quarter: currentTransCoin.quarter)
            if sentMQ != 0 {
                msg += "Quarter : \(sentMQ) \n"
            }
            if sentMD != 0 {
                msg += "Dime : \(sentMD) \n"
            }
            if sentMN != 0 {
                msg += "Nickle : \(sentMN) "
            }
            msg += "\nReturn coin please collect "
            
            msg += "with \(self.selectedItem?.name ?? "" ) item"
            isItemPurchase = true
        }
        return (msg:msg, isItemPurchase:isItemPurchase)
    }
}

extension MachineCoinModel {
    fileprivate func sentQuarterCoin(extraCents: Float) -> (extraCents:Float, availableQuarter:Float, sentQuarter:Int){
        var extCents : Float = extraCents
        var machineQuarter = self.machineQuarter
        var sentMQ = 0
        
        if machineQuarter > 0 && extCents >= CentsCount.Quarter.rawValue {
            let returnQuarter = extCents/CentsCount.Quarter.rawValue
            let returnQuarterInInt = Int(returnQuarter)
            
            if  returnQuarterInInt > Int(machineQuarter) {
                sentMQ =  Int(machineQuarter)
                machineQuarter -= Float(returnQuarterInInt)
                extCents -= Float(sentMQ)*(CentsCount.Quarter.rawValue)
            } else {
                sentMQ = returnQuarterInInt
                machineQuarter -= Float(returnQuarterInInt)
                extCents -= Float(sentMQ)*(CentsCount.Quarter.rawValue)
            }
        }
        return (extraCents:extCents, availableQuarter:machineQuarter, sentQuarter:sentMQ)
    }
    
    fileprivate func sentDimeCoin(extraCents: Float) -> (extraCents:Float, availableDime:Float, sentDime:Int) {
        var extCents : Float = extraCents
        var machineDime = self.machineDime
        var sentMD = 0
        
        if machineDime > 0 && extCents >= CentsCount.Dime.rawValue {
            let returnDimes = extCents/CentsCount.Dime.rawValue
            let returnDimesInInt = Int(returnDimes)
            
            if  returnDimesInInt > Int(machineDime) {
                sentMD =  Int(machineDime)
                machineDime -= Float(returnDimesInInt)
                extCents -= Float(sentMD)*(CentsCount.Dime.rawValue)
            } else {
                sentMD = returnDimesInInt
                machineDime -= Float(returnDimesInInt)
                extCents -= Float(sentMD)*(CentsCount.Dime.rawValue)
            }
        }
        
        return (extraCents:extCents, availableDime:machineDime, sentDime:sentMD)
    }
    
    fileprivate func sentNickleCoin(extraCents: Float) -> (extraCents:Float, availableNickle:Float, sentNickle:Int){
        var extCents : Float = extraCents
        var machineNickle = self.machineNickle
        var sentMN = 0
        
        if machineNickle > 0 && extCents >= CentsCount.Nickle.rawValue {
            let returnNickels = extCents/CentsCount.Nickle.rawValue
            let returnNickelsInInt = Int(returnNickels)
            
            if  returnNickelsInInt > Int(machineNickle) {
                sentMN = Int(machineNickle)
                machineNickle -= machineNickle
                extCents -= Float(sentMN)*(CentsCount.Nickle.rawValue)
            } else {
                sentMN = returnNickelsInInt
                machineNickle -= Float(returnNickelsInInt)
                extCents -= Float(sentMN)*(CentsCount.Nickle.rawValue)
            }
        }
        
        return (extraCents:extCents, availableNickle:machineNickle, sentNickle:sentMN)
    }
}
