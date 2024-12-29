//
//  HelloWorldApp.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import SwiftUI

@main
struct HelloWorldApp: App {
    @StateObject private var workoutPlanViewModel = WorkoutPlanViewModel()
    
    var body: some Scene {
        WindowGroup {
            WorkoutPlanListView()
                .environmentObject(workoutPlanViewModel)
        }
    }
}
