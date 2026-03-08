//
//  APIService.swift
//  ScamShield
//
//  Handle all API calls for phone number validation
//

import Foundation

// MARK: - API Service
class APIService {
    static let shared = APIService()
    
    // API Keys (move to Config.swift in production)
    private let numverifyKey = "YOUR_NUMVERIFY_KEY"
    private let abstractKey = "YOUR_ABSTRACT_KEY"
    
    private let numverifyBase = "http://apilayer.net/api/validate"
    private let abstractBase = "https://phonevalidation.abstractapi.com/v1/"
    
    private init() {}
    
    // MARK: - Check Phone Number
    func checkNumber(_ phoneNumber: String) async throws -> PhoneNumberResult {
        // 1. Check local database first
        if let localResult = await checkLocalDatabase(phoneNumber) {
            return localResult
        }
        
        // 2. Call NumVerify API
        let numverifyResult = try await callNumVerifyAPI(phoneNumber)
        
        // 3. Calculate scam score
        let scamScore = calculateScamScore(numverifyResult)
        
        // 4. Detect red flags
        let redFlags = detectRedFlags(numverifyResult)
        
        // 5. Get community report count
        let reportCount = await fetchReportCount(phoneNumber)
        
        // 6. Create result
        let result = PhoneNumberResult.from(
            numverify: numverifyResult,
            scamScore: scamScore,
            redFlags: redFlags,
            reportCount: reportCount
        )
        
        // 7. Save to history
        await saveToHistory(result)
        
        return result
    }
    
    // MARK: - NumVerify API Call
    private func callNumVerifyAPI(_ phoneNumber: String) async throws -> NumVerifyResponse {
        let urlString = "\(numverifyBase)?access_key=\(numverifyKey)&number=\(phoneNumber)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(NumVerifyResponse.self, from: data)
        
        return result
    }
    
    // MARK: - Abstract API Call (Alternative/Backup)
    private func callAbstractAPI(_ phoneNumber: String) async throws -> AbstractAPIResponse {
        let urlString = "\(abstractBase)?api_key=\(abstractKey)&phone=\(phoneNumber)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(AbstractAPIResponse.self, from: data)
        
        return result
    }
    
    // MARK: - Check Local Database
    private func checkLocalDatabase(_ phoneNumber: String) async -> PhoneNumberResult? {
        // TODO: Implement database check
        // Check against local SQLite database of known scam numbers
        return nil
    }
    
    // MARK: - Calculate Scam Score
    private func calculateScamScore(_ response: NumVerifyResponse) -> Int {
        var score = 0
        
        // Check if number is VOIP (high risk)
        if response.lineType?.lowercased() == "voip" {
            score += 40
        }
        
        // Check if carrier is unknown
        if response.carrier == nil || response.carrier?.isEmpty == true {
            score += 20
        }
        
        // Check for suspicious patterns
        if hasSequentialPattern(response.number) {
            score += 15
        }
        
        if hasRepeatedDigits(response.number) {
            score += 10
        }
        
        // Add more scoring logic here
        
        return min(score, 100)
    }
    
    // MARK: - Detect Red Flags
    private func detectRedFlags(_ response: NumVerifyResponse) -> [String] {
        var flags: [String] = []
        
        // VOIP detection
        if response.lineType?.lowercased() == "voip" {
            flags.append("VOIP number (commonly used for scam operations)")
        }
        
        // Unknown carrier
        if response.carrier == nil || response.carrier?.isEmpty == true {
            flags.append("Unknown carrier information")
        }
        
        // Pattern detection
        if hasSequentialPattern(response.number) {
            flags.append("Sequential number pattern detected (555-1234)")
        }
        
        if hasRepeatedDigits(response.number) {
            flags.append("Repeated digit pattern detected (555-5555)")
        }
        
        return flags
    }
    
    // MARK: - Pattern Detection
    private func hasSequentialPattern(_ number: String) -> Bool {
        let digits = number.filter { $0.isNumber }
        guard digits.count >= 4 else { return false }
        
        // Check for sequences like 1234, 2345, etc.
        let digitsArray = Array(digits)
        for i in 0..<(digitsArray.count - 3) {
            let slice = digitsArray[i..<i+4]
            if isSequential(Array(slice)) {
                return true
            }
        }
        
        return false
    }
    
    private func isSequential(_ digits: [Character]) -> Bool {
        guard digits.count >= 4 else { return false }
        
        for i in 0..<(digits.count - 1) {
            guard let current = Int(String(digits[i])),
                  let next = Int(String(digits[i + 1])) else {
                return false
            }
            
            if next != current + 1 {
                return false
            }
        }
        
        return true
    }
    
    private func hasRepeatedDigits(_ number: String) -> Bool {
        let digits = number.filter { $0.isNumber }
        let digitsArray = Array(digits)
        
        // Check for 4+ repeated digits
        for i in 0..<(digitsArray.count - 3) {
            let digit = digitsArray[i]
            if digitsArray[i+1] == digit &&
               digitsArray[i+2] == digit &&
               digitsArray[i+3] == digit {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Fetch Report Count from Firebase
    private func fetchReportCount(_ phoneNumber: String) async -> Int {
        // TODO: Query Firebase for report count
        // For now, return 0
        return 0
    }
    
    // MARK: - Save to History
    private func saveToHistory(_ result: PhoneNumberResult) async {
        // TODO: Save to Core Data/SQLite
    }
}

// MARK: - API Errors
enum APIError: Error {
    case invalidURL
    case serverError
    case decodingError
    case noData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .serverError:
            return "Server returned an error"
        case .decodingError:
            return "Failed to decode response"
        case .noData:
            return "No data received"
        }
    }
}

// MARK: - Mock Service for Testing
#if DEBUG
extension APIService {
    func checkNumberMock(_ phoneNumber: String) async throws -> PhoneNumberResult {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Return mock data
        if phoneNumber.contains("555-0123") {
            return .mockScam
        } else {
            return .mockSafe
        }
    }
}
#endif
