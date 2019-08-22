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
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
//    private let imageView: UIImageView
//
//    init(imageView: UIImageView) {
//        self.imageView = imageView
//    }

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
        guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first,
            let fileName = urlString.split(separator: "/").last else { return nil }
        
        return cacheDir.appendingPathComponent(CachePhotoService.pathName + "/" + fileName).path
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
    
    private func loadPhoto(with urlString: String, for indexPath: IndexPath, for imageView: UIImageView) -> UIImage {
        let noimage: UIImage = UIImage(named: "noimage")!
        var image = UIImage(named: "downloading")!
        guard let request = URL(string: urlString) else { return noimage }
        
        let semaphore = DispatchSemaphore(value: 15)
        DispatchQueue.main.async {
            semaphore.wait()
            URLSession.shared.dataTask(with: request) { [weak self] data, response , error in
                guard let self = self,
                    let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200,
                    let data = data, error == nil,
                    let newImage = UIImage(data: data)
                    else { return }
                
                self.images[urlString] = newImage
                self.saveImageToCache(urlString: urlString, image: newImage)
                DispatchQueue.main.async {
//                    self.tableView.reloadRows(at: [indexPath], with: .none)
//                    imageView.setNeedsDisplay()
//                    imageView.setNeedsLayout()
                    imageView.image = newImage
//                    self.tableView.setNeedsDisplay()
//                    self.tableView.setNeedsLayout()
//                    imageView.reloadInputViews()
                }
                semaphore.signal()
                
                image = newImage
                }.resume()
        }
        return image
    }
    
    private func setImageAfterDownload(_ imageView: UIImageView) {
        
    }


    //MARK: - Public API
    
    public func getPhoto(with urlString: String, for indexPath: IndexPath, for imageView: UIImageView) -> UIImage {
        
        //TODO: - Refactor
        if let image = images[urlString] {
//            print("💾 FIND IN DICTIONARY")
            return image
        } else if let image = getImageFromCache(urlString: urlString) {
//            print("💾 FIND IN CACHE")
            return image
        } else {
            let image = loadPhoto(with: urlString, for: indexPath, for: imageView)
//            print("💾 MAYBE LOADED")  
            return image
        }
    }
}
