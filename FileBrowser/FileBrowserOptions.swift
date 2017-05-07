//
//  FileBrowserOptions.swift
//  FileBrowser
//
//

import Foundation

@objc open class FileBrowserOptions : NSObject, NSCoding
{
	// Text File Viewing and Editing
	public var TextFile_textColorDay: UIColor?
	public var TextFile_backgroundColorDay: UIColor?
	public var TextFile_font: UIFont?
	
	public var TextFile_textColorNight: UIColor?
	public var TextFile_backgroundColorNight: UIColor?
	
	public var TextFile_showStatusBar: Bool = true // show status bar when the nav bar is hidden
	
	// Static
	public static var Default_TextFile_font: UIFont { get {return UIFont.preferredFont(forTextStyle: .body)} }
	public static let Default_TextFile_textColorDay: UIColor = UIColor.black
	public static let Default_TextFile_backgroundColorDay: UIColor = UIColor.white
	
	public static let Default_TextFile_textColorNight: UIColor = UIColor.white
	public static let Default_TextFile_backgroundColorNight: UIColor = UIColor.black
	
	
	
	public override init()
	{
		super.init()
	}
	
	public func encode(with aCoder: NSCoder)
	{
		aCoder.encode(TextFile_textColorDay, forKey: "TextFile_textColorDay")
		aCoder.encode(TextFile_backgroundColorDay, forKey: "TextFile_backgroundColorDay")
		aCoder.encode(TextFile_font, forKey: "TextFile_font")
		aCoder.encode(TextFile_textColorNight, forKey: "TextFile_textColorNight")
		aCoder.encode(TextFile_backgroundColorNight, forKey: "TextFile_backgroundColorNight")
		aCoder.encode(TextFile_showStatusBar, forKey: "TextFile_showStatusBar")
	}
	
	required public init?(coder aDecoder: NSCoder)
	{
		self.TextFile_textColorDay = aDecoder.decodeObject(forKey: "TextFile_textColorDay") as? UIColor
		self.TextFile_backgroundColorDay = aDecoder.decodeObject(forKey: "TextFile_backgroundColorDay") as? UIColor
		self.TextFile_font = aDecoder.decodeObject(forKey: "TextFile_font") as? UIFont
		self.TextFile_textColorNight = aDecoder.decodeObject(forKey: "TextFile_textColorNight") as? UIColor
		self.TextFile_backgroundColorNight = aDecoder.decodeObject(forKey: "TextFile_backgroundColorNight") as? UIColor
		self.TextFile_showStatusBar = aDecoder.decodeBool(forKey: "TextFile_showStatusBar")
	}
	
}
