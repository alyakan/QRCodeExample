//
//  ReaderViewController.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 23/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

class ReaderViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?

    @IBOutlet weak var videoPreview: UIView!
    private var videoLayer: CALayer!
    private var didSetConstraints = false

    private lazy var areaOfInterestView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = 2
        return view
    }()

    var codeReader: CodeScanner!

    override func viewDidLoad() {
        videoLayer = codeReader.videoPreviewLayer
        videoPreview.layer.addSublayer(videoLayer)
        addAreaOfInterest()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer.frame = videoPreview.bounds
        codeReader.rectOfInterest = areaOfInterestView.frame
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startReading()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBlur()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeReader.stopScanning()
    }

    override func updateViewConstraints() {
        guard didSetConstraints == false else { return }

        defer {
            didSetConstraints = true
        }

        NSLayoutConstraint.activate([
            areaOfInterestView.centerXAnchor.constraint(equalTo: videoPreview.centerXAnchor),
            areaOfInterestView.centerYAnchor.constraint(equalTo: videoPreview.centerYAnchor),
            areaOfInterestView.widthAnchor.constraint(equalToConstant: 224),
            areaOfInterestView.heightAnchor.constraint(equalToConstant: 224),

        ])

        super.updateViewConstraints()
    }

    @IBAction func startSessionTapped(_ sender: Any) {
        startReading()
    }

    private func startReading() {
        codeReader.startScanning { [weak self] code in
            guard let self = self else { return }
            self.coordinator?.showDetails(details: code.value)
        }
    }

    private func addAreaOfInterest() {
        videoPreview.addSubview(areaOfInterestView)
        view.setNeedsUpdateConstraints()
    }

    private func addBlur() {
        let blurView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        blurView.effect = UIBlurEffect(style: .dark)

        let scanLayer = CAShapeLayer()
        scanLayer.cornerRadius = 2

        let scanRect = areaOfInterestView.frame

        let outerPath = UIBezierPath(rect: scanRect)

        let superlayerPath = UIBezierPath.init(rect: blurView.frame)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = .evenOdd
        scanLayer.fillColor = UIColor.black.cgColor

        videoPreview.addSubview(blurView)
        blurView.layer.mask = scanLayer
    }
}
