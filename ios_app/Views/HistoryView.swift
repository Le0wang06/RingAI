//
//  HistoryView.swift
//  ScamShield
//
//  View checked number history with enhanced UX
//

import SwiftUI

struct HistoryView: View {
    @State private var searchText = ""
    @State private var history: [CallLog] = []
    @State private var filterType: FilterType = .all
    @State private var isLoading = false
    @State private var sortOrder: SortOrder = .dateDescending
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case scams = "Scams"
        case safe = "Safe"
    }
    
    enum SortOrder: String, CaseIterable {
        case dateDescending = "Newest First"
        case dateAscending = "Oldest First"
        case scoreDescending = "Highest Score"
        case scoreAscending = "Lowest Score"
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
        
        // Apply sort
        switch sortOrder {
        case .dateDescending:
            filtered.sort { $0.checkedAt > $1.checkedAt }
        case .dateAscending:
            filtered.sort { $0.checkedAt < $1.checkedAt }
        case .scoreDescending:
            filtered.sort { $0.scamScore > $1.scamScore }
        case .scoreAscending:
            filtered.sort { $0.scamScore < $1.scamScore }
        }
        
        return filtered
    }
    
    var groupedHistory: [(String, [CallLog])] {
        let calendar = Calendar.current
        let now = Date()
        
        var grouped: [String: [CallLog]] = [:]
        
        for log in filteredHistory {
            let section: String
            if calendar.isDateInToday(log.checkedAt) {
                section = "Today"
            } else if calendar.isDateInYesterday(log.checkedAt) {
                section = "Yesterday"
            } else if calendar.isDate(log.checkedAt, equalTo: now, toGranularity: .weekOfYear) {
                section = "This Week"
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM yyyy"
                section = formatter.string(from: log.checkedAt)
            }
            
            if grouped[section] == nil {
                grouped[section] = []
            }
            grouped[section]?.append(log)
        }
        
        let order = ["Today", "Yesterday", "This Week"]
        return grouped.sorted { first, second in
            if let firstIndex = order.firstIndex(of: first.key),
               let secondIndex = order.firstIndex(of: second.key) {
                return firstIndex < secondIndex
            } else if order.contains(first.key) {
                return true
            } else if order.contains(second.key) {
                return false
            } else {
                return first.key > second.key
            }
        }
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
                                action: { 
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        filterType = type
                                    }
                                    // Haptic feedback
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color(.systemBackground))
                
                // History List
                if isLoading {
                    LoadingHistoryView()
                } else if filteredHistory.isEmpty {
                    EmptyHistoryView(searchText: searchText, filterType: filterType)
                } else {
                    List {
                        ForEach(groupedHistory, id: \.0) { section, logs in
                            Section(header: Text(section)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .textCase(nil)
                            ) {
                                ForEach(logs) { log in
                                    HistoryRowView(log: log)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                                withAnimation {
                                                    deleteLog(log)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                shareNumber(log)
                                            } label: {
                                                Label("Share", systemImage: "square.and.arrow.up")
                                            }
                                            .tint(.blue)
                                        }
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity)
                                        ))
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .refreshable {
                        await refreshHistory()
                    }
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: filterType)
            .navigationTitle("History")
            .searchable(text: $searchText, prompt: "Search phone numbers")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Sort By", selection: $sortOrder) {
                            ForEach(SortOrder.allCases, id: \.self) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                
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
        isLoading = true
        // TODO: Load from database
        // Placeholder: Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Placeholder data for now
            history = []
            isLoading = false
        }
    }
    
    private func refreshHistory() async {
        // Haptic feedback for refresh
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // TODO: Reload from database
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            loadHistory()
        }
    }
    
    private func deleteLog(_ log: CallLog) {
        // Haptic feedback for delete
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // TODO: Delete from database
        history.removeAll { $0.id == log.id }
    }
    
    private func clearHistory() {
        // Haptic feedback for clear
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
        
        // TODO: Clear database
        withAnimation {
            history.removeAll()
        }
    }
    
    private func exportHistory() {
        // TODO: Export to CSV
    }
    
    private func shareNumber(_ log: CallLog) {
        // TODO: Share functionality
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
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
                .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

// MARK: - History Row
struct HistoryRowView: View {
    let log: CallLog
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Status Icon with animation
            ZStack {
                Circle()
                    .fill(log.isScam ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: log.isScam ? "exclamationmark.triangle.fill" : "checkmark.shield.fill")
                    .font(.title3)
                    .foregroundColor(log.isScam ? .red : .green)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(log.phoneNumber)
                    .font(.body)
                    .fontWeight(.semibold)
                
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption2)
                    Text(log.location ?? "Unknown Location")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Score and Date
            VStack(alignment: .trailing, spacing: 4) {
                // Score badge
                Text("\(log.scamScore)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(log.isScam ? Color.red : Color.green)
                    )
                
                Text(log.formattedDate)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Empty History View
struct EmptyHistoryView: View {
    let searchText: String
    let filterType: HistoryView.FilterType
    @State private var animateIcon = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Animated icon
            Image(systemName: searchText.isEmpty ? "clock.arrow.circlepath" : "magnifyingglass")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.5))
                .rotationEffect(.degrees(animateIcon ? 360 : 0))
                .animation(
                    searchText.isEmpty ? 
                        Animation.linear(duration: 2).repeatForever(autoreverses: false) : 
                        .default,
                    value: animateIcon
                )
            
            VStack(spacing: 8) {
                Text(emptyStateTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(emptyStateMessage)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animateIcon = true
        }
    }
    
    var emptyStateTitle: String {
        if !searchText.isEmpty {
            return "No Results Found"
        }
        switch filterType {
        case .all:
            return "No History Yet"
        case .scams:
            return "No Scams Found"
        case .safe:
            return "No Safe Numbers"
        }
    }
    
    var emptyStateMessage: String {
        if !searchText.isEmpty {
            return "Try adjusting your search or filters"
        }
        switch filterType {
        case .all:
            return "Check phone numbers to see them here"
        case .scams:
            return "Great! No scam calls detected yet"
        case .safe:
            return "No safe numbers have been checked"
        }
    }
}

// MARK: - Loading View
struct LoadingHistoryView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle())
            
            Text("Loading history...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
#Preview {
    HistoryView()
}
