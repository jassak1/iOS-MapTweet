//
//  PlaceView.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 04/02/2022.
//

import SwiftUI

struct PlaceView: View {
    @Environment(\.presentationMode) var hideSheet
    @ObservedObject var place: PlaceVM
    var body: some View {
        UINavigationBar.appearance().backgroundColor = .black.withAlphaComponent(0.3)
        UITableView.appearance().backgroundColor = .clear
        return NavigationView{
            ZStack{
                Color("DarkGrey").edgesIgnoringSafeArea(.all)
                VStack{
                    Divider()
                    Spacer()
                }
                VStack{
                    List{
                        Section(header: Text("Closest location with trending topics")){
                            VStack(alignment: .leading){
                                Text("Country: \(place.placeVM.country)")
                                Text("City: \(place.placeVM.name)")
                            }.redacted(reason: place.isLoading ? .placeholder : [])
                        }
                        Section(header: Text("Location image")){
                            HStack {
                                Spacer()
                                Image(uiImage: place.image)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        place.showSheet = true
                                    }
                                Spacer()
                            }
                        }
                    }.listStyle(.insetGrouped).foregroundColor(.white)
                }
            }.navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {hideSheet.wrappedValue.dismiss(); place.removeLocation()}, label: {Image(systemName: "trash")})
                    }
                    ToolbarItem(placement: .principal){
                        VStack{
                            Text("\(place.place.countryU)")
                                .font(.title)
                            Text("\(place.place.cityU)")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                    ToolbarItem{
                        Button(action: {
                            if place.noConnection{
                                place.showAlert = true
                            } else{
                                place.saveLocation()
                                hideSheet.wrappedValue.dismiss()
                            }
                        }, label: {Image(systemName: "internaldrive")})
                    }
                }.foregroundColor(.accentColor).font(.headline)
                .alert(isPresented: $place.showAlert){
                    Alert(title: Text("No internet connection"), message: Text("Enable Wi-Fi or Cellular data in order to save data."), dismissButton: .default(Text("OK"),action: {hideSheet.wrappedValue.dismiss()}))}
                .sheet(isPresented: $place.showSheet){
                    GalleryView(placeVM: place)
                }
                .onDisappear{
                    place.isLoading = true
                    UINavigationBar.appearance().backgroundColor = .clear
                }
        }
    }
    init(place: PlaceVM){
        self.place = place
    }
}

