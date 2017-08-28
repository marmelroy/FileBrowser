//
//  QuickLookWithActionsViewController.swift
//  FileBrowser
//
//

import Foundation
import QuickLook

//this doesn't work may just have to make own view controller
class QuickLookWithActionsViewController : QLPreviewController
{
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
	
	
}


class LocalFileQLViewController : QLPreviewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource
{
	var theFile : NSURL?
	
	convenience init(fileURL : NSURL) {
		self.init()
		
		theFile = fileURL
		
		dataSource = self
	}
	
	
	// MARK: delegate methods
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
		return 1
	}
	
	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
		
		return theFile!
	}
}
