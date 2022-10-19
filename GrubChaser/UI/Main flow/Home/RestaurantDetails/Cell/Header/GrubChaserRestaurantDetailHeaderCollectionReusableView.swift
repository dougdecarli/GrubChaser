//
//  GrubChaserRestaurantDetailHeaderCollectionReusableView.swift
//  GrubChaser
//
//  Created by Douglas Immig on 27/09/22.
//

import UIKit

final class GrubChaserRestaurantDetailHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var restaurantDistance: UILabel!
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var occupancyLabel: UILabel!
    
    static let identifier = "GrubChaserRestaurantDetailHeaderCollectionReusableView",
               nibName = "GrubChaserRestaurantDetailHeaderCollectionReusableView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(restaurant: GrubChaserRestaurantModel,
              distance: String,
              numberOfTables: String,
              numberOfTablesOccupied: String) {
        restaurantImageView.loadImage(imageURL: restaurant.logo,
                                      genericImage: R.image.genericLogo()!)
        restaurantCategoryLabel.text = restaurant.categoryName
        restaurantAddressLabel.text = restaurant.location.address
        restaurantDistance.text = distance
        occupancyLabel.text = "\(numberOfTablesOccupied) mesas num total de \(numberOfTables) estão ocupadas"
    }
}
