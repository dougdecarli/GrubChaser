//
//  GrubChaserRestaurantCheckinCollectionViewCell.swift
//  GrubChaser
//
//  Created by Douglas Immig on 13/09/22.
//

import UIKit

class GrubChaserRestaurantCheckinCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var restaurantLogo: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantCategory: UILabel!
    
    static let identifier = "GrubChaserRestaurantCheckinCollectionViewCell",
               nibName: String = "GrubChaserRestaurantCheckinCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(cellModel: GrubChaserRestaurantModel) {
        self.restaurantName.text = cellModel.name
        self.restaurantCategory.text = cellModel.categoryName
        restaurantLogo.loadImage(imageURL: cellModel.logo,
                                  genericImage: R.image.genericLogo()!)
    }
}
