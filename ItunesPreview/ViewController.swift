//
//  ViewController.swift
//  Swift_TableView_Example
//
//  Created by Rama Chandra on 09/09/2015.
//  Copyright (c) 2015 Amsphere. All rights reserved.
//

import UIKit
import Foundation



class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,DataControllerProtocal {

    @IBOutlet weak var tableView: UITableView!
    
    let kCellIdentifier:NSString = "searchResultCell"
    var trackName:NSString?
    var urlString:NSString?
    var formattedPrice:NSString?
    var mageData:NSData?
    
    var albums = [Album]()
    
    var api:DataController!
    
    var imgDict = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        api = DataController(delegate: self)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        api.searchItem("Beatles")
       
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums.count
    }
    
       
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:kCellIdentifier as String)
        
         let album = self.albums[indexPath.row]
        
          cell.textLabel?.text = album.title as String
          cell.detailTextLabel?.text = album.price  as String
        
          cell.imageView?.image = UIImage(named: "Blank52")
        
        
          if let image = imgDict[album.itemURL as String]
          {
            cell.imageView?.image = image
            
          }else
          {
            
            let request = NSURLRequest(URL: NSURL(string: (album.thumbnailImageURL as String) )!)
           
            let mainQueue = NSOperationQueue.mainQueue()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, imageData, error) -> Void in
                
                if error == nil
                {
                    let image = UIImage(data: imageData)
                    
                    self.imgDict[(album.thumbnailImageURL as String)] = image
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        if let tableCell = tableView.cellForRowAtIndexPath(indexPath)
                        {
                            tableCell.imageView?.image = image
                        }
                    })
                    
                }else
                {
                    println("\(error.localizedDescription)")
                }
                
            })
            

            
          }
        
        
        
        
        
        
        return cell
        
        
        
    }
    
    func didReceiveResults(results: NSArray) {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            //println("\(results)")
            
            self.albums = Album.albumWithJSONData(results)
            
            
            self.tableView.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("row selected")
        
        self.performSegueWithIdentifier("DetailsViewController", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let detailsViewController:DetailsViewController = segue.destinationViewController as? DetailsViewController{
            
            var albumIndex = tableView!.indexPathForSelectedRow()?.row
            var selectedAlbum = self.albums[albumIndex!]
            detailsViewController.album = selectedAlbum
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

