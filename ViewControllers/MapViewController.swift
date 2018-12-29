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
    
    private var currentMapWidth:CGFloat = 0
    private var currentMapHeidth:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultZoomScaleBtn.alpha = 0
        
        if let map = Bundle.main.loadNibNamed("EcoparkMapViewXIB", owner: nil, options: nil)?.first as? EcoparkMapView {
            mapView = map
            mapView.delegate = self
            mapView.frame.origin = CGPoint.zero
            mapScrollView.addSubview(mapView)
            mapScrollView.contentSize = mapView.frame.size
            currentMapWidth = mapView.frame.width
            currentMapHeidth = mapView.frame.height
            mapView.viewIsOnScreen()
            mapScrollView.delegate = self
//            setCorrectScrollViewPositionAndSize()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .all
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        setMapToMyCurrentPosition(animated: true)
    }
    
    
    private func setMapToMyCurrentPosition(animated: Bool) {
//
        let myCurrentX = mapView.myCurrentPos.x * mapScrollView.zoomScale - (self.view.frame.width / 2)
        let myCurrentY = mapView.myCurrentPos.y * mapScrollView.zoomScale - (self.view.frame.height / 2)

        mapScrollView.setContentOffset(CGPoint(x: myCurrentX, y: myCurrentY), animated: animated)
        
    }
    
    private func setCorrectScrollViewPositionAndSize() {
          mapView.frame = CGRect(x: 0, y: 0, width: (currentMapWidth * mapScrollView.zoomScale), height: (currentMapHeidth * mapScrollView.zoomScale))
//        print(mapScrollView.contentOffset)
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
        
        let alert = UIAlertController(title: currentItemModel.name, message: currentItemModel.description, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let showDirectionAction = UIAlertAction(title: "Направление", style: .default) { (alrt) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "NavigationToPointViewControllerIdentifier") as! NavigationToPointViewController
            controller.currentItemModel = self.currentItemModel
            self.present(controller, animated: true, completion: nil)
            
            self.currentItemModel = ItemModel()
        }
        
        alert.addAction(showDirectionAction)
        
        present(alert, animated: true, completion: nil)
        
//кастомный алерт
      /*  infoView.nameLabel.text = currentItemModel.name
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
        } */
    }
 
 }

extension MapViewController: InfoMapViewDelegate {
    func infoMapCancelDidTap() {
//        UIView.animate(withDuration: Consts.serviceViewAnimationsDuration, animations: {
//            self.infoView.alpha = 0
//        }) { (isFinished) in
//            if isFinished {
//                self.infoView.alpha = 0
//                self.infoView.removeFromSuperview()
//                self.currentItemModel = ItemModel()
//            }
//        }
        
    }
    
    func infoMapSgowDirectDidTap() {
//        infoView.alpha = 0
//        infoView.removeFromSuperview()
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "NavigationToPointViewControllerIdentifier") as! NavigationToPointViewController
//        controller.currentItemModel = currentItemModel
//        self.present(controller, animated: true, completion: nil)
//
//        currentItemModel = ItemModel()
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
        
      setCorrectScrollViewPositionAndSize()


    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mapView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isSetMyPositionBtnVisible {
            isSetMyPositionBtnVisible = true
            UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
                self.myPositionBtn.alpha = 1
            }
        }

       setCorrectScrollViewPositionAndSize()

    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isSetMyPositionBtnVisible = false
            UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
                self.myPositionBtn.alpha = 0
            }
        setCorrectScrollViewPositionAndSize()
    }
    
    
}
