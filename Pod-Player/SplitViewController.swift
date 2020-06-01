//
//  SplitViewController.swift
//  Pod-Player
//
//  Created by as on 6/1/20.
//  Copyright © 2020 as. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    
    @IBOutlet weak var podcastItem: NSSplitViewItem!
    
    @IBOutlet weak var episodesItem: NSSplitViewItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if let podcastVc = podcastItem.viewController as? PodcastViewController {
            if let episodesVc = episodesItem .viewController as? EpisodesViewController{
                podcastVc.episodesVc = episodesVc
                episodesVc.podcastsVc = podcastVc
            }
        }
        
    }
    
}
