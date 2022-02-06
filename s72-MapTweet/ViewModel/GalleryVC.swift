//
//  GalleryVC.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 04/02/2022.
//

import Foundation
import SwiftUI
import PhotosUI

struct GalleryVC: UIViewControllerRepresentable{
    @ObservedObject var placeVM: PlaceVM
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var pickerConfig = PHPickerConfiguration()
        pickerConfig.filter = .images
        let photoPicker = PHPickerViewController(configuration: pickerConfig)
        photoPicker.delegate = context.coordinator
        return photoPicker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        @ObservedObject var placeVM: PlaceVM
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else {return}
            if provider.canLoadObject(ofClass: UIImage.self){
                Task{
                    do{
                        placeVM.image = try await provider.asyncLoadObject(ofClass: UIImage.self) as? UIImage ?? UIImage(imageLiteralResourceName: "globe")
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        init(placeVM: PlaceVM){
            self.placeVM = placeVM
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(placeVM: placeVM)
    }
    
}
