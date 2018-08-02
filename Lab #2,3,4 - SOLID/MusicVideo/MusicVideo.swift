//
//  MusicVideo.swift
//  MusicVideo
//
//  Created by Victoria on 7/10/18.
//  Copyright © 2018 Victoria. All rights reserved.
//


import Foundation

class Video {
    
    
    
    // Data encapsulation
    private(set) var vRank:Int
    private(set) var vName:String
    private(set) var vRights:String
    private(set) var vPrice:String
    private(set) var vImageUrl:String
    private(set) var vArtist:String
    private(set) var vVideoUrl:String
    private(set) var vImid:String
    private(set) var vGenre:String
    private(set) var vLinkToiTunes:String
    private(set) var vReleaseDte:String
    
    // This variable gets created from the UI
    var vImageData:NSData?
    
    
    
    init(vRank:Int, vName:String, vRights:String, vPrice:String,
         vImageUrl:String, vArtist:String, vVideoUrl:String, vImid:String,
         vGenre:String, vLinkToiTunes:String, vReleaseDte:String) {
        
        
        self.vRank = vRank
        self.vName = vName
        self.vRights = vRights
        self.vPrice = vPrice
        self.vImageUrl = vImageUrl
        self.vArtist = vArtist
        self.vVideoUrl = vVideoUrl
        self.vImid = vImid
        self.vGenre = vGenre
        self.vLinkToiTunes = vLinkToiTunes
        self.vReleaseDte = vReleaseDte
        
    }
}
