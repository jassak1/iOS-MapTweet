//
//  TrendsView.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 31/01/2022.
//

import SwiftUI

struct TrendsView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var hashtagsVM: HashtagsVM
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Place.country, ascending: true)]) var coreFiles: FetchedResults<Place>
    var body: some View {
        //UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.systemFont(ofSize: 30), .foregroundColor: UIColor(Color.accentColor)]
        UITableView.appearance().backgroundColor = .clear
        return NavigationView{
            ZStack{
                Color("DarkGrey").edgesIgnoringSafeArea(.all)
                GeometryReader{geo in
                    List{
                        NavigationLink(destination: {HashtagsView(hashtagsVM: hashtagsVM, place: coreFiles[0])}, label: {LocationView(country: "World", image: Data(), geo: geo)})
                        ForEach(coreFiles){item in
                            if item.woeid > 1{
                                NavigationLink(destination: {HashtagsView(hashtagsVM: hashtagsVM, place: item)}, label: {LocationView(country: item.countryU, image:item.imageU, geo: geo)})
                            }
                        }.onDelete{
                            moc.delete(coreFiles[$0.first ?? 0])
                            try? moc.save()
                        }
                    }.listStyle(.insetGrouped)
                }
            }.navigationBarTitle(Text("Trending now"), displayMode: .inline)
        }
    }
}

struct LocationView: View{
    var country: String
    var image: Data
    var geo: GeometryProxy
    var body: some View{
        HStack(spacing: 10){
            Image(uiImage: UIImage(data: image) ?? UIImage(imageLiteralResourceName: "globe"))
                .resizable()
                .frame(width: geo.size.width/5, height: geo.size.width/5)
                .scaledToFit()
                .clipShape(Circle())
            VStack(alignment: .leading){
                Text("\(country)")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Discover what's happening")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

