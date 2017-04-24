//
//  ImageViewController.swift
//  FileBrowser
//
//

import Foundation


class ImageViewController: UIViewController, UIScrollViewDelegate {
	
	var file: FBFile!
	
	var imageView : UIImageView!
	var scrollView : UIScrollView!
	
	
	convenience init (file: FBFile) {
		self.init(nibName: "WebviewPreviewViewContoller", bundle: Bundle(for: ImageViewController.self))
		self.file = file
		self.title = file.displayName
		
		//let configuration = URLSessionConfiguration.default
		//session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var image : UIImage?
		if let fileString = file.fileLocation?.path
		{
			image = UIImage(contentsOfFile: fileString)
		}
		scrollView = UIScrollView(frame:self.view.frame)
		scrollView.maximumZoomScale = 4
		scrollView.minimumZoomScale = 0.5
		
		//Setting up the scrollView
		scrollView.bouncesZoom = true
		scrollView.delegate = self
		scrollView.clipsToBounds = true
		
		//Setting up the imageView
		imageView = UIImageView(image: image)
		imageView.autoresizingMask = [.flexibleWidth , .flexibleHeight , .flexibleLeftMargin , .flexibleRightMargin]

		//Adding the imageView to the scrollView as subView
		scrollView.addSubview(imageView)
		scrollView.contentSize = CGSize(width:imageView.bounds.size.width, height:imageView.bounds.size.height)
		scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
		
		scrollView.zoomScale = 1.0;
		scrollView.contentMode = .scaleAspectFit;
		imageView.sizeToFit()
		scrollView.contentSize = CGSize(width: imageView.frame.size.width, height: imageView.frame.size.height)

		
		
		self.view.addSubview(scrollView)
		

		
		// Add share button
		//let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WebviewPreviewViewContoller.shareFile(sender:)))
		//self.navigationItem.rightBarButtonItem = shareButton
	}
	
	 public func viewForZooming(in scrollView: UIScrollView) -> UIView?
	{
		return self.imageView;
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Add toolbar items to this view
		var toolbarItems : [UIBarButtonItem]
		
		if self.toolbarItems != nil
		{
			toolbarItems = self.toolbarItems!
		}
		else
		{
			toolbarItems = [UIBarButtonItem]()
		}
		//			= self.toolbarItems;
		//var ti = [UIBarButtonItem]()
		
		//ti += toolbarItems
		toolbarItems.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(ImageViewController.trashAction(button:))))
		
		self.setToolbarItems(toolbarItems, animated: false);
	}
	
	@objc func trashAction(button: UIBarButtonItem = UIBarButtonItem()) {
		print("Trash this")
	}
}
