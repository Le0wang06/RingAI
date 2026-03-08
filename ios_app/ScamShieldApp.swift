//
//  ScamShieldApp.swift
//  ScamShield
//
//  Main app entry point
//

import SwiftUI
import Firebase

@main
struct ScamShieldApp: App {
    
    // Initialize Firebase on app launch
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Content View (Root)
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home/Lookup Tab
            HomeView()
                .tabItem {
                    Label("Lookup", systemImage: "magnifyingglass")
                }
                .tag(0)
            
            // History Tab
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(1)
            
            // Community Tab
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3")
                }
                .tag(2)
            
            // Settings Tab (optional)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

// MARK: - Settings View (Basic)
struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("1")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Support")) {
                    Button("Report a Bug") {
                        // TODO: Implement bug reporting
                    }
                    
                    Button("Send Feedback") {
                        // TODO: Implement feedback
                    }
                }
                
                Section(header: Text("Legal")) {
                    Button("Privacy Policy") {
                        // TODO: Show privacy policy
                    }
                    
                    Button("Terms of Service") {
                        // TODO: Show terms
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
