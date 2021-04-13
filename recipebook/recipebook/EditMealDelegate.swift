//
//  EditMealDelegate.swift
//  recipebook
//
//  Created by Andre Pham on 8/4/21.
//

import Foundation

protocol EditMealDelegate: AnyObject {
    
    func updateMealName(_ newMealName: String)
    func updateMealInstructions(_ newMealInstructions: String)
    func updateMealIngredients(_ newIngredient: IngredientMeasurementData)
    
}
