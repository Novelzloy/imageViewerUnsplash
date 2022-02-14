//
//  Model.swift
//  imageViewerUnsplash
//
//  Created by Роман on 07.02.2022.
//

import Foundation

struct Images: Codable{
    let results:[Result]
}

struct Result: Codable{
    let id: String
    let urls: URLS
}

struct URLS: Codable{
    let full: String
    let small: String
}
