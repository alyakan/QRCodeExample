//
//  ReaderViewController.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 23/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

struct Constants {
    static let kScannerCornerRadius: CGFloat = 8.0
}

class ReaderViewController: UIViewController, Storyboarded {
    var codeScanner = AVCodeScanner()
    weak var coordinator: MainCoordinator?
    private var videoLayer: CALayer!
    private var didSetConstraints = false

    @IBOutlet private weak var videoPreview: UIView!

    private lazy var areaOfInterestView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.cornerRadius = Constants.kScannerCornerRadius
        return view
    }()

    // MARK: - ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        videoLayer = codeScanner.videoPreviewLayer
        videoPreview.layer.addSublayer(videoLayer)
        addAreaOfInterest()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer.frame = videoPreview.bounds
        codeScanner.rectOfInterest = areaOfInterestView.frame
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScanning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBlur()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeScanner.stopScanning()
    }

    // MARK: - IBActions

    @IBAction func startSessionTapped(_ sender: Any) {
        startScanning()
    }

    // MARK: - Helpers

    private func startScanning() {
        codeScanner.startScanning { [weak self] code in
            guard let self = self else { return }
            self.coordinator?.showDetails(details: code.value)
        }
    }

    private func addAreaOfInterest() {
        videoPreview.addSubview(areaOfInterestView)

        NSLayoutConstraint.activate([
            areaOfInterestView.centerXAnchor.constraint(equalTo: videoPreview.centerXAnchor),
            areaOfInterestView.centerYAnchor.constraint(equalTo: videoPreview.centerYAnchor, constant: -50),
            areaOfInterestView.widthAnchor.constraint(equalToConstant: 224),
            areaOfInterestView.heightAnchor.constraint(equalToConstant: 224),

        ])
    }

    private func addBlur() {
        videoPreview.addBlurWithCutoutRect(areaOfInterestView.frame)
    }
}


