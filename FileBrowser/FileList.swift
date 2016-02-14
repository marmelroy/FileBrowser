//
//  FileList.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

class FileList: UIViewController {
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    let collation = UILocalizedIndexedCollation.currentCollation()
    
    /// Data
    var didSelectFile: ((File) -> ())?
    var files = [File]()
    var initialPath: NSURL?
    let parser = FileParser.sharedInstance
    let previewManager = PreviewManager()
    var sections: [[File]] = []

    // Search controller
    var filteredFiles = [File]()
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.backgroundColor = UIColor.whiteColor()
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    
    //MARK: Lifecycle
    
    convenience init (initialPath: NSURL) {
        self.init(nibName: "FileBrowser", bundle: NSBundle(forClass: FileList.self))
        self.edgesForExtendedLayout = .None
        
        // Set initial path
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
        
        // Set search controller delegates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        // Add dismiss button
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismiss")
        self.navigationItem.rightBarButtonItem = dismissButton
        
    }
    
    deinit{
        if #available(iOS 9.0, *) {
            searchController.loadViewIfNeeded()
        } else {
            searchController.loadView()
        }
    }
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        
        // Prepare data
        if let initialPath = initialPath {
            files = parser.filesForDirectory(initialPath)
            indexFiles()
        }
        
        // Set search bar
        tableView.tableHeaderView = searchController.searchBar
        
        // Register for 3D touch
        self.registerFor3DTouch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.contentOffset = CGPointMake(0, searchController.searchBar.frame.size.height)
        self.navigationController?.navigationBarHidden = false
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    

}

