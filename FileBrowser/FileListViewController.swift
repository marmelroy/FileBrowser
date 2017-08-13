//
//  FileListViewController.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

class FileListViewController: UIViewController {
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
	var refreshControl: UIRefreshControl?
    
    /// Data
    var directory: FBFile!
	var fileBrowserState: FileBrowserState!
	
    var files = [FBFile]()
    var sections: [[FBFile]] = []

    // Search controller
    var filteredFiles = [FBFile]()
    var searchController: UISearchController?
    
    
    //MARK: Lifecycle
    
	convenience init (state: FileBrowserState, withDirectory directory: FBFile) {
        self.init(nibName: "FileBrowser", bundle: Bundle(for: FileListViewController.self))
        self.edgesForExtendedLayout = UIRectEdge()
        
        // Set implicitly unwrapped optionals
        self.fileBrowserState = state
        self.directory = directory
		
        self.title = directory.displayName
		
		if( fileBrowserState.allowSearch )
		{
			let searchController = UISearchController(searchResultsController: nil)
			searchController.searchBar.searchBarStyle = .minimal
			searchController.searchBar.backgroundColor = UIColor.white
			searchController.dimsBackgroundDuringPresentation = false
			
			// Set search controller delegates
			searchController.searchResultsUpdater = self
			searchController.searchBar.delegate = self
			searchController.delegate = self
			self.searchController = searchController
		}
		
        // Add dismiss button
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FileListViewController.dismiss(button:)))
        self.navigationItem.rightBarButtonItem = dismissButton
        
    }
    
    deinit{
		if let searchController = self.searchController
		{
			if #available(iOS 9.0, *) {
				searchController.loadViewIfNeeded()
			} else {
				searchController.loadView()
			}
		}
    }
		
    //MARK: UIViewController
    
    override func viewDidLoad() {
        
		// Create pull to refresh
		refreshControl = UIRefreshControl()
		refreshControl?.attributedTitle = NSAttributedString(string: "Pull To Refresh")
		refreshControl?.addTarget(self, action: #selector(FileListViewController.prepareData(sender:)), for: .valueChanged)
		if #available(iOS 10.0, *) {
			self.tableView.refreshControl = refreshControl
		} else {
			// Fallback on earlier versions
		};
		
		// Prepare data
		//prepareData(sender:nil) // now doing this in view will appear
		
		if let searchController = self.searchController
		{
			// Set search bar
			tableView.tableHeaderView = searchController.searchBar
		}
		tableView.rowHeight = CGFloat(fileBrowserState.options?.List_FileRowCellHeight ?? 44)
		
        // Register for 3D touch
        self.registerFor3DTouch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Scroll to hide search bar
		if let searchController = self.searchController
		{
			if self.tableView.contentOffset.y < searchController.searchBar.frame.size.height
			{
				self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
			}
		}

		if tableView.rowHeight != CGFloat(fileBrowserState.options?.List_FileRowCellHeight ?? 0)
		{
			tableView.rowHeight = CGFloat(fileBrowserState.options?.List_FileRowCellHeight ?? 44)
		}

		// Refresh / load data
		prepareData(sender:nil)
		
		self.navigationController?.hidesBarsOnTap = false
        // Make sure navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
		
		// Notify
		NotificationCenter.default.post(name: FileBrowser.FILE_BROWSER_VIEW_NOTIFICATION, object: self.directory)
    }
    
    @objc func dismiss(button: UIBarButtonItem = UIBarButtonItem()) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Data
	
	@objc func prepareData(sender:UIButton?) {
		if( sender != refreshControl )
		{
			refreshControl?.beginRefreshing()
		}
		refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing")
		// Prepare data
		loadingCompleted = false
		fileBrowserState.dataSource.provideContents(ofDirectory: self.directory) { result in
			self.didCompleteLoading()
			self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to Refresh")
			switch result {
			case .success(let files):
				self.files = files
				self.indexFiles()
				//TODO: Check before reloading data as it removes the selection (save the selection?)
				self.tableView.reloadData()
			case .error(let error):
				self.replaceTableViewRowsShowing(error: error)
			}
			self.refreshControl?.endRefreshing()
		}
		
		// show a loading indicator if it takes more than 0.5 seconds
		//DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
			//self?.showLoadingIndicatorIfNeeded()
		//}

	}
	
    func indexFiles() {
		if fileBrowserState.shouldIncludeIndex()
		{
			let selector = fileBrowserState.sortingSelector()
			sections = Array(repeating: [], count: fileBrowserState.collation.sectionTitles.count)
			let sortedObjects = fileBrowserState.sort(fileList: files)
			for object in sortedObjects {
				let sectionNumber = fileBrowserState.collation.section(for: object, collationStringSelector: selector)
				sections[sectionNumber].append(object)
			}
		}
		else
		{
			sections = Array(repeating: [], count: 1)
			let sortedObjects = fileBrowserState.sort(fileList: files)
			for object in sortedObjects {
				sections[0].append(object)
			}
		}
    }
	
    func fileForIndexPath(_ indexPath: IndexPath) -> FBFile {
        var file: FBFile
        if let searchController = self.searchController, searchController.isActive
		{
            file = filteredFiles[(indexPath as NSIndexPath).row]
        }
        else
		{
            file = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        }
        return file
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFiles = files.filter({ (file: FBFile) -> Bool in
            return file.displayName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func replaceTableViewRowsShowing(error: Error) {
        let errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        errorLabel.text = error.localizedDescription
        errorLabel.textColor = UIColor.black
        errorLabel.textAlignment = .center
        
        tableView.backgroundView = errorLabel
        tableView.separatorStyle = .none
    }
    
    //MARK: loading indicator
    
    var loadingCompleted = false
    func didCompleteLoading() {
        locking(loadingCompleted) {
            loadingCompleted = true
        }
        //hideLoadingIndicator()
    }
//
//    func showLoadingIndicatorIfNeeded() {
//        locking(loadingCompleted) {
//            if !loadingCompleted {
//                //navigationItem.prompt = "Loading..."
//            }
//        }
//    }
//    
//    func hideLoadingIndicator() {
//        navigationItem.prompt = nil
//    }
	
    func locking(_ lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
}

