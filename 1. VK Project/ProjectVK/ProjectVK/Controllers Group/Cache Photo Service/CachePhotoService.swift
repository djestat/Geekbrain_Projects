//
//  CachePhotoService.swift
//  ProjectVK
//
//  Created by Igor on 29/07/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import UIKit

class CachePhotoService {
    
    private var images = [String: UIImage]()
    private let cacheLifeTime: TimeInterval = 60*60*24*7
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        
        let url = cacheDir.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private func getFilePath(urlString: String) -> String? {
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = String(describing: urlString.hashValue)
        
        return cacheDir.appendingPathComponent(CachePhotoService.pathName + "/" + hashName).path
    }
    
    private func saveImageToCache(urlString: String, image: UIImage) {
        guard let filename = getFilePath(urlString: urlString) else { return }
        
        let data = image.pngData()
        FileManager.default.createFile(atPath: filename, contents: data, attributes: nil)
    }
    
    private func getImageFromCache(urlString: String) -> UIImage? {
        guard let filename = getFilePath(urlString: urlString),
            let info = try? FileManager.default.attributesOfItem(atPath: filename),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }
        
        let lifetime = Date().timeIntervalSince(modificationDate)
        guard lifetime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: filename) else { return nil }
        DispatchQueue.main.async {
            self.images[urlString] = image
        }
        return image
    }
    /*
    private func loadPhoto(with urlString: String) -> Promise<UIImage> {
        guard let request = URL(string: urlString) else { return Promise(error: PMKError.badInput) }
        return URLSession.shared.dataTask(.promise, with: request)
            .map { [weak self] data, response in
                guard let self = self,
                    let newImage = UIImage(data: data) else { throw PMKError.badInput }
                
                DispatchQueue.main.async {
                    self.images[urlString] = newImage
                }
                self.saveImageToCache(urlString: urlString, image: newImage)
                return newImage
        }
    }*/
    
    private func loadPhoto2(with urlString: String) -> UIImage? {
        guard let request = URL(string: urlString) else { return nil }
        var image: UIImage? = nil
        URLSession.shared.dataTask(with: request) { [weak self] data, response , error in
            guard let self = self,
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let newImage = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async {
                self.images[urlString] = newImage
            }
            self.saveImageToCache(urlString: urlString, image: newImage)
            image = newImage
        }.resume()
        
        return image!
    }

    //MARK: - Public API
    /*
    public func photo(with urlString: String) -> Promise<UIImage> {
        
        //TODO: - Refactor
        return Promise<UIImage> { resolver in
            if let image = images[urlString] {
                resolver.fulfill(image)
            } else if let image = getImageFromCache(urlString: urlString) {
                resolver.fulfill(image)
            } else {
                loadPhoto(with: urlString).done { image in
                    resolver.fulfill(image)
                    }.catch{ error in
                        resolver.reject(error)
                }
            }
        }
    }*/
    
    public func photo2(with urlString: String) -> UIImage {
        
        //TODO: - Refactor
        var image: UIImage? = nil
        /*
        if let image = images[urlString] {
            resolver.fulfill(image)
        } else if let image = getImageFromCache(urlString: urlString) {
            resolver.fulfill(image)
        } else {
            loadPhoto2(with: urlString).done { image in
                resolver.fulfill(image)
                }.catch{ error in
                    resolver.reject(error)
            }
        }*/
        
        return image!
    }
}
