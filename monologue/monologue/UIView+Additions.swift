//
//  NotificationViewController.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/10.
//
//  The entire file is working for the notification page


import UIKit


extension UIView {
    // let the corner of chat box round
    func smoothRoundCorners(to radius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: radius
        ).cgPath
        layer.mask = maskLayer
    }
}
