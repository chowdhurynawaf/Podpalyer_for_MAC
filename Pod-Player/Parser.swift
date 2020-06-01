//
//  Parser.swift
//  Pod-Player
//
//  Created by as on 5/29/20.
//  Copyright © 2020 as. All rights reserved.
//

import Foundation
import SWXMLHash

class Parser {
    
    func getPodcastmetaData(data : Data) -> (title:String? , imageURL:String?) {
        
        
        let xml = SWXMLHash.parse(data)
        //print(xml)
        //print(xml["rss"]["channel"]["title"])
        //print(xml["html"]["head"]["meta"].element?.attribute(by: "charset")?.text)
        return (xml["rss"]["channel"]["title"].element?.text , xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)
        
    }
    
    
    func getEpisodes(data:Data)->[Episode]{
        
        let xml  = SWXMLHash.parse(data)
        var episodes : [Episode] = []
        for item in xml["rss"]["channel"]["item"].all{
            print(item)
            let episode = Episode()
            if let title = item["title"].element?.text
            {
                episode.title = title
            }
            
            if let htmlDescription = item["description"].element?.text
                       {
                        episode.htmlDescription = htmlDescription
                       }
            
            if let audioURL = item["enclosure"].element?.attribute(by: "url")?.text
                       {
                           episode.audioURL = audioURL
                       }
            if let pubdate = item["pubDate"].element?.text
            {
                if let date =  Episode.formatter.date(from: pubdate){
                    episode.pubdate = date
                }
            }
            episodes.append(episode)
        }
        
        return episodes
    }
}
