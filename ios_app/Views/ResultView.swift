//
//  ResultView.swift
//  ScamShield
//
//  Display scan results with detailed analysis
//

import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) var dismiss
    let result: PhoneNumberResult
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Scam Score Circle
                    ScoreCircleView(score: result.scamScore)
                        .padding(.top, 20)
                    
                    // Status Message
                    VStack(spacing: 8) {
                        Text(result.statusTitle)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(result.statusColor)
                        
                        Text(result.statusMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Phone Number Details
                    DetailsSectionView(result: result)
                    
                    // Red Flags (if any)
                    if !result.redFlags.isEmpty {
                        RedFlagsSection(flags: result.redFlags)
                    }
                    
                    // Community Reports
                    if result.reportCount > 0 {
                        CommunityReportsSection(count: result.reportCount)
                    }
                    
                    // Action Buttons
                    ActionButtonsSection(result: result)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Analysis Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Score Circle Component
struct ScoreCircleView: View {
    let score: Int
    
    var scoreColor: Color {
        switch score {
        case 0..<30: return .green
        case 30..<70: return .yellow
        default: return .red
        }
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                .frame(width: 150, height: 150)
            
            // Score circle
            Circle()
                .trim(from: 0, to: CGFloat(score) / 100)
                .stroke(scoreColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: score)
            
            // Score text
            VStack(spacing: 4) {
                Text("\(score)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(scoreColor)
                Text("/ 100")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Details Section
struct DetailsSectionView: View {
    let result: PhoneNumberResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Number Details")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                DetailRow(icon: "phone", label: "Number", value: result.phoneNumber)
                DetailRow(icon: "location", label: "Location", value: result.location)
                DetailRow(icon: "antenna.radiowaves.left.and.right", label: "Carrier", value: result.carrier)
                DetailRow(icon: "network", label: "Line Type", value: result.lineType)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(label)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Red Flags Section
struct RedFlagsSection: View {
    let flags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text("Red Flags Detected")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            VStack(spacing: 8) {
                ForEach(flags, id: \.self) { flag in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        Text(flag)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

// MARK: - Community Reports Section
struct CommunityReportsSection: View {
    let count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "person.3.fill")
                    .foregroundColor(.blue)
                Text("Community Reports")
                    .font(.headline)
            }
            
            HStack {
                Text("\(count) users reported this number as spam/scam")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Action Buttons Section
struct ActionButtonsSection: View {
    let result: PhoneNumberResult
    @State private var showingReportSheet = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Block Button
            Button(action: {
                // TODO: Add to blocklist
            }) {
                HStack {
                    Image(systemName: "nosign")
                    Text("Block Number")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            
            // Report Button
            Button(action: {
                showingReportSheet = true
            }) {
                HStack {
                    Image(systemName: "flag")
                    Text("Report as Scam")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .sheet(isPresented: $showingReportSheet) {
                ReportScamView(phoneNumber: result.phoneNumber)
            }
            
            // Share Button
            Button(action: {
                // TODO: Share result
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .foregroundColor(.blue)
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Report Scam View
struct ReportScamView: View {
    @Environment(\.dismiss) var dismiss
    let phoneNumber: String
    @State private var selectedType = "Robocall"
    @State private var description = ""
    
    let scamTypes = ["Robocall", "IRS Scam", "Tech Support", "Lottery", "Banking Fraud", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Scam Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(scamTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Description (Optional)")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section {
                    Button("Submit Report") {
                        submitReport()
                    }
                }
            }
            .navigationTitle("Report Scam")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func submitReport() {
        // TODO: Submit to Firebase
        dismiss()
    }
}

// MARK: - Preview
#Preview {
    ResultView(result: PhoneNumberResult(
        phoneNumber: "+1 (561) 555-0123",
        scamScore: 92,
        location: "West Palm Beach, FL",
        carrier: "Unknown VOIP",
        lineType: "VOIP",
        redFlags: [
            "VOIP number (commonly used for scams)",
            "347 community reports in last 30 days",
            "Associated with IRS scam campaign"
        ],
        reportCount: 347,
        isScam: true
    ))
}
