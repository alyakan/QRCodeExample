//
//  ViewController.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 22/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Coordinator Pattern"
    }

    @IBAction func buyTapped(_ sender: Any) {
        coordinator?.buySubscription()
    }

    @IBAction func createAccountTapped(_ sender: Any) {
        coordinator?.createAccount()
    }
}
