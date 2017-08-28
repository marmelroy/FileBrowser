//
//  FileBrowserDelegate.swift
//  FileBrowser
//
//

import Foundation

@objc public protocol FileBrowserDelegate
{
	func displayOptionsFrom( _ viewController: UIViewController )
	func displayFolderActionsFor( _ directory: FBFile, viewController: UIViewController  )
}
