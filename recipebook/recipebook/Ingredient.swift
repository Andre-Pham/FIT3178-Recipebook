//
//  Ingredient.swift
//  recipebook
//
//  Created by Andre Pham on 5/4/21.
//

import UIKit

class Ingredient: NSObject {
    
    // MARK: - Properties
    
    var name: String?
    var ingredientDescription: String?

    // MARK: - Constructor
    
    init(name: String, ingredientDescription: String) {
        self.name = name
        self.ingredientDescription = ingredientDescription
    }
}
