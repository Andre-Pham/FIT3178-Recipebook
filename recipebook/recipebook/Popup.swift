//
//  Popup.swift
//  recipebook
//
//  Created by Andre Pham on 7/4/21.
//

import UIKit

class Popup: NSObject {
    static func displayPopup(title: String, message: String, viewController: UIViewController) -> Void {
      // Define alert
      let alertController = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
      )
      // Add interaction to alert
      alertController.addAction(
        UIAlertAction(
          title: "Dismiss",
          style: .default,
          handler: nil
        )
      )
      // Present alert
      viewController.present(
        alertController,
        animated: true,
        completion: nil
      )
    }
}
