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
    
    let parser = FileParser.sharedInstance
    
    var fileList: FileListViewController?

    /// File types to exclude from the file browser.
    open var excludesFileExtensions: [String]? {
        didSet {
            parser.excludesFileExtensions = excludesFileExtensions
        }
    }
    
    /// File paths to exclude from the file browser.
    open var excludesFilepaths: [URL]? {
        didSet {
            parser.excludesFilepaths = excludesFilepaths
        }
    }
    
    /// Override default preview and actionsheet behaviour in favour of custom file handling.
    open var didSelectFile: ((FBFile) -> ())? {
        didSet {
            fileList?.didSelectFile = didSelectFile
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        let parser = FileParser.sharedInstance
        let path = parser.documentsURL()
        
        let fileListViewController = FileListViewController(initialPath: path, showCancelButton: false)
        fileListViewController.allowEditing = true
        self.viewControllers = [fileListViewController]
        self.view.backgroundColor = UIColor.white
        self.fileList = fileListViewController

    }
}
