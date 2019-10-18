//
//  ViewController.swift
//  UIScrollViewDemo
//
//  Created by QDSG on 2019/10/17.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1 / 25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var imageView = UIImageView()
    
    var imageURL: URL? {
        didSet {
            imageView.image = nil
            if view.window != nil { // 确保在窗口中
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size
            activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if imageURL == nil {
//            imageURL = ImageURLs.stanford
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    func fetchImage() {
        if let url = imageURL {
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in // self不要自身管理生命周期
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents, url == self?.imageURL {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

