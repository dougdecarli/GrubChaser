//
//  GrubChaserProdutsCollectionViewCell.swift
//  GrubChaser
//
//  Created by Douglas Immig on 30/08/22.
//

import UIKit
import Nuke

class GrubChaserProdutsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    static let identifier = "GrubChaserProdutsCollectionViewCell",
               nibName: String = "GrubChaserProdutsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(product: GrubChaserProductsCellModel) {
        self.productPrice.text = product.price
        self.productName.text = product.name
        productImage.loadImage(imageURL: product.image,
                                  genericImage: R.image.genericFood()!)
    }
}
