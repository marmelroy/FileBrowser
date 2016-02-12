//
//  FileUtilities.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

enum FileType: String {
    case PNG = "png"
    case JPG = "jpg"
    case PDF = "pdf"
    case ZIP = "zip"
    case Default = "file"

    func image() -> UIImage? {
        
        let bundle =  NSBundle(forClass: FileBrowser.self)
        var fileName = String()
        switch self {
        case PNG: fileName = "image@2x.png"
        case JPG: fileName = "image@2x.png"
        case PDF: fileName = "pdf@2x.png"
        case ZIP: fileName = "zip@2x.png"
        case Default: fileName = "file@2x.png"
        }
        let file = UIImage(named: fileName, inBundle: bundle, compatibleWithTraitCollection: nil)
        return file
    }
}

class FileUtilities {
    

}