//
//  Element.swift
//  PlaygroundProject
//
//  Created by Victor WANG on 14/11/15.
//  Copyright © 2015 Le Monde. All rights reserved.
//

import Foundation

class Element {

    let elementId: Int
    let avatalUrl: String
    let login: String

    // A naive implementation about converting json to model object
    // Waiting for improvement
    init(dictionary: Dictionary<String, AnyObject>) {
        elementId = dictionary["id"] as? Int ?? 0
        avatalUrl = dictionary["avatar_url"] as? String ?? ""
        login = dictionary["login"] as? String ?? ""
    }
}