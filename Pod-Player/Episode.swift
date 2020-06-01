//
//  Episode.swift
//  Pod-Player
//
//  Created by as on 6/1/20.
//  Copyright © 2020 as. All rights reserved.
//

import Cocoa

class Episode  {
    
    var title = ""
    var pubdate = Date()
    var htmlDescription = ""
    var audioURL = ""
    
     static let formatter : DateFormatter = {
    
    let formatter = DateFormatter()
        formatter.dateFormat = "EEE , dd MMM yyyy HH:mm:ss zzz"
        return formatter
        
        
    }()
    
    
}
