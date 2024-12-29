//
//  NotificationManager.swift
//  HelloWorld
//
//  Created by Arjun Ankathatti Chandrashekara on 12/28/24.
//

import Foundation
import UserNotifications

/// Manages all notification-related functionality in the app.
class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    // MARK: - Request Authorization

    /// Requests notification permissions from the user.
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            } else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    // MARK: - Scheduling Notifications

    /// Schedules notifications for a workout plan's exercises.
    /// - Parameter plan: The workout plan for which notifications should be scheduled.
    func scheduleWorkoutNotifications(for plan: WorkoutPlan) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests() // Clear previous notifications

        var currentTime = Date() // Start scheduling from the current time

        for (index, exercise) in plan.exercises.enumerated() {
            let totalDuration = calculateExerciseDuration(exercise: exercise)

            // Notification content
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Exercise \(index + 1): \(exercise.name)"
            let formattedWeight = String(format: "%.1f", exercise.weight)
            notificationContent.body = """
            Do \(exercise.sets) sets of \(exercise.reps) reps at \(formattedWeight) kg. \
            Rest for \(Int(exercise.restTime)) seconds after each set.
            """
            
            notificationContent.sound = .default

            // Schedule time for this notification
            let triggerDate = Calendar.current.date(byAdding: .second, value: Int(totalDuration), to: currentTime) ?? currentTime
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate),
                repeats: false
            )

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)

            // Add notification request
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error)")
                }
            }

            // Update current time for the next exercise
            currentTime = triggerDate
        }
    }

    // MARK: - Helper Functions

    /// Calculates the total duration for an exercise (including rest).
    /// - Parameter exercise: The exercise for which the duration is calculated.
    /// - Returns: The total time in seconds for all sets and rest periods of the exercise.
    private func calculateExerciseDuration(exercise: Exercise) -> TimeInterval {
        let timePerSet = 45.0 // Assume each set takes 45 seconds
        let totalSetTime = timePerSet * Double(exercise.sets) // Total time spent doing sets
        let totalRestTime = exercise.restTime * Double(exercise.sets - 1) // Rest time between sets
        //return totalSetTime + totalRestTime
        return 5.0
    }

    /// Prints all pending notification requests (for debugging purposes).
    func printPendingNotifications() {
        print("Printing notifications from the notification manager")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("Pending Notification: \(request.identifier) -> \(request.content.title)")
            }
        }
    }

    /// Removes all pending notifications.
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All notifications canceled.")
    }
}
