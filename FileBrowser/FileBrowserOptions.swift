//
//  FileBrowserOptions.swift
//  FileBrowser
//
//

import Foundation

@objc open class FileBrowserOptions : NSObject
{
	// Text File Viewing and Editing
	public var TextFile_textColorDay: UIColor?
	public var TextFile_backgroundColorDay: UIColor?
	public var TextFile_font: UIFont?
	
	public var TextFile_textColorNight: UIColor?
	public var TextFile_backgroundColorNight: UIColor?
	
	public final var Default_TextFile_font: UIFont { get {return UIFont.preferredFont(forTextStyle: .body)} }
	public let Default_TextFile_textColorDay: UIColor = UIColor.black
	public let Default_TextFile_backgroundColorDay: UIColor = UIColor.white
}
