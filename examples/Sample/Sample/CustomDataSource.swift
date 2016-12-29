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
    
    
    public func contents(ofDirectory directory: FBFile) throws -> [FBFile] {
        // traverse the file tree outlined in the JSON file to find the directory
        let pathComponents = Array(directory.path.pathComponents.dropFirst())
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
        
        return files
    }
    
    public func attributes(ofItemWithUrl fileUrl: URL) -> NSDictionary? {
        return nil
    }
    
    
    public func dataURL(forFile file: FBFile) throws -> URL {
        return file.fileLocation!
    }
    
}

//extension URL {
//    func relativeTo(baseUrl: URL) -> URL {
//        
//        let keep = self.pathComponents.dropFirst(baseUrl.pathComponents.count)
//        return keep.fir
//    }
//}
