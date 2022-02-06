//
//  HomeView.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 31/01/2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var settingsVM = SettingsVM()
    @StateObject private var hashtagsVM = HashtagsVM()
    @StateObject private var mapVM = MapVM()
    @StateObject private var placeVM = PlaceVM(place: Place(),image: UIImage(imageLiteralResourceName: "globe"))
    var body: some View {
        UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.95)
        return TabView{
            TrendsView(hashtagsVM: hashtagsVM)
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis.circle")
                    Text("Trends")
                }
            MapView(mapVM: mapVM, placeVM: placeVM)
                .tabItem{
                    Image(systemName: "map.circle")
                    Text("Map")
                }
            SettingsView(settingsVM: settingsVM)
                .tabItem{
                    Image(systemName: "gear.circle")
                    Text("Settings")
                }
        }.background(Color.pink)
    }
}


