//
//  FolderEditorViewController.swift
//  FileBrowser
//
//  Created by test on 4/3/17.
//  Copyright © 2017 Roy Marmelstein. All rights reserved.
//

import Foundation

class FolderEditorTableView : FileListViewController
{
    //MARK: Lifecycle
    func configureToolBars()
    {
		
		self.setToolbarItems(self.navigationToolItems(), animated: true)
		
		
		//self.toolbar = self.navigationController.toolbar;
		//self.navigationBar = self.navigationController.navigationBar;
		//self.navigationBarSuperView = self.navigationBar.superview;
		
		let hideBarsWithGestures = true;
		
		self.navigationController?.hidesBarsOnSwipe = hideBarsWithGestures;
		self.navigationController?.hidesBarsWhenKeyboardAppears = hideBarsWithGestures;
		self.navigationController?.hidesBarsWhenVerticallyCompact = hideBarsWithGestures;
		
//		if (self.hideBarsWithGestures) {
//			[self.navigationBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
//			[self.navigationBar addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
//			[self.navigationBar addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:&DZNWebViewControllerKVOContext];
//		}
		
		//if (!DZN_IS_IPAD && self.navigationController.toolbarHidden && self.toolbarItems.count > 0) {
		if (self.navigationController?.isToolbarHidden ?? false) && ((self.toolbarItems?.count ?? 0) > 0)
		{
			self.navigationController?.setToolbarHidden(false, animated: false)
		}
		//}
    }
	
	@objc func select(button: UIBarButtonItem = UIBarButtonItem()) {
		self.setEditing(true, animated:true)
	}


	func navigationToolItems() -> [UIBarButtonItem]
	{
		var items = [UIBarButtonItem]()
		
		items.append( UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FolderEditorTableView.select(button:))))
		
		return items
	}

	
    convenience init (dataSource: FileBrowserDataSource, withDirectory directory: FBFile) {
		self.init(nibName: "FileBrowser", bundle: Bundle(for: FileListViewController.self))
		self.edgesForExtendedLayout = UIRectEdge()
		
		// Set implicitly unwrapped optionals
		self.dataSource = dataSource
		self.directory = directory
		
		self.title = directory.displayName
		
		// Set search controller delegates
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.delegate = self
		
		// Add dismiss button
		let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FileListViewController.dismiss(button:)))
		self.navigationItem.rightBarButtonItem = dismissButton
		
        // Add dismiss button
        //let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FileListViewController.dismiss(button:)))
        //self.navigationItem.rightBarButtonItem = dismissButton
  
        // Create toolbar
        self.configureToolBars()
    }
    
    // create toolbar with select button
    
    // changes to edit commands
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    
    // allow editing
}
