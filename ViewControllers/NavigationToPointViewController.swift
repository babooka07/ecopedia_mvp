//
//  NavigationToPointViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 09.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit



class NavigationToPointViewController: UIViewController {

    //NavigationToPointViewControllerIdentifier
    @IBOutlet weak var navigationArrowView: UIImageView!
    
    var currentItemModel = ItemModel()
    
    @IBOutlet weak var testLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        testLabel.text = currentItemModel.name
        
    }
    
    
    @IBAction func cancelBtnDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
