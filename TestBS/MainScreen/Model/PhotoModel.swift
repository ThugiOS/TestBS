//
//  AppDelegate.swift
//  TestBS
//
//  Created by Никитин Артем on 25.09.23.
//

import Foundation

struct PhotoTypeDtoOut: Decodable {
    let content: [PhotoDtoOut]
    let page: Int
    let totalPages: Int
    
    struct PhotoDtoOut: Decodable {
        let id: Int
        let name: String
        let image: String?
    }
}

struct PhotoUploadDtoOut: Decodable {
    let id: String
}



