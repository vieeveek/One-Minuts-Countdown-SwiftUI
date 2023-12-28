//
//  TimerViewModel.swift
//  CountdownMeter
//
//  Created by Vieeveek Singh on 28/12/23.
//

import UserNotifications
import UIKit
import Combine
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var seconds: Int = 60
    @Published var tenths: Int = 0
    @Published var isRunning = false

    private var timerCancellable: AnyCancellable?
    private var backgroundTaskID: UIBackgroundTaskIdentifier?

    init() {
        // Set up a timer to handle timer events
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.handleTimerEvent()
            }
    }

    deinit {
        // Cleanup: Cancel the timer and end the background task
        timerCancellable?.cancel()
        endBackgroundTask()
    }

    // Toggle the timer between running and paused
    func toggleTimer() {
        if isRunning {
            // If running, pause the timer and end the background task
            isRunning = false
            endBackgroundTask()
        } else {
            // If paused, start the timer and begin a background task
            isRunning = true
            if seconds == 0, tenths == 0 {
                // If timer is at 0, restart the timer
                restartTimer()
            }
            startBackgroundTask()
        }
    }

    // Restart the timer
    func restartTimer() {
        isRunning = false
        seconds = 60
        tenths = 0
    }

    // Handle timer events
    private func handleTimerEvent() {
        guard isRunning else { return }

        let remainingTenths = seconds * 10 + tenths
        let newRemainingTenths = remainingTenths - 1

        // Update seconds and tenths based on new remaining tenths
        seconds = newRemainingTenths / 10
        tenths = newRemainingTenths % 10

        if seconds == 0, tenths == 0 {
            // If timer reaches 0, toggle the timer and trigger a notification
            isRunning.toggle()
            Notify()
        }
    }

    // Display a notification
    private func Notify() {
        let content = UNMutableNotificationContent()
        content.title = "Countdown"
        content.body = "Timer Is Completed Successfully In Background !!!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }

    // Begin a background task
    private func startBackgroundTask() {
        backgroundTaskID = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
    }

    // End the background task
    private func endBackgroundTask() {
        if let backgroundTaskID = backgroundTaskID {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            self.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }
}
