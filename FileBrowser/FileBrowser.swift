//
//  FileBrowser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public class FileBrowser: UINavigationController {
    
    convenience init() {
        let parser = FileParser()
        let path = parser.documentsURL()
        self.init(initialPath: path)
    }
    
    convenience init(initialPath: NSURL) {
        let fileList = FileList(initialPath: initialPath)
        self.init(rootViewController: fileList)
    }
    
}