//
//  ViewController.swift
//  QRCodeScanner
//
//  Created by ToLToL on 29/08/2018.
//  Copyright © 2018 ToLToL. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var square: UIImageView!
    
    var video = AVCaptureVideoPreviewLayer()
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                           AVMetadataObject.ObjectType.code39,
                                           AVMetadataObject.ObjectType.code39Mod43,
                                           AVMetadataObject.ObjectType.code93,
                                           AVMetadataObject.ObjectType.code128,
                                           AVMetadataObject.ObjectType.ean8,
                                           AVMetadataObject.ObjectType.ean13,
                                           AVMetadataObject.ObjectType.aztec,
                                           AVMetadataObject.ObjectType.pdf417,
                                           AVMetadataObject.ObjectType.itf14,
                                           AVMetadataObject.ObjectType.dataMatrix,
                                           AVMetadataObject.ObjectType.interleaved2of5,
                                           AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        } catch {
            print(error)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = supportedCodeTypes
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        self.view.bringSubview(toFront: square)
        
        session.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if supportedCodeTypes.contains(object.type) {
                    let alert = UIAlertController(title: "Your code is:", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = object.stringValue
                    }))
                    present(alert, animated: true, completion: nil)
                    print(object)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

