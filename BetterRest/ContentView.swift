
//
//  ContentView.swift
//  BetterRest
//
//  Created by Krow on 10/16/24.
//
import CoreML

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static  var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When  do you want to wake up?") {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("When do you want to wake up?") {
                   
                        
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                Section("Desired amount of sleep") {
                    
                      
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                Section("Daily Coffee Intake") {
                   
                        
                    
                    Picker("Select number of cups",
                           selection: $coffeeAmount){
                        
                        ForEach(2..<21) {
                            Text("\($0) cups")
                        }
                    }
                    
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
                
            }
            
        }
    }
            
            func calculateBedTime() {
                do {
                    let config = MLModelConfiguration()
                    let model = try SleepCalculator(configuration: config)
                    
                    let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
                    let minute = (components.minute ?? 0) * 60
                    let hour = (components.hour ?? 0) * 60 * 60
                    
                    let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
                    
                    let sleepTime = wakeUp - prediction.actualSleep
                    alertTitle = "Your ideal bedtime is..."
                    alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
                } catch {
                    alertTitle = "Error"
                    alertMessage = "Sorry, there was a problem calculating your bedtime."
                
                }
                
                showingAlert = true
            }
    }


#Preview {
    ContentView()
}
