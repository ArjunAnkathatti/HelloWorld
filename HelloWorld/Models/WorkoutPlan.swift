//
//  WorkoutPlan.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//
import Foundation

/// Represents a workout plan consisting of multiple exercises.
struct WorkoutPlan: Identifiable, Codable {
    let id: UUID          // Unique identifier for each workout plan
    var name: String      // Name of the workout plan (e.g., "Full Body Workout")
    var date: Date        // Date the workout plan is created or scheduled
    var exercises: [Exercise] // List of exercises in the workout plan
    var isCompleted: Bool // Tracks if the workout plan has been completed
    var notes: String?    // Optional notes about the workout plan (e.g., "Focus on form")

    /// Initializes a new workout plan.
    init(
        name: String,
        date: Date = Date(),
        exercises: [Exercise] = [],
        isCompleted: Bool = false,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.exercises = exercises
        self.isCompleted = isCompleted
        self.notes = notes
    }

    /// Returns the total number of exercises in the plan.
    var totalExercises: Int {
        exercises.count
    }

    /// Returns the total volume of the workout plan (sum of all weights * reps).
    var totalVolume: Double {
        exercises.reduce(0) { $0 + ($1.weight * Double($1.reps) * Double($1.sets)) }
    }

    /// Returns the estimated workout duration in seconds.
    /// - Assumes 45 seconds per set + the rest time between sets.
    var estimatedDuration: TimeInterval {
        exercises.reduce(0) { total, exercise in
            let timePerSet = 45.0 // Approximate duration (in seconds) for one set
            let exerciseDuration = (timePerSet * Double(exercise.sets)) +
                                   (exercise.restTime * Double(exercise.sets - 1)) // Rest time between sets
            return total + exerciseDuration
        }
    }

    /// Returns the estimated workout duration as a formatted string (e.g., "1 hr 15 min").
    var formattedEstimatedDuration: String {
        let duration = Int(estimatedDuration)
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        if hours > 0 {
            return "\(hours) hr \(minutes) min"
        } else {
            return "\(minutes) min"
        }
    }
}

#if DEBUG
// Sample data for preview and testing.
extension WorkoutPlan {
    static let sampleWorkoutPlans: [WorkoutPlan] = [
        WorkoutPlan(
            name: "Upper Body Strength",
            date: Date(),
            exercises: [
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
                )
            ],
            isCompleted: true,
            notes: "Focus on upper body pushing and pulling movements."
        ),
        WorkoutPlan(
            name: "Leg Day",
            date: Date().addingTimeInterval(-10),
            exercises: [
                Exercise(
                    name: "Squat",
                    sets: 4,
                    reps: 10,
                    weight: 80.0,
                    restTime: 90,
                    musclesTargeted: ["Quads", "Glutes", "Core"],
                    notes: "Keep chest up and maintain depth."
                ),
                Exercise(
                    name: "Romanian Deadlift",
                    sets: 4,
                    reps: 12,
                    weight: 60.0,
                    restTime: 60,
                    musclesTargeted: ["Hamstrings", "Glutes"],
                    notes: "Keep bar close to shins."
                )
            ],
            isCompleted: false,
            notes: "Focus on building lower body strength."
        )
    ]
}
#endif

