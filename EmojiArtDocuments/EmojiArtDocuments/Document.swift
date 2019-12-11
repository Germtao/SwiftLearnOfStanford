//
//  Document.swift
//  EmojiArtDocuments
//
//  Created by QDSG on 2019/12/11.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

