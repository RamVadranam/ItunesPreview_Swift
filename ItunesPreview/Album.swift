//
//  Album.swift
//  Swift_TableView_Example
//
//  Created by Rama Chandra on 15/09/2015.
//  Copyright (c) 2015 Amsphere. All rights reserved.
//

import Foundation

struct Album {
    
    let title:NSString
    let price:NSString
    let thumbnailImageURL:NSString
    let largeImageURL:NSString
    let itemURL:NSString
    let artistURL:NSString
    let collectionId:Int
    
    init(name:NSString,price:NSString,thumbnailImageURL:NSString,largeImageURL:NSString,itemURL:NSString,artistURL:NSString,collectionid:Int)
    {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionid
    }
    
    static func albumWithJSONData(results:NSArray)->[Album]
    {
        var albums = [Album]()
        
        if results.count>0
        {
            for result in results
            {
               
            if let collectionId = result["collectionId"] as? Int {
                var name = result["trackName"] as? String
                 if name == nil
                 {
                    name=result["collectionName"] as? String
                  }
                
                var price = result["formattedPrice"] as? String
                
                if price == nil {
                    
                    price = result["collectionPrice"] as? String
                    
                    if price == nil
                    {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil
                        {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                let thumnailURL = result["artworkUrl60"] as? String ?? ""
                let imageURL = result["artworkUrl100"] as? String ?? ""
                let artistURL = result["artistViewUrl"] as? String ?? ""
                
                var itemURL = result["collectionViewUrl"] as? String
                
                if itemURL == nil
                {
                    itemURL =  result["trackViewUrl"] as? String
                }
                
                    var newAlbum = Album(name: name!, price: price!, thumbnailImageURL: thumnailURL, largeImageURL: imageURL, itemURL: itemURL!, artistURL: artistURL,collectionid:collectionId)
                
                albums.append(newAlbum)
                
            }
            }
        }
        
         return albums
    }
    
      
   
}
