//
//  FileListPreview.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 13/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import QuickLook

extension FileListViewController: UIViewControllerPreviewingDelegate {
    
    //MARK: UIViewControllerPreviewingDelegate
    
    func registerFor3DTouch() {
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                registerForPreviewingWithDelegate(self, sourceView: tableView)
            }
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if #available(iOS 9.0, *) {
            if let indexPath = tableView.indexPathForRowAtPoint(location) {
                let selectedFile = fileForIndexPath(indexPath)
                previewingContext.sourceRect = tableView.rectForRowAtIndexPath(indexPath)
                if selectedFile.isDirectory == false {
                    return previewManager.previewViewControllerForFile(selectedFile)
                }
            }
        }
        return nil
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
    }
    
    
}

class PreviewManager: NSObject, QLPreviewControllerDataSource {
    
    var filePath: NSURL?
    
    func previewViewControllerForFile(file: FBFile) -> UIViewController {
        let quickLook = QLPreviewController()
        quickLook.dataSource = self
        self.filePath = file.filePath
        return quickLook
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


