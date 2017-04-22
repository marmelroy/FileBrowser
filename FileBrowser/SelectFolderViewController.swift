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
			// TODO: move files
		
		})
		// add in nav controller
		let nc = UINavigationController(rootViewController: vc)
		
		
		return nc;
	}
	
	convenience init (state: FileBrowserState, enclosingDirectory: FBFile, prompt: String, action: @escaping (FBFile)->()) {
		self.init(state: state, withDirectory: enclosingDirectory)
		
		// Data
		self.action = action;
		self.actionPrompt = prompt;
		
		// Add cancel button
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FileListViewController.dismiss(button:)))
		self.navigationItem.rightBarButtonItem = cancelButton

	}
	
	//MARK: Lifecycle
	
	
	
	
	
}
