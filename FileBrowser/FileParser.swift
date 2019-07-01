//
//  FileParser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 13/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

class FileParser {

    enum DefaultExtensionVisibilityType {
        case Allow
        case Deny
    }
    
    static let sharedInstance = FileParser()

    var _defaultExtensionVisibilityType = DefaultExtensionVisibilityType.Allow
    var _excludesFileExtensions = [String]()
    var _includesFileExtensions = [String]()
    
    /// Mapped for case insensitivity
    var excludesFileExtensions: [String]? {
        get {
            return _excludesFileExtensions.map({$0.lowercased()})
        }
        set {
            if let newValue = newValue {
                _defaultExtensionVisibilityType = .Allow
                _excludesFileExtensions = newValue
            }
        }
    }

    var includesFileExtensions: [String]? {
        get {
            return _includesFileExtensions.map({$0.lowercased()})
        }
        set {
            if let newValue = newValue {
                _defaultExtensionVisibilityType = .Deny
                _includesFileExtensions = newValue
            }
        }
    }
    
    var _excludesFilepaths: [URL]?
    var _includesFilepaths: [URL]?

    var excludesFilepaths : [URL]? {
        get {
            return _excludesFilepaths
        }
        set {
            if let newValue = newValue {
                _defaultExtensionVisibilityType = .Allow
                _excludesFilepaths = newValue
            }
        }
    }

    var includesFilepaths : [URL]? {
        get {
            return _includesFilepaths
        }
        set {
            if let newValue = newValue {
                _defaultExtensionVisibilityType = .Deny
                _includesFilepaths = newValue
            }
        }
    }
    
    let fileManager = FileManager.default
    
    func documentsURL() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }
    
    func filesForDirectory(_ directoryPath: URL) -> [FBFile]  {
        var files = [FBFile]()
        var filePaths = [URL]()
        // Get contents
        do  {
            filePaths = try self.fileManager.contentsOfDirectory(at: directoryPath, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
        } catch {
            return files
        }

        // Parse
        switch _defaultExtensionVisibilityType {
            /// if user set excludesFileExtensions, default is allowed all files
        case .Allow :
            for filePath in filePaths {
                let file = FBFile(filePath: filePath)
                if let excludesFileExtensions = excludesFileExtensions, let fileExtensions = file.fileExtension , excludesFileExtensions.contains(fileExtensions) {
                    continue
                }
                if let excludesFilepaths = excludesFilepaths , excludesFilepaths.contains(file.filePath) {
                    continue
                }
                if file.displayName.isEmpty == false {
                    files.append(file)
                }
            }
            break

        case .Deny :
            for filePath in filePaths {
                let file = FBFile(filePath: filePath)
                if let includesFileExtensions = includesFileExtensions, let fileExtensions = file.fileExtension , includesFileExtensions.contains(fileExtensions) {
                    if file.displayName.isEmpty == false {
                        files.append(file)
                    }
                    continue
                }
                if let includesFilepaths = includesFilepaths , includesFilepaths.contains(file.filePath) {
                    if file.displayName.isEmpty == false {
                        files.append(file)
                    }
                    continue
                }
            }
            break
        }
        // Sort
        files = files.sorted(){$0.displayName < $1.displayName}
        return files
    }

}
