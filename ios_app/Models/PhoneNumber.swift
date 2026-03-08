//
//  PhoneNumber.swift
//  ScamShield
//
//  Data models for phone number information
//

import Foundation

// MARK: - Phone Number Result
struct PhoneNumberResult: Identifiable {
    let id = UUID()
    let phoneNumber: String
    let scamScore: Int
    let location: String
    let carrier: String
    let lineType: String
    let redFlags: [String]
    let reportCount: Int
    let isScam: Bool
    
    var statusTitle: String {
        switch scamScore {
        case 0..<30:
            return "Likely Safe ✅"
        case 30..<70:
            return "Proceed with Caution ⚠️"
        default:
            return "High Risk Scam 🚫"
        }
    }
    
    var statusMessage: String {
        switch scamScore {
        case 0..<30:
            return "This number appears to be legitimate"
        case 30..<70:
            return "Some suspicious indicators detected"
        default:
            return "Strong evidence this is a scam number"
        }
    }
    
    var statusColor: Color {
        switch scamScore {
        case 0..<30: return .green
        case 30..<70: return .orange
        default: return .red
        }
    }
}

// MARK: - Call Log (History)
struct CallLog: Identifiable {
    let id = UUID()
    let phoneNumber: String
    let scamScore: Int
    let isScam: Bool
    let location: String?
    let checkedAt: Date
    
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: checkedAt, relativeTo: Date())
    }
}

// MARK: - Community Report
struct CommunityReport: Identifiable {
    let id = UUID()
    let phoneNumber: String
    let scamType: String
    let description: String
    let reporterId: String
    let reportedAt: Date
    let verifications: Int
    
    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: reportedAt, relativeTo: Date())
    }
}

// MARK: - Scam Report (for submission)
struct ScamReport {
    let phoneNumber: String
    let scamType: String
    let description: String
    let reportedBy: String
    let timestamp: Date
}

// MARK: - Area Code Info
struct AreaCodeInfo {
    let code: String
    let location: String
    let state: String
    let country: String
    let isHighRisk: Bool
}

// MARK: - API Response Models
struct NumVerifyResponse: Codable {
    let valid: Bool
    let number: String
    let localFormat: String?
    let internationalFormat: String?
    let countryPrefix: String?
    let countryCode: String?
    let countryName: String?
    let location: String?
    let carrier: String?
    let lineType: String?
    
    enum CodingKeys: String, CodingKey {
        case valid, number
        case localFormat = "local_format"
        case internationalFormat = "international_format"
        case countryPrefix = "country_prefix"
        case countryCode = "country_code"
        case countryName = "country_name"
        case location, carrier
        case lineType = "line_type"
    }
}

// MARK: - Abstract API Response
struct AbstractAPIResponse: Codable {
    let valid: Bool
    let format: PhoneFormat?
    let country: CountryInfo?
    let type: String?
    
    struct PhoneFormat: Codable {
        let international: String?
        let local: String?
    }
    
    struct CountryInfo: Codable {
        let code: String?
        let name: String?
        let prefix: String?
    }
}

// MARK: - Extensions
extension PhoneNumberResult {
    // Create from API responses
    static func from(numverify: NumVerifyResponse, scamScore: Int, redFlags: [String], reportCount: Int) -> PhoneNumberResult {
        return PhoneNumberResult(
            phoneNumber: numverify.internationalFormat ?? numverify.number,
            scamScore: scamScore,
            location: numverify.location ?? "Unknown",
            carrier: numverify.carrier ?? "Unknown",
            lineType: numverify.lineType ?? "Unknown",
            redFlags: redFlags,
            reportCount: reportCount,
            isScam: scamScore >= 70
        )
    }
}

// MARK: - Mock Data for Previews
extension PhoneNumberResult {
    static var mockScam: PhoneNumberResult {
        PhoneNumberResult(
            phoneNumber: "+1 (561) 555-0123",
            scamScore: 92,
            location: "West Palm Beach, FL",
            carrier: "Unknown VOIP Provider",
            lineType: "VOIP",
            redFlags: [
                "VOIP number (commonly used for scams)",
                "347 community reports in last 30 days",
                "Associated with IRS scam campaign",
                "Sequential number pattern detected"
            ],
            reportCount: 347,
            isScam: true
        )
    }
    
    static var mockSafe: PhoneNumberResult {
        PhoneNumberResult(
            phoneNumber: "+1 (555) 123-4567",
            scamScore: 15,
            location: "New York, NY",
            carrier: "Verizon Wireless",
            lineType: "Mobile",
            redFlags: [],
            reportCount: 0,
            isScam: false
        )
    }
}

extension CallLog {
    static var mockLogs: [CallLog] {
        [
            CallLog(
                phoneNumber: "+1 (561) 555-0123",
                scamScore: 92,
                isScam: true,
                location: "West Palm Beach, FL",
                checkedAt: Date().addingTimeInterval(-3600)
            ),
            CallLog(
                phoneNumber: "+1 (555) 123-4567",
                scamScore: 15,
                isScam: false,
                location: "New York, NY",
                checkedAt: Date().addingTimeInterval(-7200)
            )
        ]
    }
}

extension CommunityReport {
    static var mockReports: [CommunityReport] {
        [
            CommunityReport(
                phoneNumber: "+1 (561) 555-0123",
                scamType: "IRS Scam",
                description: "Claimed to be from IRS demanding immediate payment via gift cards",
                reporterId: "8472",
                reportedAt: Date().addingTimeInterval(-3600),
                verifications: 47
            ),
            CommunityReport(
                phoneNumber: "+1 (555) 999-8888",
                scamType: "Tech Support",
                description: "Fake Microsoft support, wanted remote access to computer",
                reporterId: "2941",
                reportedAt: Date().addingTimeInterval(-7200),
                verifications: 23
            )
        ]
    }
}
