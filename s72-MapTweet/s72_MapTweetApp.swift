//
//  s72_MapTweetApp.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 31/01/2022.
//

import SwiftUI

@main
struct s72_MapTweetApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreController.moc.viewContext)
        }
    }
}
