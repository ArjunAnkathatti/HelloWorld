//
//  WorkoutPlanListView.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import SwiftUI

struct WorkoutPlanListView: View {
    // MARK: - State & ViewModel
    @StateObject private var viewModel = WorkoutPlanViewModel() // Manages workout plans
    @State private var showOnlyIncomplete = false               // Filter: Show only incomplete plans
    @State private var sortByDate = false                       // Filter: Sort plans by date
    @State private var isAddingNewPlan = false                  // State for add new plan sheet

    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                // Fetch workout plans based on filters
                let workoutPlans = viewModel.getAllWorkoutPlans(
                    sortedByDate: sortByDate,
                    showOnlyIncomplete: showOnlyIncomplete
                )

                // List of workout plans
                if workoutPlans.isEmpty {
                    Text("No workout plans available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(workoutPlans) { plan in
                            NavigationLink(destination: WorkoutPlanDetailView(viewModel: viewModel, plan: plan)) {
                                VStack(alignment: .leading) {
                                    Text(plan.name)
                                        .font(.headline)
                                    Text("Exercises: \(plan.totalExercises)")
                                        .font(.subheadline)
                                    Text("Estimated Duration: \(plan.formattedEstimatedDuration)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    if plan.isCompleted {
                                        Text("Status: Completed")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                viewModel.deleteWorkoutPlan(id: workoutPlans[index].id)
                            }
                        }
                    }
                }

                // Filter Toggles
                HStack {
                    Toggle("Show Only Incomplete", isOn: $showOnlyIncomplete)
                        .padding(.horizontal)
                    Toggle("Sort by Date", isOn: $sortByDate)
                        .padding(.horizontal)
                }

                // Add New Plan Button
                Button(action: { isAddingNewPlan = true }) {
                    Text("Add New Plan")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $isAddingNewPlan) {
                    AddWorkoutPlanView { newPlan in
                        viewModel.addWorkoutPlan(newPlan)
                    }
                }
            }
            .navigationTitle("Workout Plans")
            .onAppear {
                //viewModel.loadWorkoutPlan()
                //viewModel.loadSampleWorkoutPlans()
                NotificationManager.shared.requestAuthorization()
            }
        }
    }
}

