//
//  BuyCoordinator.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 22/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

class BuyCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parentCoordinator: MainCoordinator? // TODO: Put this in the protocol

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = BuyViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

//    func didFinishBuying() {
//        parentCoordinator?.childDidFinish(self)
//    }
}
