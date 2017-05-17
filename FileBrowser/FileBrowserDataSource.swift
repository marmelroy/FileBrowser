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
    func provideContents(ofDirectory directory: FBFile, callback: @escaping (Result<[FBFile]>) -> ())
    
    func attributes(ofItemWithUrl fileUrl: URL) -> NSDictionary?
    func data(forFile file: FBFile) throws -> Data
    func dataURL(forFile file: FBFile) throws -> URL
    
    var excludesFileExtensions: [String]? { get set }
    var excludesFilepaths: [URL]? { get set }
}

extension FileBrowserDataSource {
    public func data(forFile file: FBFile) throws -> Data {
        let url = try dataURL(forFile: file)
        return try Data(contentsOf: url)
    }
	
	public func fileInSameDirectory(after file: FBFile, callback: @escaping (Result<FBFile>)->())
	{
		provideContents(ofDirectory: file.enclosingDirectory()) { result in
			switch result {
			case .success(let files):
				var foundFile: Bool = false
				var hasNextFile: Bool = false
				for testFile in files
				{
					if testFile == file
					{
						foundFile = true
					}
					else if foundFile
					{
						callback(.success(testFile))
						hasNextFile = true
						break
					}
				}
				if foundFile == false
				{
					callback(.error(NSError(domain: "Could not find file.", code: 1)))
				}
				else if hasNextFile == false
				{
					callback(.error(NSError(domain: "last file.", code: 1)))
				}
			case .error(let error):
				callback(.error(error))
			}
		}

	}
	
	public func fileInSameDirectory(before file: FBFile, callback: @escaping (Result<FBFile>)->())
	{
		provideContents(ofDirectory: file.enclosingDirectory()) { result in
			switch result {
			case .success(let files):
				var foundFile: Bool = false
				var lastFile: FBFile? = nil
				for testFile in files
				{
					if testFile == file
					{
						foundFile = true
						if let lastFile = lastFile
						{
							callback(.success(lastFile))
							break
						}
					}
					
					lastFile = testFile
				}
				if foundFile == false
				{
					callback(.error(NSError(domain: "Could not find file.", code: 1)))
				}
				else if lastFile == nil
				{
					callback(.error(NSError(domain: "first file.", code: 1)))
				}
			case .error(let error):
				callback(.error(error))
			}
		}

	}
}
