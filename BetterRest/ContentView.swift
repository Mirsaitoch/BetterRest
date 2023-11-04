//
//  ContentView.swift
//  BetterRest
//
//  Created by Мирсаит Сабирзянов on 01.11.2023.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State var wakeUpDate = defaultSleepTime
    @State var sleepAmount = 8.0
    @State var cupsOfCoffee = 0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    private var sleepTime: Date{
        var totalTime = Date.now
        do {
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpDate)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let prediction = try model.prediction(wake: Int64((hour + minute)), estimatedSleep: sleepAmount, coffee: Int64((cupsOfCoffee)))
            totalTime = wakeUpDate - prediction.actualSleep
        } catch {
            print("error!")
        }
        return totalTime
    }
    
    static var defaultSleepTime: Date {
        var components = DateComponents()
        components.hour = 8
        components.minute = 30
        return Calendar.current.date(from: components) ?? .now}
    
    var body: some View {
        NavigationStack{
            Form{
                VStack(alignment: .leading, spacing: 10) {
                    Text("When do you want to wake up?")
                    DatePicker("Wake up", selection: $wakeUpDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Desired amount of sleep")
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...15, step: 0.5)
                }
                VStack(alignment: .leading, spacing: 10) {
                    
                    Picker("Cups of coffee: ", selection: $cupsOfCoffee){
                        ForEach(0..<21){
                            Text("\($0)")
                        }
                    }
                }
                Section{
                    Text("Recommended time to sleep: \(sleepTime.formatted(date: .omitted, time: .shortened))")
                }
            }
            .navigationTitle("BetterRest")
            
        }
    }
}

#Preview {
    ContentView()
}
