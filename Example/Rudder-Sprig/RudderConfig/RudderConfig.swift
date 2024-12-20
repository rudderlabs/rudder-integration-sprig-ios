//
//  RudderConfig.swift
//  Rudder-Sprig_Example
//
//  Created by Abhishek Pandey on 21/03/23.
//  Copyright © 2023 arnabp92. All rights reserved.
//

import Foundation

@objc
class RudderConfig: NSObject, Codable {
    @objc let WRITE_KEY: String
    @objc let DATA_PLANE_URL: String
    @objc let CONTROL_PLANE_URL: String
    
    @objc
    class func create(from url: URL) -> RudderConfig? {
        if let data = try? Data(contentsOf: url),
           let rudderConfig = try? PropertyListDecoder().decode(RudderConfig.self, from: data) {
            return rudderConfig
        }
        return nil
    }
}
