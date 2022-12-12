//
//  LoginTVController.swift
//  ImageAdder
//
//  Created by Vladislav Green on 12/10/22.
//

import UIKit
import KeychainAccess

class LoginTVController: UITableViewController {
    
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var userIsRegistered: Bool!
    
    private var passwordToConfirm: String? = nil
    
    let keychain = Keychain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSavedPassword()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.text = nil
        passwordToConfirm = nil
    }
    
    
    private func checkSavedPassword() {
        
        // Пароль не создавался: userIsRegistered = false, loginButton.setTitle - Create Password
        // Есть сохранённый пароль: userIsRegistered = true, loginButton.setTitle - Enter Password
        
        if keychain["user"] == nil {
            userIsRegistered = false
            logoutButton?.isHidden = true
            loginButton.setTitle("Create password and press here", for: .normal)
        } else {
            userIsRegistered = true
            logoutButton?.isHidden = false
            loginButton.setTitle("Enter password and press here", for: .normal) 
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {

        //  userIsRegistered = true
            // Проверка пароля, если не совпадает
                // Alarm + Reenter
            // Открываем экран профиля
        //  userIsRegistered = false
            // Проверить на не менее четырёх символов, если нет
                // User Alarm
            // loginButton.setTitle - Repeat Password
            // Ввести пароль второй раз, если не совпадает
                // User Alarm + Заново с первой попытки
            // Сохраняем в Keychain
            // Открываем экран профиля
        
        if passwordToConfirm == nil {
            if userIsRegistered {
                guard passwordTextField.text == keychain["user"] else {
                    let message = "Пароль не совпадает с сохранённым"
                    showAlarm(with: message)
                    return
                }
                enterProfile()
            } else {
                
                passwordToConfirm = passwordTextField.text
                guard passwordToConfirm?.count ?? 0 > 3 else {
                    let message = "Пароль содержит менее четырёх символов"
                    showAlarm(with: message)
                    logout()
                    return
                }
                loginButton.setTitle("Repeat password and press here", for: .normal)
                passwordTextField.text = nil
                return
            }
        } else {
            guard passwordToConfirm == passwordTextField.text else {
//                print("Пароли не совпадают, давайте сначала")
                let message = "Пароли не совпадают, давайте сначала."
                showAlarm(with: message)
                logout()
                tableView.reloadData()
                return
            }
            keychain["user"] = passwordTextField.text
            passwordToConfirm = nil
            passwordTextField.text = nil
            enterProfile()
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        logout()
    }
    
    private func logout() {
        print("выходим из профиля")
        keychain["user"] = nil
        userIsRegistered = false
        passwordToConfirm = nil
        passwordTextField.text = nil
        logoutButton?.isHidden = true
        tableView.reloadData()
        checkSavedPassword()
    }
    
    private func enterProfile() {
        print("Входим в профиль")
        performSegue(withIdentifier: "goToProfile", sender: self)
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
