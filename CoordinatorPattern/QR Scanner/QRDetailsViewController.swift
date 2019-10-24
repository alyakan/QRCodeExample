//
//  QRDetailsViewController.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 24/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

class QRDetailsViewController: UIViewController, Storyboarded {

    weak var coordinator: Coordinator?
    var details = "No details provided"
    @IBOutlet weak var detailsLabel: UILabel!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        details = "No details provided"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        details = "No details provided"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailsLabel.text = details
    }
}
