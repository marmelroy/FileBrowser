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
	var selectBtn : UIBarButtonItem?;
	var selectAllBtn : UIBarButtonItem?;
	var selectActionBtn : UIBarButtonItem?;
	var selectCancelBtn : UIBarButtonItem?;
	var actionAddBtn : UIBarButtonItem?;
	var selectActionTrashBtn : UIBarButtonItem?;
	
   //MARK: Lifecycle
    func configureToolBars()
    {
		
		self.setToolbarItems(self.navigationToolItems(), animated: true)
		
		
		self.toolbar = self.navigationController?.toolbar;
		//self.navigationBar = self.navigationController.navigationBar;
		//self.navigationBarSuperView = self.navigationBar.superview;
		
		//let hideBarsWithGestures = true;
		
		//self.navigationController?.hidesBarsOnSwipe = hideBarsWithGestures;
		//self.navigationController?.hidesBarsWhenKeyboardAppears = hideBarsWithGestures;
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
	
	

	func selectToolbarItems() -> [UIBarButtonItem]
	{
		var items = [UIBarButtonItem]()
		
		
		if selectAllBtn == nil
		{
			selectAllBtn = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(FolderEditorTableView.selectAll(button:)))
		}
		items.append( selectAllBtn! )

		items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) )

		if selectActionTrashBtn == nil
		{
			selectActionTrashBtn = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(FolderEditorTableView.selectActionTrash(button:)))
		}
		items.append( selectActionTrashBtn! )

		items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) )
		
		if selectActionBtn == nil
		{
			//.action
			selectActionBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(FolderEditorTableView.selectAction(button:)))
//			selectActionBtn = UIBarButtonItem(title: "Action", style: .plain, target: self, action: #selector(FolderEditorTableView.selectAction(button:)))
		}
		items.append( selectActionBtn! )
		
		items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) )

		if selectCancelBtn == nil
		{
			selectCancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FolderEditorTableView.selectCancel(button:)))
		}
		items.append( selectCancelBtn! )
		
		return items
	}

	func navigationToolItems() -> [UIBarButtonItem]
	{
		var items = [UIBarButtonItem]()
		
		if actionAddBtn == nil
		{
			actionAddBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(FolderEditorTableView.actionAdd(button:)))
		}
		items.append( actionAddBtn! )
		
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		items.append( space )

		if selectBtn == nil
		{
			selectBtn = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(FolderEditorTableView.select(button:)))
		}
		items.append( selectBtn! )
		
		return items
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.configureToolBars()
	
		self.tableView.allowsMultipleSelectionDuringEditing = true;
	}
	

    
    // create toolbar with select button
    
    // changes to edit commands
	
	//MARK: Utility
	
	func allSelectedFiles() -> [FBFile]
	{
		var selectedFiles = [FBFile]()
		
		let selectedIndexPaths = self.tableView.indexPathsForSelectedRows
		
		if( (selectedIndexPaths?.count ?? 0) > 0 )
		{
			for selectedIndexPath in selectedIndexPaths!
			{
				selectedFiles.append(fileForIndexPath(selectedIndexPath))
			}
		}

		return selectedFiles
	}
	
	//MARK: Button Actions
	
	@objc func select(button: UIBarButtonItem = UIBarButtonItem()) {
		self.setEditing(true, animated:true)
		self.tableView.setEditing(true, animated: true)
		
		self.setToolbarItems(self.selectToolbarItems(), animated: true)
	}
	
	@objc func selectAll(button: UIBarButtonItem = UIBarButtonItem()) {
		var path = IndexPath( row: 0, section: 0)
		
		for section in 0..<self.numberOfSections(in: self.tableView)
		{
			path.section = section
			for row in 0..<self.tableView(self.tableView, numberOfRowsInSection: section)
			{
				path.row = row
				self.tableView.selectRow(at: path, animated: false, scrollPosition: .none)
			}
		}
	}
	
	@objc func selectAction(button: UIBarButtonItem = UIBarButtonItem()) {
		// TODO: show sheet
		
		// Move
		// Copy
		// User definable actions
		
		// get selections
		let selectedIndexPaths = self.tableView.indexPathsForSelectedRows
		
		if( (selectedIndexPaths?.count ?? 0) > 0 )
		{
			let file = fileForIndexPath(selectedIndexPaths![0])
			
			let viewController = FileActivityViewController.activityControllerFor(file: file, title: "Title", sender: button)
			
			self.present(viewController, animated: true, completion: {})
		}
	}
	
	@objc func selectCancel(button: UIBarButtonItem = UIBarButtonItem()) {
		self.setEditing(false, animated:false )
		self.tableView.setEditing(false, animated: false)
		self.setToolbarItems(self.navigationToolItems(), animated: true)
	}
	
	@objc func actionAdd(button: UIBarButtonItem = UIBarButtonItem()) {
		// TODO: not done
		
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let folderAction = UIAlertAction(title: "New Folder", style: .default, handler: {(alert: UIAlertAction!) in
			// Create new folder
			
			// ask for name
			Alert_AskForText(title: "New Folder", question: "Name for new folder", presenter: self, okHandler:{
				(alert: UIAlertController) in
				// Create folder
				
				if let text = alert.textFields?[0].text
				{
					if self.directory.createDirectory(name: text)
					{
						self.prepareData()
					}
				}
			})
			
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
		let fileAction = UIAlertAction(title: "New File", style: .default, handler: {(alert: UIAlertAction!) in
			// Create new file
			
			// ask for name
			Alert_AskForText(title: "New File", question: "Name for new file", presenter: self, okHandler:{
				(alert: UIAlertController) in
				// Create file
				
				if let text = alert.textFields?[0].text
				{
					if self.directory.createFile(name: text)
					{
						self.prepareData()
					}
				}
			})
			
		})
		
		alertController.addAction(cancelAction)
		alertController.addAction(fileAction)
		alertController.addAction(folderAction)
		
		// Configure the alert controller's popover presentation controller if it has one.
		if let popoverPresentationController = alertController.popoverPresentationController
		{
			popoverPresentationController.barButtonItem = button
		}
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	@objc func selectActionTrash(button: UIBarButtonItem = UIBarButtonItem()) {
		
		guard let selectedPaths = self.tableView.indexPathsForSelectedRows else {return}
		guard selectedPaths.count > 0 else {return}
		
		
		// Need confirm delete
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(alert: UIAlertAction!) in
			// Perform delete
			let files = self.allSelectedFiles()
			
			for file in files
			{
				file.delete()
			}
			
			self.prepareData()

		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
		
		alertController.addAction(cancelAction)
		alertController.addAction(deleteAction)
		
		// Configure the alert controller's popover presentation controller if it has one.
		if let popoverPresentationController = alertController.popoverPresentationController
		{
			popoverPresentationController.barButtonItem = button
		}
		self.present(alertController, animated: true, completion: nil)
	}
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.isEditing == false
		{
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
	}
    // allow editing
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		// TODO: probably done, just makes the item selectable
		return true;
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
	{
		
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
	{
		return .none;
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
