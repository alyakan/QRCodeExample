//
//  CreateAccountViewController.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 22/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Create Account"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
