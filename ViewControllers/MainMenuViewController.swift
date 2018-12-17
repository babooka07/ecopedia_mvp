//
//  MainMenuViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 06.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func unwindToMainMenu(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func QRreaderBtnDidTap(_ sender: Any) {
        
        let storibiard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storibiard.instantiateViewController(withIdentifier: "QRReaderViewControllerIdentifier")
                self.navigationController?.pushViewController(targetVC, animated: true) 
    }
}
