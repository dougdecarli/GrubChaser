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
              numberOfTables: Int,
              numberOfTablesOccupied: Int) {
        restaurantImageView.loadImage(imageURL: restaurant.logo,
                                      genericImage: R.image.genericLogo()!)
        restaurantCategoryLabel.text = restaurant.categoryName
        restaurantAddressLabel.text = restaurant.location.address
        restaurantDistance.text = distance
        
        if numberOfTablesOccupied > 0 {
            occupancyLabel.text = "\(String(numberOfTablesOccupied)) \(numberOfTablesOccupied > 1 ? "mesas" : "mesa") num total de \(String(numberOfTables)) mesas deste restaurante estão ocupadas"
        } else {
            occupancyLabel.text = "Nenhuma mesa deste restaurante está ocupada"
        }
    }
}
