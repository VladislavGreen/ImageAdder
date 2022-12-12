//
//  TextPicker.swift
//  ImageAdder
//
//  Created by Vladislav Green on 12/12/22.
//

import UIKit

class TextPicker {
    
    static let defaultPicker = TextPicker()
    
    func showPicker(in viewController: UIViewController, completion: @escaping (_ text: String) -> Void) {
        
        let alertController = UIAlertController(title: "Enter the name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter the name"
        }
        
        let actionOK = UIAlertAction(title: "OK", style: .default) {
            action in
            if let text = alertController.textFields?[0].text, text != "" {
                completion(text)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(actionOK)
        alertController.addAction(actionCancel)
        
        viewController.present(alertController, animated: true)
    }
}

