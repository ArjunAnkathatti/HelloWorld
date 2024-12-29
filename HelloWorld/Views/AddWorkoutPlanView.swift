//
//  AddWorkoutPlanView.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import SwiftUI

struct AddWorkoutPlanView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss            // Dismiss the sheet
    @State private var name: String = ""           // Name of the workout plan
    @State private var notes: String = ""          // Optional notes for the workout plan
    @State private var showError = false           // Error state for invalid inputs

    var onSave: (WorkoutPlan) -> Void              // Callback to save the new workout plan

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                // Section for Workout Plan Name
                Section(header: Text("Workout Plan Name")) {
                    TextField("Enter name", text: $name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }

                // Section for Notes
                Section(header: Text("Notes (Optional)")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .foregroundColor(.secondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            .navigationTitle("Add Workout Plan")
            .toolbar {
                // Save Button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWorkoutPlan()
                    }
                    .disabled(name.isEmpty) // Disable if name is empty
                }

                // Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Invalid Input"),
                      message: Text("Please enter a name for the workout plan."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Helper Functions

    /// Validates and saves the new workout plan.
    private func saveWorkoutPlan() {
        guard !name.isEmpty else {
            showError = true
            return
        }

        let newPlan = WorkoutPlan(name: name, notes: notes.isEmpty ? nil : notes)
        onSave(newPlan)
        dismiss()
    }
}

