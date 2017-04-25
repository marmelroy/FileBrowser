//
//  LoadingViewController.swift
//  FileBrowser
//
//  Created by Carl Julius Gödecken on 29/12/2016.
//  Copyright © 2016 Carl Julius Gödecken.
//

import Foundation
import QuickLook


class LoadingViewController: UIViewController, URLSessionDownloadDelegate, URLSessionDataDelegate {
    //MARK: Lifecycle
    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    
    var downloadTask: URLSessionDownloadTask?
    var session: URLSession!
    
    var file: FBFile!
    convenience init (file: FBFile) {
        self.init(nibName: "LoadingViewController", bundle: Bundle(for: LoadingViewController.self))
        self.file = file
        self.title = file.displayName
        
        let configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
//    var request: DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.setProgress(0, animated: false)
        guard let fileLocation = file.fileLocation else {
            print("Error: File has no fileLocation set")
            return
        }
 
        downloadTask = session.downloadTask(with: fileLocation)
        downloadTask!.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        downloadTask?.cancel()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        downloadTask?.cancel()
        navigationController?.popViewController(animated: true)
    }
    
    func showFile(data: Data?) {
        let previewManager = PreviewManager()
        let controller = previewManager.previewViewControllerForFile(self.file, data: data, fromNavigation: true, state: FileBrowserState(dataSource: LocalFileBrowserDataSource()))
        DispatchQueue.main.async {
            if let nav = self.navigationController {
                //nav.pushViewController(controller, animated: true)
                
                var viewControllers = nav.viewControllers
                viewControllers.removeLast(1)
                viewControllers.append(controller)
                nav.setViewControllers(viewControllers, animated: true)
                
            } else {
                self.present(controller, animated: true, completion: nil)
            }
            if let ql = (controller as? QLPreviewController) ?? (controller as? PreviewTransitionViewController)?.quickLookPreviewController {
                // fix for dataSource magically disappearing because hey let's store it in a weak variable in QLPreviewController
                ql.dataSource = previewManager
                ql.reloadData()
            }
        }
    }
    
    func show(error: Error) {
        DispatchQueue.main.async {
            self.cancelButton.isHidden = true
            self.progressView.isHidden = true
            self.errorLabel.text = error.localizedDescription
            self.errorLabel.isHidden = false
        }
    }
    
    //MARK: URLSession

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            show(error: error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            self.showFile(data: data)
        } catch let error {
            print(error)
            show(error: error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten / totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error, (error as? NSError)?.code != NSURLErrorCancelled {
            show(error: error)
        }
        session.finishTasksAndInvalidate()
    }
}

