//
//  CollectionViewCellConfigurations.swift
//  BearBeers
//
//  Created by Victor WANG on 14/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//

import Foundation
import UIKit

struct Configurations {
    
    struct CellKeys {
        static let components = "CellComponentKeys"
        static let styles = "CellComponentStyles"
        static let layout = "CellComponentLayout"
        static let metrics = "CellComponentLayoutMetrics"
    }

    static let layoutMetrics = [
        "top":20,
        "bottom":20,
        "left":20,
        "right":20,
        "interspaceH":10,
        "interspaceV":10]

}

// MARK: CellTypes
extension Configurations {

    struct CellType {
        static let A = "CellTypeA"
        static let B = "CellTypeB"
        static let C = "CellTypeC"
    }

    static let CellTypeA: Dictionary<String, AnyObject> = [
        CellKeys.components: [Component.avatar, Component.title, Component.subtitle, Component.date],
        CellKeys.styles: [Styles.Image.A, Styles.Title.A, Styles.Subtitle.A, Styles.Title.A],
        CellKeys.layout: [
            "H:|-left-[avatar(50)]-interspaceH-[title]-(>=interspaceH)-[date]-right-|",
            "H:[avatar]-interspaceH-[subtitle]-right-|",
            "V:|-top-[title]-interspaceV-[subtitle]-(>=bottom)-|",
            "V:|-top-[avatar(50)]-(>=bottom)-|",
            "V:|-top-[date]-(>=bottom)-|"
        ],
        CellKeys.metrics:layoutMetrics
    ]

    static let CellTypeB: Dictionary<String, AnyObject> = [
        CellKeys.components: [Component.avatar, Component.title, Component.subtitle, Component.date],
        CellKeys.styles: [Styles.Image.A, Styles.Title.A, Styles.Subtitle.A, Styles.Title.A],
        CellKeys.layout: [
            "H:|-left-[date]-(>=interspaceH)-[title]-interspaceH-[avatar(50)]-right-|",
            "H:[subtitle]-interspaceH-[avatar]-right-|",
            "V:|-top-[title]-interspaceV-[subtitle]-(>=bottom)-|",
            "V:|-top-[avatar(50)]-(>=bottom)-|",
            "V:|-top-[date]-(>=bottom)-|"
        ],
        CellKeys.metrics:layoutMetrics
    ]

    static let CellTypeC: Dictionary<String, AnyObject> = [
        CellKeys.components: [Component.avatar, Component.title, Component.date],
        CellKeys.styles: [Styles.Image.A, Styles.Title.B, Styles.Title.B],
        CellKeys.layout: [
            "H:|[avatar]|",
            "V:|[avatar]|",
            "H:|[title]|",
            "H:|[date]|",
            "V:|-top-[title]-interspaceV-[date]-(>=bottom)-|"
        ],
        CellKeys.metrics:layoutMetrics
    ]

    static let AllCellConfigurations: Dictionary<String, Dictionary<String, AnyObject>> = [
        CellType.A: CellTypeA,
        CellType.B: CellTypeB,
        CellType.C: CellTypeC
    ]

    static func CellConfigurationWithReuseIdentifier(reuseIdentifier: String) -> Dictionary<String, AnyObject>? {
        return AllCellConfigurations[reuseIdentifier]
    }
}

// MARK: Components
extension Configurations {

    struct Component {
        static let title = "title"
        static let subtitle = "subtitle"
        static let date = "date"
        static let avatar = "avatar"
    }

    static let ComponentClasses = [Component.title : object_getClass(CellComponentLabel.self),
        Component.subtitle : object_getClass(CellComponentLabel.self),
        Component.date : object_getClass(CellComponentLabel.self),
        Component.avatar : object_getClass(CellComponentImageView.self)]
}

// MARK: Styles
extension Configurations {

    struct Styles {
        struct Title {
            static let A = [Appearance.font: UIFont.systemFontOfSize(15), Appearance.textColor: UIColor.grayColor()]
            static let B = [Appearance.font: UIFont.systemFontOfSize(15), Appearance.textColor: UIColor.redColor(), Appearance.textAlignment: NSNumber(integer: NSTextAlignment.Center.rawValue)]
        }
        struct Subtitle {
            static let A = [Appearance.font: UIFont.systemFontOfSize(15), Appearance.textColor: UIColor.lightGrayColor()]
        }
        struct Image {
            static let A = [Appearance.backgroundColor: UIColor.greenColor()]
        }
    }

    struct Appearance {
        static let font = "font"
        static let textColor = "textColor"
        static let backgroundColor = "backgroundColor"
        static let textAlignment = "textAlignment"
    }
}







