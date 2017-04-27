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
	
	static let ZOOM_STEP : CGFloat = 2.0
	
	
	convenience init (file: FBFile, state: FileBrowserState) {
		self.init(nibName: "WebviewPreviewViewContoller", bundle: Bundle(for: ImageViewController.self))
		self.file = file
		self.state = state
		self.title = file.displayName
		self.edgesForExtendedLayout = UIRectEdge()
		
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
		//scrollView.contentInset =
		
		scrollView.addSubview(imageView)
		view.addSubview(scrollView)
		
		
		scrollView.delegate = self
		
		setZoomScale( setInitialScale: true )
		
		setupGestureRecognizer()
		//self.automaticallyAdjustsScrollViewInsets = false
		
		// Add share button
		//let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WebviewPreviewViewContoller.shareFile(sender:)))
		//self.navigationItem.rightBarButtonItem = shareButton
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let imageViewSize = imageView.frame.size
		let scrollViewSize = scrollView.bounds.size
		
		let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
		let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
		
		//scrollView.contentMode = .center
		scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
	}
	
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
	
	//MARK: TapDetectingImageViewDelegate methods
	
	func setupGestureRecognizer() {
		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.handleDoubleTap(recognizer:)))
		doubleTap.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTap)
		
		let twoFingerTap = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.handleTwoFingerTap(gestureRecognizer:)))
		twoFingerTap.numberOfTouchesRequired = 2
		scrollView.addGestureRecognizer(twoFingerTap)
	}
	
//	@objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
//		
//		if (scrollView.zoomScale > scrollView.minimumZoomScale) {
//			scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
//		} else {
//			scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
//		}
//	}
	
	
	@objc func handleDoubleTap(recognizer: UIGestureRecognizer) {
		// zoom in
		var newScale = scrollView.zoomScale * ImageViewController.ZOOM_STEP
		
		if (newScale > self.scrollView.maximumZoomScale)
		{
			newScale = self.scrollView.minimumZoomScale
			let zoomRect = zoomRectForScale(newScale, withCenter:recognizer.location(in:recognizer.view));
			
			scrollView.zoom(to:zoomRect, animated:true);
		}
		else
		{
			newScale = self.scrollView.maximumZoomScale;
			let zoomRect = zoomRectForScale(newScale, withCenter:recognizer.location(in:recognizer.view));
			
			scrollView.zoom(to: zoomRect, animated: true);
		}
	}
	
	func handleTwoFingerTap( gestureRecognizer: UIGestureRecognizer) {
		// two-finger tap zooms out
		let newScale = scrollView.zoomScale / ImageViewController.ZOOM_STEP
		let zoomRect = zoomRectForScale(newScale, withCenter:gestureRecognizer.location(in: gestureRecognizer.view))
		scrollView.zoom(to: zoomRect, animated:true);
	}
	
	//MARK: Utility methods
	
	func zoomRectForScale(_ scale :CGFloat, withCenter center:CGPoint)->CGRect {
		
		var zoomRect = CGRect()
		
		// the zoom rect is in the content view's coordinates.
		//    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
		//    As the zoom scale decreases, so more content is visible, the size of the rect grows.
		zoomRect.size.height = scrollView.frame.size.height / scale;
		zoomRect.size.width  = scrollView.frame.size.width  / scale;
		
		// choose an origin so as to get the right center.
		zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
		zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
		
		return zoomRect;
	}
}
