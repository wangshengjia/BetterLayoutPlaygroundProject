//
//  Element.swift
//  PlaygroundProject
//
//  Created by Victor WANG on 14/11/15.
//  Copyright © 2015 Le Monde. All rights reserved.
//

import Foundation

struct Element {

    let elementId: Int

    // An naive implementation about json to model object
    // Waiting for improving
    init(dictionary: Dictionary<String, AnyObject>) {
        if let id = dictionary["id"] as? Int {
            elementId = id
        } else {
            elementId = 0
        }
    }
}