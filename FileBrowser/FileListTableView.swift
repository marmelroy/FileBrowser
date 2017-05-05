//
//  FlieListTableView.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 14/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

extension FileListViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchController?.isActive ?? false {
            return 1
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController?.isActive ?? false {
            return filteredFiles.count
        }
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
		let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        var cell = reuseCell
        if cell == nil
		{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        cell!.selectionStyle = .blue
        let selectedFile = fileForIndexPath(indexPath)
        cell!.textLabel?.text = selectedFile.displayName
        cell!.imageView?.image = selectedFile.type.image()
		
		cell!.textLabel?.adjustsFontSizeToFitWidth = true
		cell!.textLabel?.minimumScaleFactor = 0.5
		
		if #available(iOS 9, *) {
			cell!.textLabel?.allowsDefaultTighteningForTruncation = true
		} else {
		}
		
		if fileBrowserState.cellShowDetail
		{
			cell!.detailTextLabel?.text = String_GetDisplayTextForFileSize(file: selectedFile, displayType: false)
		}
		
		cell!.accessoryType = fileBrowserState.cellAcc
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = fileForIndexPath(indexPath)
        searchController?.isActive = false
		fileBrowserState.viewFile(file: selectedFile, controller: self)
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (fileBrowserState.includeIndex == false) || (searchController?.isActive ?? false) {
            return nil
        }
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        }
        else {
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if (fileBrowserState.includeIndex == false) || (searchController?.isActive ?? false)
		{
            return nil
        }
        return collation.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if (fileBrowserState.includeIndex == false) || (searchController?.isActive ?? false) {
            return 0
        }
        return collation.section(forSectionIndexTitle: index)
    }
    
    
}
