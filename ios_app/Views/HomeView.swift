//
//  HomeView.swift
//  ScamShield
//
//  Main home screen with quick stats and lookup
//

import SwiftUI

struct HomeView: View {
    @State private var showingLookup = false
    @State private var stats = UserStats(numbersChecked: 0, scamsBlocked: 0, timeSaved: 0)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "shield.checkered")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("ScamShield")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("AI-Powered Scam Detection")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    
                    // Main Check Button
                    Button(action: {
                        showingLookup = true
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                            Text("Check Phone Number")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Stats Cards
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            StatCard(
                                icon: "checkmark.shield",
                                title: "Numbers Checked",
                                value: "\(stats.numbersChecked)",
                                color: .blue
                            )
                            
                            StatCard(
                                icon: "exclamationmark.triangle",
                                title: "Scams Blocked",
                                value: "\(stats.scamsBlocked)",
                                color: .red
                            )
                        }
                        
                        StatCard(
                            icon: "clock",
                            title: "Time Saved",
                            value: "\(stats.timeSaved) min",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    // Quick Tips
                    QuickTipsCard()
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showingLookup) {
                LookupView()
            }
            .onAppear {
                loadStats()
            }
        }
    }
    
    private func loadStats() {
        // TODO: Load actual stats from database
        // For now, using placeholder data
        stats = UserStats(numbersChecked: 0, scamsBlocked: 0, timeSaved: 0)
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Quick Tips Card
struct QuickTipsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow)
                Text("Quick Tips")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                TipRow(text: "Check unknown numbers before answering")
                TipRow(text: "Report scams to help the community")
                TipRow(text: "VOIP numbers are often used in scams")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TipRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .foregroundColor(.gray)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - User Stats Model
struct UserStats {
    var numbersChecked: Int
    var scamsBlocked: Int
    var timeSaved: Int
}

// MARK: - Preview
#Preview {
    HomeView()
}
