//
//  WorkoutPlanViewModel.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import Foundation

/// ViewModel for managing workout plans.
class WorkoutPlanViewModel: ObservableObject {
    private let storageKey = "WorkoutPlans"         // Key for saving to UserDefaults
    
    // MARK: - Published Properties
    @Published var workoutPlans: [WorkoutPlan] = [] // List of all workout plans
    @Published var selectedWorkoutPlan: WorkoutPlan? // Currently selected workout plan
    
    // MARK: - Initialization
    init() {
        loadWorkoutPlans()
    }

    // MARK: - Methods

    /// Adds a new workout plan to the list.
    /// - Parameter plan: The new workout plan to add.
    func addWorkoutPlan(_ plan: WorkoutPlan) {
        workoutPlans.append(plan)
        saveWorkoutPlans()
    }

    /// Updates an existing workout plan.
    /// - Parameters:
    ///   - id: The unique identifier of the workout plan to update.
    ///   - updatedPlan: The updated workout plan data.
    func updateWorkoutPlan(id: UUID, with updatedPlan: WorkoutPlan) {
        if let index = workoutPlans.firstIndex(where: { $0.id == id }) {
            workoutPlans[index] = updatedPlan
            saveWorkoutPlans()
        }
    }

    /// Deletes a workout plan from the list.
    /// - Parameter id: The unique identifier of the workout plan to delete.
    func deleteWorkoutPlan(id: UUID) {
        workoutPlans.removeAll { $0.id == id }
        saveWorkoutPlans()
    }

    /// Retrieves a workout plan by its unique identifier.
    /// - Parameter id: The unique identifier of the workout plan.
    /// - Returns: The matching `WorkoutPlan` or `nil` if not found.
    func getWorkoutPlan(by id: UUID) -> WorkoutPlan? {
        return workoutPlans.first(where: { $0.id == id })
    }

    /// Adds an exercise to a specific workout plan.
    /// - Parameters:
    ///   - planId: The unique identifier of the workout plan.
    ///   - exercise: The exercise to add.
    func addExercise(to planId: UUID, exercise: Exercise) {
        if let index = workoutPlans.firstIndex(where: { $0.id == planId }) {
            workoutPlans[index].exercises.append(exercise)
        }
    }

    /// Deletes an exercise from a specific workout plan.
    /// - Parameters:
    ///   - planId: The unique identifier of the workout plan.
    ///   - exerciseId: The unique identifier of the exercise to delete.
    func deleteExercise(from planId: UUID, exerciseId: UUID) {
        if let planIndex = workoutPlans.firstIndex(where: { $0.id == planId }) {
            workoutPlans[planIndex].exercises.removeAll { $0.id == exerciseId }
        }
    }

    /// Calculates the total volume of all workout plans.
    /// - Returns: The total workout volume across all plans.
    func calculateTotalVolume() -> Double {
        workoutPlans.reduce(0) { total, plan in
            total + plan.totalVolume
        }
    }

    func getAllWorkoutPlans(sortedByDate: Bool = false, showOnlyIncomplete: Bool = false) -> [WorkoutPlan] {
        var filteredPlans = workoutPlans

        // Filter incomplete plans if needed
        if showOnlyIncomplete {
            filteredPlans = filteredPlans.filter { !$0.isCompleted }
        }

        // Sort by date if needed
        if sortedByDate {
            filteredPlans = filteredPlans.sorted(by: { $0.date < $1.date })
        }

        return filteredPlans
    }
    
    // MARK: - Persistence

    /// Saves the workout plans to UserDefaults.
    private func saveWorkoutPlans() {
        if let encodedData = try? JSONEncoder().encode(workoutPlans) {
            UserDefaults.standard.set(encodedData, forKey: storageKey)
        }
    }

    /// Loads the workout plans from UserDefaults.
    private func loadWorkoutPlans() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decodedPlans = try? JSONDecoder().decode([WorkoutPlan].self, from: savedData) {
            workoutPlans = decodedPlans
        } else {
            // If no saved data, load sample data for testing
            #if DEBUG
            loadSampleWorkoutPlans()
            #endif
        }
    }

    /// Loads sample workout plans for testing or preview purposes.
    func loadSampleWorkoutPlans() {
        workoutPlans = WorkoutPlan.sampleWorkoutPlans
    }

    /// Clears all workout plans.
    func clearAllWorkoutPlans() {
        workoutPlans.removeAll()
        saveWorkoutPlans()
    }
}
