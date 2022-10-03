//
//  GrubChaserProductBagTableViewCell.swift
//  GrubChaser
//
//  Created by Douglas Immig on 21/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class GrubChaserProductBagTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productsNumberLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    static let identifier = "GrubChaserProductBagTableViewCell",
               nibName = "GrubChaserProductBagTableViewCell"
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(model: GrubChaserProductBag) {
        productImage.loadImage(imageURL: model.product.image, genericImage: R.image.productImage()!)
        productNameLabel.text = model.product.name
        productPriceLabel.text = "\(String(model.product.price * Double(model.quantity)).currencyFormatting())"
        productsNumberLabel.text = String(model.quantity)
        minusButton.setImage(model.quantity <= 1 ?
                             UIImage(systemName: "trash") :
                                UIImage(systemName: "minus"), for: .normal)
    }
}
