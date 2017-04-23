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
	
	static func newInstanceForMovingFiles(files: [FBFile], state: FileBrowserState, action: (()->())? = nil, cancelAction: (()->())? = nil) -> UIViewController?
	{
		guard files.count > 0 else
		{
			return nil;
		}
		
		guard let enclosingDir = files[0].enclosingDirectory() else
		{
			return nil;
		}
		
		var prompt : String
		
		if files.count > 1
		{
			prompt = "Move \(files.count) items here"
		}
		else
		{
			prompt = "Move item here"
		}
		
		let stateForSelect = FileBrowserState(dataSource: state.dataSource)
		stateForSelect.allowSearch = false
		stateForSelect.includeIndex = false
		stateForSelect.cellAcc = .none
		stateForSelect.showOnlyFolders = true
		
		let vc = SelectFolderViewController(state: stateForSelect, enclosingDirectory: enclosingDir, prompt:prompt, action: {(directory:FBFile, vc:UIViewController) in
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
		// add in nav controller
		
		//TODO: Need to create view controller list from Documents folder all the way to the current folder
		
		
		let nc = UINavigationController(rootViewController: vc)
		
		
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
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.configureToolBar()
	}
	
	//MARK: Actions
	
	@objc func actionAddButton(button: UIBarButtonItem)
	{
		// TODO: new folder
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
