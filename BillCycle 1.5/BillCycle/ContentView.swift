//
//  ContentView.swift
//  BillCycle
//
//  Created by Tiberiu on 12.02.2021.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @FetchRequest(entity: Bill.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Bill.status, ascending: false),
    ])
    var bills: FetchedResults<Bill>
    
    var predicate: NSPredicate {
        switch filterNum {
        case 1:
            return NSPredicate(format: "status == %@", "Paid")
        case 2:
            return NSPredicate(format: "status == %@", "Unpaid")
        default:
            return NSPredicate(format: "status CONTAINS[c] %@", "pai")
        }
    }
    
    var filterButtonName: String {
        switch filterNum {
        case 1:
            return "Unpaid"
        case 2:
            return "All"
        default:
            return "Paid"
        }
    }
    
    @State private var showingAuthAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var filterNum = 3
    @StateObject var settings = Settings()
    
    var body: some View {
        
        VStack {
            if settings.isUnlocked {
                FilterView(predicate: predicate, filterNum: $filterNum, filterButtonName: filterButtonName)
                    .environmentObject(settings)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                        if settings.isEnabled {
                            settings.isUnlocked = false
                            }
                        }
            } else {
                VStack {
                    Button("Unlock") {
                        authenticate()
                    }
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    .alert(isPresented: $showingAuthAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }

                    
                    
                }
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Please authenticate yourself to unlock your bills."
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { succes, authenticationError in
                
                DispatchQueue.main.async {
                    if succes {
                        settings.isUnlocked = true
                    } else {
                        //error
                        alertTitle = "Locked"
                        alertMessage = "Could not read your biometrics"
                        showingAuthAlert = true
                    }
                }
            }
        } 
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Settings: ObservableObject {
    @Published var isUnlocked = true
    @Published var isEnabled = false {
        didSet {
            if isEnabled {
                isUnlocked = false
            }
            
            let encoder = JSONEncoder()
            if let encodedSetting = try? encoder.encode(isEnabled) {
                UserDefaults.standard.setValue(encodedSetting, forKey: "isEnabled")
            } else {
                print("Unable to save setting.")
            }
        }
    }
    
    init() {
        if let isEnabled = UserDefaults.standard.data(forKey: "isEnabled") {
            let decoder = JSONDecoder()
            if let decodedSetting = try? decoder.decode(Bool.self, from: isEnabled) {
                self.isEnabled = decodedSetting
            } else {
                print("Unable to load setting")
            }
        }
    }
}
