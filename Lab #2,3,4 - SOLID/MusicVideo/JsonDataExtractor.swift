//
//  JsonDataExtractor.swift
//  MusicVideo
//
//  Created by Victoria on 7/10/18.
//  Copyright © 2018 Victoria. All rights reserved.
//


import Foundation

class JsonDataExtractor {
    
    static func extractVideoDataFromJson(videoDataObject: AnyObject) -> [Video] {
        
        guard let videoData = videoDataObject as? JSONDictionary else { return [Video]() }
        
        var videos = [Video]()
        
        if let feeds = videoData["feed"] as? JSONDictionary, let entries = feeds["entry"] as? JSONArray {
            
            for (index, data) in entries.enumerated() {
                
                
                var vName = " ", vRights = "", vPrice = "", vImageUrl = "",
                vArtist = "", vVideoUrl = "", vImid = "", vGenre = "",
                vLinkToiTunes = "", vReleaseDte = ""
                
                
                
                // Video name
                if let imName = data["im:name"] as? JSONDictionary,
                    let label = imName["label"] as? String {
                    vName = label
                }
                
                
                // The Studio Name
                if let rightsDict = data["rights"] as? JSONDictionary,
                    let label = rightsDict["label"] as? String {
                    vRights = label
                }
                
                
                
                // Price of Video
                
                if let imPrice = data["im:price"] as? JSONDictionary,
                    let label = imPrice["label"] as? String {
                    vPrice = label
                }
                
                
                
                
                // The Video Image
                if let imImage = data["im:image"] as? JSONArray,
                    let image = imImage[2] as? JSONDictionary,
                    let label = image["label"] as? String {
                    vImageUrl = label.replacingOccurrences(of: "100x100", with: "600x600")
                }
                
                
                
                // The Artist Name
                if let imArtist = data["im:artist"] as? JSONDictionary,
                    let label = imArtist["label"] as? String {
                    vArtist = label
                }
                
                
                
                
                //Video Url
                if let link = data["link"] as? JSONArray,
                    let vUrl = link[1] as? JSONDictionary,
                    let attributes = vUrl["attributes"] as? JSONDictionary,
                    let href = attributes["href"] as? String {
                    vVideoUrl = href
                }
                
                
                
                
                // The Artist ID for iTunes Search API
                if let id = data["id"] as? JSONDictionary,
                    let attributes = id["attributes"] as? JSONDictionary,
                    let Imid = attributes["im:id"] as? String {
                    vImid = Imid
                }
                
                
                
                // The Genre
                if let category = data["category"] as? JSONDictionary,
                    let attributes = category["attributes"] as? JSONDictionary,
                    let term = attributes["term"] as? String {
                    vGenre = term
                }
                
                
                
                // Video Link to iTunes
                if let id = data["id"] as? JSONDictionary,
                    let label = id["label"] as? String {
                    vLinkToiTunes = label
                }
                
                
                
                
                // The Release Date
                if let imReleaseDate = data["im:releaseDate"] as? JSONDictionary,
                    let attributes = imReleaseDate["attributes"] as? JSONDictionary,
                    let label = attributes["label"] as? String {
                    vReleaseDte = label
                }
                
                
                
                let currentVideo = Video(vRank: index + 1, vName: vName, vRights: vRights, vPrice: vPrice, vImageUrl: vImageUrl, vArtist: vArtist, vVideoUrl: vVideoUrl, vImid: vImid, vGenre: vGenre, vLinkToiTunes: vLinkToiTunes, vReleaseDte: vReleaseDte)
                
                videos.append(currentVideo)
                
                
            }
            
        }
        
        return videos
        
    }
}

