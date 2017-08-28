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
    
    var file: FBFile?
    var fileData: Data?
	
	func quickLookControllerForFile(_ file: FBFile, data: Data?, fromNavigation: Bool) -> UIViewController {
		if data == nil && file.isRemoteFile {
			return LoadingViewController(file: file)
		}
		
		if file.type == .PLIST || file.type == .JSON {
			let webviewPreviewViewContoller = WebviewPreviewViewContoller(nibName: "WebviewPreviewViewContoller", bundle: Bundle(for: WebviewPreviewViewContoller.self))
			webviewPreviewViewContoller.fileData = data
			webviewPreviewViewContoller.file = file
			return webviewPreviewViewContoller
		}
		else {
			let previewTransitionViewController = PreviewTransitionViewController(nibName: "PreviewTransitionViewController", bundle: Bundle(for: PreviewTransitionViewController.self))
			self.file = file
			self.fileData = data
			
			previewTransitionViewController.quickLookPreviewController.dataSource = self
			
			if fromNavigation == true {
				return previewTransitionViewController.quickLookPreviewController
			}
			return previewTransitionViewController
			
		}
	}
	
	static func previewViewControllerForFile(_ file: FBFile, data: Data?, state: FileBrowserState, fileList : [FBFileProto]?) -> UIViewController {
        if data == nil && file.isRemoteFile {
            return LoadingViewController(file: file)
        }
        
        if file.type == .PLIST || file.type == .JSON
		{
            let webviewPreviewViewContoller = WebviewPreviewViewContoller(nibName: "WebviewPreviewViewContoller", bundle: Bundle(for: WebviewPreviewViewContoller.self))
            webviewPreviewViewContoller.fileData = data
            webviewPreviewViewContoller.file = file
            return webviewPreviewViewContoller
        }
		else if file.type == .TXT || file.type == .TEXT
		{
			// Open Text previewer
			// TODO: if file size is less than 20MB
			return TextFileViewController(file: file, state: state)
		}
        else if (file.type.isImage() == false) && (file is LocalFBFile)
		{
			return LocalFileQLViewController(fileURL: file.path as NSURL)
		}
		else
		{
			return ImageViewController(file: file, state: state, fileList: fileList)
        }
    }
    
    // MARK: delegate methods
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let item = PreviewItem()
        
        if let file = file,
            let fileData = fileData,
            let url = copyDataToTemporaryDirectory(fileData, file: file) {
            item.filePath = url
        } else if let file = file, let url = file.fileLocation, url.scheme == "file" {
            item.filePath = url
        }
        
        return item
    }
    
    func copyDataToTemporaryDirectory(_ data: Data, file: FBFile) -> URL?
    {
        let tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        let fileExtension = file.fileExtension ?? file.type.rawValue
        let targetURL = tempDirectoryURL.appendingPathComponent("\(file.displayName).\(fileExtension)")  // TODO: better file extensions
        
        // Copy the file.
        do {
            try data.write(to: targetURL)
            return targetURL
        } catch let error {
            print("Unable to copy file: \(error)")
            return nil
        }
    }
}

class PreviewItem: NSObject, QLPreviewItem {
    
    /*!
     * @abstract The URL of the item to preview.
     * @discussion The URL must be a file URL.
     */
    
    var filePath: URL?
    public var previewItemURL: URL? {
        if let filePath = filePath {
            return filePath
        }
        return nil
    }
    
}
