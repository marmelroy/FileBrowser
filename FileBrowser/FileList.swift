//
//  FileList.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import QuickLook

class FileList: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    let parser = FileParser()
    let previewManager = PreviewManager()
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    let collation = UILocalizedIndexedCollation.currentCollation()

    var isSearching = false
    
    var initialPath: NSURL? {
        didSet {
            if let initialPath = initialPath {
                files = parser.filesForDirectory(initialPath)
                self.title = initialPath.lastPathComponent
            }
        }
    }
    
    var sections: [[File]] = []    
    var files = [File]() {
        didSet {
            self.indexFiles()
        }
    }
    
    var filteredFiles = [File]()

    func indexFiles() {
        let selector: Selector = "fileName"
        sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
        if let sortedObjects = collation.sortedArrayFromArray(files, collationStringSelector: selector) as? [File]{
            for object in sortedObjects {
                let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
        }
    }

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        tableView.tableHeaderView = searchController.searchBar
    }
    
    convenience init () {
        let parser = FileParser()
        let path = parser.documentsURL()
        self.init(initialPath: path)
    }
    
    convenience init (initialPath: NSURL) {
        self.init(nibName: "FileBrowser", bundle: NSBundle(forClass: FileList.self))
        self.initialPath = initialPath
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.title = initialPath.lastPathComponent
        files = parser.filesForDirectory(initialPath)
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismiss")
        self.navigationItem.rightBarButtonItem = rightBarButton
        indexFiles()
    }
    
    deinit{
        if #available(iOS 9.0, *) {
            searchController.loadViewIfNeeded()
        } else {
            searchController.loadView()
        }
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension FileList: UITableViewDataSource, UITableViewDelegate {
    //MARK: UITableView Data Source and Delegate
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.active && searchController.searchBar.text != "" {
            return nil
        }
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        }
        else {
            return nil
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if searchController.active && searchController.searchBar.text != "" {
            return nil
        }
        return collation.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return 0
        }
        return collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return 1
        }
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredFiles.count
        }
        return sections[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            cell = reuseCell
        }
        cell.selectionStyle = .Blue
        var file: File
        if searchController.active && searchController.searchBar.text != "" {
            file = filteredFiles[indexPath.row]
        }
        else {
            file = sections[indexPath.section][indexPath.row]
        }
        cell.textLabel?.text = file.fileName
        cell.imageView?.image = file.type.image()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var file: File
        if searchController.active && searchController.searchBar.text != "" {
            file = filteredFiles[indexPath.row]
        }
        else {
            file = sections[indexPath.section][indexPath.row]
        }
        if file.isDirectory {
            let browser = FileList(initialPath: file.filePath)
            self.navigationController?.pushViewController(browser, animated: true)
        }
        else {
            let quickLook = QLPreviewController()
            previewManager.filePath = file.filePath
            quickLook.dataSource = previewManager
            self.navigationController?.pushViewController(quickLook, animated: true)
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredFiles = files.filter({ (file: File) -> Bool in
            return file.fileName.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }

}

extension FileList: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension FileList: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
