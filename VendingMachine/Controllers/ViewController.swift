//
//  ViewController.swift
//  VendingMachine
//
//  Created by Brainvire on 20/09/21.
//

import UIKit

class ViewController: UIViewController {
    //This should not go in cherry pick
    //This commit is from head of sub branch
    //    MARK:- Outlets
    //Sub comment
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
    
    //    MARK:- Variable name priority
    var viewModel: ViewModel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpView()
    }
    
    //    MARK:- SetUp View
    private func setUpView() {
        self.viewInsertCoin.isHidden = true
        self.lblPennyCoinNotAccept.isHidden = true
        self.lblItemDetails.isHidden = true
        self.stackCoin.isHidden = true
        self.btnSubmit.isEnabled = false
        self.viewModel = ViewModel()
        self.viewModel.delegate = self
        
        tblView?.register(UINib(nibName: "ProductListCell", bundle: nil), forCellReuseIdentifier: "ProductListCell")
        self.tblView?.tableFooterView = UIView()
        self.tblView?.dataSource = self
        self.tblView?.delegate = self
    }
    
    //    MARK:- Button Action
    @IBAction func actionCoinClick(_ sender: UIButton) {
        self.lblItemDetails.isHidden = true
        self.lblPennyCoinNotAccept.isHidden = true
        if sender.tag == 3 {
            self.lblPennyCoinNotAccept.isHidden = false
        } else {
            self.viewModel.actionCoinClick(index: sender.tag)
        }
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        
        self.lblItemDetails.isHidden = false
        self.btnSubmit.isEnabled = false
        self.lblSelectItem.isHidden = false
        self.lblSelectItem.text = "Thank You"
        let message = self.viewModel.actionSubmit()
        self.lblItemDetails.text = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.viewModel.resetSelectedItemData()
            self.resetData()
        }
    }
    
    @IBAction func actionReturn(_ sender: Any) {
        self.lblItemDetails.isHidden = false
        self.stackCoin.isHidden = true
        let message = self.viewModel.actionReturnCoin()
        self.lblItemDetails.text = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel.resetSelectedItemData()
            self.resetData()
        }
    }
    //    MARK:- Reset Data
    private func resetData() {
        self.tblView.reloadData()
        self.lblTotal.text = "$0.0"
        self.viewInsertCoin.isHidden = true
        self.lblItemDetails.isHidden = true
        self.lblItemDetails.text = ""
        self.lblSelectItem.isHidden = false
        self.lblSelectItem.text = "Select Item"
    }
}

//MARK:- TableView Delegate & DataSource Method

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrProductItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListCell
        cell.productData = self.viewModel.arrProductItems[indexPath.row]
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.isSelectProduct == true {
            self.viewModel.selectProduct(item: self.viewModel.arrProductItems[indexPath.row])
            self.viewModel.selectItemIndex = indexPath.row
            self.viewModel.isSelectProduct = false
            for (index,_) in self.viewModel.arrProductItems.enumerated() {
                if index == indexPath.row {
                    self.viewModel.arrProductItems[index].isSelected = true
                } else {
                    self.viewModel.arrProductItems[index].isSelected = false
                }
            }
            self.tblView.reloadData()
        }
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
                self.tblView.reloadData()
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
