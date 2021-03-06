//
//  ViewController.swift
//  PlaygroundProject
//
//  Created by Victor WANG on 12/11/15.
//  Copyright © 2015 Le Monde. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            for reuseId in Configurations.AllCellConfigurations.keys {
                collectionView.registerClass(ReusableCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
            }
        }
    }

    private var elements: Array<Element> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // a little bit hack, should not ship to production
        guard let textField = searchBar.valueForKey("_searchField") as? UITextField else {
            return
        }

        let searchStrings: SignalProducer = textField.rac_textSignal()
            .toSignalProducer()
            .throttle(2.0, onScheduler: QueueScheduler.mainQueueScheduler)
            .map { text in text as! String }
            .filter {text in text.characters.count > 3}
            .flatMap(.Latest) { (query: String) -> SignalProducer<(NSData, NSURLResponse), NSError> in

                if let queryEncoded = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()),
                    let url = NSURL(string: "https://api.github.com/search/users?q=\(queryEncoded)&sort=score") {
                    return NSURLSession.sharedSession()
                        .rac_dataWithRequest(NSURLRequest(URL: url))
                        .flatMapError { error in
                            print("Network error occurred: \(error)")
                            return SignalProducer.empty
                    }
                } else {
                    return SignalProducer.empty
                }
            }
            .map { (data, URLResponse) -> AnyObject? in
                return try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            }
            .observeOn(QueueScheduler.mainQueueScheduler)

        searchStrings.start {[weak self] event in
            switch event {
            case let .Next(value):
                if let value = value as? Dictionary<String, AnyObject>,
                    let elementDictionaries = value["items"] as? Array<Dictionary<String, AnyObject>> {
                        self?.elements = elementDictionaries.map{ elementDictionary -> Element in
                            return Element(dictionary: elementDictionary)
                        }
                        self?.collectionView.reloadData()
                }
            case let .Failed(error):
                print("Failed event: \(error)")

            case .Completed:
                print("Completed event")

            case .Interrupted:
                print("Interrupted event")
            }
        }
    }

    // MARK: Collection View DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var reuseId: String
        switch indexPath.item % 3 {
        case 0: reuseId = Configurations.CellType.A
        case 1: reuseId = Configurations.CellType.B
        default: reuseId = Configurations.CellType.C
        }


        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseId, forIndexPath: indexPath) as? ReusableCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configureWithItem(elements[indexPath.item], reuseIdentifier: reuseId)
        return cell
    }


    // MARK: Collection View Layout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 120)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
}

