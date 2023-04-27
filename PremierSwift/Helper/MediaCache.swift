//
//  MediaCache.swift
//  PremierSwift
//
//  Created by Senthil Kumar on 27/04/23.
//  Copyright © 2023 Deliveroo. All rights reserved.
//

import UIKit


struct MediaCache {
    
    private static let cacheQueue = DispatchQueue(label: "com.deliveroo.mediacache.queue",
                                                  qos: .userInteractive, attributes: .concurrent)
    
    private static let imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "com.deliveroo.mediacache"
        return cache
    }()
    
    static func setImageInCache(key: String, image: UIImage){
        cacheQueue.async(flags: .barrier) {
            imageCache.setObject(image, forKey: key as NSString)
        }
    }
    
    static func getCachedImage(key: String) -> UIImage?{
        return cacheQueue.sync {
            imageCache.object(forKey: key as NSString)
        }
    }
    
    
    /**
     Clearing a `Cache` if  app recievs memory warning.
     */
    static func clearCache() {
        cacheQueue.async(flags: .barrier) {
            imageCache.removeAllObjects()
        }
    }
    
    /**
     Loading a `Image` from cache.
     - parameter imageURL: URL
     */
    
    static func getImage(imageURL: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        if let cachedImage = MediaCache.getCachedImage(key: imageURL.absoluteString){
            PSDispatchOnMainThread {
                completion(cachedImage)
            }
        }else{
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let data = try Data(contentsOf: imageURL)
                    if let image = UIImage(data: data) {
                        MediaCache.setImageInCache(key: imageURL.absoluteString, image: image)
                        PSDispatchOnMainThread {
                            completion(image)
                        }
                    }
                } catch _ { }
            }
        }
    }
    
}
