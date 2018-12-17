//
//  QRReaderViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 08.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit
import AVFoundation

//

class QRReaderViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate
{

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    @IBOutlet weak var simulateAnimalBTN: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        capchureQRCode()
//            found(code: "1")
    }
    
    func capchureQRCode() {

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }

        let videoInput: AVCaptureInput

        do {

            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)

        }catch {
            return
        }


        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }


        let metaDataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metaDataOutput) {
            captureSession.addOutput(metaDataOutput)

            metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDataOutput.metadataObjectTypes = [.qr]

        }else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        view.addSubview(simulateAnimalBTN)
        captureSession.startRunning()

    }



    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Yuor device doesn't support scanning", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else {return}
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
    }
    
    
    @IBAction func simulateBtnDidTap(_ sender: Any) {
        captureSession.stopRunning()
        let alert = UIAlertController(title: "читер", message: "выбери животнку", preferredStyle: .actionSheet)
        let act1 = UIAlertAction(title: "Лев", style: .default) { (alrt) in
            self.found(code: "1")
        }
        alert.addAction(act1)
        
        let act2 = UIAlertAction(title: "Верблюд", style: .default) { (alrt) in
            self.found(code: "2")
        }
        alert.addAction(act2)
        
        let act3 = UIAlertAction(title: "Кролег", style: .default) { (alrt) in
            self.found(code: "3")
        }
        alert.addAction(act3)
        
        let act4 = UIAlertAction(title: "Close", style: .destructive) { (alrt) in
            self.captureSession.startRunning()
        }
        alert.addAction(act4)
        
        present(alert, animated: true, completion: nil)
    }
    
    func found(code: String) {
           if let tag = Int(code) {
            for animalTag in DataBase.shared.getArrayOfAnimalsTags() {
                if animalTag == tag {
                    proceedCorrectQR(tag: tag)
                    return
                }
            }
            showNoMatchAlert()
        } else {
            showNoMatchAlert()
        }
        
    }
    
    func proceedCorrectQR(tag: Int)  {
        let animalModel = DataBase.shared.getItemModelBy(tag: tag)
        
        let alert = UIAlertController(title: animalModel.name, message: "Хотите посмотреть слайд животного?", preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "ДА", style: .default) { (alrt) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let targetController = storyboard.instantiateViewController(withIdentifier: "AnimalSlideViewControllerIdentifier") as! AnimalSlideViewController
                self.present(targetController, animated: true, completion: {
//
            })
            targetController.initializeWith(tag: tag)
        }
        alert.addAction(actionYes)
        
        let actionNo = UIAlertAction(title: "Отмена", style: .cancel) { (alrt) in
           self.captureSession.startRunning()
        }
        alert.addAction(actionNo)
        present(alert, animated: true, completion: nil)
    }
    
    func showNoMatchAlert() {
        let alert = UIAlertController(title: "ОШИБКА!", message: "Ваш QR код не соответствет ни одному животному", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        { (alrt) in
            self.captureSession.startRunning()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

