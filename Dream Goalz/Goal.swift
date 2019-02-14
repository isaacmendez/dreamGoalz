//
//  Goal.swift
//  Dream Goalz
//
//  Created by Laurie Gray on 10/02/2019.
//  Copyright © 2019 Code Disciple. All rights reserved.
//

import Foundation

class Goal: NSObject, NSCoding {
    
    // Turn into binary
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(title, forKey: "title")
        aCoder.encode(isCompleted, forKey: "isComplete")
    }
    
    // Make goal from binary data
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let isCompleted = aDecoder.decodeBool(forKey: "isComplete")
        
        self.init(title: title, isCompleted: isCompleted)
    }
    
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool = false) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
