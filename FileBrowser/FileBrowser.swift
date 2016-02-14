//
//  FileBrowser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// File browser containing navigation controller.
public class FileBrowser: UINavigationController {
    
    let parser = FileParser.sharedInstance
    
    var fileList: FileList?

    /// File types to exclude from the file browser.
    public var excludesFileTypes: [FileType]? {
        didSet {
            parser.excludesFileTypes = excludesFileTypes
        }
    }
    
    /// File paths to exclude from the file browser.
    public var excludesFilepaths: [NSURL]? {
        didSet {
            parser.excludesFilepaths = excludesFilepaths
        }
    }
    
    /// Override default preview and actionsheet behaviour in favour of custom file handling.
    public var didSelectFile: ((File) -> ())? {
        didSet {
            fileList?.didSelectFile = didSelectFile
        }
    }
    
    /**
     Init to documents folder.
     
     - returns: File browser view controller.
     */
    public convenience init() {
        let parser = FileParser.sharedInstance
        let path = parser.documentsURL()
        self.init(initialPath: path)
    }
    
    /**
     Init to a custom directory path.
     
     - parameter initialPath: NSURL filepath to containing directory.
     
     - returns: File browser view controller.
     */
    public convenience init(initialPath: NSURL) {
        let fileListViewController = FileList(initialPath: initialPath)
        self.init(rootViewController: fileListViewController)
        self.view.backgroundColor = UIColor.whiteColor()
        self.fileList = fileListViewController
    }
    
}