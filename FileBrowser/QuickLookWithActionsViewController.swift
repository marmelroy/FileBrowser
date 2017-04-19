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
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Add toolbar items to this view
		var toolbarItems = self.toolbarItems;
		var ti = [UIBarButtonItem]()
		
		//ti += toolbarItems
		ti.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(QuickLookWithActionsViewController.trashAction(button:))))
		
		self.setToolbarItems(ti, animated: false);
	}
	
	@objc func trashAction(button: UIBarButtonItem = UIBarButtonItem()) {
		print("Trash this")
	}
}
