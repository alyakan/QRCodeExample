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

    var codeReader: CodeReader!

    override func viewDidLoad() {
        videoLayer = codeReader.videoPreview
        videoPreview.layer.addSublayer(videoLayer)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer.frame = videoPreview.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startReading()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        codeReader.stopReading()
    }

    @IBAction func startSessionTapped(_ sender: Any) {
        startReading()
    }

    private func startReading() {
        codeReader.startReading { [weak self] (code) in
            DispatchQueue.main.async {
                self?.coordinator?.showDetails(details: code)
            }
        }
    }
}
