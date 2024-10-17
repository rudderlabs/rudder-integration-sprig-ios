//
//  ViewController.swift
//  Rudder-Sprig_Example
//
//  Created by Abhishek Pandey on 16/10/24.
//  Copyright © 2024 arnabp92. All rights reserved.
//

import UIKit
import Rudder
import Rudder_Sprig

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Pass ViewController instance to RudderSprigFactory. As Sprig SDK requires this to display the servey.
        RudderSprigFactory.instance.setViewController(self)
    }
    
    @IBAction func identify(_ sender: Any) {
        let traits: [String: Any] = [
            "email": "test@mail.com",
            "key-1": "value",
            "key-2": 100,
            "key-3": 122.56,
            "key-4": true,
        ]
        RSClient.getInstance().identify("User iOS 1", traits: traits)
    }
    
    @IBAction func trackWithoutProperties(_ sender: Any) {
        RSClient.getInstance().track("Track event without properties")
    }
    
    @IBAction func trackWithProperties(_ sender: Any) {
        let properties: [String: Any] = [
            "key-5": "value 5",
            "key-6": 200,
        ]
        RSClient.getInstance().track("Track event with properties", properties: properties)
    }
    
    @IBAction func reset(_ sender: Any) {
        RSClient.getInstance().reset(false)
    }
}
