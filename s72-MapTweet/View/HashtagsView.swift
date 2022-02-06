//
//  HashtagsView.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 05/02/2022.
//

import SwiftUI

struct HashtagsView: View {
    @ObservedObject var hashtagsVM: HashtagsVM
    var place: Place
    var body: some View {
        UITableView.appearance().backgroundColor = .clear
        return ZStack{
            Color("DarkGrey").edgesIgnoringSafeArea(.all)
            switch hashtagsVM.shownView{
            case .success:
                VStack{
                    GeometryReader{geo in
                        VStack{
                            ScrollView(.vertical, showsIndicators: false){
                                LazyVGrid(columns: [GridItem(spacing: 5),GridItem(spacing: 5)]){
                                    ForEach(0..<10){item in
                                        VStack{
                                            Text("\(hashtagsVM.hashtagsVM[item].name)")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .frame(width: geo.size.width/3, height: geo.size.width/3)
                                                .background(LinearGradient(colors: [Color("DarkBlue"), Color("DarkGreen")], startPoint: .topTrailing, endPoint: .bottomLeading))
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .onTapGesture {
                                                    hashtagsVM.showSheet = true
                                                    hashtagsVM.selectedHT = (hashtagsVM.hashtagsVM[item].name)
                                                }
                                        }.padding()
                                    }
                                }
                            }
                        }
                    }
                }
            case .loading:
                ProgressView()
            case .error:
                VStack{
                    Spacer()
                    VStack{
                        Text("Network error")
                            .font(.title)
                        Text("Please check you internet connection")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }.padding().background(Color.black).clipShape(RoundedRectangle(cornerRadius: 10)).padding(20)
                }
            }
        }.toolbar{
            ToolbarItem(placement: .principal){
                VStack{
                    Text("\(place.countryU)")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                    Text("\(place.cityU)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .actionSheet(isPresented: $hashtagsVM.showSheet){
            ActionSheet(title: Text("Hashtag info"), buttons: [
                .default(Text("Copty hasthag to clipboard"), action: {UIPasteboard.general.string = hashtagsVM.selectedHT}),
                .destructive(Text("Cancel"))
            ])
        }
        .onAppear{
            hashtagsVM.networkCall(woeid: Int(place.woeid))
        }
        .onDisappear{
            hashtagsVM.shownView = .loading
        }
    }
    init(hashtagsVM: HashtagsVM, place: Place){
        self.hashtagsVM = hashtagsVM
        self.place = place
    }
}

