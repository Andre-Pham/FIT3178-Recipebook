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
        
        // Assign fonts and add support for dynamic type - My Meals page
        self.labelMealTitle?.font = CustomFont.setSubtitleFont()
        self.labelMealDescription?.font = CustomFont.setBodyFont()
        self.labelMealTitle?.adjustsFontForContentSizeCategory = true
        self.labelMealTitle?.adjustsFontForContentSizeCategory = true
        
        // Assign fonts and add support for dynamic type - Search Meals page
        self.labelMatchingMealTitle?.font = CustomFont.setSubtitleFont()
        self.labelMatchingMealDescription?.font = CustomFont.setBodyFont()
        self.labelMatchingMealTitle?.adjustsFontForContentSizeCategory = true
        self.labelMatchingMealDescription?.adjustsFontForContentSizeCategory = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
