//
//  Models.swift
//  Day One Clone
//
//  Created by Yash Bhojgarhia on 22/06/21.
//

import UIKit
import RealmSwift
import Toucan

class Entry: Object {
    @objc dynamic var text = ""
    @objc dynamic var date = Date()
    let pictures = List<Picture>()
    
    func datePrettyString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    func dayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    func monthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date)
    }
    
    func yearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
    }
}

class Picture: Object {
    @objc dynamic var fullImageName = ""
    @objc dynamic var thumbnailName = ""
    @objc dynamic var entry: Entry?
    
    convenience init(image: UIImage) {
        self.init()
        fullImageName = imageToURLString(image: image)
        if let smallImage = Toucan(image: image).resize(CGSize(width: 500, height: 500), fitMode: .crop).image {
            thumbnailName = imageToURLString(image: smallImage)
        }
    }
    
    func fullImage() -> UIImage {
        return imageWithFileName(fileName: fullImageName)
    }
    
    func thumbnail() -> UIImage {
        return imageWithFileName(fileName: thumbnailName)
    }
    
    func imageWithFileName(fileName: String) -> UIImage {
        var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        path.appendPathComponent(fileName)
        if let imageData = try? Data(contentsOf: path) {
            if let image = UIImage(data: imageData) {
                return image
            }
        }
        return UIImage()
    }
 
    func imageToURLString(image: UIImage) -> String {
        if let imageData = image.pngData() {
            let fileName = UUID().uuidString + ".png"
            var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            path.appendPathComponent(fileName)
            try? imageData.write(to: path)
            return fileName
        }
        return ""
    }
}
