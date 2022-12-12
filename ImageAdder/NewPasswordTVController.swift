//
//  NewPasswordTVController.swift
//  ImageAdder
//
//  Created by Vladislav Green on 12/12/22.
//

import UIKit
import KeychainAccess

class NewPasswordTVController: UITableViewController {
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createNewPasswordButtonPushed(_ sender: Any) {
        guard newPasswordTextField.text?.count ?? 0 > 3 else {
            let message = "Пароль содержит менее четырёх символов"
            showAlarm(with: message)
            return
        }
        let keychain = Keychain()
        keychain["user"] = newPasswordTextField.text
        self.dismiss(animated: true)
    }
    
    private func showAlarm(with message: String) {
        print(message)
        
        let alertConfiguration = UIAlertController(title: "Message:",
                                                   message: message,
                                                   preferredStyle: .alert)
        alertConfiguration.addAction(UIAlertAction(title: "OK",
                                                   style: .cancel,
                                                   handler: {_ in
        }))
        
        self.present(alertConfiguration, animated: true)
    }
    
}
