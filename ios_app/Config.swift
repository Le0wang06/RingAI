// //  Config.swift
//  ScamShield
//
//  App configuration and API keys
//

import Foundation

struct Config {
    // MARK: - API Keys
    // TODO: Replace with your actual API keys
    static let numverifyAPIKey = "YOUR_NUMVERIFY_KEY_HERE"
    static let abstractAPIKey = "YOUR_ABSTRACT_API_KEY_HERE"
    
    // MARK: - API Endpoints
    static let numverifyBaseURL = "http://apilayer.net/api/validate"
    static let abstractBaseURL = "https://phonevalidation.abstractapi.com/v1/"
    
    // MARK: - App Configuration
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    
    // MARK: - Firebase Configuration
    // Firebase is configured via GoogleService-Info.plist
    
    // MARK: - Feature Flags
    static let enableCommunityReports = true
    static let enableStatistics = true
    static let enableExport = true
    
    // MARK: - Limits
    static let maxHistoryItems = 1000
    static let maxScamDatabaseSize = 50000
    static let apiRequestTimeout: TimeInterval = 30.0
    
    // MARK: - Thresholds
    static let highRiskScoreThreshold = 70
    static let mediumRiskScoreThreshold = 30
    
    // MARK: - Development/Debug
    #if DEBUG
    static let useMockData = false // Set to true for testing without API calls
    static let enableLogging = true
    #else
    static let useMockData = false
    static let enableLogging = false
    #endif
}

// MARK: - Helper Extensions
extension Config {
    static func log(_ message: String) {
        #if DEBUG
        if enableLogging {
            print("🛡️ ScamShield: \(message)")
        }
        #endif
    }
}
