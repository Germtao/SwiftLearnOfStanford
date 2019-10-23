//
//  Utilities.swift
//  EmojiArt
//
//  Created by TT on 2019/10/20.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

class ImageFetcher {
    
    var backup: UIImage? {
        didSet {
            callHandlerIfNeed()
        }
    }
    
    func fetch(_ url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url.imageURL) {
                if self != nil {
                    // 可以在主线程上创建UIImage
                    if let image = UIImage(data: data) {
                        self?.handler(url, image)
                    } else {
                        self?.fetchFailed = true
                    }
                } else {
                    print("ImageFetcher: fetch returned but I've left the heap -- ignoring result.")
                }
            } else {
                self?.fetchFailed = true
            }
        }
    }
    
    init(fetch url: URL, handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
        fetch(url)
    }
    
    init(handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
    }
    
    private let handler: (URL, UIImage) -> Void
    
    private var fetchFailed = false {
        didSet {
            callHandlerIfNeed()
        }
    }
    
    private func callHandlerIfNeed() {
        if fetchFailed, let image = backup,
            let url = image.storeLocallyAsJPEG(named: String(Date().timeIntervalSinceReferenceDate)) {
            handler(url, image)
        }
    }
    
}

extension URL {
    var imageURL: URL {
        if let url = UIImage.urlToStoreLocallyAsJPEG(named: self.path) {
            return url
        } else {
            // 检查是否有嵌入式imgurl
            for query in query?.components(separatedBy: "&") ?? [] {
                let queryComponents = query.components(separatedBy: "=")
                if queryComponents.count == 2 {
                    if queryComponents[0] == "imgurl",
                        let url = URL(string: queryComponents[1].removingPercentEncoding ?? "") {
                        return url
                    }
                }
            }
            
            return self.baseURL ?? self
        }
    }
}

extension UIImage {
    
    private static let localImagesDirectory = "UIImage.storeLocallyAsJPEG"
    
    static func urlToStoreLocallyAsJPEG(named: String) -> URL? {
        var name = named
        let pathComponents = named.components(separatedBy: "/")
        if pathComponents.count > 1 {
            if pathComponents[pathComponents.count - 2] == localImagesDirectory {
                name = pathComponents.last!
            } else {
                return nil
            }
        }
        
        if var url = FileManager.default.urls(for: .applicationSupportDirectory,
                                              in: .userDomainMask).first {
            url = url.appendingPathComponent(localImagesDirectory)
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                url = url.appendingPathComponent(name)
                if url.pathExtension != "jpg" {
                    url = url.appendingPathExtension("jpg")
                }
                return url
            } catch let error {
                print("UIImage.urlToStoreLocallyAsJPEG \(error)")
            }
        }
        
        return nil
    }
    
    func storeLocallyAsJPEG(named name: String) -> URL? {
        if let imageData = self.jpegData(compressionQuality: 1.0) {
            if let url = UIImage.urlToStoreLocallyAsJPEG(named: name) {
                do {
                    try imageData.write(to: url)
                    return url
                } catch let error {
                    print("UIImage.storeLocallyAsJPEG \(error)")
                }
            }
        }
        return nil
    }
    
    func scaled(by factor: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * factor, height: size.height * factor)
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: .zero, size: newSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension String {
    func madeUnique(withRespectTo otherStrings: [String]) -> String {
        var possiblyUnique = self
        var uniqueNumber = 1
        while otherStrings.contains(possiblyUnique) {
            possiblyUnique = self + "\(uniqueNumber)"
            uniqueNumber += 1
        }
        return possiblyUnique
    }
}
