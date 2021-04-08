import Foundation

protocol EditMealDelegate: AnyObject {
    func updateMealName(_ newMealName: String)
    func updateMealInstructions(_ newMealInstructions: String)
    func updateMealIngredients(_ newIngredient: IngredientMeasurement)
}
