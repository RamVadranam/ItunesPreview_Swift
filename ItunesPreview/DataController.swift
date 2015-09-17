//
//  DataController.swift
//  Swift_TableView_Example
//
//  Created by Rama Chandra on 15/09/2015.
//  Copyright (c) 2015 Amsphere. All rights reserved.
//

import UIKit

protocol DataControllerProtocal
{
    func didReceiveResults(results:NSArray)
}

class DataController: NSObject {
    
    var delegate:DataControllerProtocal
    
    init(delegate:DataControllerProtocal) {
        
        self.delegate = delegate
    }
   
    func searchItem(searchTerm:NSString!)
    {
        
        let itunesString:NSString = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        if let escapedSearchTerm = itunesString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        {
            
            let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            
            
            get(urlPath)
        }
    }
    
    func get(path: String)
    {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in
            
            println("Task Completed")
            
            if (error != nil)
            {
                println(error.localizedDescription)
            }
            
            var err:NSError?
            
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options:    NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
            {
                
                if (err != nil)
                {
                    println("JSON error \(err?.localizedDescription)")
                }
                
                if let results:NSArray=jsonResult["results"] as? NSArray
                {
                   
                        self.delegate.didReceiveResults(results)
                }
            }
        })
        
        task.resume()
        
       
    }
    
    
    func lookupAlbum(collectionId:Int)
    {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }

        
    

}
