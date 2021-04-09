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
    //var allIngredients: [String]
    
    // MARK: - Coding Keys
    
    /*
    private enum RootKeys: String, CodingKey {
        // This is the name of the root that stores the subsequent values
        case ingredients = "meals"
    }
    */
    
    
    private enum IngredientKeys: String, CodingKey {
        // Where our case matches our property names, we don't need to specify a value
        case ingredientName = "strIngredient"
        case ingredientDescription = "strDescription"
    }
    
    
    // MARK: - Constructor
    
    required init(from decoder: Decoder) throws {
        // Get the root container first
        //let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // Get the ingredient containers
        //let ingredientContainer = try rootContainer.nestedContainer(keyedBy: IngredientKeys.self, forKey: .ingredients)
        
        let ingredientContainer = try decoder.container(keyedBy: IngredientKeys.self)
        
        /*
        if let ingredientsArray = try? rootContainer.decode([String].self, forKey: .ingredients) {
            self.allIngredients = ingredientsArray
        }
        else {
            self.allIngredients = []
        }
        */
        
        // Get the book info
        // If it fails we just provide nil as the value
        do {
            self.ingredientName = try ingredientContainer.decode(String.self, forKey: .ingredientName)
        }
        catch {
            self.ingredientName = ""
        }
        
        do {
            self.ingredientDescription = try ingredientContainer.decode(String.self, forKey: .ingredientDescription)
        }
        catch {
            self.ingredientDescription = ""
        }
        
        
        //self.ingredientName = try rootContainer.decode(String.self, forKey: .ingredientName)
        //self.ingredientDescription = try rootContainer.decode(String.self, forKey: .ingredientDescription)
        
    }
    
}
