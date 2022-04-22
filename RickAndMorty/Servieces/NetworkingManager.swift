//
//  NetworkingManager.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 12.03.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(from url: String?, with complition: @escaping (RickAndMorty) -> Void) {
        guard let stringURL = url else {return}
        guard let url = URL(string: stringURL) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let rickAndMorty = try JSONDecoder().decode(RickAndMorty.self, from: data)
                DispatchQueue.main.async {
                    complition(rickAndMorty)
                }
            } catch let error {
                print(error)
            }

        }.resume()
    }
    
    func fetchEpisode(from url: String, with complition: @escaping (Result<Episode,Error>) -> Void) {
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let episode = try JSONDecoder().decode(Episode.self, from: data)
                DispatchQueue.main.async {
                    complition(.success(episode))
                }
            } catch let error {
                complition(.failure(error))
            }
        }.resume()
    }
    
    func fetchCharacter(from url: String, with complition: @escaping (Result<Results, Error>) -> Void) {
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let character = try JSONDecoder().decode(Results.self, from: data)
                DispatchQueue.main.async {
                    sleep(4)

                    complition(.success(character))
                }
            } catch let error {
                complition(.failure(error))
            }

        }.resume()
    }
    
}

class ImageManager {
    
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping(Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response else {
                print(error?.localizedDescription ?? "No error discription")
                return
            }
            
            guard url == response.url else { return }
            
            DispatchQueue.main.async {
                completion(data, response)
            }
        }.resume()
    }
}
