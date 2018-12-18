//
//  MapViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 06.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
  
    
    @IBOutlet weak var mapScrollView: UIScrollView!
    
    @IBOutlet weak var setDefaultZoomScaleBtn: UIButton!
    @IBOutlet weak var myPositionBtn: UIButton!
    
    private var mapView = EcoparkMapView()
    private var infoView = InfoMapView()
    
    private var currentItemModel = ItemModel()
    
    private var isSetDefZoomScaleBtnVisible = false
    private var isSetMyPositionBtnVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultZoomScaleBtn.alpha = 0
        
        if let map = Bundle.main.loadNibNamed("EcoparkMapViewXIB", owner: nil, options: nil)?.first as? EcoparkMapView {
            mapView = map
            mapView.delegate = self
            mapView.frame.origin = CGPoint.zero
            mapScrollView.addSubview(mapView)
            mapScrollView.contentSize = mapView.frame.size
            mapView.viewIsOnScreen()
            mapScrollView.delegate = self
            
        }
        
        if let info = Bundle.main.loadNibNamed("InfoMapView", owner: nil, options: nil)?.first as? InfoMapView {
            infoView = info
            infoView.alpha = 0
            infoView.delegate = self
        }
        
        mapScrollView.minimumZoomScale = Consts.mapMinimumZoomScale
        mapScrollView.maximumZoomScale = Consts.mapMaximumZoomScale
        
        
        setMapToMyCurrentPosition(animated: false)
        self.myPositionBtn.alpha = 0
        isSetMyPositionBtnVisible = false

        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setMapToMyCurrentPosition(animated: true)
//        print("self.view" ,self.view.frame.width)
//        print("UIScreen",UIScreen.main.bounds.width)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait

    }
    
    private func setMapToMyCurrentPosition(animated: Bool) {
//
        let myCurrentX = mapView.myCurrentPos.x * mapScrollView.zoomScale - (self.view.frame.width / 2)
        let myCurrentY = mapView.myCurrentPos.y * mapScrollView.zoomScale - (self.view.frame.height / 2)

        mapScrollView.setContentOffset(CGPoint(x: myCurrentX, y: myCurrentY), animated: animated)
        
    }
    
    
    @IBAction func setDefaultZoomScaleBtnDidTap(_ sender: Any) {
        mapScrollView.setZoomScale(Consts.mapDefaultZoomScale, animated: true)
        isSetDefZoomScaleBtnVisible = false
        UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
            self.setDefaultZoomScaleBtn.alpha = 0
        }
    }
    
    
    @IBAction func myPosotionBtnDidTap(_ sender: Any) {
        setMapToMyCurrentPosition(animated: true)
    }
  

}

extension MapViewController: EcoparkMapViewDelegate {
    func itemDidTap(_ sender: Any) {
        currentItemModel = DataBase.shared.getItemModelBy(tag: (sender as! UIButton).tag)
        
        infoView.nameLabel.text = currentItemModel.name
        infoView.descriptionLabel.text = currentItemModel.description
        infoView.frame = self.view.frame
        self.view.addSubview(infoView)
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: view.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        self.view.setNeedsDisplay()
        
        UIView.animate(withDuration: Consts.serviceViewAnimationsDuration, animations: {
            self.infoView.alpha = 1
        }) { (isFinished) in
            if isFinished {
                self.infoView.alpha = 1
            }
        }
    }
}

extension MapViewController: InfoMapViewDelegate {
    func infoMapCancelDidTap() {
        UIView.animate(withDuration: Consts.serviceViewAnimationsDuration, animations: {
            self.infoView.alpha = 0
        }) { (isFinished) in
            if isFinished {
                self.infoView.alpha = 0
                self.infoView.removeFromSuperview()
                self.currentItemModel = ItemModel()
            }
        }
        
    }
    
    func infoMapSgowDirectDidTap() {
        infoView.alpha = 0
        infoView.removeFromSuperview()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NavigationToPointViewControllerIdentifier") as! NavigationToPointViewController
        controller.currentItemModel = currentItemModel
        self.present(controller, animated: true, completion: nil)
        
        currentItemModel = ItemModel()
    }
    
    func checkAndCorrectMapPosition () {
//        print(mapScrollView.contentOffset.x, mapScrollView.contentOffset.y )
        if mapScrollView.contentOffset.x <= 0 {
            mapScrollView.contentOffset.x = 0
        }
        if mapScrollView.contentOffset.y <= 0 {
            mapScrollView.contentOffset.y = 0
        }
//            print(mapView.frame.width)
//        if mapScrollView.contentOffset.x >= mapView.frame.width - self.view.frame.width {
//           mapScrollView.contentOffset.x = mapView.frame.width - self.view.frame.width
//        }
//        if mapScrollView.contentOffset.y >= mapView.frame.height - self.view.frame.height
//        {
//            mapScrollView.contentOffset.y = mapView.frame.height - self.view.frame.height
//        }
        
    }
}

extension MapViewController: UIScrollViewDelegate {
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        mapView.updateItemsWith(zoomScale: mapScrollView.zoomScale)
        mapScrollView.contentSize = mapView.frame.size
        if mapScrollView.zoomScale != Consts.mapDefaultZoomScale && !isSetDefZoomScaleBtnVisible {
            isSetDefZoomScaleBtnVisible = !isSetDefZoomScaleBtnVisible
            UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
                self.setDefaultZoomScaleBtn.alpha = 1
            }

        }
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkAndCorrectMapPosition()
        if !isSetMyPositionBtnVisible {
            isSetMyPositionBtnVisible = true
            UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
                self.myPositionBtn.alpha = 1
            }
        }
//
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isSetMyPositionBtnVisible = false
            UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
                self.myPositionBtn.alpha = 0
            }
    }
    
    
}
