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
			Alert_Show(title: "Error", message: "An error occured when trying to delete file:\(String(describing: self.fileLocation)) Error:\(error)")
		}
	}

	open override func createDirectory(name: String) -> Bool
	{
		guard fileLocation != nil else
		{
			print("Could not create directory at nil file location.")
			return false
		}
		
		guard isDirectory else
		{
			print("Could not create a directory inside a file.")
			return false
		}

		do
		{
			if let dirPath = fileLocation?.appendingPathComponent(name, isDirectory: true)
			{
				try FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: false, attributes: nil)
				return true
			}
		}
		catch
		{
			Alert_Show(title: "Error", message: "An error occured when trying to create a directory:\(String(describing: self.fileLocation)) Error:\(error)")
		}
		return false
	}
	
	open override func createFile(name: String) -> Bool
	{
		guard fileLocation != nil else
		{
			print("Could not create directory at nil file location.")
			return false
		}
		
		guard isDirectory else
		{
			print("Could not create a directory inside a file.")
			return false
		}
		
		if let dirPath = fileLocation?.appendingPathComponent(name, isDirectory: true)
		{
			if FileManager.default.fileExists(atPath: dirPath.absoluteString) == false
			{
				let data = NSData()
				
				//FileManager.default.createFile(atPath: dirPath.absoluteString, contents: nil, attributes: nil)
				
				if data.write(to: dirPath, atomically: true) == false
				{
					Alert_Show(title: "Error", message: "Could not create file.")
				}
				else
				{
					return true
				}
			}
			else
			{
				Alert_Show(title: "File Exists", message: "Could not create file as file with that name already exists.")
			}
		}
		return false
	}
	
	open override func getFileSize() -> Int
	{
		do
		{
			if let resourceValues = try fileLocation?.resourceValues(forKeys: [URLResourceKey.fileSizeKey])
			{
				return resourceValues.fileSize ?? 0
			}
		}
		catch
		{
		}
		return 0;
	}
	
	open override func getCreationDate() -> Date
	{
		do
		{
			if let resourceValues = try fileLocation?.resourceValues(forKeys: [URLResourceKey.creationDateKey])
			{
				return resourceValues.creationDate ?? Date()
			}
		}
		catch
		{
		}
		return Date()
	}
	
	open override func getModificationDate() -> Date
	{
		do
		{
			if let resourceValues = try fileLocation?.resourceValues(forKeys: [URLResourceKey.contentModificationDateKey])
			{
				return resourceValues.contentModificationDate ?? Date()
			}
		}
		catch
		{
		}
		return Date()
	}
}
