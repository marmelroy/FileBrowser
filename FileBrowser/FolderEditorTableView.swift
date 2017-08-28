//
//  FolderEditorViewController.swift
//  FileBrowser
//
//

import Foundation

class FolderEditorTableView : FileListViewController
{
	//weak var toolbar : UIToolbar?
	// Edit mode toolbar
	var selectAllBtn : UIBarButtonItem?
	var selectActionBtn : UIBarButtonItem?
	var selectCancelBtn : UIBarButtonItem?
	var selectActionTrashBtn : UIBarButtonItem?
	// Regular toolbar
	var selectBtn : UIBarButtonItem?
	var optionsBtn : UIBarButtonItem?
	var refreshBtn : UIBarButtonItem?
	var actionAddBtn : UIBarButtonItem?
	
   //MARK: Lifecycle
    func configureToolBars()
    {
		if selectCancelBtn == nil
		{
			selectCancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FolderEditorTableView.selectCancel(button:)))
		}
		if selectBtn == nil
		{
			selectBtn = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(FolderEditorTableView.select(button:)))
		}
		
		if self.tableView.isEditing
		{
			self.navigationItem.rightBarButtonItem = selectCancelBtn
			self.setToolbarItems(self.selectToolbarItems(), animated: true)
		}
		else
		{
			self.navigationItem.rightBarButtonItem = selectBtn
			self.setToolbarItems(self.navigationToolItems(), animated: true)
		}
		
		self.navigationController?.setToolbarHidden(false, animated: false)
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

		items.append( fileBrowserState.getDoneButton(target: self, action: #selector(FileListViewController.dismiss(button:))))
		
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
		
		items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) )

		// have a custom more/action button instead
		if fileBrowserState.delegate != nil
		{
			items.append(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(FolderEditorTableView.actionFolderActions(button:))))
		}
		
//		if refreshBtn == nil
//		{
//			refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(FolderEditorTableView.actionRefresh(button:)))
//		}
//		items.append( refreshBtn! )
		
		items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) )

		if optionsBtn == nil
		{
			optionsBtn = UIBarButtonItem( image: UIImage(named: "gear_icon"), style: .plain,  target: self, action: #selector(FolderEditorTableView.actionOptions(button:)))
			//optionsBtn = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(FolderEditorTableView.actionOptions(button:)))
		}
		items.append( optionsBtn! )
		
		items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) )
		
		items.append( fileBrowserState.getDoneButton(target: self, action: #selector(FileListViewController.dismiss(button:))))
		
		return items
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.configureToolBars()
	
		self.tableView.allowsMultipleSelectionDuringEditing = true
		
		fileBrowserState.cellShowDetail = true
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
	
	@objc func actionFolderActions( button : UIBarButtonItem )
	{
		if let delegate = fileBrowserState.delegate
		{
			delegate.displayFolderActionsFor(directory, viewController: self)
		}
	}
	
	@objc func actionRefresh( button : UIBarButtonItem )
	{
		self.prepareData(sender: nil)
	}
	
	@objc func actionOptions( button : UIBarButtonItem )
	{
		fileBrowserState.displayOptionsFrom(self)
	}
	
	@objc func select(button: UIBarButtonItem = UIBarButtonItem()) {
		self.setEditing(true, animated:true)
		self.tableView.setEditing(true, animated: true)
		
		configureToolBars()
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
		// Move
		// Copy
		// User definable actions
		
		// get selections
		let selectedIndexPaths = self.tableView.indexPathsForSelectedRows
		
		if( (selectedIndexPaths?.count ?? 0) > 0 )
		{
			let viewController = FileActivityViewController.activityControllerFor(files: allSelectedFiles(), state: fileBrowserState, title: "Title", sender: button)
			
			self.present(viewController, animated: true, completion: {})
		}
	}
	
	@objc func selectCancel(button: UIBarButtonItem = UIBarButtonItem()) {
		self.setEditing(false, animated:false )
		self.tableView.setEditing(false, animated: false)
		configureToolBars()
	}
	
	@objc func actionAdd(button: UIBarButtonItem = UIBarButtonItem()) {
		
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let folderAction = UIAlertAction(title: "New Folder", style: .default, handler: {(alert: UIAlertAction!) in
			// Create new folder
			
			self.fileBrowserState.newFolder(directory: self.directory, controller: self, action: {self.prepareData(sender: nil)})
			
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
		let fileAction = UIAlertAction(title: "New File", style: .default, handler: {(alert: UIAlertAction!) in
			// Create new file
			
			// ask for name
			AlertUtilities.Alert_AskForText(title: "New File", question: "Name for new file", presenter: self, okHandler:{
				(alert: UIAlertController) in
				// Create file
				
				if let text = alert.textFields?[0].text
				{
					if self.directory.createFile(name: text)
					{
						self.prepareData(sender:nil)
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
	
	func deleteFilesWithConfirmation( prompt : String, files: [FBFile], fromButton: UIBarButtonItem? )
	{
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		let deleteAction = UIAlertAction(title: prompt, style: .destructive, handler: {(alert: UIAlertAction!) in
			// Perform delete
			
			for file in files
			{
				file.delete()
			}
			
			self.prepareData(sender: nil)
			
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
		
		alertController.addAction(cancelAction)
		alertController.addAction(deleteAction)
		
		// Configure the alert controller's popover presentation controller if it has one.
		if let button = fromButton, let popoverPresentationController = alertController.popoverPresentationController
		{
			popoverPresentationController.barButtonItem = button
		}
		self.present(alertController, animated: true, completion: nil)
	}
	
	@objc func selectActionTrash(button: UIBarButtonItem = UIBarButtonItem()) {
		
		guard let selectedPaths = self.tableView.indexPathsForSelectedRows else {return}
		guard selectedPaths.count > 0 else {return}
		
		var prompt = "Delete \(selectedPaths.count) item"
		if selectedPaths.count > 1
		{
			prompt = prompt + "s"
		}
		
		// Need confirm delete
		deleteFilesWithConfirmation(prompt: prompt, files: self.allSelectedFiles(), fromButton: button)
	}
	
    //MARK: UITableViewDataSource, UITableViewDelegate
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView.isEditing == false
		{
			let selectedFile = fileForIndexPath(indexPath)
			// Notify
			NotificationCenter.default.post(name: FileBrowser.FILE_BROWSER_VIEW_NOTIFICATION, object: selectedFile)
			
			//
			searchController?.isActive = false
			fileBrowserState.viewFile(file: selectedFile, controller: self, fileList: files)
			//tableView.deselectRow(at: indexPath, animated: true)
		}
	}
    // allow editing
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
	{
		return true;
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
	{
		if editingStyle == .delete
		{
			let selectedFile = fileForIndexPath(indexPath)
			
			deleteFilesWithConfirmation(prompt: "Are you sure you want to delete \(selectedFile.displayName)?", files: [selectedFile], fromButton: nil)
			
		}
	}

	// TODO: for adding more actions
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
	{
		// add info or move actions + delete
		let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: { (rowAction, indexPath) in
			let selectedFile = self.fileForIndexPath(indexPath)
			
			self.deleteFilesWithConfirmation(prompt: "Are you sure you want to delete \(selectedFile.displayName)?", files: [selectedFile], fromButton: nil)
		})
		
		let moreAction = UITableViewRowAction(style: .normal, title: "More", handler: { (rowAction, indexPath) in
			let selectedFile = self.fileForIndexPath(indexPath)
			
			//TODO: action sheet with the following
			//"View" "Rename" "Move" "Duplicate" "Copy"
		})
		moreAction.backgroundColor = UIColor.gray
		
		let detailsAction = UITableViewRowAction(style: .normal, title: "Details", handler: { (rowAction, indexPath) in
			let selectedFile = self.fileForIndexPath(indexPath)
			
			let detailViewController = FileDetailViewController(file: selectedFile, state: self.fileBrowserState)
			self.navigationController?.pushViewController(detailViewController, animated: true)
		})
		detailsAction.backgroundColor = UIColor.black
		
		
		return [deleteAction, detailsAction, moreAction ];
		
	}
	
	func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
	{
		// Info button tapped
		
		// show file detail view controller
		
		// for renaming, open in, delete
		let detailViewController = FileDetailViewController(file: fileForIndexPath(indexPath), state: fileBrowserState)
		self.navigationController?.pushViewController(detailViewController, animated: true)
		
//		self.showDetailViewController(<#T##vc: UIViewController##UIViewController#>, sender: <#T##Any?#>)
	}

}
