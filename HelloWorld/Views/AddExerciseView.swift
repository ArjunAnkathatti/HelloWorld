//
//  AddExerciseView.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import SwiftUI

struct AddExerciseView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss            // Dismiss the sheet
    @State private var name: String = ""           // Name of the exercise
    @State private var sets: Int = 3               // Number of sets
    @State private var reps: Int = 10              // Number of reps
    @State private var weight: Double = 0.0        // Weight to lift
    @State private var restTime: TimeInterval = 60 // Rest time in seconds
    @State private var musclesTargeted: String = "" // Targeted muscles (comma-separated)
    @State private var showError = false           // Error state for invalid inputs

    var onSave: (Exercise) -> Void                 // Callback to save the new exercise

    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                // Section for Exercise Name
                Section(header: Text("Exercise Name")) {
                    TextField("Enter name", text: $name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }

                // Section for Exercise Details
                Section(header: Text("Details")) {
                    Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                    Stepper("Reps: \(reps)", value: $reps, in: 1...50)
                    Stepper("Weight: \(weight, specifier: "%.1f") kg", value: $weight, in: 0...300, step: 2.5)
                    Stepper("Rest Time: \(Int(restTime)) sec", value: $restTime, in: 10...300, step: 10)
                }

                // Section for Muscles Targeted
                Section(header: Text("Muscles Targeted (Optional)")) {
                    TextField("Enter muscles (comma-separated)", text: $musclesTargeted)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            .navigationTitle("Add Exercise")
            .toolbar {
                // Save Button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExercise()
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
                      message: Text("Please enter a name for the exercise."),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Helper Functions

    /// Validates and saves the new exercise.
    private func saveExercise() {
        guard !name.isEmpty else {
            showError = true
            return
        }

        let muscleArray = musclesTargeted
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        let newExercise = Exercise(
            name: name,
            sets: sets,
            reps: reps,
            weight: weight,
            restTime: restTime,
            musclesTargeted: muscleArray,
            notes: nil
        )

        onSave(newExercise)
        dismiss()
    }
}

// MARK: - Preview

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView { newExercise in
            print("Exercise Saved: \(newExercise)")
        }
    }
}
