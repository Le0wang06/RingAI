//
//  HistoryView.swift
//  ScamShield
//
//  View checked number history
//

import SwiftUI

struct HistoryView: View {
    @State private var searchText = ""
    @State private var history: [CallLog] = []
    @State private var filterType: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case scams = "Scams"
        case safe = "Safe"
    }
    
    var filteredHistory: [CallLog] {
        var filtered = history
        
        // Apply filter
        switch filterType {
        case .all:
            break
        case .scams:
            filtered = filtered.filter { $0.isScam }
        case .safe:
            filtered = filtered.filter { !$0.isScam }
        }
        
        // Apply search
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.phoneNumber.contains(searchText) }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(FilterType.allCases, id: \.self) { type in
                            FilterPill(
                                title: type.rawValue,
                                isSelected: filterType == type,
                                action: { filterType = type }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color(.systemBackground))
                
                // History List
                if filteredHistory.isEmpty {
                    EmptyHistoryView()
                } else {
                    List {
                        ForEach(filteredHistory) { log in
                            HistoryRowView(log: log)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        deleteLog(log)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("History")
            .searchable(text: $searchText, prompt: "Search phone numbers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: exportHistory) {
                            Label("Export", systemImage: "square.and.arrow.up")
                        }
                        Button(role: .destructive, action: clearHistory) {
                            Label("Clear All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .onAppear {
                loadHistory()
            }
        }
    }
    
    // MARK: - Functions
    private func loadHistory() {
        // TODO: Load from database
        // Placeholder data for now
        history = []
    }
    
    private func deleteLog(_ log: CallLog) {
        // TODO: Delete from database
        history.removeAll { $0.id == log.id }
    }
    
    private func clearHistory() {
        // TODO: Clear database
        history.removeAll()
    }
    
    private func exportHistory() {
        // TODO: Export to CSV
    }
}

// MARK: - Filter Pill
struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// MARK: - History Row
struct HistoryRowView: View {
    let log: CallLog
    
    var body: some View {
        HStack(spacing: 12) {
            // Status Icon
            Image(systemName: log.isScam ? "exclamationmark.triangle.fill" : "checkmark.shield.fill")
                .font(.title2)
                .foregroundColor(log.isScam ? .red : .green)
                .frame(width: 32)
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(log.phoneNumber)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(log.location ?? "Unknown Location")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Score and Date
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(log.scamScore)")
                    .font(.headline)
                    .foregroundColor(log.isScam ? .red : .green)
                
                Text(log.formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Empty History View
struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No History Yet")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Check phone numbers to see them here")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
#Preview {
    HistoryView()
}
