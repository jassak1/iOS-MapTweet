//
//  SettingsVM.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 06/02/2022.
//

import Foundation
import LocalAuthentication
import CoreData

class SettingsVM: ObservableObject{
    var coreFiles = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
    var moc = CoreController.moc.viewContext
    @Published var showAlert = false
    
    @MainActor
    func unlockDevice(){
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {return print(error!)}
        Task{
            do{
                try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "MapTweet would like to use TouchID")
                removeAll()
            } catch{
                DispatchQueue.main.async {
                    self.showAlert = true
                }
            }
        }
    }
    
    func removeAll(){
        let coreResults = try? moc.fetch(coreFiles) as? [Place]
        for (index, element) in coreResults!.enumerated(){
            if index != 0{
                moc.delete(element)
            }
        }
        try? moc.save()
    }
    
}
