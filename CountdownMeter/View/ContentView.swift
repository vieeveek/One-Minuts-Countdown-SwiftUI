//
//  ContentView.swift
//  CountdownMeter
//
//  Created by Vieeveek Singh on 28/12/23.
//
import SwiftUI
import UserNotifications
import Combine

struct ContentView: View {
    // StateObject is a property wrapper that creates an observable object for this view.
    @StateObject private var viewModel = TimerViewModel()
    
    // body is the main body of the view, defining its structure and content.
    var body: some View {
        ZStack {
            // Background color for the entire view.
            Color.black.opacity(0.06).edgesIgnoringSafeArea(.all)
            
            VStack {
                // Countdown Timer Display
                ZStack {
                    // Outer circle for styling.
                    Circle()
                        .trim(from: 0, to: 1)
                        .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 280, height: 280)
                    
                    // Inner circle representing the countdown progress.
                    Circle()
                        .trim(from: 0, to: calculateTrim())
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 35, lineCap: .round))
                        .frame(width: 280, height: 280)
                        .rotationEffect(.init(degrees: -90))
                    
                    // Text displaying the timer value.
                    VStack {
                        Text(String(format: "%02d:%02d", viewModel.seconds, viewModel.tenths))
                            .font(.system(size: 65))
                            .fontWeight(.bold)
                        
                        // Title indicating "Countdown".
                        Text("Countdown")
                            .font(.title)
                            .padding(.top)
                    }
                }
                
                // Buttons for controlling the timer.
                HStack(spacing: 20) {
                    // Start/Pause Button
                    Button(action: {
                        viewModel.toggleTimer()
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                                .foregroundColor(.white)
                            Text(viewModel.isRunning ? "Pause" : "Start")
                                .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .shadow(radius: 6)
                    }
                    
                    // Reset Button
                    Button(action: {
                        viewModel.restartTimer()
                    }) {
                        HStack(spacing: 15) {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.red)
                            Text("Reset")
                                .foregroundColor(.red)
                        }
                        .padding(.vertical)
                        .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                        .background(
                            Capsule()
                                .stroke(Color.red, lineWidth: 2)
                        )
                        .shadow(radius: 6)
                    }
                }
                .padding(.top, 55)
            }
        }
        // Code that runs when the view appears.
        .onAppear {
            // Requesting user authorization for notifications.
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in }
        }
    }
    
    // Function to calculate the trim value for the inner circle based on the timer progress.
    private func calculateTrim() -> CGFloat {
        let totalTenths = 600
        let remainingTenths = viewModel.seconds * 10 + viewModel.tenths
        return CGFloat(remainingTenths) / CGFloat(totalTenths)
    }
}

// PreviewProvider for displaying the ContentView in the Xcode preview.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
