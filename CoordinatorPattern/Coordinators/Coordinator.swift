//
//  Coordinator.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 22/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set } // TODO: Investigate how to use this
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
    }

    func start() {
//        let vc = ViewController.instantiate()
        let vc = ReaderViewController.instantiate()
        vc.codeScanner = AVCodeScanner()
        vc.coordinator = self // TODO: Move this to `instantiate()` method
        navigationController.pushViewController(vc, animated: false)
    }

    func buySubscription() {
        let child = BuyCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

    func createAccount() {
        let vc = CreateAccountViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func showDetails(details: String) {
        let vc = QRDetailsViewController.instantiate()
        vc.details = details
        vc.coordinator = self
        navigationController.present(vc, animated: true, completion: nil)
    }

    func childDidFinish(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}

extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_
        navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool)
    {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let buyViewController = fromViewController as? BuyViewController {
            childDidFinish(buyViewController.coordinator!)
        }
    }
}
