//
//  ImageViewController.swift
//  FileBrowser
//
//

import Foundation


class ImageViewController: UIViewController, UIScrollViewDelegate {
	
	var file: FBFile!
	var state: FileBrowserState!
	
	var imageView : UIImageView!
	var scrollView : UIScrollView!
	var setZoom : Bool = false
	
	
	convenience init (file: FBFile, state: FileBrowserState) {
		self.init(nibName: "WebviewPreviewViewContoller", bundle: Bundle(for: ImageViewController.self))
		self.file = file
		self.state = state
		self.title = file.displayName
		
		//let configuration = URLSessionConfiguration.default
		//session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
	}
	
	func setZoomScale( setInitialScale: Bool = false ) {
		let imageViewSize = imageView.bounds.size
		let scrollViewSize = scrollView.bounds.size
		let widthScale = scrollViewSize.width / imageViewSize.width
		let heightScale = scrollViewSize.height / imageViewSize.height
		
		var minScale = min(widthScale, heightScale)
		var scale : CGFloat = 1.0
		
		if minScale > 1.0
		{
			minScale = 1.0
			scale = min((scrollViewSize.width - 50) / imageViewSize.width, ((scrollViewSize.height-100) / imageViewSize.height))
		}
		else
		{
			scale = minScale
		}
		
		scrollView.minimumZoomScale = minScale
		if setInitialScale
		{
			scrollView.zoomScale = scale
			scrollViewDidZoom(scrollView)
		}
		scrollView.maximumZoomScale = 3.0
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		var image : UIImage?
		if let fileString = file.fileLocation?.path
		{
			image = UIImage(contentsOfFile: fileString)
		}
		
		imageView = UIImageView(image: image)
		
		scrollView = UIScrollView(frame: view.bounds)
		scrollView.backgroundColor = .white
		scrollView.contentSize = imageView.bounds.size
		scrollView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		
		scrollView.addSubview(imageView)
		view.addSubview(scrollView)
		
		
		scrollView.delegate = self
		
		
//		self.view.autoresizesSubviews = true
//		scrollView = UIScrollView(frame:self.view.frame)
//		scrollView.autoresizesSubviews = true
//		self.view.addSubview(scrollView)
//		scrollView.maximumZoomScale = 4
//		scrollView.minimumZoomScale = 0.5
//		
//		//Setting up the scrollView
//		scrollView.bouncesZoom = true
//		scrollView.delegate = self
//		//scrollView.clipsToBounds = true
//		
//		//Setting up the imageView
//		imageView = UIImageView(image: image)
//		imageView.autoresizingMask = [.flexibleWidth , .flexibleHeight , .flexibleLeftMargin , .flexibleRightMargin]
//		imageView.isUserInteractionEnabled = true
//
//		//Adding the imageView to the scrollView as subView
//		scrollView.addSubview(imageView)
//		scrollView.contentSize = CGSize(width:imageView.bounds.size.width, height:imageView.bounds.size.height)
//		scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
//		
//		scrollView.zoomScale = 1.0;
//		scrollView.contentMode = .scaleAspectFit;
//		imageView.sizeToFit()
//		scrollView.contentSize = CGSize(width: imageView.frame.size.width, height: imageView.frame.size.height)

		
		setZoomScale( setInitialScale: true )

		
		// Add share button
		//let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WebviewPreviewViewContoller.shareFile(sender:)))
		//self.navigationItem.rightBarButtonItem = shareButton
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let imageViewSize = imageView.frame.size
		let scrollViewSize = scrollView.bounds.size
		
		let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
		let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
		
		scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
	}
	
//	override var childViewControllerForStatusBarHidden : UIViewController?
//	{
//		return self.navigationController
//	}
	
	override var prefersStatusBarHidden: Bool
	{
		let hidden = self.navigationController?.isNavigationBarHidden ?? false
		
		if scrollView != nil
		{
			let backColor : UIColor = hidden ? .black : .white
			
			if scrollView.backgroundColor != backColor
			{
				scrollView.backgroundColor = backColor
			}
		}

		return hidden
	}
	
	override func viewWillLayoutSubviews() {
	}
	
	override func viewDidLayoutSubviews() {
		if setZoom == false
		{
			setZoomScale( setInitialScale: true )
			setZoom = true
		}
		else
		{
			setZoomScale()
		}
		scrollViewDidZoom( scrollView )
	}
	
	public func viewForZooming(in scrollView: UIScrollView) -> UIView?
	{
		return self.imageView;
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Add toolbar items to this view
		var toolbarItems = [UIBarButtonItem]()
		
//		if self.toolbarItems != nil
//		{
//			toolbarItems = self.toolbarItems!
//		}
//		else
//		{
//			toolbarItems = [UIBarButtonItem]()
//		}
		//			= self.toolbarItems;
		//var ti = [UIBarButtonItem]()
		
		//ti += toolbarItems
		toolbarItems.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(ImageViewController.trashAction(button:))))
		
		toolbarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
		
		toolbarItems.append(UIBarButtonItem(title: "QL", style: .plain, target: self, action: #selector(ImageViewController.qlAction(button:))))

		toolbarItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
		
		toolbarItems.append(UIBarButtonItem(title: "Details", style: .plain, target: self, action: #selector(ImageViewController.detailsAction(button:))))

		self.setToolbarItems(toolbarItems, animated: false);
		
		
		self.navigationController?.hidesBarsOnTap = true
		
		// Make sure navigation bar is visible
		self.navigationController?.isNavigationBarHidden = false
		self.navigationController?.setToolbarHidden(false, animated: false)
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
	
	@objc func trashAction(button: UIBarButtonItem) {
		print("Trash this")
	}
}
