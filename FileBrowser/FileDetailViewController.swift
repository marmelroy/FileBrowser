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
	// Rename action
	// Move action
	// Copy action
	// Duplicate action
	// Delete Action
	private static let MOVE_ACTION = 1
	private static let COPY_ACTION = 2
	private static let DELETE_ACTION = 3
	private static let RENAME_ACTION = 0
	
	
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
	
	func setupInfoCellForRow( row: Int, cell: UITableViewCell )
	{
		switch row {
		case 0:
			cell.textLabel?.text = "Name"
			cell.detailTextLabel?.text = file.displayName
			break;
		case 1:
			cell.textLabel?.text = "Size"
			cell.detailTextLabel?.text = "\(file.getFileSize()) bytes"
			break;
		case 2:
			cell.textLabel?.text = "Created"
			cell.detailTextLabel?.text = file.getCreationDate().description
			break;
		case 3:
			cell.textLabel?.text = "Modified"
			cell.detailTextLabel?.text = file.getModificationDate().description
			break;
		default:
			break;
		}
		cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
		cell.detailTextLabel?.minimumScaleFactor = 0.5
	}
	
	func buttonTextForRow( row: Int ) -> String{
		switch row {
		case FileDetailViewController.RENAME_ACTION:
			return "Rename"
		case FileDetailViewController.MOVE_ACTION:
			return "Move"
		case FileDetailViewController.COPY_ACTION:
			return "Copy"
		case FileDetailViewController.DELETE_ACTION:
			return "Delete"
		default:
			return ""
		}
	}
	
	//MARK: UITableViewDataSource, UITableViewDelegate
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell : UITableViewCell
		
		if indexPath.section == 0
		{
		
			let cellIdentifier = "FileDetailCell"
			let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
			
			if reuseCell != nil
			{
				cell = reuseCell!
			}
			else
			{
				cell = UITableViewCell(style: .value2, reuseIdentifier: cellIdentifier)
			}
			
			cell.selectionStyle = .none
			setupInfoCellForRow(row: indexPath.row, cell: cell)
			//		cell.imageView?.image = file.type.image()
			//cell.layer.borderColor
			
		}
		else
		{
			// buttons
			let cellIdentifier = "FileDetailButtonCell"
			let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
			
			if reuseCell != nil
			{
				cell = reuseCell!
			}
			else
			{
				cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
			}
			
			cell.selectionStyle = .blue
			cell.textLabel?.text = buttonTextForRow(row: indexPath.row)
			cell.textLabel?.textAlignment = .center
			cell.textLabel?.textColor = .blue
			
		}
		
		cell.textLabel?.adjustsFontSizeToFitWidth = true
		cell.textLabel?.minimumScaleFactor = 0.5
		
		if #available(iOS 9, *) {
			cell.textLabel?.allowsDefaultTighteningForTruncation = true
		} else {
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		if indexPath.section == 1
		{
			switch indexPath.row
			{
			case FileDetailViewController.RENAME_ACTION:
				
			break;
			case FileDetailViewController.DELETE_ACTION:
				break;
			default:
				break;
			}
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section
		{
		case 0:
			return "File Information"
		case 1:
			return "Actions"
		default:
			return nil;
		}
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return nil;
	}
	

}

