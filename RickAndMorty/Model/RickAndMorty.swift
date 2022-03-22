//
//  RickAndMorty.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 11.03.2022.
//

import Foundation

struct RickAndMorty: Decodable {
    let info: Info
    let  results: [Results]
}

struct Info: Decodable {
    let pages: Int
    let next: String?
    let prev: String?
}

struct Results: Decodable {
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: Origin
    let location: Origin
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    var description: String {
        """
        Name: \(name)
        Status:\(status)
        Species:"\(species)
        Gender:"\(gender)
        Origin:"\(origin.name)
        Location:"\(location.name)
        """
    }
}

struct Origin: Decodable {
    let name: String
}

struct Episode: Decodable {
    let name: String
    let date: String
    let episode: String
    let characters: [String]
    
    var description: String {
        """
        episode: \(name)
        date:\(date)
        """
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case date = "air_date"
        case episode = "episode"
        case characters = "characters"
    }
}

enum URLS: String {
    case rickandmortyapi = "https://rickandmortyapi.com/api/character"
}
