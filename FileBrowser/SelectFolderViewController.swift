//
//  SelectFolderViewController.swift
//  FileBrowser
//
//

import Foundation


class SelectFolderViewController : FileListViewController
{
	
	var action: ((FBFile)->())?
	var actionPrompt: String!
	
	static func newInstanceForMovingFiles(files: [FBFile], state: FileBrowserState) -> UIViewController?
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
		
		var stateForSelect = FileBrowserState(dataSource: state.dataSource)
		stateForSelect.allowSearch = false
		stateForSelect.includeIndex = false
		stateForSelect.cellAcc = .none
		stateForSelect.showOnlyFolders = true
		
		let vc = SelectFolderViewController(state: stateForSelect, enclosingDirectory: enclosingDir, prompt:prompt, action: {(directory:FBFile) in
			for file in files
			{
				file.moveTo(directory: directory)
			}
		})
		// add in nav controller
		
		//TODO: Need to create view controller list from Documents folder all the way to the current folder
		
		
		let nc = UINavigationController(rootViewController: vc)
		
		
		return nc;
	}
	
	convenience init (state: FileBrowserState, enclosingDirectory: FBFile, prompt: String, action: ((FBFile)->())?) {
		self.init(state: state, withDirectory: enclosingDirectory)
		
		// Data
		self.action = action;
		self.actionPrompt = prompt;
		
		// Add cancel button
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FileListViewController.dismiss(button:)))
		self.navigationItem.rightBarButtonItem = cancelButton

	}
	
	//MARK: Lifecycle
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedFile = fileForIndexPath(indexPath)
		searchController?.isActive = false
		if selectedFile.isDirectory
		{
			let fileListViewController = SelectFolderViewController(state: fileBrowserState, enclosingDirectory: selectedFile, prompt: actionPrompt, action: self.action)
			self.navigationController?.pushViewController(fileListViewController, animated: true)
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	@objc func actionAddButton(button: UIBarButtonItem)
	{
		// TODO: new folder
	}
	
	@objc func actionComplete(button: UIBarButtonItem)
	{
		if let action = self.action
		{
			action(self.directory)
		}
		self.dismiss(button: button)
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.configureToolBar()
	}

	
}
