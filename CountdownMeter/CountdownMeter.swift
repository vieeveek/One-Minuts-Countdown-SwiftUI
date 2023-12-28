//
//  CountdownMeter.swift
//  CountdownMeter
//
//  Created by Vieeveek Singh on 28/12/23.
// 

import SwiftUI

@main
struct CountdownMeter: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var viewModel = TimerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
