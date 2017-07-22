//
//  FileParser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 13/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

class LocalFileParser: FileBrowserDataSource {
    
    var excludesFileExtensions: [String]? = nil
    var excludesFilepaths: [URL]? = nil
    var excludesWithEmptyFilenames = false
    
    
    let fileManager = FileManager.default
    
    var customRootUrl: URL?
    var defaultRootUrl: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }
    
    var rootDirectory: FBFile {
        let url = customRootUrl ?? defaultRootUrl
        return BasicFBFile(path: url)
    }
    
    func provideContents(ofDirectory directory: FBFile, callback: @escaping (FBResult<[FBFile]>) -> ()) {
        
        // Get contents
        do {
            let filePaths = try self.fileManager.contentsOfDirectory(at: directory.path, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
            
            
            // Filter
            var files = filePaths.map(BasicFBFile.init)
            if let excludesFileExtensions = excludesFileExtensions {
                let lowercased = excludesFileExtensions.map { $0.lowercased() }
                files = files.filter { !lowercased.contains($0.fileExtension?.lowercased() ?? "") }
            }
            if let excludesFilepaths = excludesFilepaths {
                files = files.filter { !excludesFilepaths.contains($0.path) }
            }
            
            // Sort
            files = files.sorted(){$0.displayName < $1.displayName}
            callback(.success(files))
        } catch let error {
            callback(.error(error))
            return
        }
    }
    
    func attributes(ofItemWithUrl fileUrl: URL) -> NSDictionary? {
        let path = fileUrl.path
        do {
            let attributes = try fileManager.attributesOfItem(atPath: path) as NSDictionary
            return attributes
        } catch {
            return nil
        }
    }
    
    func dataURL(forFile file: FBFile) throws -> URL {
        return file.path
    }


}
