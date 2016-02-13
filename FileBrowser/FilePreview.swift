//
//  FilePreview.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 13/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import QuickLook

class PreviewManager: NSObject, QLPreviewControllerDataSource {
    
    var filePath: NSURL?
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        let item = PreviewItem()
        if let filePath = filePath {
            item.filePath = filePath
        }
        return item
    }
    
}

class PreviewItem: NSObject, QLPreviewItem {
    
    var filePath: NSURL?
    
    internal var previewItemURL: NSURL {
        if let filePath = filePath {
            return filePath
        }
        return NSURL()
    }
    
    internal var previewItemTitle: String?
    
}
