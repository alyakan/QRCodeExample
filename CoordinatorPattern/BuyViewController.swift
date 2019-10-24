//
//  BuyViewController.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 22/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController, Storyboarded {
    weak var coordinator: BuyCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Buy"
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        coordinator?.didFinishBuying()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
