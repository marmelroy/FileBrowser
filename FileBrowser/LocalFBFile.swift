//
//  LocalFBFile.swift
//  FileBrowser
//
//

import Foundation

open class LocalFBFile : FBFile
{
	
	override open func delete()
	{
		guard fileLocation != nil else
		{
			print("Could not delete nil file location.")
			return
		}
		
		
		do
		{
			try FileManager.default.removeItem(at:fileLocation!)
		}
		catch
		{
			print("An error occured when trying to delete file:\(self.fileLocation) Error:\(error)")
		}
	}

}
