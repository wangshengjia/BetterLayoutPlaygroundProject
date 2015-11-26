//
//  ReusableCollectionViewCell.swift
//  BearBeers
//
//  Created by Victor WANG on 14/06/15.
//  Copyright (c) 2015 AllblueTechnology. All rights reserved.
//


class ReusableCollectionViewCell : UICollectionViewCell {

    func configureWithItem(item: AnyObject, reuseIdentifier: String) {
        if shouldSetupCell() {
            setupCellWithItem(item, reuseIdentifier: reuseIdentifier)
        } else {
            for subview in self.contentView.subviews {
                (subview as? CellComponentProtocol)?.update(item)
            }
        }
        self.backgroundColor = UIColor.whiteColor()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for subview in self.contentView.subviews {
            (subview as? CellComponentProtocol)?.cleanUp()
        }
    }

    func shouldSetupCell() -> Bool {
        return self.contentView.subviews.count == 0
    }

    func setupCellWithItem(item: AnyObject, reuseIdentifier: String) {
        guard let configuration = Configurations.CellConfigurationWithReuseIdentifier(reuseIdentifier),
            let componentKeys = configuration[Configurations.CellKeys.components] as? Array<String>,
            let componentStyles = configuration[Configurations.CellKeys.styles]  as? Array<String> else {
                print("")
                return
        }

        var viewsDictionary = [String: UIView]()
        for (index, componentKey) in componentKeys.enumerate() {
            if let componentClass = Configurations.ComponentClasses[componentKey] as? CellComponentProtocol.Type {
                let view = CellComponentFactory.createCellComponentFromClass(componentClass, componentKey: componentKey)
                viewsDictionary[componentKey] = view
                self.contentView.addSubview(view)
                (view as! CellComponentProtocol).setup(item, style: componentStyles[index])
            }
        }

        if let visualFormats = configuration[Configurations.CellKeys.layout] as? Array<String>,
            let visualMetrics = configuration[Configurations.CellKeys.metrics] as? Dictionary<String, AnyObject>{
                for format in visualFormats {
                    self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics: visualMetrics, views: viewsDictionary))
                }
        }
    }
}