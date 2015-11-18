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
        guard let element = item as? Element else {
            assert(false, "can't handle item \(item) type")
            return
        }

        switch componentKey {
        case Configurations.Component.title:
            self.text = "id: \(element.elementId)"
        case Configurations.Component.subtitle:
            self.text = "This is description"
        case Configurations.Component.date:
            self.text = "publication date"
        default:
            assert(false, "can't handle with component key: \(componentKey)")
        }
    }

    func cleanUp() {
        self.text = nil
    }
}