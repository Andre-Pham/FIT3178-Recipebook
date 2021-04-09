//
//  IngredientRootWebData.swift
//  recipebook
//
//  Created by Andre Pham on 9/4/21.
//

import UIKit

class IngredientRootWebData: NSObject, Decodable {
    
    // MARK: - Properties
        
    // Web service
    var ingredients: [IngredientWebData]?
    
    // MARK: - Coding Keys
    
    // Ingredients
    private enum CodingKeys: String, CodingKey {
        case ingredients = "meals"
    }
}
