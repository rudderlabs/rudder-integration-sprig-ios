//
//  RudderSprigFactory.swift
//  Rudder-Sprig
//
//  Created by Satheesh Kannan on 07/06/24.
//

import Foundation
import Rudder

// MARK: - RudderSprigFactory
@objcMembers
public class RudderSprigFactory: NSObject, RSIntegrationFactory {
    
    // MARK: - Instance
    public static let instance: RudderSprigFactory = RudderSprigFactory()
    
    // MARK: - Initializer
    public func initiate(_ config: [AnyHashable : Any], client: RSClient, rudderConfig: RSConfig) -> any RSIntegration {
        RSLogger.logDebug("Creating RudderSprigIntegrationFactory")
        
        return RudderSprigIntegration(config: config, client: client, rudderConfig: rudderConfig)
    }
    
    // MARK: - Key
    public func key() -> String {
        return "Sprig"
    }
    
    private override init() {}
}
