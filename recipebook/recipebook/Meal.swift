//
//  Meal.swift
//  recipebook
//
//  Created by Andre Pham on 5/4/21.
//

import UIKit

class Meal: NSObject {

    // MARK: - Properties
    
    var name: String?
    var instructions: String
    //var ingredients: [IngredientMeasurement]
    
    // MARK: - Constructor
    
    init(name: String, instructions: String) {
        self.name = name
        self.instructions = instructions
        //self.ingredients = ingredients
    }
}
