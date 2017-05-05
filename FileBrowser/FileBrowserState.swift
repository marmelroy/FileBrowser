//
//  FileBrowserState.swift
//  FileBrowser
//
//

import Foundation

class FileBrowserState : NSObject, NSCopying
{
	var dataSource: FileBrowserDataSource!
	var delegate: FileBrowserDelegate?
	var options: FileBrowserOptions?
	
	var didSelectFile: ((FBFile) -> ())?
	let previewManager = PreviewManager()
	
	var includeIndex: Bool = true
	var showOnlyFolders: Bool = false
	var cellAcc: UITableViewCellAccessoryType = .detailButton
	var allowSearch: Bool = true
	var cellShowDetail: Bool = false

	convenience init(dataSource: FileBrowserDataSource)
	{
		self.init()
		
		self.dataSource = dataSource;
	}
	
	public func copy(with zone: NSZone? = nil) -> Any
	{
		let state = FileBrowserState(dataSource: dataSource)
		
		state.delegate = self.delegate
		state.didSelectFile = self.didSelectFile
		state.includeIndex = self.includeIndex
		state.showOnlyFolders = self.showOnlyFolders
		state.cellAcc = self.cellAcc
		state.allowSearch = self.allowSearch
		state.cellShowDetail = self.cellShowDetail
		state.options = self.options
		
		return state
	}
	
	func viewControllerFor( file: FBFile ) -> UIViewController
	{
		if file.isDirectory
		{
			let fileListViewController = FolderEditorTableView(state: self, withDirectory: file)
			return fileListViewController
		}
		else
		{
			let filePreview = previewManager.previewViewControllerForFile(file, data: nil, fromNavigation: true, state: self)
			return filePreview
		}

	}
	
	func viewFile( file: FBFile, controller: UIViewController )
	{
		if file.isDirectory
		{
			controller.navigationController?.pushViewController(viewControllerFor(file: file), animated: true)
		}
		else {
			if let didSelectFile = didSelectFile {
				controller.dismiss(animated: true, completion: nil)
				didSelectFile(file)
			}
			else
			{
				controller.navigationController?.pushViewController(viewControllerFor(file: file), animated: true)
			}
		}
		
	}
	
	func renameFile( file: FBFile, controller: UIViewController, completion: ((FBFile)->())? )
	{
		// this is just a test
		// bring up the alert thing with two text fields
		let alertController = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)

		alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
			textField.placeholder = "File Name"
			textField.tag = 1
			textField.text = file.fileNameWithoutExtension()
		})

		if file.isDirectory == false
		{
			alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
				textField.placeholder = "Extension"
				textField.tag = 2
				textField.text = file.fileExtension
			})
		}

		
		
		let renameAction = UIAlertAction(title: "Rename", style: .destructive, handler: {(alert: UIAlertAction!) in
			// Perform rename
			if file.isDirectory
			{
				guard alertController.textFields?.count == 1 else
				{
					print("Failed to rename. Text Fields not equal to 1")
					return
				}
				
				guard let firstTextField = alertController.textFields?[0] else
				{
					return
				}
				
				if let name = firstTextField.text
				{
					let newName = name
					
					let newFile = file.rename(name: newName)
					
					if let completion = completion
					{
						completion( newFile )
					}
				}
			}
			else
			{
				guard alertController.textFields?.count == 2 else
				{
					print("Failed to rename. Text Fields not equal to two")
					return
				}
				
				guard let firstTextField = alertController.textFields?[0] else
				{
					return
				}
				
				guard let secondTextField = alertController.textFields?[1] else
				{
					return
				}
				
				var nameTextField : UITextField
				var extTextField : UITextField
				
				if firstTextField.tag == 1
				{
					nameTextField = firstTextField
					extTextField = secondTextField
				}
				else
				{
					nameTextField = secondTextField
					extTextField = firstTextField
				}
				
				if let name = nameTextField.text, let ext = extTextField.text
				{
					var newName : String = name
					
					if ext.characters.count > 0
					{
						newName += "." + ext
					}
					
					let newFile = file.rename(name: newName)
					
					if let completion = completion
					{
						completion( newFile )
					}
				}
			}
			

		})

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )

		alertController.addAction(cancelAction)
		alertController.addAction(renameAction)
		
		controller.present(alertController, animated: true, completion: nil)
	}
	
	func deleteFileAfterUserConfirmation( files: [FBFile], controller: UIViewController, refresh: @escaping ()->() )
	{
		// Need confirm delete
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(alert: UIAlertAction!) in
			// Perform delete
			for file in files
			{
				file.delete()
			}
			
			refresh()
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
		
		alertController.addAction(cancelAction)
		alertController.addAction(deleteAction)
		
		controller.present(alertController, animated: true, completion: nil)
	}
	
	func moveFiles( files: [FBFile], controller: UIViewController, sender: Any? )
	{
		let vc = SelectFolderViewController.newInstanceForMovingFiles(files: files, state: self, action:{
			//TODO: move to the new directory
		} )
		if let vc = vc
		{
			controller.showDetailViewController(vc, sender: sender)
		}
	}
	
	func newFolder( directory: FBFile, controller: UIViewController, action: @escaping ()->() )
	{
		// ask for name
		Alert_AskForText(title: "New Folder", question: "Name for new folder", presenter: controller, okHandler:{
			(alert: UIAlertController) in
			// Create folder
			
			if let text = alert.textFields?[0].text
			{
				if directory.createDirectory(name: text)
				{
					 action()
				}
			}
		})
	}
	
	func displayOptionsFrom( _ viewController: UIViewController )
	{
		if let delegate = delegate
		{
			delegate.displayOptionsFrom(viewController)
		}
	}
}
