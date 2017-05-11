//
//  FileBrowserDownloadDelegate.swift
//  FileBrowser
//
//  Created by Carl Gödecken on 09.05.17.
//  Copyright © 2017 Carl Gödecken.
//

import Foundation

public protocol FileBrowserDownloadDelegate {
    /// option to provide custom URLs before the download starts
    /// called only if the fileLocation for a file is not set
    func provideCustomDownloadUrl(for file: FBFile, completionHandler: @escaping (FBResult<URL>) -> ())
    
    /// customization point e.g. for setting custom headers
    func willPerformDownloadTask(for file: FBFile, using request: inout URLRequest)
    
    /// may be used to validate the response and throw errors before the file is displayed
    func didFinishDownloading(data: Data, for file: FBFile, for task: URLSessionDownloadTask) throws
}

extension FileBrowserDownloadDelegate {
    func provideCustomDownloadUrl(for file: FBFile, completionHandler: @escaping (FBResult<URL>) -> ()) {
        if let url = file.fileLocation {
            completionHandler(.success(url))
        } else {
            completionHandler(.error(FileBrowserDownloadError.noFileUrlGiven))
        }
    }
    
    func didFinishDownloading(data: Data, for file: FBFile, for task: URLSessionDownloadTask) throws {}
}

enum FileBrowserDownloadError: Error {
    case noFileUrlGiven
}
