//
//  SettingsView.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 31/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @FetchRequest(sortDescriptors: []) var coreFiles: FetchedResults<Place>
    @ObservedObject var settingsVM: SettingsVM
    var body: some View {
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemFont(ofSize: 30), .foregroundColor: UIColor(Color.accentColor)]
        UITableView.appearance().backgroundColor = .clear
        return NavigationView {
            ZStack{
                Color("DarkGrey").edgesIgnoringSafeArea(.all)
                VStack{
                    List{
                        Section(header: Text("CoreData edit")){
                            Button(action: {settingsVM.unlockDevice()}, label: {Label("Delete all locations", systemImage: "trash")})
                                .disabled(coreFiles.count <= 1)
                        }
                    }
                }
            }.navigationBarTitle(Text("Settings"), displayMode: .inline)
                .alert(isPresented: $settingsVM.showAlert){
                    Alert(title: Text("Could not unlock device"), message: Text("Unlock your device in order to delete all locations."), dismissButton: .default(Text("OK")))
            }
        }
    }
}


