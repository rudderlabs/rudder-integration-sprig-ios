//
//  RudderSprigIntegration.swift
//  Rudder-Sprig
//
//  Created by Satheesh Kannan on 07/06/24.
//

import Foundation
import Rudder
import UserLeapKit

// MARK: - Rudder ServerConfig Keys
private struct ServerConfigKey {
    static let apiKey = "apiKey"
    
    private init() {}
}

// MARK: - RudderSprigIntegration

@objcMembers
public class RudderSprigIntegration: NSObject {
    
    // MARK: - Variables
    let config: [AnyHashable : Any]
    let client: RSClient
    let rudderConfig: RSConfig
    var viewController: UIViewController?
    
    // MARK: - Initializer
    init(config: [AnyHashable : Any], client: RSClient, rudderConfig: RSConfig) {
        self.config = config
        self.client = client
        self.rudderConfig = rudderConfig
        
        super.init()
        
        self.initializeSprig()
    }
}

// MARK: - Framework Initializer

extension RudderSprigIntegration {
    
    func initializeSprig() {
        guard let config = self.config as? [String: Any] else { return }
        
        if config.isEmpty {
            RSLogger.logError("Destination configuration is empty. Aborting sprig initialization.")
            return
        } else {
            
            guard let apiKey = config[ServerConfigKey.apiKey] as? String, !apiKey.isEmpty else {
                RSLogger.logError("Invalid API key. Aborting sprig initialization.")
                return
            }

            // Sprig.shared.configure(withEnvironment: apiKey)
            // RSLogger.logVerbose("Sprig SDK is initialized successfully.")
        }
    }
}

// MARK: - RSIntegration
extension RudderSprigIntegration: RSIntegration {
    
    enum RSMessageType: String {
        case identify = "identify"
        case screen = "screen"
        case track = "track"
        case group = "group"
        case alias = "alias"
    }
    
    public func dump(_ message: RSMessage) {
        switch message.type {
            case RSMessageType.identify.rawValue:
                self.handleIdentifyMessage(message)

            case RSMessageType.track.rawValue:
                self.handleTrackMessage(message)

            default:
                RSLogger.logWarn("SprigIntegrationFactory: MessageType(\(message.type.capitalized) is not supported")
        }
    }
    
    public func reset() {
    }
    
    public func flush() {
    }
}

// MARK: - Event Handlers

extension RudderSprigIntegration {
    func handleIdentifyMessage(_ message: RSMessage) {
    }
    
    func handleTrackMessage(_ message: RSMessage) {
        guard let controller = self.viewController else {
            RSLogger.logError("SprigIntegrationFactory: Dropping track event because view controller is not set")
            return
        }
        
        let payload = EventPayload(
            eventName: message.event,
            properties: message.properties
        )
        
        Sprig.shared.trackAndPresent(
            payload: payload,
            from: controller
        )
    }
}
