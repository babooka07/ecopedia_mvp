//
//  ItemModel.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 06.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

enum PoiType {
    case animal
//    case exit
    case pointOfInterest
    case plaseholder
}

enum PoiCategory: String {
    case exit       = "Exit"
    case toilet     = "Toilet"
    case food       = "Food"
    case actions    = "Actions"
    case souvwnir   = "Souvenir"
    
}

import Foundation

class ItemModel {
    
    var tag: Int
    var type: PoiType
    var poiCategory: PoiCategory?
    var coords: (latitude: Double, longitude: Double)
    var name:String
    var description: String
    var hideIqonWhenBigZoom = false
    var imageForListName: String?
    var audioSlideResourceName : String?
    var animalURL: String?
    
    var isVisited = false
    
    init (tag:Int, type:PoiType, coords:(Double, Double), name: String, poiCategory:PoiCategory?, description: String, hideIqonWhenBigZoom: Bool, imageForListName: String?, audioSlideResourceName: String?, animalURL: String?){
        self.tag = tag
        self.type = type
        self.coords = coords
        self.name = name
        self.poiCategory = poiCategory
        self.description = description
        self.hideIqonWhenBigZoom = hideIqonWhenBigZoom
        self.imageForListName = imageForListName
        self.audioSlideResourceName = audioSlideResourceName
        self.animalURL = animalURL
    }
    
    // initializtion of placeholder
     init () {
        self.tag = -1
        self.type = .plaseholder
        self.coords = (-100, -100)
        self.name = "PLACEHOLDER"
        self.poiCategory = nil
        self.description = "<<ERROR>> \n !!!!!ITEM MODEL IS MISSING!!!!! "
    }
    
}
