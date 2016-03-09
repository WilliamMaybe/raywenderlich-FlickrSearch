//
//  FlickrPhotosViewController.swift
//  FlickrSearch
//
//  Created by WilliamZhang on 16/3/9.
//  Copyright © 2016年 WilliamZhang. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FlickrCell"
private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)

class FlickrPhotosViewController: UICollectionViewController {

    private var searches = [FlickrSearchResults]()
    private let flickr = Flickr()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
}

extension FlickrPhotosViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell
        
        let flickrPhoto = photoForIndexPath(indexPath)

        cell.backgroundColor = UIColor.blackColor()
        cell.imageView.image = flickrPhoto.thumbnail
        
        return cell
    }
}

extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let flickrPhoto = photoForIndexPath(indexPath)
        
        if var size = flickrPhoto.thumbnail?.size {
            size.width += 10
            size.height += 10
            return size
        }
        
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension FlickrPhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(textField.text!) { (results, error) -> Void in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            guard error == nil else {
                print("Error search : \(error)")
                return
            }
            
            guard let _ = results else {
                return
            }
            
            print("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
            self.searches.insert(results!, atIndex: 0)
            self.collectionView?.reloadData()
        }
        
        return true
    }
}