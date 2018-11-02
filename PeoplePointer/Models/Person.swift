//
//  Person.swift
//  PeoplePointer
//
//  Created by Gabriel Blaine Palmer on 10/12/18.
//  Copyright © 2018 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation
import UIKit

class Person: NSObject, NSCoding {
    var image: UIImage
    var name: String

    init(image: UIImage, name: String) {
        
        self.image = image
        self.name = name
        
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory,    in: .userDomainMask).first!
    static let MaleArchiveURL = DocumentsDirectory.appendingPathComponent("males")
    static let FemaleArchiveURL = DocumentsDirectory.appendingPathComponent("females")
    
    struct PropertyKey {
        static let imageKey = "image"
        static let nameKey = "name"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let theirPicture = aDecoder.decodeObject(forKey: PropertyKey.imageKey) as? UIImage else {return nil}
        guard let theirName = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as? String else {return nil}
        
        self.init(image: theirPicture, name: theirName)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: PropertyKey.imageKey)
        aCoder.encode(name, forKey: PropertyKey.nameKey)
    }
}

