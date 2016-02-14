//
//  FileListPreview.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 13/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import QuickLook

class PreviewManager: NSObject, QLPreviewControllerDataSource {
    
    var filePath: NSURL?
    
    func previewViewControllerForFile(file: File) -> UIViewController {
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
    
    internal var previewItemTitle: String?
}

extension FileListViewController: UIViewControllerPreviewingDelegate {
    
    func registerFor3DTouch() {
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                registerForPreviewingWithDelegate(self, sourceView: tableView)
            }
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = tableView.indexPathForRowAtPoint(location) {
            //This will show the cell clearly and blur the rest of the screen for our peek.
            if #available(iOS 9.0, *) {
                previewingContext.sourceRect = tableView.rectForRowAtIndexPath(indexPath)
                var file: File
                if searchController.active {
                    file = filteredFiles[indexPath.row]
                }
                else {
                    file = sections[indexPath.section][indexPath.row]
                }
                if file.isDirectory {
                    return nil
                }
                return previewManager.previewViewControllerForFile(file)
            }
        }
        return nil
    }

}
