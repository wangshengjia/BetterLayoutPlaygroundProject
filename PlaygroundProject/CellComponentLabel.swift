//
//  CellComponentLabel.swift
//  BearBeers
//
//  Created by Victor WANG on 15/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//

class CellComponentLabel : UILabel, CellComponentProtocol {
    var componentKey = ""

    required init(componentKey: String) {
        self.componentKey = componentKey
        super.init(frame: CGRectZero)

        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup(item: AnyObject, style: String) {
        if let configuration = Configurations.StyleConfigurationWithKey(style) {
            self.setValuesForKeysWithDictionary(configuration)
        }
        
        update(item)
    }
    
    func update(item: AnyObject) {
        switch item {
        case let item as Element:
            self.text = "\(item.elementId)"
        default:
            assert(false, "can't handle item \(item) type")
        }
    }

    func cleanUp() {
        self.text = nil
    }
}