//
//  NetworkManager.swift
//  Hiro
//
//  Created by Jonathan Long on 9/24/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

//MARK: - NetworkManagerDelegate
protocol NetworkManagerDelegate{
    func networkManager(manager : NetworkManager, didReceiveJSON object : JSON)
}

//MARK: - NetworkManager
class NetworkManager: NSObject, NSURLSessionDataDelegate {
    //MARK: - Public properties
    var session : NSURLSession?
    let delegateQ : NSOperationQueue
    var delegate : NetworkManagerDelegate?
    
    //MARK: - Private Properties
    private var isJSON : Bool
    
    //MARK: - Public Methods
    override init(){
        delegateQ = NSOperationQueue()
        delegateQ.name = "com.hiro.networkManagerQueue"
        isJSON = false
        super.init()
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: delegateQ)
    }
    
    func getRequestToURL(URL: NSURL){
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        performRequest(request)
    }
    
    func postRequestToURL(URL: NSURL){
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        performRequest(request)
    }
    
    func putRequestToURL(URL: NSURL){
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "PUT"
        performRequest(request)
    }
    
    func deleteRequestToURL(URL: NSURL){
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "DELETE"
        performRequest(request)
    }
    
    //MARK: - NSURLSessionDataDelegate
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if (session == self.session!){
            let operation = NSBlockOperation(block: { () -> Void in
                if self.isJSON{
                    do {
                        let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        self.delegate?.networkManager(self, didReceiveJSON: JSON(jsonObject))
                    } catch {
                        // Need to figure out how to get the error. Should we rethrow or try and handle it?
                    }
                }
            });
            delegateQ.addOperation(operation)
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        if let HTTPResponse = response as? NSHTTPURLResponse{
            let jsonContentType = "application/json"
            let headers = HTTPResponse.allHeaderFields
            isJSON = headers["Content-Type"] as? String == jsonContentType
            print("isJSON: \(isJSON)")
            switch HTTPResponse.statusCode{
            case 200:
                completionHandler(.Allow)
            case 404:
                completionHandler(.Cancel)
            default:
                completionHandler(.Allow)
            }
        }
    }
    
    //MARK: - Private Methods
    private func performRequest(request:NSURLRequest){
        if let downloadTask = session?.dataTaskWithRequest(request){
            downloadTask.resume()
        }
    }
}

//MARK: - PhotoNetworkManager
class PhotoNetworkManager: NetworkManager {
    //MARK: - Private Properties
    private let baseURL = "http://127.0.0.1:5000/api/v1/"
    private let lowerBound = "lowerbound"
    private let upperBound = "upperbound"
    private let albumName = "album_name"
    private let photoURL = "url"
    private let favoritesEndPoint = "favorites"
    private let albumsEndPoint = "albums"
    private let photosEndPoint = "photos"
    
    //MARK: - Private methonds
    private func URLWithParameters(base: String, parameters : Dictionary<String, AnyObject>?) -> String{
        var startingString = base
        if let URLParameters = parameters{
            //TODO: Need to find out how to pass multiple parameters. I don't think this is right
            startingString += "?"
            for key in URLParameters.keys{
                if let value = URLParameters[key]{
                    startingString += "\(key)=\(value)&"
                }
                
            }
            startingString.removeAtIndex(startingString.endIndex.predecessor())
        }
        
        return startingString
    }
    
    private func performGETRequestWithParameters(parameters : Dictionary<String, AnyObject>?, andEndPoint endPoint: String){
        let endpointWithParameters = URLWithParameters(endPoint, parameters: parameters)
        print("\(endpointWithParameters)")
        
        if let URL = NSURL(string: baseURL + endpointWithParameters){
            print("URL: \(URL)")
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = "GET"
            //TODO: File a bug on this warning - Should we warn in this scenario?
            self.performRequest(request)
        }
    }
    
    //MARK: - Public Methods
    func getPhotosInRange(range : NSRange){
        let parameters = [lowerBound : range.location, upperBound : range.location + range.length]
        performGETRequestWithParameters(parameters, andEndPoint: photosEndPoint)
    }
    
    func getPhotosInAlbum(album : String) {
        let parameters = [albumName : album]
        performGETRequestWithParameters(parameters, andEndPoint: photosEndPoint)
    }
    
    func getPhotosInAlbumInRange(album : String, range : NSRange){
        let parameters : Dictionary<String, AnyObject> = [albumName : album, lowerBound : range.location, upperBound : (range.location + range.length)]
        performGETRequestWithParameters(parameters, andEndPoint: photosEndPoint)
    }
    
    func getAllPhotos(){
        performGETRequestWithParameters(nil, andEndPoint: photosEndPoint)
    }
    
    func getPhotoForURL(stringURL: String){
        let parameters = [photoURL : stringURL]
        performGETRequestWithParameters(parameters, andEndPoint: photosEndPoint)
    }
    
    /*!
    @method		getAlbums:
    @abstract		Performs a request for either all of the albums, or an album with a specific name
    @param		name
    An optional parameter that should be the album name you wish to receive
    @discussion	Performs a request for either all of the albums, or an album with a specific name
    */
    func getAlbum(name : String?) {
        var parameters : Dictionary<String, AnyObject>? = nil
        if let albumName = name{
            parameters = [self.albumName : albumName]
        }
        performGETRequestWithParameters(parameters, andEndPoint: albumsEndPoint)
    }
    
    func getAllAlbums() {
        performGETRequestWithParameters(nil, andEndPoint: albumsEndPoint)
    }
    
    func imageForPhotoDestination( photoDestination : String) -> UIImage?{
        if let imageURL = NSURL(string: "http://localhost:5000/api/v1/photo/"+photoDestination){
            print("ImageURL: \(imageURL)")
            if let imageData = NSData(contentsOfURL: imageURL) {
                let image = UIImage(data: imageData)
                return image
            }
        }
        return nil
    }
    
}
