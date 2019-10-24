//
//  AVCodeReader.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 23/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import AVFoundation
import UIKit

struct ScannedCode {
    let type: AVMetadataObject.ObjectType = .qr
    let value: String
    var bounds: CGRect?
}

protocol CodeScanner {
    typealias ScanResult = (ScannedCode) -> Void
    var videoPreviewLayer: CALayer { get }
    var rectOfInterest: CGRect { get set }
    func startScanning(completion: @escaping ScanResult)
    func stopScanning()
}

class AVCodeScanner: NSObject {

    // MARK: - Properties

    fileprivate(set) var videoPreviewLayer = CALayer()
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var captureMetadataOutput = AVCaptureMetadataOutput()
    fileprivate var captureVideoPreview: AVCaptureVideoPreviewLayer?
    fileprivate var scanCompletionHandler: (ScanResult)?

    var rectOfInterest: CGRect {
        didSet {
            guard let captureVideoPreview = captureVideoPreview else {
                return
            }

            captureMetadataOutput.rectOfInterest = captureVideoPreview.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
        }
    }

    // MARK: - Initializers

    override init() {
        rectOfInterest = CGRect.zero
        super.init()

        // Make sure the device can handle video
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }

        // Initialize session
        captureSession = AVCaptureSession()

        // Add input of type video
        captureSession?.addInput(deviceInput)

        // Add output of type metadata
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        // Interpret qr codes only
        captureMetadataOutput.metadataObjectTypes = [.qr]

        // Setup video preview
        guard let captureSession = captureSession else { return }
        captureVideoPreview = AVCaptureVideoPreviewLayer(session: captureSession)

        guard let captureVideoPreview = captureVideoPreview else { return }
        captureVideoPreview.videoGravity = .resizeAspectFill
        videoPreviewLayer = captureVideoPreview
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension AVCodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard
            let readableCode = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let code = readableCode.stringValue else {
             return
        }

        print(readableCode.bounds)

        let scannedCode = ScannedCode(value: code)

        //Vibrate the phone
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        stopScanning()

        scanCompletionHandler?(scannedCode)
    }
}

// MARK: - Code Scanner Protocol

extension AVCodeScanner: CodeScanner {
    func startScanning(completion: @escaping ScanResult) {
        self.scanCompletionHandler = completion
        captureSession?.startRunning()
    }

    func stopScanning() {
        captureSession?.stopRunning()
    }
}
