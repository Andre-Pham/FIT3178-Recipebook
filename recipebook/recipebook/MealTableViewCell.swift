//
//  MealTableViewCell.swift
//  recipebook
//
//  Created by Andre Pham on 5/4/21.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var labelMealTitle: UILabel!
    @IBOutlet weak var labelMealDescription: UILabel!
    @IBOutlet weak var labelMatchingMealTitle: UILabel!
    @IBOutlet weak var labelMatchingMealDescription: UILabel!
    
    // MARK: - Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
