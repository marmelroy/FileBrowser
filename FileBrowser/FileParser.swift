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
            if file.fileName.isEmpty == false {
                files.append(file)
            }
        }
        // Sort
        files = files.sort(){$0.fileName < $1.fileName}
        return files
    }

}

public class FBFile: NSObject {
    public let filePath: NSURL
    public let fileName: String
    public let isDirectory: Bool
    public let fileExtension: String?
    public let type: FBFileType
    
    init(filePath: NSURL) {
        var fileName = filePath.lastPathComponent
        self.filePath = filePath
        let isDirectory = checkDirectory(filePath)
        self.isDirectory = isDirectory
        if self.isDirectory {
            self.fileExtension = nil
            self.type = .Directory
        }
        else {
            self.fileExtension = self.filePath.pathExtension
            if let fileExtension = fileExtension {
                self.type = FBFileType(rawValue: fileExtension) ?? .Default
                fileName = fileName?.stringByReplacingOccurrencesOfString(".\(fileExtension)", withString: "")
            }
            else {
                self.type = .Default
            }
        }
        if let fileName = fileName {
            self.fileName = fileName
        }
        else {
            self.fileName = String()
        }
    }
}

public enum FBFileType: String {
    case Directory = "directory"
    case GIF = "gif"
    case JPG = "jpg"
    case PDF = "pdf"
    case PNG = "png"
    case ZIP = "zip"
    case Default = "file"
    
    func image() -> UIImage? {
        let bundle =  NSBundle(forClass: FileParser.self)
        var fileName = String()
        switch self {
        case Directory: fileName = "folder@2x.png"
        case JPG, PNG, GIF: fileName = "image@2x.png"
        case PDF: fileName = "pdf@2x.png"
        case ZIP: fileName = "zip@2x.png"
        case Default: fileName = "file@2x.png"
        }
        let file = UIImage(named: fileName, inBundle: bundle, compatibleWithTraitCollection: nil)
        return file
    }
}

func checkDirectory(filePath: NSURL) -> Bool {
    var isDirectory = false
    do {
        var resourceValue: AnyObject?
        try filePath.getResourceValue(&resourceValue, forKey: NSURLIsDirectoryKey)
        if let number = resourceValue as? NSNumber {
            if number == true {
                isDirectory = true
            }
        }
    }
    catch { }
    return isDirectory
}
