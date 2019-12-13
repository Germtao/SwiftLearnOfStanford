//
//  DocumentBrowserViewController.swift
//  EmojiArtDocuments
//
//  Created by QDSG on 2019/12/11.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController {
    
    var template: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            template = try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("Untitled.json")
            if template != nil {
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
            }
        }
    }
    
    // MARK: Document Presentation
    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentVc = storyBoard.instantiateViewController(withIdentifier: "DocumentMVC")
        if let emojiVc = documentVc.contents as? EmojiArtViewController {
            emojiVc.document = EmojiArtDocument(fileURL: documentURL)
        }
        present(documentVc, animated: true)
    }
}

// MARK: UIDocumentBrowserViewControllerDelegate
extension DocumentBrowserViewController: UIDocumentBrowserViewControllerDelegate {
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        // 设置新文档的URL, 可以在调用importHandler之前显示一个模板选择器
        // 即使用户取消了创建请求, 也请确保始终调用importHandler
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // 为选择的第一个文档提供文档视图控制器
        // 如果支持选择多个项目, 请确保全部处理
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // 为新创建的文档提供文档视图控制器
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // 确保正确处理失败的导入, 例如: 向用户显示错误消息
    }
}

