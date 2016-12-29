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
    
    open var dataSource: FileBrowserDataSource = LocalFileParser()
    
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
    
    /// Whether to exclude files with empty filenames
    open var excludesWithEmptyFilenames: Bool = false {
        didSet {
            dataSource.excludesWithEmptyFilenames = excludesWithEmptyFilenames
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
        let parser = LocalFileParser()
        self.init(dataSource: parser)
    }
    
    /**
     Init to a custom local directory path.
     
     - parameter initialPath: NSURL filepath to containing directory.
    */
    public convenience init(initialPath: URL) {
        let parser = LocalFileParser()
        parser.customRootUrl = initialPath
        self.init(dataSource: parser)
    }
    
    /**
    Init with a custom dataSource. Alternatively, the dataSource can be set after initialization.
     
     - parameter parser: The data source used by the file browser
    */
    
    public convenience init(dataSource: FileBrowserDataSource) {
        let fileListViewController = FileListViewController(dataSource: dataSource, withDirectory: dataSource.rootDirectory)
        self.init(rootViewController: fileListViewController)
        self.dataSource = dataSource
        self.view.backgroundColor = UIColor.white
        self.fileList = fileListViewController
    }
    
    
    
}
