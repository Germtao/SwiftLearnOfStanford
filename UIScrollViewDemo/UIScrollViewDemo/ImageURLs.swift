//
//  ImageURLs.swift
//  UIScrollViewDemo
//
//  Created by QDSG on 2019/10/17.
//  Copyright © 2019 unitTao. All rights reserved.
//

import Foundation

struct ImageURLs {
    static let stanford = Bundle.main.url(forResource: "oval", withExtension: "jpg")
//    static let stanford = URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/55/Stanford_Oval_September_2013_panorama.jpg")
    
    static var NASA: [String: URL] = {
        let NASAURLStrings = [
            "Cassini": "http://dingyue.ws.126.net/G6uxuOVNXMDgKY6tLEbHnTGIKuhc0bqQediTcWZIbCLBk1526450617692.jpg",
            "Earth": "http://wx2.sinaimg.cn/large/593d9f8fly1fzzh4k929pj21xg0trhc7.jpg",
            "Saturn": "http://hbimg.b0.upaiyun.com/dd7502afc6d61b2de2acd81d9036b82ac76224f845340-WbI7YI_fw658"
        ]
        
        var urls = [String: URL]()
        for (key, value) in NASAURLStrings {
            urls[key] = URL(string: value)
        }
        
        return urls
    }()
}
