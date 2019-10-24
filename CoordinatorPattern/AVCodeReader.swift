//
//  AVCodeReader.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 23/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import AVFoundation
import UIKit

protocol CodeReader {
    var videoPreview: CALayer { get }
    var rectOfInterest: CGRect { get set }
    func startReading(completion: @escaping (String) -> Void)
    func stopReading()
}

class AVCodeReader: NSObject {
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
    fileprivate var didRead: ((String) -> Void)?

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

extension AVCodeReader: AVCaptureMetadataOutputObjectsDelegate {
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
        stopReading()

        didRead?(code)
    }
}

extension AVCodeReader: CodeReader {
    func startReading(completion: @escaping (String) -> Void) {
        self.didRead = completion
        captureSession?.startRunning()
    }

    func stopReading() {
        captureSession?.stopRunning()
    }
}
