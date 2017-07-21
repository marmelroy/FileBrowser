//
//  FileBrowser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// File browser containing navigation controller.
open class FileBrowser: UINavigationController {
	
	// Notification send when file browser will appear. Object is FBFile currently looking at
	@objc public static let FILE_BROWSER_VIEW_NOTIFICATION = NSNotification.Name("FileBrowserWillView")
    
    open var dataSource: FileBrowserDataSource = LocalFileBrowserDataSource()
    
//    var fileList: FileListViewController?

    /// File types to exclude from the file browser.
    open var excludesFileExtensions: [String]? {
        didSet {
            dataSource.excludesFileExtensions = excludesFileExtensions
        }
    }
    
    /// File paths to exclude from the file browser.
    open var excludesFilepaths: [URL]? {
        didSet {
            dataSource.excludesFilepaths = excludesFilepaths
        }
    }
    
    /// Override default preview and actionsheet behaviour in favour of custom file handling.
//    open var didSelectFile: ((FBFile) -> ())? {
//        didSet {
//            fileList?.fileBrowserState.didSelectFile = didSelectFile
//        }
//    }
    
    /**
     Init to local documents folder.
    */
    public convenience init() {
        let parser = LocalFileBrowserDataSource()
		self.init(dataSource: parser, directory: parser.rootDirectory, delegate: nil, options: nil)
    }
    
    /**
     Init to a custom local directory path.
     
     - parameter initialPath: NSURL filepath to containing directory.
    */
	@objc public convenience init(initialPath: URL, delegate: FileBrowserDelegate?, options: FileBrowserOptions? )
	{
        let parser = LocalFileBrowserDataSource()
		
		self.init(dataSource: parser, directory: LocalFBFile(path: initialPath), delegate: delegate, options: options)
    }
    
    /**
    Init with a custom dataSource. Alternatively, the dataSource can be set after initialization.
     
     - parameter parser: The data source used by the file browser
    */
    
	public convenience init(dataSource: FileBrowserDataSource, directory: FBFile, delegate: FileBrowserDelegate?, options: FileBrowserOptions? ) {
		var directory = directory
		if directory.hasViewPermission() == false
		{
			print("No view persmission for directory:", directory.path)
			directory = dataSource.rootDirectory
		}
		
		let state = FileBrowserState(dataSource: dataSource)
		state.delegate = delegate
		state.options = options
		
		// need to create navigation stack starting with the root directory
		let folderList = directory.folderListFrom(directory: dataSource.rootDirectory)
		var userViewController : UIViewController
		if directory.isDirectory
		{
			userViewController = FolderEditorTableView(state: state, withDirectory: directory)
		}
		else
		{
			userViewController = state.viewControllerFor(file: directory, fileList: nil)
		}
		var vcs = [UIViewController]()
		for folder in folderList
		{
			vcs.append(FolderEditorTableView(state: state, withDirectory: folder))
		}
		vcs.append(userViewController)
		
        self.init(rootViewController: userViewController)
        self.dataSource = dataSource
        self.view.backgroundColor = UIColor.white
     //   self.fileList = userViewController
		
		self.viewControllers = vcs
    }
    
    
    
}
