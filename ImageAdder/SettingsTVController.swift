//
//  SettingsTVController.swift
//  ImageAdder
//
//  Created by Vladislav Green on 12/11/22.
//

import UIKit

class SettingsTVController: UITableViewController {

    
    @IBOutlet weak var orderSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
    }
    
    
    @IBAction func changePesswordButtonPushed(_ sender: Any) {
    }
    
    
    @IBAction func orderSwitchToggled(_ sender: Any) {
        let value = orderSwitch.isOn
        if value {
            print("Switch is on")
            UserDefaults.standard.set("Alphabetically", forKey: "order")
        } else {
            print("Switch is off")
            UserDefaults.standard.set("Unalphabetically", forKey: "order")
        }
    }
    
    private func loadUserDefaults() {
        let order = UserDefaults.standard.string(forKey: "order")
        if order == nil {
            UserDefaults.standard.set("Alphabetically", forKey: "order")
            orderSwitch.setOn(true, animated: true)
        } else {
            if order == "Alphabetically" {
                orderSwitch.setOn(true, animated: true)
            } else {
                orderSwitch.setOn(false, animated: true)
            }
            
        }
    }
}
