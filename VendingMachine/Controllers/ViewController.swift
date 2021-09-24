//
//  ViewController.swift
//  VendingMachine
//
//  Created by Brainvire on 20/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    //    MARK:- Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewScreen: UIView!
    @IBOutlet weak var lblSelectItem: UILabel!
    
    @IBOutlet weak var viewInsertCoin: UIView!
    @IBOutlet weak var lblInsertCoin: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var stackCoin: UIStackView!
    @IBOutlet weak var btnDime: UIButton!
    @IBOutlet weak var btnNickle: UIButton!
    @IBOutlet weak var btnQuarter: UIButton!
    @IBOutlet weak var btnPenny: UIButton!
    
    @IBOutlet weak var lblPennyCoinNotAccept: UILabel!
    @IBOutlet weak var lblItemDetails: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnReturn: UIButton!
    
    //    MARK:- Variable
    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpView()
    }
    
    //    MARK:- SetUp View
    
    func setUpView() {
        self.viewInsertCoin.isHidden = true
        self.lblPennyCoinNotAccept.isHidden = true
        self.lblItemDetails.isHidden = true
        self.stackCoin.isHidden = true
        self.btnSubmit.isEnabled = false
        self.viewModel = ViewModel()
        self.viewModel.viewController = self
        self.viewModel.tblView = tblView
        self.viewModel.setUpData()
        self.viewModel.delegate = self
        
    }
    //    MARK:- Action
    
    @IBAction func actionCoinClick(_ sender: UIButton) {
        self.lblItemDetails.isHidden = true
        self.lblPennyCoinNotAccept.isHidden = true
        if sender.tag == 3 {
            self.lblPennyCoinNotAccept.isHidden = false
        } else {
            self.viewModel.actionCointClick(ind: sender.tag)
        }
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        
        self.lblItemDetails.isHidden = false
        self.btnSubmit.isEnabled = false
        self.lblSelectItem.isHidden = false
        self.lblSelectItem.text = "Thank You"
        let str = self.viewModel.actionSubmit()
        self.lblItemDetails.text = str
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.viewModel.resetData()
            self.resetData()
        }
    }
    
    @IBAction func actionReturn(_ sender: Any) {
        self.lblItemDetails.isHidden = false
        self.stackCoin.isHidden = true
        let str = self.viewModel.actionReturnCoint()
        self.lblItemDetails.text = str
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.resetData()
            self.resetData()
        }
    }
    
    func resetData() {
        self.tblView.reloadData()
        self.lblTotal.text = "$0.0"
        self.viewInsertCoin.isHidden = true
        self.lblItemDetails.isHidden = true
        self.lblItemDetails.text = ""
        self.lblSelectItem.isHidden = false
        self.lblSelectItem.text = "Select Item"
    }
}

//MARK:- Delegate Method
extension ViewController: SelectProductDelegate {
    
    func isExactChangeOrInsertCoin(strLbl: String, itemQty: Int) {
        if itemQty == 0 {
            self.viewInsertCoin.isHidden = true
            self.stackCoin.isHidden = true
            self.lblSelectItem.isHidden = false
            self.lblSelectItem.text = strLbl
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.lblSelectItem.text = "Select Item"
            }
        } else {
            self.viewInsertCoin.isHidden = false
            self.stackCoin.isHidden = false
            self.lblSelectItem.isHidden = true
            self.lblInsertCoin.text = strLbl
        }
    }
    
    func coinChangeValue(isCoinsCollected:Bool, collectedCoins: Float) {
        if isCoinsCollected == true {
            self.viewInsertCoin.isHidden = true
            self.lblSelectItem.isHidden = false
            self.btnSubmit.isEnabled = true
            self.stackCoin.isHidden = true
            self.lblSelectItem.text = "Submit Item"
        } else {
            self.viewInsertCoin.isHidden = false
            self.lblSelectItem.isHidden = true
            self.btnSubmit.isEnabled = false
            self.lblTotal.text = "$\(collectedCoins)"
        }
    }
}
