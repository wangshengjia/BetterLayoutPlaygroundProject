//
//  ViewController.swift
//  PlaygroundProject
//
//  Created by Victor WANG on 12/11/15.
//  Copyright © 2015 Le Monde. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let textField = searchBar.valueForKey("_searchField") as? UITextField else {
            return
        }

        let searchStrings: SignalProducer = textField.rac_textSignal()
            .toSignalProducer()
            .throttle(2.0, onScheduler: QueueScheduler.mainQueueScheduler)
            .map { text in text as! String }
            .filter {text in text.characters.count > 3}
            .flatMap(.Latest) { (query: String) -> SignalProducer<(NSData, NSURLResponse), NSError> in
                let URLRequest =  NSURLRequest(URL: NSURL(string: "http://api-cdn.lemonde.fr/ws/5/mobile/www/ios-phone/search/index.json?keywords=holland")!) // self.searchRequestWithEscapedQuery(query)
                return NSURLSession.sharedSession()
                    .rac_dataWithRequest(URLRequest)
                    .flatMapError { error in
                        print("Network error occurred: \(error)")
                        return SignalProducer.empty
                }
            }
            .map { (data, URLResponse) -> AnyObject? in
                return try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) //self.parseJSONResultsFromString(string)
            }
            .observeOn(QueueScheduler.mainQueueScheduler)

        searchStrings.start { event in
            switch event {
            case let .Next(value):
                if let value = value as? Dictionary<String, AnyObject>,
                    let elements = value["elements"] as? Array<Dictionary<String, AnyObject>> {
                    print("Next event: \(elements)")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()


    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

    }

}

