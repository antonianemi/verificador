//
//  ScannerProcessVC.swift
//  Dispatcher
//
//  Created by Ramiro Aguirre on 21/05/20.
//  Copyright © 2020 Innovasport-Dispatcher. All rights reserved.
//

import UIKit
import AVFoundation
import SCLAlertView

protocol ScannerResultProtocol {
    func getScannedCode(code:String)
}

class ScannerProcessVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    
    @IBOutlet weak var scannerView:UIView!
    @IBOutlet weak var cancelScanBtn:UIButton!
    @IBOutlet weak var inputManual:UITextField!
    @IBOutlet weak var addManualCodeBtn:UIButton!
    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var scannerDelegate: ScannerResultProtocol?
    
    var scannedCode: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        
//        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        var defaultVideoDevice: AVCaptureDevice?
        if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                    defaultVideoDevice = frontCameraDevice
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.global(qos: .userInteractive))

            metadataOutput.metadataObjectTypes = [
//                AVMetadataObject.ObjectType.qr,
//                        AVMetadataObject.ObjectType.aztec,
                AVMetadataObject.ObjectType.code128,
                AVMetadataObject.ObjectType.code39,
                AVMetadataObject.ObjectType.code39Mod43,
                AVMetadataObject.ObjectType.code93,
//                        AVMetadataObject.ObjectType.dataMatrix,
                AVMetadataObject.ObjectType.ean13,
                AVMetadataObject.ObjectType.ean8,
                AVMetadataObject.ObjectType.interleaved2of5,
                AVMetadataObject.ObjectType.itf14,
//                        AVMetadataObject.ObjectType.pdf417
                
            ]

        } else {
            failed()
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = self.scannerView.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        self.scannerView.layer.addSublayer(previewLayer);

        captureSession.startRunning();

        self.scannerView.addSubview(cancelScanBtn)
        self.scannerView.addSubview(inputManual)
        self.scannerView.addSubview(addManualCodeBtn)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        self.captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            if readableObject.stringValue != nil {
                self.scannedCode = readableObject.stringValue!
            }else {
                SCLAlertView().showWarning("", subTitle: "Intentelo de nuevo por favor.")
                return
            }
            
        }else{
            return
        }
        
        DispatchQueue.main.async {
            
            self.scannerDelegate?.getScannedCode(code: self.scannedCode)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func failed() {
        SCLAlertView().showError("Scanning not supported", subTitle: "Your device does not support scanning a code from an item. Please use a device with a camera.")
        captureSession = nil
    }
    
    override func viewWillLayoutSubviews() {
        
        let orientation: UIDeviceOrientation = UIDevice.current.orientation

        switch (orientation) {
        case .portrait:
            previewLayer?.connection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            previewLayer?.connection?.videoOrientation = .landscapeRight
        case .landscapeLeft:
            previewLayer?.connection?.videoOrientation = .landscapeRight
        default:
            previewLayer?.connection?.videoOrientation = .landscapeRight
        }
    }
    
    @IBAction func cancelScanBtnPressed(_ sender: Any) {
        self.captureSession.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addManualCodeBtnPressed(_ sender:Any){
        
        self.scannerDelegate?.getScannedCode(code: self.inputManual.text ?? "")
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
