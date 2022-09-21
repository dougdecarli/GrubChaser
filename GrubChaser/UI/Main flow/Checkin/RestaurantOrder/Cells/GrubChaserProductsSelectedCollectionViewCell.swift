//
//  GrubChaserProductsSelectedCollectionViewCell.swift
//  GrubChaser
//
//  Created by Douglas Immig on 20/09/22.
//

import UIKit

class GrubChaserProductsSelectedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    static let identifier = "GrubChaserProductsSelectedCollectionViewCell",
               nibName = "GrubChaserProductsSelectedCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(productImageURL: String) {
        productImage.loadImage(imageURL: productImageURL,
                                    genericImage: R.image.productImage()!)
    }
}
