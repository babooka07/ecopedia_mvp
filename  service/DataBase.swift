//
//  DataBase.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 07.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import Foundation

class DataBase {
    
    static let shared = DataBase()
    
    var arrOfItemModels: [ItemModel] = []
    
    //save data
    
    var poiListFiltersArray: [Bool] = [true, true, true, true, true]
    
    var vizitedItemsDictionary: [Int: Bool] = [:]
    
    
  private init() {
        initializeModels()
        //инициировать, если сейв посещенных не найден - устанавливает дефолтные значения в дикшинари посещенных
        initializedDefaultVizitedAnimals()
    }
    
    
    private func initializedDefaultVizitedAnimals() {
        for i in 1..<arrOfItemModels.count {
//            print(i)
            vizitedItemsDictionary[i] = false
            
        }
//        print(vizied)
        
    }
    
    // ATTANTION!!!
    //for 'name' please use less than 15 symbols
    //for 'description' please use less than 100 symbols
    
   private func initializeModels() {
        arrOfItemModels = []
    
        let item0 = ItemModel()
        arrOfItemModels.append(item0)
//
    
    let item1 = ItemModel(tag: 1, type: .animal, coords: (10,10), name: "Lion", poiCategory: nil, description: "Лев, царь зверей", hideIqonWhenBigZoom: true, imageForListName: "lion-150x150", audioSlideResourceName: "Lion", animalURL: "https://en.wikipedia.org/wiki/Lion" )
        arrOfItemModels.append(item1)
        
    let item2 = ItemModel(tag: 2, type: .animal, coords: (20,20), name: "Camel", poiCategory: nil, description: "Верблюд он и в африке верблюд", hideIqonWhenBigZoom: true, imageForListName: "camel-150x150", audioSlideResourceName: "Camel", animalURL: "https://ru.wikipedia.org/wiki/Верблюды")
        arrOfItemModels.append(item2)
        
    let item3 = ItemModel(tag: 3, type: .animal, coords: (30,30), name: "Rabbit",  poiCategory: nil, description: "Кролег он и в африке кролег", hideIqonWhenBigZoom: true, imageForListName: "rabbit-150x150", audioSlideResourceName: "", animalURL: "")
        arrOfItemModels.append(item3)
        
        let item4 = ItemModel(tag: 4, type: .pointOfInterest, coords: (40,40), name: "Theater", poiCategory: .actions, description: "Открытый летний театр", hideIqonWhenBigZoom: true, imageForListName: "", audioSlideResourceName: "", animalURL: "")
        arrOfItemModels.append(item4)
        
        let item5 = ItemModel(tag: 5, type: .pointOfInterest, coords: (50,50), name: "Exit", poiCategory: .exit, description: "Выход к автобусной остановке", hideIqonWhenBigZoom: false, imageForListName: "", audioSlideResourceName: "", animalURL: "")
        arrOfItemModels.append(item5)
        
        let item6 = ItemModel(tag: 6, type: .pointOfInterest, coords: (60,60), name: "Toilet", poiCategory: .toilet, description: "Мужской и женский туалеты", hideIqonWhenBigZoom: false, imageForListName: "", audioSlideResourceName: "", animalURL: "")
        arrOfItemModels.append(item6)
        
        let item7 = ItemModel(tag: 7, type: .pointOfInterest, coords: (70,70), name: "Junk food", poiCategory: .food, description: "Хотдоги и кофе", hideIqonWhenBigZoom: true, imageForListName: "", audioSlideResourceName: "", animalURL: "")
    
    
        arrOfItemModels.append(item7)
    }
    
    //MARK: Static Functions
    func getItemModelBy(tag: Int) -> ItemModel {
        var itemForReturn = arrOfItemModels[0]
        
        for item in arrOfItemModels {
            if item.tag == tag {
                itemForReturn = item
            }
            
        }
        return itemForReturn
    }
    
    func getArrayOfModelsBy(type: PoiType) -> [ItemModel] {
        var array:[ItemModel] = []
        for item in arrOfItemModels where item.type == type {
            array.append(item)
        }
        return array
    }
    
    func getArrayOfDeleteWhenZoomModelsTags() -> [Int] {
        var arrayToReturn: [Int] = []
        for item in arrOfItemModels {
            if (item.hideIqonWhenBigZoom) {
                arrayToReturn.append(item.tag)
            }
        }
        
        return arrayToReturn
    }
    
    func getArrayOfAnimalsTags() -> [Int] {
        var arrayToReturn: [Int] = []
        for item in arrOfItemModels {
            
            switch item.type {
            case .animal:
                arrayToReturn.append(item.tag)
            default:
                break
            }
            
        }
        
        return arrayToReturn
    }
    
    func getArrayOfAnimals() -> [ItemModel] {
        var arrayToReturn: [ItemModel] = []
        for item in arrOfItemModels {
            
            switch item.type {
            case .animal:
                arrayToReturn.append(item)
            default:
                break
            }
            
        }
        
        return arrayToReturn
    }
    
    func getArrayOfPoi() -> [ItemModel] {
        var arrayToReturn: [ItemModel] = []
        for item in arrOfItemModels {
            
            switch item.type {
            case .pointOfInterest:
                arrayToReturn.append(item)
            default:
                break
            }
            
        }
        
        return arrayToReturn
    }

    func getArrayOfPoiByPoiCategery(poiCategory: PoiCategory) -> [ItemModel] {
        var arrayToReturn: [ItemModel] = []
        for item in arrOfItemModels {
            
            switch item.poiCategory {
            case poiCategory:
                arrayToReturn.append(item)
            default:
                break
            }
            
        }
        
        return arrayToReturn
    }
    
    func setVizitedItemBy(tag: Int) {
        if let isVizited = vizitedItemsDictionary[tag] {
            if  !isVizited {
                vizitedItemsDictionary[tag] = true
            }
        }
    }
    
    func getIsvizitedItemByTag(tag: Int) -> Bool {
        if let isVizited = vizitedItemsDictionary[tag] {
            return isVizited
        } else {
            print("DataBase.getIsvizitedItemByTag(tag) - CRITICAL ERROR! - dicrionary element is misseng")
            return false
        }
    }
    
}
