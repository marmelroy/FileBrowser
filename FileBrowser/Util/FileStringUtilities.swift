//
//  FileStringUtilities.swift
//  FileBrowser
//
//  Created by Eric Patno on 5/3/17.
//  Copyright © 2017 Eric Patno. All rights reserved.
//

import Foundation


func String_GetDisplayTextForFileSize( file : FBFile, displayType: Bool ) -> String
{
	if file.isDirectory
	{
		if( displayType )
		{
			return "Folder" // TODO: later calculate folder size?
		}
	}
	else
	{
		return "\(file.getFileSize()) bytes"
	}
	return ""
}
