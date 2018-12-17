//
//  PoiListViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 08.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit

class PoiListViewController: UIViewController {
    @IBOutlet weak var filtersConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var poiListableView: UITableView!
    @IBOutlet weak var filtersView: UIView!
    
    
    @IBOutlet weak var toiletFilterSwith: UISwitch!
    @IBOutlet weak var exitFilterSwitch: UISwitch!
    @IBOutlet weak var foodFilterSwith: UISwitch!
    @IBOutlet weak var actionFiterSwitch: UISwitch!
    @IBOutlet weak var souvenirFilterSwitch: UISwitch!
    
    private var arrayOfFilters:[Bool] = []
    
    private var arrOfItems: [ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersView.alpha = 0
        
        arrayOfFilters = DataBase.shared.poiListFiltersArray
        
        
        updateTableViewByFilters()
        let nib = UINib(nibName: "PoiListTableViewCell", bundle: nil)
        poiListableView.register(nib, forCellReuseIdentifier:
            "PoiListTableViewCellIdentifier")
        poiListableView.delegate = self
        poiListableView.dataSource = self
        poiListableView.tableFooterView = UIView()
        
        
    }
    
    func updateTableViewByFilters () {
        arrOfItems = []
        arrayOfFilters = []
        arrayOfFilters = DataBase.shared.poiListFiltersArray
        
        if arrayOfFilters[0] {
            arrOfItems += DataBase.shared.getArrayOfPoiByPoiCategery(poiCategory: .toilet)
                toiletFilterSwith.setOn(true, animated: false)
        }else{toiletFilterSwith.setOn(false, animated: false)}
        
        if arrayOfFilters[1] {
            arrOfItems += DataBase.shared.getArrayOfPoiByPoiCategery(poiCategory: .exit)
            exitFilterSwitch.setOn(true, animated: false)
        }else{exitFilterSwitch.setOn(false, animated: false)}
        
        if arrayOfFilters[2] {
            arrOfItems += DataBase.shared.getArrayOfPoiByPoiCategery(poiCategory: .food)
            foodFilterSwith.setOn(true, animated: false)
        }else{foodFilterSwith.setOn(false, animated: false)}
        
        if arrayOfFilters[3] {
            arrOfItems += DataBase.shared.getArrayOfPoiByPoiCategery(poiCategory: .actions)
            actionFiterSwitch.setOn(true, animated: false)
        }else{actionFiterSwitch.setOn(false, animated: false)}
        
        if arrayOfFilters[4] {
            arrOfItems += DataBase.shared.getArrayOfPoiByPoiCategery(poiCategory: .souvwnir)
            souvenirFilterSwitch.setOn(true, animated: false)
        }else{souvenirFilterSwitch.setOn(false, animated: false)}
        
        poiListableView.reloadData()
    }
    
    //MARK: navigation
    
    func presentNavigationVCWith(animalModel: ItemModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: "NavigationToPointViewControllerIdentifier") as! NavigationToPointViewController
        targetVC.currentItemModel = animalModel
        present(targetVC, animated: true, completion: nil)
    }
    

    @IBAction func filtersDoneBtnDidTap(_ sender: Any) {
        if toiletFilterSwith.isOn {
            DataBase.shared.poiListFiltersArray[0] = true
        } else {
            DataBase.shared.poiListFiltersArray[0] = false
        }
        if exitFilterSwitch.isOn {
            DataBase.shared.poiListFiltersArray[1] = true
        } else {
            DataBase.shared.poiListFiltersArray[1] = false
        }
        if foodFilterSwith.isOn {
            DataBase.shared.poiListFiltersArray[2] = true
        } else {
            DataBase.shared.poiListFiltersArray[2] = false
        }
        if actionFiterSwitch.isOn {
            DataBase.shared.poiListFiltersArray[3] = true
        } else {
            DataBase.shared.poiListFiltersArray[3] = false
        }
        if souvenirFilterSwitch.isOn {
            DataBase.shared.poiListFiltersArray[4] = true
        } else {
            DataBase.shared.poiListFiltersArray[4] = false
        }
        
        updateTableViewByFilters()

        poiListableView.allowsSelection = true

        UIView.animate(withDuration: Consts.serviceViewAnimationsDuration, animations: {
            self.filtersView.frame.origin.x = -250
        }, completion: { (isFinished) in
            if isFinished {
                self.filtersView.alpha = 0
            }
        })
        
    }
    
    @IBAction func filtersBtnDidTap(_ sender: Any) {
        filtersView.alpha = 1

        poiListableView.allowsSelection = false
        UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
            
            self.filtersView.frame.origin.x = 0

        }
        
    }
}

extension PoiListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "PoiListTableViewCellIdentifier", for: indexPath) as! PoiListTableViewCell
        
        cell.nameLabel.text = arrOfItems[indexPath.row].name
        cell.descriptionLabel.text = arrOfItems[indexPath.row].description
        
        return cell
    }
    
    
}
extension PoiListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemModel = arrOfItems[indexPath.row]
            
        let alert = UIAlertController(title: itemModel.name, message: "Проложить маршрут?", preferredStyle: .alert)
            
        let actionNo = UIAlertAction(title: "НЕТ", style: .destructive, handler: nil)
        alert.addAction(actionNo)
        
        let actionYes = UIAlertAction(title: "ДА", style: .default) { (alrt) in
            self.presentNavigationVCWith(animalModel: itemModel)
        }
        alert.addAction(actionYes)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
