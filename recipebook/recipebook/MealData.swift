//
//  MealData.swift
//  recipebook
//
//  Created by Andre Pham on 11/4/21.
//

import UIKit

class MealData: NSObject {

    // MARK: - Properties
    
    var name: String?
    var instructions: String?
    var ingredients: [IngredientMeasurementData]?

    // MARK: - Constructor
    
    init(name: String, instructions: String, ingredients: [IngredientMeasurementData]) {
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
    }
}
