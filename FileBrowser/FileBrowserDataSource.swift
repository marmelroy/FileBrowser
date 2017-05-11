//
//  FileBrowserDataSource.swift
//  FileBrowser
//
//  Created by Carl Julius Gödecken on 28/12/2016.
//  Copyright © 2016 Carl Julius Gödecken.
//

import Foundation

public protocol FileBrowserDataSource {
    var rootDirectory: FBFile { get }
    func provideContents(ofDirectory directory: FBFile, callback: @escaping (FBResult<[FBFile]>) -> ())
    
    func data(forFile file: FBFile) throws -> Data
    
    var excludesFileExtensions: [String]? { get set }
    var excludesFilepaths: [URL]? { get set }
}

extension FileBrowserDataSource {
    public func data(forFile file: FBFile) throws -> Data {
        let url = file.resourceUrl!
        return try Data(contentsOf: url)
    }
}
