//
//  PhotosCollectionViewController.swift
//  Hiro
//
//  Created by Jonathan Long on 9/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class PhotosCollectionViewController: UICollectionViewController, NSURLSessionDataDelegate, NetworkManagerDelegate {
    let networkManager : PhotoNetworkManager = PhotoNetworkManager()
    var currentStartRange = 0
    let photoDownloadLimit = 30
    var photos : JSON?
    var albumName : String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        networkManager.delegate = self;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        networkManager.delegate = self;
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.downloadMorePhotos()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.backgroundColor = UIColor.whiteColor()
    }
    
    //MARK: - Download Photos
    func downloadMorePhotos(){
        if let name = albumName{
//            networkManager.getPhotosInAlbumInRange(name, range: NSMakeRange(currentStartRange, photoDownloadLimit))
            networkManager.getPhotosInAlbum(name)
        }
        else {
//            networkManager.getPhotosInRange(NSMakeRange(currentStartRange, photoDownloadLimit))
            networkManager.getAllPhotos();
        }
//        currentStartRange += photoDownloadLimit
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos != nil{
            print("Photos: \(photos!.count)")
            return photos!.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        if let thePhotos = photos {
            if let photoDestination = thePhotos[indexPath.row]["photoDestination"].string {
                print("PhotoDestination: \(photoDestination)")
                if let image = networkManager.imageForPhotoDestination(photoDestination) {
                    cell.imageView.image = image
                }
            }
        }

        cell.backgroundColor = UIColor.whiteColor()
    
        return cell
    }
    
    // MARK: - NetworkManager DataSource
    func networkManager(manager: NetworkManager, didReceiveJSON object: JSON) {
        photos = object["photos"]
        print("\(photos)")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            collectionView?.reloadData()
        }
    }

}
