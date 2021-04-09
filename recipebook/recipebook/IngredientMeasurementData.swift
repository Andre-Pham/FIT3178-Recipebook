import UIKit

class IngredientMeasurementData: NSObject {

    // MARK: - Properties
    
    var name: String?
    var quantity: String?

    // MARK: - Constructor
    
    init(name: String, quantity: String) {
        self.name = name
        self.quantity = quantity
    }
}
