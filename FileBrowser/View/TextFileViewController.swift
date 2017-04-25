//
//  TextFileViewController.swift
//  FileBrowser
//
//

import Foundation

class TextFileViewController : UIViewController
{
	var file: FBFile!
	var state: FileBrowserState!
	
	var scrollView : UIScrollView!
	var textView : UITextView!
	
	convenience init (file: FBFile, state: FileBrowserState) {
		self.init(nibName: "WebviewPreviewViewContoller", bundle: Bundle(for: ImageViewController.self))
		self.file = file
		self.state = state
		self.title = file.displayName
		
		//let configuration = URLSessionConfiguration.default
		//session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Prevent loading of too large of files
		textView = UITextView(frame: view.bounds)
		
		do
		{
			textView.text = try NSString(contentsOfFile: file.path.path, usedEncoding: nil) as String!
			textView.isEditable = true
			textView.isUserInteractionEnabled = true
		}
		catch
		{
			// unable to load text file
			print("Unable to read file. \(error)")
		}
		
		self.view.addSubview(textView)
		
		
		// Add share button
		//let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WebviewPreviewViewContoller.shareFile(sender:)))
		//self.navigationItem.rightBarButtonItem = shareButton
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Add toolbar items to this view
		var toolbarItems = [UIBarButtonItem]()
		
		toolbarItems.append(UIBarButtonItem(title: "QL", style: .plain, target: self, action: #selector(TextFileViewController.qlAction(button:))))
		
		toolbarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
		
		toolbarItems.append(UIBarButtonItem(title: "Details", style: .plain, target: self, action: #selector(TextFileViewController.detailsAction(button:))))

		toolbarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
		
		toolbarItems.append(UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(TextFileViewController.saveAction(button:))))

		self.setToolbarItems(toolbarItems, animated: false);
		
		self.navigationController?.hidesBarsOnTap = true
		
		// Make sure navigation bar is visible
		self.navigationController?.isNavigationBarHidden = false
		self.navigationController?.setToolbarHidden(false, animated: false)
	}

	@objc func saveAction(button: UIBarButtonItem)
	{
		if let text = textView.text
		{
			do
			{
				try text.write(to: file.path, atomically: true, encoding: String.Encoding.utf8)
			}
			catch
			{
				print ("Failed to write file. Error:\(error)")
			}
		}
	}

	@objc func qlAction(button: UIBarButtonItem)
	{
		let qlController = state.previewManager.quickLookControllerForFile(file, data: nil, fromNavigation: true)
		self.navigationController?.pushViewController(qlController, animated: true)
	}
	
	@objc func detailsAction(button: UIBarButtonItem) {
		let detailViewController = FileDetailViewController(file: file, state: state, fromImageViewer: true)
		self.navigationController?.pushViewController(detailViewController, animated: true)
	}
}
