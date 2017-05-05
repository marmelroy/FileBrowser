//
//  SelectFolderViewController.swift
//  FileBrowser
//
//

import Foundation


class SelectFolderViewController : FileListViewController
{
	
	var action: ((FBFile, UIViewController)->())?
	var cancelAction: ((UIViewController)->())?
	var actionPrompt: String!
	
	static private func controllerForDirectory(files: [FBFile], state: FileBrowserState, directory: FBFile, prompt: String, action: (()->())? = nil, cancelAction: (()->())? = nil) -> UIViewController
	{
		let vc = SelectFolderViewController(state: state, enclosingDirectory: directory, prompt:prompt, action: {(directory:FBFile, vc:UIViewController) in
			for file in files
			{
				file.moveTo(directory: directory)
			}
			
			if let action = action
			{
				action()
			}
			else
			{
				vc.dismiss(animated: true, completion: nil)
			}
		}, cancelAction: {(vc: UIViewController) in
			if let action = cancelAction
			{
				action()
			}
			else
			{
				vc.dismiss(animated: true, completion: nil)
			}
		})
		
		return vc;
	}
	
	static func newInstanceForMovingFiles(files: [FBFile], state: FileBrowserState, action: (()->())? = nil, cancelAction: (()->())? = nil) -> UIViewController?
	{
		guard files.count > 0 else
		{
			return nil;
		}
		
		//let enclosingDir = files[0].enclosingDirectory()
		var prompt : String
		
		if files.count > 1
		{
			prompt = "Move \(files.count) items here"
		}
		else
		{
			prompt = "Move item here"
		}
		
		let stateForSelect = state.copy() as! FileBrowserState
		stateForSelect.allowSearch = false
		stateForSelect.includeIndex = false
		stateForSelect.cellAcc = .none
		stateForSelect.showOnlyFolders = true
		
		// add in nav controller
		
		let rootVC = controllerForDirectory(files: files, state: stateForSelect, directory: state.dataSource.rootDirectory, prompt: prompt)
		
		let nc = UINavigationController(rootViewController: rootVC)
		
		// Create the folder list
		let folderList = files[0].folderListFrom(directory: state.dataSource.rootDirectory)
		
		// Create the view controller stack
		var vcStack = [UIViewController]()
		
		for curDir in folderList
		{
			print("Building view controller list:\(curDir.path)")
			
			vcStack.append(controllerForDirectory(files: files, state: stateForSelect, directory: curDir, prompt: prompt))
		}
		
		nc.setViewControllers(vcStack, animated: false)
		
		return nc;
	}
	
	convenience init (state: FileBrowserState, enclosingDirectory: FBFile, prompt: String, action: ((FBFile, UIViewController)->())?,
	                  cancelAction: ((UIViewController)->())?) {
		self.init(state: state, withDirectory: enclosingDirectory)
		
		// Data
		self.action = action
		self.actionPrompt = prompt
		self.cancelAction = cancelAction
		
		// Add cancel button
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SelectFolderViewController.actionCancel(button:)))
		self.navigationItem.rightBarButtonItem = cancelButton

	}
	
	//MARK: Lifecycle
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedFile = fileForIndexPath(indexPath)
		searchController?.isActive = false
		if selectedFile.isDirectory
		{
			let fileListViewController = SelectFolderViewController(state: fileBrowserState, enclosingDirectory: selectedFile, prompt: actionPrompt, action: self.action, cancelAction: self.cancelAction)
			self.navigationController?.pushViewController(fileListViewController, animated: true)
		}
		//tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.configureToolBar()
	}
	
	//MARK: Actions
	
	@objc func actionAddButton(button: UIBarButtonItem)
	{
		fileBrowserState.newFolder(directory: self.directory, controller: self, action: {self.prepareData(sender: nil)})
	}
	
	@objc func actionCancel(button: UIBarButtonItem)
	{
		if let action = self.cancelAction
		{
			action( self )
		}
		else
		{
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	@objc func actionComplete(button: UIBarButtonItem)
	{
		if let action = self.action
		{
			action(self.directory, self)
		}
	}

	func configureToolBar()
	{
		var items = [UIBarButtonItem]()
		
		// Show prompt
		
		let actionAddBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SelectFolderViewController.actionAddButton(button:)))
		items.append( actionAddBtn )
		
		items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) )
		
		let selectBtn = UIBarButtonItem(title: actionPrompt, style: .plain, target: self, action: #selector(SelectFolderViewController.actionComplete(button:)))
		items.append( selectBtn )
		
		self.setToolbarItems(items, animated: false)
		self.navigationController?.setToolbarHidden(false, animated: false)
	}
	
	

	
}
