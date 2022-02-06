//
//  GalleryView.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 05/02/2022.
//

import SwiftUI

struct GalleryView: View {
    @ObservedObject var placeVM: PlaceVM
    var body: some View {
        ZStack{
            GalleryVC(placeVM: placeVM)
        }
    }
}

