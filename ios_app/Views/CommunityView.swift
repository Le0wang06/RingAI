//
//  CommunityView.swift
//  ScamShield
//
//  View community scam reports
//

import SwiftUI

struct CommunityView: View {
    @State private var reports: [CommunityReport] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading reports...")
                } else if reports.isEmpty {
                    EmptyCommunityView()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Stats Header
                            CommunityStatsView()
                                .padding(.horizontal)
                            
                            // Recent Reports
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Recent Scam Reports")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                LazyVStack(spacing: 12) {
                                    ForEach(reports) { report in
                                        CommunityReportCard(report: report)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Community")
            .refreshable {
                await loadReports()
            }
            .onAppear {
                Task {
                    await loadReports()
                }
            }
        }
    }
    
    // MARK: - Load Reports
    private func loadReports() async {
        isLoading = true
        
        // TODO: Load from Firebase
        // Placeholder for now
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        reports = []
        isLoading = false
    }
}

// MARK: - Community Stats View
struct CommunityStatsView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                CommunityStatCard(
                    icon: "exclamationmark.triangle",
                    value: "10,247",
                    label: "Total Reports",
                    color: .red
                )
                
                CommunityStatCard(
                    icon: "person.3",
                    value: "1,832",
                    label: "Contributors",
                    color: .blue
                )
            }
            
            CommunityStatCard(
                icon: "chart.line.uptrend.xyaxis",
                value: "247",
                label: "Reports Today",
                color: .orange
            )
        }
    }
}

struct CommunityStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Community Report Card
struct CommunityReportCard: View {
    let report: CommunityReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(.gray)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("User \(report.reporterId)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(report.formattedDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Scam Type Badge
                Text(report.scamType)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red.opacity(0.2))
                    .foregroundColor(.red)
                    .cornerRadius(8)
            }
            
            // Phone Number
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.blue)
                Text(report.phoneNumber)
                    .font(.body)
                    .fontWeight(.semibold)
            }
            
            // Description
            if !report.description.isEmpty {
                Text(report.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            // Actions
            HStack(spacing: 16) {
                Button(action: {}) {
                    Label("Verify", systemImage: "checkmark.circle")
                        .font(.caption)
                }
                
                Button(action: {}) {
                    Label("Block", systemImage: "nosign")
                        .font(.caption)
                }
                
                Spacer()
                
                Text("\(report.verifications) verified")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Empty Community View
struct EmptyCommunityView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Reports Yet")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Be the first to report a scam!")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
#Preview {
    CommunityView()
}
