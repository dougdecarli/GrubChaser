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
    }
    
    func bind(cellModel: GrubChaserRestaurantCellModel) {
        self.restaurantName.text = cellModel.restaurantName
        self.restaurantImage.image = cellModel.restaurantImage
    }
}
