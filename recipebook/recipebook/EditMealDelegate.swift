import Foundation

protocol EditMealDelegate: AnyObject {
    func updateMealName(_ newMealName: String)
    func updateMealInstructions(_ newMealInstructions: String)
}
