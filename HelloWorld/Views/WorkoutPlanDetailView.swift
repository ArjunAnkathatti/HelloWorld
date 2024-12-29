//
//  WorkoutPlanDetailView.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import SwiftUI

struct WorkoutPlanDetailView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: WorkoutPlanViewModel // ViewModel to manage workout plans
    var plan: WorkoutPlan                               // Selected workout plan
    @State private var isEditing = false                // State for editing the workout plan
    @State private var isAddingExercise = false         // State for adding a new exercise

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading) {
            // Plan Summary
            Text(plan.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            HStack {
                Text("Exercises: \(plan.totalExercises)")
                    .font(.headline)
                Spacer()
                Text("Estimated Duration: \(plan.formattedEstimatedDuration)")
                    .font(.headline)
            }
            .padding(.bottom)

            if plan.isCompleted {
                Text("Status: Completed")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("Status: Incomplete")
                    .font(.headline)
                    .foregroundColor(.red)
            }

            Divider()
                .padding(.vertical)

            // Exercises List
            Text("Exercises")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom)

            if plan.exercises.isEmpty {
                Text("No exercises added yet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(plan.exercises) { exercise in
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.headline)
                            Text("Sets: \(exercise.sets), Reps: \(exercise.reps), Weight: \(exercise.weight, specifier: "%.1f") kg")
                                .font(.subheadline)
                            Text("Rest Time: \(Int(exercise.restTime)) sec")
                                .font(.subheadline)
                            Text("Muscles: \(exercise.musclesTargeted.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.deleteExercise(from: plan.id, exerciseId: plan.exercises[index].id)
                        }
                    }
                }
            }

            Spacer()

            // Action Buttons
            HStack {
                Button(action: {
                    isAddingExercise = true
                }) {
                    Text("Add Exercise")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    isEditing = true
                }) {
                    Text("Edit Plan")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.vertical)
        }
        .padding()
        .sheet(isPresented: $isAddingExercise) {
            AddExerciseView { newExercise in
                viewModel.addExercise(to: plan.id, exercise: newExercise)
            }
        }
        .sheet(isPresented: $isEditing) {
            EditWorkoutPlanView(plan: plan) { updatedPlan in
                viewModel.updateWorkoutPlan(id: updatedPlan.id, with: updatedPlan)
            }
        }
        .onAppear() {
            print("scheduling notifications")
            NotificationManager.shared.scheduleWorkoutNotifications(for: plan)
        }
        .onDisappear() {
            NotificationManager.shared.printPendingNotifications()
            NotificationManager.shared.cancelAllNotifications()
        }
        
    }
}

