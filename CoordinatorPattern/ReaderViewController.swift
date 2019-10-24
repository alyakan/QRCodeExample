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
        addAreaOfInterest()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer.frame = videoPreview.bounds
        codeReader.rectOfInterest = CGRect(x: 100, y: 100, width: 100, height: 100)
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
        codeReader.startReading { [weak self] code in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.coordinator?.showDetails(details: code)
            }
        }
    }

    private func addAreaOfInterest() {
        let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.cornerRadius = 2

        videoPreview.addSubview(view)
    }
}
