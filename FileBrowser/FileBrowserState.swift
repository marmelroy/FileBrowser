//
//  FileBrowserState.swift
//  FileBrowser
//
//

import Foundation

class FileBrowserState
{
	var dataSource: FileBrowserDataSource!
	
	var didSelectFile: ((FBFile) -> ())?
	let previewManager = PreviewManager()
	
	var includeIndex: Bool = true
	var showOnlyFolders: Bool = false
	var cellAcc: UITableViewCellAccessoryType = .detailButton
	var allowSearch: Bool = true

	convenience init(dataSource: FileBrowserDataSource)
	{
		self.init()
		
		self.dataSource = dataSource;
	}
	
	func viewFile( file: FBFile, controller: UIViewController )
	{
		if file.isDirectory {
			let fileListViewController = FolderEditorTableView(state: self, withDirectory: file)
			controller.navigationController?.pushViewController(fileListViewController, animated: true)
		}
		else {
			if let didSelectFile = didSelectFile {
				controller.dismiss(animated: true, completion: nil)
				didSelectFile(file)
			}
			else
			{
				let filePreview = previewManager.previewViewControllerForFile(file, data: nil, fromNavigation: true)
				controller.navigationController?.pushViewController(filePreview, animated: true)
			}
		}
		
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
	
	func moveFile( file: FBFile, controller: UIViewController, sender: Any? )
	{
		let vc = SelectFolderViewController.newInstanceForMovingFiles(files: [file], state: self)
		if let vc = vc
		{
			controller.showDetailViewController(vc, sender: sender)
		}
	}
}
