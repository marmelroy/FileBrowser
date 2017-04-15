//
//  FileMoveActivity.swift
//  FileBrowser
//
//

import Foundation


class FileMoveActivity : UIActivity
{
	override var activityTitle : String
	{
		return "Move"
	}
	
	override var activityImage: UIImage?
	{
		return nil
	}
	
	override var activityType: UIActivityType
	{
		return UIActivityType("com.FileBrowser.activity.FileMoveActivity")
	}
	
	override var activityViewController: UIViewController?
	{
		//TODO: create view controller to select folder to move to
		
		return nil
	}
	
	override func canPerform(withActivityItems items: [Any] ) -> Bool
	{
		for item in items
		{
			if item is FBFile
			{
				return true
			}
		}
		
		return false
	}
	
	override func prepare(withActivityItems items: [Any] )
	{
		// TODO: create view controller
	}
	
	override func perform() {
		/*
		
		This method is called on your app’s main thread. If your app can complete the activity quickly on the main thread, do so and call the activityDidFinish(_:) method when it is done. If performing the activity might take some time, use this method to start the work in the background and then exit without calling activityDidFinish(_:) from this method. When your background work has completed, call activityDidFinish(_:). You must call activityDidFinish(_:) on the main thread.
		*/
		activityDidFinish(true)
	}
	
	override class var activityCategory: UIActivityCategory
	{
		return .action
	}
}
