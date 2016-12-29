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
    

    
    public var excludesFileExtensions: [String]? = nil
    public var excludesFilepaths: [URL]? = nil
    public var excludesWithEmptyFilenames = false
    
    public var rootDirectory: FBFile {
        return FBFile(filePath: Directory.root.url())
    }
    
    let fileManager = FileManager.default
    
    enum Directory {
        case root
        case imagesFolder
        
        func url() -> URL {
            switch self {
            case .root:
                return URL(string: "/")!
            case .imagesFolder:
                return Directory.root.url().appendingPathComponent("Images", isDirectory: true)
            }
        }
        
        func contentUrls() -> [URL] {
            switch self {
            case .root:
                return [Directory.imagesFolder.url(),
                        self.url().appendingPathComponent("Info.plist"),
                        self.url().appendingPathComponent("Images.zip")]
            case .imagesFolder:
                return [self.url().appendingPathComponent("Baymax.jpg"),
                        self.url().appendingPathComponent("BB8.jpg"),
                        self.url().appendingPathComponent("Stitch.jpg")]
            }
        }
        
        func contents() -> [FBFile] {
            return contentUrls().map(FBFile.init)
        }
    }
    
    public func contents(ofDirectory directory: FBFile) throws -> [FBFile] {
        
        switch(directory.filePath) {
        case Directory.root.url():
            return Directory.root.contents()
        case Directory.imagesFolder.url():
            return Directory.imagesFolder.contents()
        default:
            return []
        }

    }
    
    public func attributes(ofItemWithUrl fileUrl: URL) -> NSDictionary? {
        return nil
    }
    
    
    public func dataURL(forFile file: FBFile) throws -> URL {
        // all the files are contained in the bundle, access them by filename
        let bundleUrl = Bundle.main.resourceURL!
        let filename = file.filePath.lastPathComponent
        return bundleUrl.appendingPathComponent(filename)
    }
    
}
