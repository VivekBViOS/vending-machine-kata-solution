//
//  ProductListCell.swift
//  VendingMachine
//
//  Created by Brainvire on 20/09/21.
//

import UIKit

class ProductListCell: UITableViewCell {

    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    var productData: ProductItems! {
        didSet{
            self.lblProductName.text = productData.name
            self.lblPrice.text = productData.amount
            if productData.isSelected {
                viewProduct.layer.borderWidth = 2
                viewProduct.layer.borderColor = UIColor.red.cgColor
            } else {
                viewProduct.layer.borderWidth = 1
                viewProduct.layer.borderColor = UIColor.lightGray.cgColor

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
