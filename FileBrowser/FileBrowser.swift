//
//  FileBrowser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public class FileBrowser: UINavigationController {
    
    let parser = FileParser.sharedInstance
    
    var fileList: FileList?

    public var excludesFileTypes: [FileType]? {
        didSet {
            parser.excludesFileTypes = excludesFileTypes
        }
    }
    
    public var excludesFilepaths: [NSURL]? {
        didSet {
            parser.excludesFilepaths = excludesFilepaths
        }
    }
    
    public var didSelectFile: ((File) -> ())? {
        didSet {
            fileList?.didSelectFile = didSelectFile
        }
    }
    
    public convenience init() {
        let parser = FileParser.sharedInstance
        let path = parser.documentsURL()
        self.init(initialPath: path)
    }
    
    public convenience init(initialPath: NSURL) {
        let fileListViewController = FileList(initialPath: initialPath)
        self.init(rootViewController: fileListViewController)
        self.view.backgroundColor = UIColor.whiteColor()
        self.fileList = fileListViewController
    }
    
}