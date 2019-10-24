//
//  AVCodeReader.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 23/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import AVFoundation
import UIKit

protocol CodeScanner {
    typealias ScanResult = (String) -> Void
    var videoPreview: CALayer { get }
    var rectOfInterest: CGRect { get set }
    func startScanning(completion: @escaping ScanResult)
    func stopScanning()
}

class AVCodeScanner: NSObject {
    var rectOfInterest: CGRect {
        didSet {
            guard let captureVideoPreview = captureVideoPreview else {
                return
            }

            captureMetadataOutput.rectOfInterest = captureVideoPreview.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
        }
    }

    fileprivate(set) var videoPreview = CALayer()
    fileprivate var captureMetadataOutput = AVCaptureMetadataOutput()
    fileprivate var captureVideoPreview: AVCaptureVideoPreviewLayer?

    fileprivate var captureSession: AVCaptureSession?
    fileprivate var scanCompletionHandler: (ScanResult)?

    override init() {
        rectOfInterest = CGRect.zero
        super.init()

        //Make sure the device can handle video
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }

        //session
        captureSession = AVCaptureSession()

        //input
        captureSession?.addInput(deviceInput)

        //output
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        //interprets qr codes only
        captureMetadataOutput.metadataObjectTypes = [.qr]

        //preview
        guard let captureSession = captureSession else { return }
        captureVideoPreview = AVCaptureVideoPreviewLayer(session: captureSession)
        guard let captureVideoPreview = captureVideoPreview else { return }
        captureVideoPreview.videoGravity = .resizeAspectFill
        self.videoPreview = captureVideoPreview
    }


}

extension AVCodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard
            let readableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = readableCode.stringValue else {
             return
        }

        //Vibrate the phone
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        stopScanning()

        scanCompletionHandler?(code)
    }
}

extension AVCodeScanner: CodeScanner {
    func startScanning(completion: @escaping ScanResult) {
        self.scanCompletionHandler = completion
        captureSession?.startRunning()
    }

    func stopScanning() {
        captureSession?.stopRunning()
    }
}
