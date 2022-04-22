//
//  CharacteImageView.swift
//  RickAndMorty
//
//  Created by Даниил Хантуров on 11.04.2022.
//

import UIKit

class CharacteImageView: UIImageView {
    func fetchImage(from url: String) {
        guard let imageUrl = URL(string: url) else {
            image = UIImage(named: "noPhoto")
            return
        }
        
        if let cachedImage = getCachedImage(from: imageUrl) {
            image = cachedImage
            return
        }
        
        ImageManager.shared.fetchImage(from: imageUrl) { data, response in
            self.image = UIImage(data: data)
            
            self.saveDataToCache(with: data, and: response)
        }
    }
    
    private func saveDataToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let request = URLRequest(url: url)
        let cachedUrlResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedUrlResponse, for: request)
    }
    
    private func getCachedImage(from url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        if let cachedUrlResponse = URLCache.shared.cachedResponse(for: request) {
            return UIImage(data: cachedUrlResponse.data)
        }
        return nil
    }
}


