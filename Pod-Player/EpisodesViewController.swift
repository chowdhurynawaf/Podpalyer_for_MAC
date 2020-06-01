//
//  EpisodesViewController.swift
//  Pod-Player
//
//  Created by as on 6/1/20.
//  Copyright © 2020 as. All rights reserved.
//

import Cocoa
import AVFoundation

class EpisodesViewController: NSViewController , NSTableViewDelegate , NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var titleLbl: NSTextField!
    
    @IBOutlet weak var pausePlayBtnOutlet: NSButton!
    
    @IBOutlet weak var imageView: NSImageView!
    
    
    
    var podcast : Podcast? = nil
    var podcastsVc : PodcastViewController? = nil
    var episodes : [Episode] = []
    var player : AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    
    func updateVeiw(){
        if podcast?.title != nil{
            titleLbl.stringValue = podcast!.title!

        } else {
            titleLbl.stringValue = ""
        }
        
        if podcast?.imageURL != nil{
            let image = NSImage(byReferencing: URL(string: (podcast!.imageURL!))! )
            imageView.image = image
        }else {
            imageView.image = nil
        }
        
        pausePlayBtnOutlet.isHidden = true
        
       getEpisodes()

    }
    
    func getEpisodes() {
        if podcast?.rssURL != nil{
            if let url  = URL(string: podcast!.rssURL!){
            URLSession.shared.dataTask(with: url) { (data:Data?,response: URLResponse?,error: Error?) in
        
        
        if error != nil {
            print("error")
        }else{
            if  data != nil {
                let parser = Parser()
                parser.getEpisodes(data: data!)
                self.episodes = parser.getEpisodes(data: data!)
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                    
                
                
            }
        }
        
        
        }.resume()
            }
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {

        if podcast != nil{
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            context.delete(podcast!)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            podcastsVc?.getPodcast()
            //tableView.reloadData()
            podcast = nil
            updateVeiw()
        }

        }
    }
    
    
    @IBAction func pausePlayBtnClicked(_ sender: Any) {
        if pausePlayBtnOutlet.title == "Pause"{
        player?.pause()
        pausePlayBtnOutlet.title = "Play"
        }
        else{
            player?.play()
            pausePlayBtnOutlet.title = "Pause"

            
        }
    }
    
    
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let episode = episodes[row]
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "episodeCell"), owner: self) as? NSTableCellView
        
        cell?.textField?.stringValue = episode.title
        return cell
        
        
        
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0{
        let episode = episodes[tableView.selectedRow]
            if let url = URL(string: episode.audioURL) {
                player?.pause()
                player = nil
                player = AVPlayer(url: url)
                player?.play()

            }
            
            pausePlayBtnOutlet.isHidden = false
            pausePlayBtnOutlet.title = "Pause"

        }
    }
       
    }
    

