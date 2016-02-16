//
//  PreviewManager.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 16/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import QuickLook

class PreviewManager: NSObject, QLPreviewControllerDataSource {
    
    var filePath: NSURL?
    
    func previewViewControllerForFile(file: FBFile, fromNavigation: Bool) -> UIViewController {
        
        if file.type == .PLIST || file.type == .JSON{
            let webviewPreviewViewContoller = WebviewPreviewViewContoller(nibName: "WebviewPreviewViewContoller", bundle: NSBundle(forClass: WebviewPreviewViewContoller.self))
            webviewPreviewViewContoller.file = file
            return webviewPreviewViewContoller
        }
        else {
            let previewTransitionViewController = PreviewTransitionViewController(nibName: "PreviewTransitionViewController", bundle: NSBundle(forClass: PreviewTransitionViewController.self))
            previewTransitionViewController.quickLookPreviewController.dataSource = self

            self.filePath = file.filePath
            if fromNavigation == true {
                return previewTransitionViewController.quickLookPreviewController
            }
            return previewTransitionViewController
        }
    }
    
    
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
    
}
