//
//  GrubChaserProductsHeaderCollectionReusableView.swift
//  GrubChaser
//
//  Created by Douglas Immig on 27/09/22.
//

import UIKit

final class GrubChaserProductsHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    
    static let identifier = "GrubChaserProductsHeaderCollectionReusableView",
               nibName = "GrubChaserProductsHeaderCollectionReusableView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(restaurant: GrubChaserRestaurantModel) {
        restaurantNameLabel.text = restaurant.name
        restaurantCategoryLabel.text = restaurant.categoryName
        restaurantImageView.loadImage(imageURL: restaurant.logo, genericImage: R.image.genericLogo()!)
    }
}
