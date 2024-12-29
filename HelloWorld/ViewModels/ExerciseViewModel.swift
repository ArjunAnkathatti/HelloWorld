//
//  ExerciseViewModel.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import Foundation

/// ViewModel for managing operations related to exercises.
class ExerciseViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var exercises: [Exercise] = [] // List of exercises in the workout plan
    @Published var selectedExercise: Exercise? // The currently selected exercise for editing

    // MARK: - Methods

    /// Adds a new exercise to the list.
    /// - Parameter exercise: The new exercise to add.
    func addExercise(_ exercise: Exercise) {
        exercises.append(exercise)
    }

    /// Updates an existing exercise in the list.
    /// - Parameters:
    ///   - id: The unique identifier of the exercise to update.
    ///   - updatedExercise: The updated exercise data.
    func updateExercise(id: UUID, with updatedExercise: Exercise) {
        if let index = exercises.firstIndex(where: { $0.id == id }) {
            exercises[index] = updatedExercise
        }
    }

    /// Deletes an exercise from the list.
    /// - Parameter id: The unique identifier of the exercise to delete.
    func deleteExercise(id: UUID) {
        exercises.removeAll { $0.id == id }
    }

    /// Fetches an exercise by its unique identifier.
    /// - Parameter id: The unique identifier of the exercise.
    /// - Returns: The matching `Exercise` or `nil` if not found.
    func getExercise(by id: UUID) -> Exercise? {
        return exercises.first(where: { $0.id == id })
    }

    /// Calculates the total volume of all exercises.
    /// - Returns: The total workout volume (sum of weight * reps * sets).
    func calculateTotalVolume() -> Double {
        exercises.reduce(0) { $0 + ($1.weight * Double($1.reps) * Double($1.sets)) }
    }

    /// Calculates the total estimated duration of all exercises.
    /// - Returns: The total duration in seconds.
    /// - Assumes 45 seconds per set + rest time between sets.
    func calculateEstimatedDuration() -> TimeInterval {
        exercises.reduce(0) { total, exercise in
            let timePerSet = 45.0
            let exerciseDuration = (timePerSet * Double(exercise.sets)) +
                                   (exercise.restTime * Double(exercise.sets - 1)) // Rest time between sets
            return total + exerciseDuration
        }
    }

    /// Clears all exercises from the list.
    func clearAllExercises() {
        exercises.removeAll()
    }

    /// Sample data for testing and previews.
    func loadSampleExercises() {
        exercises = [
            Exercise(
                name: "Bench Press",
                sets: 3,
                reps: 10,
                weight: 70.0,
                restTime: 60,
                musclesTargeted: ["Chest", "Triceps", "Shoulders"],
                notes: "Control the bar on the eccentric phase."
            ),
            Exercise(
                name: "Pull-ups",
                sets: 3,
                reps: 8,
                weight: 0.0, // Bodyweight
                restTime: 90,
                musclesTargeted: ["Back", "Biceps"],
                notes: "Focus on full range of motion."
            ),
            Exercise(
                name: "Squat",
                sets: 4,
                reps: 10,
                weight: 80.0,
                restTime: 90,
                musclesTargeted: ["Quads", "Glutes", "Core"],
                notes: "Maintain proper form."
            )
        ]
    }
}
