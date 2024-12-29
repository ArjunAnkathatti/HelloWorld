//
//  EditWorkoutPlanView.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import SwiftUI

struct EditWorkoutPlanView: View {
    // MARK: - Properties
    var plan: WorkoutPlan                      // Existing workout plan to edit
    var onSave: (WorkoutPlan) -> Void          // Callback to save the updated workout plan

    @Environment(\.dismiss) var dismiss        // Dismiss the sheet
    @State private var name: String            // Name of the workout plan
    @State private var notes: String           // Optional notes for the workout plan
    @State private var showError = false       // Error state for invalid inputs

    // MARK: - Initializer
    init(plan: WorkoutPlan, onSave: @escaping (WorkoutPlan) -> Void) {
        self.plan = plan
        self.onSave = onSave
        _name = State(initialValue: plan.name)
        _notes = State(initialValue: plan.notes ?? "")
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                // Section for Editing Plan Name
                Section(header: Text("Workout Plan Name")) {
                    TextField("Enter name", text: $name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }

                // Section for Editing Notes
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
            .navigationTitle("Edit Workout Plan")
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

    /// Validates and saves the updated workout plan.
    private func saveWorkoutPlan() {
        guard !name.isEmpty else {
            showError = true
            return
        }

        var updatedPlan = plan
        updatedPlan.name = name
        updatedPlan.notes = notes.isEmpty ? nil : notes

        onSave(updatedPlan)
        dismiss()
    }
}

// MARK: - Preview

struct EditWorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        // Example WorkoutPlan for preview
        let examplePlan = WorkoutPlan(name: "Sample Plan", notes: "Focus on strength training.")

        return EditWorkoutPlanView(plan: examplePlan) { updatedPlan in
            print("Updated Plan: \(updatedPlan)")
        }
    }
}
