//
//  GrubChaserRestaurantTableViewCell.swift
//  GrubChaser
//
//  Created by Douglas Immig on 22/08/22.
//

import UIKit

class GrubChaserRestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantRating: UILabel!
    static let identifier = "GrubChaserRestaurantTableViewCell",
               nibName: String = "GrubChaserRestaurantTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let favoriteAccessory = R.image.favoriteIcon()
        let favoriteAccessoryImageView = UIImageView(image: favoriteAccessory)
        favoriteAccessoryImageView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        accessoryView = favoriteAccessoryImageView
    }
    
    func bind(cellModel: GrubChaserRestaurantModel) {
        self.restaurantName.text = cellModel.name
        restaurantImage.loadImage(imageURL: cellModel.logo,
                                  genericImage: R.image.genericLogo()!)
    }
}
