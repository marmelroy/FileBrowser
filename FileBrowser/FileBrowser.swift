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
    
    open var dataSource: FileBrowserDataSource = LocalFileBrowserDataSource()
    
    var fileList: FileListViewController?

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
    open var didSelectFile: ((FBFile) -> ())? {
        didSet {
            fileList?.didSelectFile = didSelectFile
        }
    }
    
    /**
     Init to local documents folder.
    */
    public convenience init() {
        let parser = LocalFileBrowserDataSource()
        self.init(dataSource: parser)
    }
    
    /**
     Init to a custom local directory path.
     
     - parameter initialPath: NSURL filepath to containing directory.
    */
    public convenience init(initialPath: URL) {
        let parser = LocalFileBrowserDataSource()
        parser.customRootUrl = initialPath
        self.init(dataSource: parser)
    }
    
    /**
    Init with a custom dataSource. Alternatively, the dataSource can be set after initialization.
     
     - parameter parser: The data source used by the file browser
    */
    
    public convenience init(dataSource: FileBrowserDataSource) {
//        let fileListViewController = FileListViewController(dataSource: dataSource, withDirectory: dataSource.rootDirectory)
		let fileListViewController = FolderEditorTableView(dataSource: dataSource, withDirectory: dataSource.rootDirectory)
        self.init(rootViewController: fileListViewController)
        self.dataSource = dataSource
        self.view.backgroundColor = UIColor.white
        self.fileList = fileListViewController
    }
    
    
    
}
