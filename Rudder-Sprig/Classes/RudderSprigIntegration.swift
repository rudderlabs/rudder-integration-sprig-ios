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
        Sprig.shared.logout()
        RSLogger.logVerbose("SprigIntegrationFactory: Sprig.shared.logout() is called")
    }
    
    public func flush() {
    }
}

// MARK: - Event Handlers

extension RudderSprigIntegration {

    func handleIdentifyMessage(_ message: RSMessage) {
        let userId = message.userId
        guard !userId.isEmpty else {
            RSLogger.logError("SprigIntegrationFactory: UserId is not set. Dropping identify event")
            return
        }
        Sprig.shared.setUserIdentifier(userId)
        
        // set email address
        if let email = message.context.traits["email"] as? String {
            Sprig.shared.setEmailAddress(email)
        }
        
        let filteredTraits: [String : Any] = filterTraits(message.context.traits)
        
        Sprig.shared.setVisitorAttributes(filteredTraits)
    }
    
    func handleTrackMessage(_ message: RSMessage) {
        let payload = EventPayload(
            eventName: message.event,
            properties: message.properties
        )
        
        guard let controller = self.viewController else {
            Sprig.shared.track(payload: payload)
            RSLogger.logDebug("SprigIntegrationFactory: View controller is not set hence called the track Sprig.shared.track(payload) method")
            return
        }
        
        Sprig.shared.trackAndPresent(
            payload: payload,
            from: controller
        )
        RSLogger.logDebug("SprigIntegrationFactory: View controller is set hence called the track Sprig.shared.trackAndPresent(payload, controller) method")
    }
}

// MARK: - Utils Method

private func filterTraits(_ properties: NSDictionary?) -> [String: Any] {
    var filteredProperties = [String: Any]()
    
    if let properties = properties {
        for (key, value) in properties {
            guard let key = key as? String else {
                continue // Skip if the key is not a String
            }
            
            if key == "email" {
                // As email is set directly, ignoring this value
                continue
            }
            
            if key.count < 256 && !key.hasPrefix("!") {
                if value is String || value is Bool || value is Double || value is Int {
                    filteredProperties[key] = value
                } else {
                    RSLogger.logWarn("\(value) is not a valid property value. Only String, Bool, Double and Int are accepted as valid attributes. Ignoring property.")
                }
            } else {
                RSLogger.logWarn("\(key) is not a valid property name. Property names must be less than 256 characters and cannot start with a '!'. Ignoring property.")
            }
        }
    }
    
    return filteredProperties
}
