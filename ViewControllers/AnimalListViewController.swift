//
//  AnimalListViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 08.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit

class AnimalListViewController: UIViewController {
    
    @IBOutlet weak var animalsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "anilmalListTableViewCell", bundle: nil)
        animalsTableView.register(nib, forCellReuseIdentifier: "anilmalListTableViewCellIdentifier")
        
        animalsTableView.delegate = self
        animalsTableView.dataSource = self
        animalsTableView.tableFooterView = UIView()
    }
    
    // MARK: - Navigation
    func presentNavigationVCWith(animalModel: ItemModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: "NavigationToPointViewControllerIdentifier") as! NavigationToPointViewController
        targetVC.currentItemModel = animalModel
        present(targetVC, animated: true, completion: nil)
    }
    
    func presentSlideVCWith(animalModel: ItemModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier: "AnimalSlideViewControllerIdentifier") as! AnimalSlideViewController
        present(targetVC, animated: true, completion: nil)
        targetVC.initializeWith(tag: animalModel.tag)

    }

}
    


extension AnimalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataBase.shared.getArrayOfAnimals().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "anilmalListTableViewCellIdentifier", for: indexPath) as! anilmalListTableViewCell
        let animalModel = DataBase.shared.getArrayOfAnimals()[indexPath.row]
        cell.nameLabel.text = animalModel.name
        cell.descriptionLabel.text = animalModel.description
        
        if let image = UIImage(named: (animalModel.imageForListName!)) {
           cell.animalImageView.image = image
        }
        
        if DataBase.shared.getIsvizitedItemByTag(tag: animalModel.tag) {
            cell.okIndicatorImageView.alpha = 1
        }else {
            cell.okIndicatorImageView.alpha = 0
        }
        return cell
    }
}

extension AnimalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animalModel = DataBase.shared.getArrayOfAnimals()[indexPath.row]
        
        if DataBase.shared.getIsvizitedItemByTag(tag: animalModel.tag) {
            let alert = UIAlertController(title: animalModel.name, message: "Вы уже посещали это животное, вы хотите посетить его вновь или послушать слайд еще раз?", preferredStyle: .alert)
            
            let actionShowDirection = UIAlertAction(title: "Пройти", style: .default) { (alrt) in
                self.presentNavigationVCWith(animalModel: animalModel)
            }
            alert.addAction(actionShowDirection)
            
            let actionLaunchSlide = UIAlertAction(title: "Слайд", style: .default) { (alrt) in
                self.presentSlideVCWith(animalModel: animalModel)
            }
            alert.addAction(actionLaunchSlide)
            
            let actionCancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
            alert.addAction(actionCancel)
            present(alert, animated: true, completion: nil)
            
        }else {
            
            let alert = UIAlertController(title: animalModel.name, message: "Показать дорогу к животному?", preferredStyle: .alert)
            
            let actionCancel = UIAlertAction(title: "НЕТ", style: .destructive, handler: nil)
            alert.addAction(actionCancel)
            
            let actionShowDirection = UIAlertAction(title: "ДА", style: .default) { (alrt) in
                self.presentNavigationVCWith(animalModel: animalModel)
            }
            alert.addAction(actionShowDirection)
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
}

