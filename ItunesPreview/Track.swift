//
//  Track.swift
//  Swift_TableView_Example
//
//  Created by Rama Chandra on 16/09/2015.
//  Copyright (c) 2015 Amsphere. All rights reserved.
//

import Foundation

struct Track {
    
    let title:NSString
    let price:NSString
    let previewUrl:NSString
    
    init(title:NSString,price:NSString,previewUrl:NSString)
    {
        self.title=title
        self.price=price
        self.previewUrl=previewUrl
    }
    
    static func trackWithJSON(results:NSArray)->[Track]
    {
        var tracks = [Track]()
        
        if results.count != 0
        {
            for trackInfo in results
            {
                if let kind = trackInfo["kind"] as? String {
                    
                    var trackPrice = trackInfo["trackPrice"] as? String
                    var trackTitle = trackInfo["trackName"] as? String
                    var trackPreViewUrl = trackInfo["previewUrl"] as? String
                    
                    if trackTitle == nil
                    {
                        trackTitle = "Unknown"
                    }
                   if trackPrice == nil
                    {
                        println("No track price\(trackInfo)")
                        trackPrice = "?"
                    }
                     if trackPreViewUrl == nil
                    {
                        trackPreViewUrl = " "
                    }
                    
                    var track = Track(title: trackTitle!, price: trackPrice!, previewUrl: trackPreViewUrl!)
                    
                    tracks.append(track)
                }
            }
        }
        
        return tracks
    }
    
    
    

}
