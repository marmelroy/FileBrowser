//
//  FileDetailViewController.swift
//  FileBrowser
//
//

import Foundation

class FileDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	// Table Rows
	
	// File Name (tap to rename)
	// File Size
	// File Creation date
	// File modification date
	// File added date
	// Last viewed date
	// Move action
	// Copy action
	// Duplicate action
	// Delete Action
	
	
	// TableView
	@IBOutlet weak var tableView: UITableView!
	
	/// Data
	var file: FBFile!
	
	//MARK: Lifecycle
	
	convenience init (file: FBFile) {
		self.init(nibName: "FileBrowser", bundle: Bundle(for: FileDetailViewController.self))
		self.edgesForExtendedLayout = UIRectEdge()
		
		self.title = file.displayName
		self.file = file;
		
		// Add dismiss button
		let dismissButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FileListViewController.dismiss(button:)))
		self.navigationItem.rightBarButtonItem = dismissButton
		
	}
	
//	deinit{
//		
//	}
	
	//MARK: UIViewController
	
	override func viewDidLoad() {
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Make sure navigation bar is visible
		self.navigationController?.isNavigationBarHidden = false
		
		
	}
	
	@objc func dismiss(button: UIBarButtonItem = UIBarButtonItem()) {
		self.dismiss(animated: true, completion: nil)
	}
	
	//MARK: Data
	
	
	//MARK: UITableViewDataSource, UITableViewDelegate
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "FileDetailCell"
		let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
		var cell = reuseCell
		if cell == nil
		{
			cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
		}
		cell!.selectionStyle = .blue
		cell!.textLabel?.text = file.displayName
		cell!.imageView?.image = file.type.image()
		
		cell!.textLabel?.adjustsFontSizeToFitWidth = true
		cell!.textLabel?.minimumScaleFactor = 0.5
		
		if #available(iOS 9, *) {
			cell!.textLabel?.allowsDefaultTighteningForTruncation = true
		} else {
		}
		
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return nil;
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return nil;
	}
	

}

