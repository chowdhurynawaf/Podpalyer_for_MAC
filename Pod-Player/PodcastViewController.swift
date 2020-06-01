//
//  PodcastViewController.swift
//  Pod-Player
//
//  Created by as on 5/29/20.
//  Copyright © 2020 as. All rights reserved.
//

import Cocoa

class PodcastViewController: NSViewController , NSTableViewDelegate , NSTableViewDataSource {
    
    var podcasts:[Podcast] = []
    var episodesVc : EpisodesViewController? = nil
    
    @IBOutlet weak var podcastURLTextField: NSTextField!
    
    
    @IBOutlet weak var tableView: NSTableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.

        podcastURLTextField.stringValue = "http://www.espn.com/espnradio/podcast/feeds/itunes/podCast?id=2406595"
        //"https://ictd.gov.bd/site/view/notices"
        //"https://github.com/drmohundro/SWXMLHash"
        
        getPodcast()

        
    }
    
    
    
    func getPodcast(){
        
        if let context =  (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
            
            
            let fetchy  = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            do{
            podcasts = try context.fetch(fetchy)
                print(podcasts)}catch{}
            
            DispatchQueue.main.async {
                       self.tableView.reloadData()

                   }
        }
       

    }
    
    
    
    @IBAction func addPodcastClicked(_ sender: AnyObject) {
        
        if let url = URL(string: podcastURLTextField.stringValue){            URLSession.shared.dataTask(with: url) { (data:Data?,response: URLResponse?,error: Error?) in
            
            
            if error != nil {
                print("error")
            }else{
                if  data != nil {
                    let parser = Parser()
                     let info =  parser.getPodcastmetaData(data: data!)
                    //print(info)
                    DispatchQueue.main.async{
                    if !self.podcastExists(rssURL: self.podcastURLTextField.stringValue){
                    
                    if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                        
                        let podcast = Podcast(context: context)
                        podcast.rssURL = self.podcastURLTextField.stringValue
                        podcast.imageURL = info.imageURL
                        podcast.title = info.title
                        
                        (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                        
                        self.getPodcast()
                        
                        
                        DispatchQueue.main.async {
                            self.podcastURLTextField.stringValue = ""
                        }
                        
                        
                        }
                        }
                    
                    }
                }
            }
            
            
            }.resume()
            
            
            
        }
    }
    
    
    func podcastExists(rssURL : String) ->Bool{
    if let context =  (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
         
         
         let fetchy  = Podcast.fetchRequest() as NSFetchRequest<Podcast>
        fetchy.predicate = NSPredicate(format: "rssURL == %@", rssURL)
        do{
        let  matchingpodcasts = try context.fetch(fetchy)
            if matchingpodcasts.count >= 1{
                return true
            }else{
                return false
            }
             }catch{}
     
     }
    
    return false
    
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        //print(podcasts)
        return podcasts.count
        
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "podcastCell"), owner: self) as?  NSTableCellView
            
           let podcast = podcasts[row]
            
        
        
            if podcast.title != nil {
                cell!.textField!.stringValue = podcast.title!
            }
            else{
             cell!.textField!.stringValue = "UNKNOWN"
            }
            
    
            
            return cell
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        
        if tableView.selectedRow >= 0 {
            let podcast = podcasts[tableView.selectedRow]
            
            episodesVc?.podcast = podcast
            episodesVc?.updateVeiw()
            
        }
    }
    
    
}
