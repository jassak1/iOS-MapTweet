//
//  MapView.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 31/01/2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    @FetchRequest(sortDescriptors: []) var coreFiles: FetchedResults<Place>
    @ObservedObject var mapVM: MapVM
    @ObservedObject var placeVM: PlaceVM
    var body: some View {
        ZStack{
            Map(coordinateRegion: $mapVM.mapRegion, annotationItems: coreFiles){item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)){
                    if (item.country != "World"){
                        VStack(spacing: 2){
                            HStack{
                                Text("\(item.cityU)")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Button(action: {placeVM.place = item; placeVM.image = UIImage(data: item.imageU) ?? UIImage(imageLiteralResourceName: "globe"); mapVM.showSheet = true; placeVM.networkCall(latitude: item.latitude, longitude: item.longitude)}, label: {Image(systemName: "info.circle.fill")})
                            }.padding(5).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 10))
                                .scaleEffect((CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude) == mapVM.selectedPin) ? 1 : 0)
                            Image(systemName: "mappin")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                                .padding(5)
                                .background(Color.black.opacity(0.7))
                                .clipShape(Capsule())
                                .foregroundColor(.accentColor)
                                .font(.title)
                                .onTapGesture {
                                    mapVM.selectedPin = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                                }
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.all)
            Circle().fill().foregroundColor(.black).scaleEffect(mapVM.scaleSize).frame(width: 30, height: 30)
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        mapVM.addNotation.toggle()
                        mapVM.spinEffect()
                    },
                           label: {Image(systemName: mapVM.topIcon())
                            .font(.headline)
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                        .clipShape(Circle())}).rotationEffect(.degrees(mapVM.rotDegrees))
                }.padding(.trailing,10)
                Spacer()
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        mapVM.newLocation()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(15)
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }).scaleEffect(mapVM.scaleSize)
                }.padding(10)
            }
        }.alert(isPresented: $mapVM.showAlert){
            Alert(title: Text("No internet connection"), message: Text("Enable Wi-Fi or Cellular data in order to add new location."), dismissButton: .default(Text("OK"), action: {mapVM.addNotation = false; mapVM.spinEffect()}))
        }
        .sheet(isPresented: $mapVM.showSheet){
            PlaceView(place: placeVM)
        }
    }
    init(mapVM: MapVM, placeVM: PlaceVM) {
        self.mapVM = mapVM
        self.placeVM = placeVM
        UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
    }
}


