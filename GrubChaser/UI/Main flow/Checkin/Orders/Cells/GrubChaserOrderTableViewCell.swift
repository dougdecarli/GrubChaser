//
//  GrubChaserOrderTableViewCell.swift
//  GrubChaser
//
//  Created by Douglas Immig on 23/09/22.
//

import UIKit

final class GrubChaserOrderTableViewCell: UITableViewCell {
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    static let identifier = "GrubChaserOrderTableViewCell",
               nibName = "GrubChaserOrderTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(productBag: GrubChaserProductBag) {
        productImageView.loadImage(imageURL: productBag.product.image,
                                   genericImage: R.image.productImage()!)
        productQuantity.text = String(productBag.quantity)
        productNameLabel.text = productBag.product.name
        productPriceLabel.text = "\(String(productBag.product.price * Double(productBag.quantity)).currencyFormatting())"
    }
}
