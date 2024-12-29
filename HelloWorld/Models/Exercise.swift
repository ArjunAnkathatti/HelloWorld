//
//  Exercise.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import Foundation

/// Represents a single exercise in a workout plan.
struct Exercise: Identifiable, Codable {
    let id: UUID          // Unique identifier for each exercise
    var name: String      // Name of the exercise (e.g., "Bench Press")
    var sets: Int         // Number of sets
    var reps: Int         // Number of reps per set
    var weight: Double    // Weight to lift (e.g., in kg or lbs)
    var restTime: TimeInterval // Rest time between sets (in seconds)
    var musclesTargeted: [String] // List of muscles this exercise targets
    var notes: String?    // Optional notes about the exercise (e.g., "Focus on form")

    /// Initializes a new exercise.
    init(
        name: String,
        sets: Int,
        reps: Int,
        weight: Double,
        restTime: TimeInterval,
        musclesTargeted: [String],
        notes: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.sets = sets
        self.reps = reps
        self.weight = weight
        self.restTime = restTime
        self.musclesTargeted = musclesTargeted
        self.notes = notes
    }
}

#if DEBUG
// Sample data for preview and testing.
extension Exercise {
    static let sampleExercises: [Exercise] = [
        Exercise(
            name: "Bench Press",
            sets: 3,
            reps: 10,
            weight: 70.0,
            restTime: 60,
            musclesTargeted: ["Chest", "Triceps", "Shoulders"],
            notes: "Keep elbows at 45 degrees."
        ),
        Exercise(
            name: "Deadlift",
            sets: 4,
            reps: 8,
            weight: 120.0,
            restTime: 90,
            musclesTargeted: ["Back", "Hamstrings", "Glutes"],
            notes: "Maintain a flat back throughout."
        ),
        Exercise(
            name: "Squat",
            sets: 4,
            reps: 10,
            weight: 80.0,
            restTime: 90,
            musclesTargeted: ["Quads", "Glutes", "Core"],
            notes: "Break parallel with hips."
        )
    ]
}
#endif

