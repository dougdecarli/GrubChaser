//
//  GrubChaserProdutsCollectionViewCell.swift
//  GrubChaser
//
//  Created by Douglas Immig on 30/08/22.
//

import UIKit

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
        productImage.downloaded(from: product.image)
        self.productPrice.text = product.price
        self.productName.text = product.name
    }
    
    private func getImageFromUrl(url: String) -> UIImage {
        if let url = URL(string: url),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            return image
        }
        return R.image.genericFood()!
    }
}
