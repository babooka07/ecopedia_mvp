//
//  EcoparkMapView.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 09.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit

protocol EcoparkMapViewDelegate: class {
    func itemDidTap (_ sender: Any)
}


class EcoparkMapView: UIView {

    @IBOutlet weak var myCurrentPositionView: UIView!
    @IBOutlet var arrPointOfInterest: [UIButton]!
    
    private var isAnimalIqonsVisible = true
    private var arrOfTagsToDeleteWhenZoom = DataBase.shared.getArrayOfDeleteWhenZoomModelsTags()
    
    weak var delegate: EcoparkMapViewDelegate?
    
    var myCurrentPos = CGPoint(x: 800, y: 500)
    
    func viewIsOnScreen () {
        updateMyCurrentPosView()
    }
    
    private func updateMyCurrentPosView(){
        
        myCurrentPositionView.center = myCurrentPos
    }
    
    func updateItemsWith(zoomScale: CGFloat) {
        if zoomScale <= Consts.mapZoomScailToRemoveAnimalsIqons {
            if isAnimalIqonsVisible {
                isAnimalIqonsVisible = !isAnimalIqonsVisible
                for iqon in arrPointOfInterest {
                    for tagToDelete in arrOfTagsToDeleteWhenZoom {
                        if iqon.tag == tagToDelete {
                            UIView.animate(withDuration: Consts.serviceViewAnimationsDuration, animations: {
                                iqon.alpha = 0
                            })
                        }
                    }
                }
            }
        }else {
            if !isAnimalIqonsVisible {
                isAnimalIqonsVisible = !isAnimalIqonsVisible
                for iqon in arrPointOfInterest {
                    for tagToDelete in arrOfTagsToDeleteWhenZoom {
                        if iqon.tag == tagToDelete {
                            UIView.animate(withDuration: Consts.serviceViewAnimationsDuration, animations: {
                                iqon.alpha = 1
                            })
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func itemDidTap(_ sender: Any) {
        delegate?.itemDidTap(sender)
    }
    

}
