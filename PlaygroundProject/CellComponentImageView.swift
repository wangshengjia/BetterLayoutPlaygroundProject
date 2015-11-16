//
//  CellComponentImageView.swift
//  BearBeers
//
//  Created by Victor WANG on 15/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//

class CellComponentImageView : UIImageView, CellComponentProtocol {
    
    var componentKey = ""

    required init(componentKey: String) {
        self.componentKey = componentKey
        super.init(frame: CGRectZero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {

    }

    func setup(item: AnyObject, style: String) {

        if let configuration = Configurations.StyleConfigurationWithKey(style) {
            self.setValuesForKeysWithDictionary(configuration)
        }
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: 0.0))

        update(item)
    }
    func update(item: AnyObject) {
        switch item {
        case let item as Element:
            print(item)
        default:
            assert(false, "can't handle item \(item) type")
        }

    }
    func cleanUp() {
        self.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}