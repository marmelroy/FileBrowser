//
//  FolderEditorViewController.swift
//  FileBrowser
//
//  Created by test on 4/3/17.
//  Copyright © 2017 Roy Marmelstein. All rights reserved.
//

import Foundation

class FolderEditorTableView : FileListViewController
{
	weak var toolbar : UIToolbar?;
   //MARK: Lifecycle
    func configureToolBars()
    {
		
		self.setToolbarItems(self.navigationToolItems(), animated: true)
		
		
		self.toolbar = self.navigationController?.toolbar;
		//self.navigationBar = self.navigationController.navigationBar;
		//self.navigationBarSuperView = self.navigationBar.superview;
		
		let hideBarsWithGestures = true;
		
		//self.navigationController?.hidesBarsOnSwipe = hideBarsWithGestures;
		self.navigationController?.hidesBarsWhenKeyboardAppears = hideBarsWithGestures;
		//self.navigationController?.hidesBarsWhenVerticallyCompact = hideBarsWithGestures;
		
//		if (self.hideBarsWithGestures) {
//			[self.navigationBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
//			[self.navigationBar addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
//			[self.navigationBar addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
//		}
		
		//if (!DZN_IS_IPAD && self.navigationController.toolbarHidden && self.toolbarItems.count > 0) {
		//if (self.navigationController?.isToolbarHidden ?? false) && ((self.toolbarItems?.count ?? 0) > 0)
		//{
			self.navigationController?.setToolbarHidden(false, animated: false)
		//}
		//}
		print("Frame: \(self.toolbar?.frame.origin.y)");
    }
	
	@objc func select(button: UIBarButtonItem = UIBarButtonItem()) {
		self.setEditing(true, animated:true)
		// switch to cancel editing
		self.tableView.setEditing(true, animated: true)
		// TODO:
	}


	func navigationToolItems() -> [UIBarButtonItem]
	{
		var items = [UIBarButtonItem]()
		
		items.append( UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(FolderEditorTableView.select(button:))))
		
		return items
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.configureToolBars()
		
	}
	

    
    // create toolbar with select button
    
    // changes to edit commands
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedFile = fileForIndexPath(indexPath)
		searchController.isActive = false
		if selectedFile.isDirectory {
			let fileListViewController = FolderEditorTableView(dataSource: dataSource, withDirectory: selectedFile)
			fileListViewController.didSelectFile = didSelectFile
			self.navigationController?.pushViewController(fileListViewController, animated: true)
		}
		else {
			if let didSelectFile = didSelectFile {
				self.dismiss()
				didSelectFile(selectedFile)
			}
			else {
				let filePreview = previewManager.previewViewControllerForFile(selectedFile, data: nil, fromNavigation: true)
				self.navigationController?.pushViewController(filePreview, animated: true)
			}
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
    // allow editing
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		// TODO:
		return true;
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
	{
		
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
	{
		return .insert;// how do I get the selection style?
	}
	
	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
	{
		// Info button tapped
		
		// show file detail view controller
		
		// for renaming, open in, delete
		let detailViewController = FileDetailViewController(file: fileForIndexPath(indexPath))
		self.navigationController?.pushViewController(detailViewController, animated: true)
		
//		self.showDetailViewController(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
	}

}
