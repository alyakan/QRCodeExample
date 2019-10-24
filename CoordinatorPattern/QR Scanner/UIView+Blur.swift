//
//  UIView+Blur.swift
//  CoordinatorPattern
//
//  Created by Aly Yakan on 24/10/2019.
//  Copyright © 2019 Aly Yakan. All rights reserved.
//

import UIKit

extension UIView {

    /**
        Adds a Blur effect to the calling view with a clear, cut out rectangle.

     - Parameter cutoutRect: A CGRect representing the clear area inside the blur view.
     */
    func addBlurWithCutoutRect(_ cutoutRect: CGRect) {
        let blurView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        blurView.effect = UIBlurEffect(style: .systemThinMaterial)

        let scanLayer = CAShapeLayer()
        scanLayer.cornerRadius = Constants.kScannerCornerRadius

        let scanRect = cutoutRect

        let outerPath = UIBezierPath(roundedRect: scanRect, cornerRadius: Constants.kScannerCornerRadius)

        let superlayerPath = UIBezierPath(rect: blurView.frame)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = .evenOdd
        scanLayer.fillColor = UIColor.black.cgColor

        addSubview(blurView)
        blurView.layer.mask = scanLayer
    }
}
