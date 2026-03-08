//
//  LookupView.swift
//  ScamShield
//
//  Number lookup screen - main feature
//

import SwiftUI

struct LookupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var phoneNumber = ""
    @State private var isLoading = false
    @State private var showingResult = false
    @State private var result: PhoneNumberResult?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "phone.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Check Any Number")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Enter a phone number to check if it's safe")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // Phone Number Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone Number")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.gray)
                        
                        TextField("+1 (555) 123-4567", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .font(.body)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Check Button
                Button(action: checkNumber) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "checkmark.shield")
                            Text("Check Number")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(phoneNumber.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(phoneNumber.isEmpty || isLoading)
                .padding(.horizontal)
                
                // Error Message
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Examples
                VStack(alignment: .leading, spacing: 12) {
                    Text("Try these examples:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ExampleNumberButton(number: "+1 (561) 555-0123", label: "Known Scam") {
                        phoneNumber = "+1 (561) 555-0123"
                    }
                    
                    ExampleNumberButton(number: "+1 (555) 123-4567", label: "Test Number") {
                        phoneNumber = "+1 (555) 123-4567"
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationTitle("Check Number")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingResult) {
                if let result = result {
                    ResultView(result: result)
                }
            }
        }
    }
    
    // MARK: - Check Number Function
    private func checkNumber() {
        // Clear previous error
        errorMessage = nil
        
        // Validate phone number
        let formatted = formatPhoneNumber(phoneNumber)
        if formatted.isEmpty {
            errorMessage = "Please enter a valid phone number"
            return
        }
        
        // Start loading
        isLoading = true
        
        // Call API service
        Task {
            do {
                let apiResult = try await APIService.shared.checkNumber(formatted)
                
                // Update UI on main thread
                await MainActor.run {
                    self.result = apiResult
                    self.isLoading = false
                    self.showingResult = true
                }
            } catch {
                // Handle error
                await MainActor.run {
                    self.errorMessage = "Failed to check number. Please try again."
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Format Phone Number
    private func formatPhoneNumber(_ number: String) -> String {
        // Remove all non-numeric characters except +
        let cleaned = number.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        
        // Basic validation
        if cleaned.count < 10 {
            return ""
        }
        
        return cleaned
    }
}

// MARK: - Example Number Button
struct ExampleNumberButton: View {
    let number: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(number)
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "arrow.right.circle")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

// MARK: - Preview
#Preview {
    LookupView()
}
