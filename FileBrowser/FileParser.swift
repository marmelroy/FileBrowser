//
//  FileParser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 13/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

class FileParser {
    
    static let sharedInstance = FileParser()
    
    var excludesFileTypes: [FBFileType]?
    
    var excludesFilepaths: [NSURL]?
    
    let fileManager = NSFileManager.defaultManager()
    
    func documentsURL() -> NSURL {
        return fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
    }
    
    func filesForDirectory(directoryPath: NSURL) -> [FBFile]  {
        var files = [FBFile]()
        var filePaths = [NSURL]()
        // Get contents
        do  {
            filePaths = try self.fileManager.contentsOfDirectoryAtURL(directoryPath, includingPropertiesForKeys: [], options: [.SkipsHiddenFiles])
        } catch {
            return files
        }
        // Parse
        for filePath in filePaths {
            let file = FBFile(filePath: filePath)
            if let excludesFileTypes = excludesFileTypes where excludesFileTypes.contains(file.type) {
                continue
            }
            if let excludesFilepaths = excludesFilepaths where excludesFilepaths.contains(file.filePath) {
                continue
            }
            if file.displayName.isEmpty == false {
                files.append(file)
            }
        }
        // Sort
        files = files.sort(){$0.displayName < $1.displayName}
        return files
    }

}
