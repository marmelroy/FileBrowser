//
//  LoadingViewController.swift
//  FileBrowser
//
//  Created by Carl Julius Gödecken on 29/12/2016.
//  Copyright © 2016 Carl Julius Gödecken.
//

import Foundation
import Alamofire
import QuickLook


class LoadingViewController: UIViewController {
    //MARK: Lifecycle
    
    @IBOutlet var progressView: UIProgressView!
    
    
    var file: FBFile!
    convenience init (file: FBFile) {
        self.init(nibName: "LoadingViewController", bundle: Bundle(for: LoadingViewController.self))
        self.file = file
        self.title = file.displayName
    }
    
    var request: DataRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.setProgress(0, animated: false)
        guard let fileLocation = file.fileLocation else {
            print("Error: File has no fileLocation set")
            return
        }
        
        Alamofire
            .request(fileLocation)
            .validate()
            .downloadProgress { progress in
                self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
            }
            .responseData { response in
            switch response.result {
            case .success:
                let data = response.data
                self.showFile(data: data)
            case .failure(let error):
                print(error) // TODO: display the error
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        request?.cancel()
    }
    
    func showFile(data: Data?) {
        let previewManager = PreviewManager()
        let controller = previewManager.previewViewControllerForFile(self.file, data: data, fromNavigation: true)
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
}

