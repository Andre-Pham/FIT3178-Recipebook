//
//  IngredientWebData.swift
//  recipebook
//
//  Created by Andre Pham on 9/4/21.
//

import UIKit

class IngredientWebData: NSObject, Decodable {
    
    // MARK: - Properties
    
    // Web service
    var ingredientName: String?
    var ingredientDescription: String?
    
    // MARK: - Coding Keys
    
    private enum IngredientKeys: String, CodingKey {
        case ingredientName = "strIngredient"
        case ingredientDescription = "strDescription"
    }
    
    // MARK: - Constructor
    
    required init(from decoder: Decoder) throws {
        // Assign container that holds all the ingredients retrieved from webservice
        let ingredientContainer = try decoder.container(keyedBy: IngredientKeys.self)
        
        // Assign ingredient name from webservice ingredient data
        do {
            self.ingredientName = try ingredientContainer.decode(String.self, forKey: .ingredientName)
        }
        catch {
            self.ingredientName = ""
        }
        
        // Assign ingredient description from webservice ingredient data
        do {
            self.ingredientDescription = try ingredientContainer.decode(String.self, forKey: .ingredientDescription)
        }
        catch {
            self.ingredientDescription = ""
        }
    }
    
}
