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
    
    // MARK: - Singleton Instance
    public static let instance = RudderSprigFactory()
    
    private var sprigIntegration: RudderSprigIntegration?
    private var viewController: UIViewController?
    
    // MARK: - Initializer
    private override init() {}
    
    public func initiate(_ config: [AnyHashable: Any], client: RSClient, rudderConfig: RSConfig) -> any RSIntegration {
        RSLogger.logDebug("Creating RudderSprigIntegrationFactory")
        
        let integration = RudderSprigIntegration(config: config, client: client, rudderConfig: rudderConfig)
        self.sprigIntegration = integration
        updateViewController()
        
        return integration
    }
    
    public func addViewController(_ viewController: UIViewController) {
        self.viewController = viewController
        updateViewController()
    }
    
    // MARK: - Helper
    private func updateViewController() {
        sprigIntegration?.viewController = viewController
    }
    
    // MARK: - Key
    public func key() -> String {
        "Firebase"
    }
}
