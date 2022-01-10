//
//  PhotoLayoutProvider.swift
//  Instagrid
//
//  Created by Yann Rouzaud on 07/01/2022.


import Foundation

enum PhotoButtonPlace: CaseIterable {
    case top, bottom
}
struct PhotoLayout {
    let numberOfPhotosOnTop: Int
    let numberOfPhotosOnBottom: Int
}

struct PhotoLayoutProvider {
    static let shared = PhotoLayoutProvider()
    
    let photoLayouts: [PhotoLayout] = [
        .init(numberOfPhotosOnTop: 1, numberOfPhotosOnBottom: 2),
        .init(numberOfPhotosOnTop: 2, numberOfPhotosOnBottom: 1),
        .init(numberOfPhotosOnTop: 2, numberOfPhotosOnBottom: 2)
    ]
}

