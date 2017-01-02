//
//  CustomDataSource.swift
//  Sample
//
//  Created by Carl Julius Gödecken on 28/12/2016.
//  Copyright © 2016 Carl Julius Gödecken.
//

import Foundation
import FileBrowser

open class CustomDataSource: FileBrowserDataSource {
    
    typealias KeyValue = [String: Any]
    let json: KeyValue
    
    init() {
        let jsonPath = Bundle.main.path(forResource: "folderContent", ofType: "json")!
        let data = try! NSData(contentsOfFile: jsonPath, options: []) as Data
        json = try! JSONSerialization.jsonObject(with: data, options: []) as! KeyValue
    }
    
    public var excludesFileExtensions: [String]? = nil
    public var excludesFilepaths: [URL]? = nil
    public var excludesWithEmptyFilenames = false
        
    let rootUrl = URL(string: "/")!
    public var rootDirectory: FBFile {
        let file = FBFile(path: rootUrl)
        file.displayName = "Home"
        return file
    }
    
    let fileManager = FileManager.default
    
    
    open func provideContents(ofDirectory directory: FBFile, callback: @escaping (Result<[FBFile]>) -> ()) {
        // traverse the file tree outlined in the JSON file to find the directory
        let pathComponents = Array(directory.path.pathComponents.dropFirst())   // we're already in the root directory at the root of our json document
        let directoryDescription = pathComponents.reduce(json) { currentFolder, subfolderName -> KeyValue in
            let content = currentFolder["content"]! as! KeyValue
            return content[subfolderName] as! KeyValue
        }
        
        let files = (directoryDescription["content"] as! KeyValue).map {name, properties -> FBFile in
            let properties = properties as! KeyValue
            let isDirectory = (properties["type"] as? String) == "directory"
            let path = directory.path.appendingPathComponent(name, isDirectory: isDirectory)
            let file = FBFile(path: path)
            if let resourceURLString = properties["location"] as? String, let resourceURL = URL(string: resourceURLString) {
                file.fileLocation = resourceURL
            }
            if let typeName = properties["type"] as? String, let type = FBFileType(rawValue: typeName) {
                file.type = type
            }
            return file
        }
        
        // simulate loading of remote content
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            callback(.success(files))
        })
        
        return
    }
    
    public func attributes(ofItemWithUrl fileUrl: URL) -> NSDictionary? {
        return nil
    }
    
    
    public func dataURL(forFile file: FBFile) throws -> URL {
        return file.fileLocation!
    }
    
}
