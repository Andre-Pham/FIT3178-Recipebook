//
//  IngredientMeasurement.swift
//  recipebook
//
//  Created by Andre Pham on 5/4/21.
//

import UIKit

class IngredientMeasurement: NSObject {
    
    // MARK: - Properties
    
    var name: String?
    var quantity: String?
    
    // MARK: - Constructor
    
    init(name: String, quantity: String) {
        self.name = name
        self.quantity = quantity
    }
}