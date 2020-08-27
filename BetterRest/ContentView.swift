//
//  ContentView.swift
//  BetterRest
//
//  Created by Rafael Calunga on 2020-08-22.
//  Copyright © 2020 Rafael Calunga. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var idealBedTime: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formater = DateFormatter()
            formater.timeStyle = .short
            
            return formater.string(from: sleepTime)
        } catch {
            return "Error"
        }
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header: Text("WHEN DO YOU WANT TO WAKE UP?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section(header: Text("DESIRED AMOUNT OF SLEEP")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("DAILY COFFEE INTAKE")) {
                    Stepper(value: $coffeeAmount, in: 1...20) {
                        if coffeeAmount == 1 {
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                    /*Picker("Cups of cofee", selection: $coffeeAmount) {
                        ForEach(0..<21) {
                            Text("\($0) \($0 <= 1 ? "cup" : "cups")")
                        }.navigationBarTitle("Cups of cofee")
                    }*/
                    .navigationBarTitle("BetterRest")
                }
                
                Section(header: Text("IDEAL BEDTIME")) {
                    Text(idealBedTime)
                        .font(.largeTitle)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        .foregroundColor(.purple)
                }
            }
            .navigationBarTitle("BetterRest")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
