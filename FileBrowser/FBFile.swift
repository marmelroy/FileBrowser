//
//  FBFile.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import UIKit

/// FBFile is a class representing a file in FileBrowser
open class FBFile: NSObject {
    /// Display name. String.
    open var displayName: String
    // is Directory. Bool.
    open let isDirectory: Bool
    /// File extension.
    open let fileExtension: String?
    /// File attributes (including size, creation date etc).
    //open let fileAttributes: NSDictionary? = nil
    
    /// Describes where the resource can be found. May be a file:// or http[s]:// URL
    open var fileLocation: URL?
    // FBFileType
    open var type: FBFileType
    
    /// Describes the path in the current file system, e.g. /dir/file.txt
    open let path: URL
    
    /**
     Initialize an FBFile object with a filePath
     
     - parameter filePath: NSURL filePath
     
     - returns: FBFile object.
     */
    public init(path: URL) {
        self.path = path
        self.fileLocation = path
        self.isDirectory = checkDirectory(path)
        
        if self.isDirectory {
            self.fileExtension = nil
            self.type = .Directory
        }
        else {
            if path.pathExtension != "" {
                self.fileExtension = path.pathExtension
                self.type = FBFileType(rawValue: fileExtension!) ?? .Default
            } else {
                self.fileExtension = nil
                self.type = .Default
            }
        }
        self.displayName = path.lastPathComponent
    }
    
    public var isRemoteFile: Bool {
        return fileLocation?.scheme == "http" || fileLocation?.scheme == "https"
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
    /// PLIST file
    case JSON = "json"
    /// PDF file
    case PDF = "pdf"
    /// PLIST file
    case PLIST = "plist"
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
        let bundle = Bundle(for: FBFile.self)
        var fileName = String()
        switch self {
        case .Directory: fileName = "folder@2x.png"
        case .JPG, .PNG, .GIF: fileName = "image@2x.png"
        case .PDF: fileName = "pdf@2x.png"
        case .ZIP: fileName = "zip@2x.png"
        default: fileName = "file@2x.png"
        }
        let file = UIImage(named: fileName, in: bundle, compatibleWith: nil)
        return file
    }
}

/**
 Check if file path NSURL is directory or file.
 
 - parameter filePath: NSURL file path.
 
 - returns: isDirectory Bool.
 */
func checkDirectory(_ filePath: URL) -> Bool {
    if #available(iOS 9.0, *) {
        return filePath.hasDirectoryPath
    }
    var isDirectory = false
    do {
        var resourceValue: AnyObject?
        try (filePath as NSURL).getResourceValue(&resourceValue, forKey: URLResourceKey.isDirectoryKey)
        if let number = resourceValue as? NSNumber , number == true {
            isDirectory = true
        }
    }
    catch { }
    return isDirectory
}
