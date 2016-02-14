//
//  FBFile.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// FBFile is a class representing a file in FileBrowser
public class FBFile: NSObject {
    /// Display name. String.
    public let displayName: String
    // is Directory. Bool.
    public let isDirectory: Bool
    /// File extension.
    public let fileExtension: String?
    /// NSURL file path.
    public let filePath: NSURL
    // FBFileType
    public let type: FBFileType
    
    /**
     Initialize an FBFile object with a filePath
     
     - parameter filePath: NSURL filePath
     
     - returns: FBFile object.
     */
    init(filePath: NSURL) {
        var displayName = filePath.lastPathComponent
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
                displayName = displayName?.stringByReplacingOccurrencesOfString(".\(fileExtension)", withString: "")
            }
            else {
                self.type = .Default
            }
        }
        if let displayName = displayName {
            self.displayName = displayName
        }
        else {
            self.displayName = String()
        }
    }
}

/**
 FBFile type
 */
public enum FBFileType: String {
    /// Directory
    case Directory = "directory"
    /// GIF file
    case GIF = "gif"
    /// JPG file
    case JPG = "jpg"
    /// PDF file
    case PDF = "pdf"
    /// PNG file
    case PNG = "png"
    /// ZIP file
    case ZIP = "zip"
    /// Any file
    case Default = "file"
    
    /**
     Get representative image for file type
     
     - returns: UIImage for file type
     */
    public func image() -> UIImage? {
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

/**
 Check if file path NSURL is directory or file.
 
 - parameter filePath: NSURL file path.
 
 - returns: isDirectory Bool.
 */
func checkDirectory(filePath: NSURL) -> Bool {
    var isDirectory = false
    do {
        var resourceValue: AnyObject?
        try filePath.getResourceValue(&resourceValue, forKey: NSURLIsDirectoryKey)
        if let number = resourceValue as? NSNumber where number == true {
            isDirectory = true
        }
    }
    catch { }
    return isDirectory
}
