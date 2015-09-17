//
//  DetailsViewController.swift
//  Swift_TableView_Example
//
//  Created by Rama Chandra on 16/09/2015.
//  Copyright (c) 2015 Amsphere. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,DataControllerProtocal {
    
    
    var moviePlayer:MPMoviePlayerController = MPMoviePlayerController()
    var album:Album?
    
    var tracks = [Track]()
    
    lazy var dc:DataController = DataController(delegate: self)
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
   required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleLabel.text = album?.title as? String
        self.imageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: album!.thumbnailImageURL as String)!)!)
        
        if  self.album != nil
        {
            dc.lookupAlbum(self.album!.collectionId)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        
        let track = tracks[indexPath.row]
        
        cell.trackName.text = track.title as String
        cell.playIcon.text = "▶️"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var track = tracks[indexPath.row]
        
        moviePlayer.stop()
        
        moviePlayer.contentURL = NSURL(string: track.previewUrl as String)
        
        moviePlayer.play()
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell
        {
            cell.playIcon.text = "🎵"
        }
    }
    
    func didReceiveResults(results: NSArray) {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.tracks = Track.trackWithJSON(results)
            
            self.tableView.reloadData()
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false   
        })
        
    }

}
