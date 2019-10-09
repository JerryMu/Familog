//
//  NotificationViewController.swift
//  Familog
//
//  Created by 刘仕晟 on 2019/10/10.
//
//  The entire file is working for the notification page

import UIKit

extension UIView {
  
  func smoothRoundCorners(to radius: CGFloat) {
    let maskLayer = CAShapeLayer()
    maskLayer.path = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: radius
    ).cgPath
    
    layer.mask = maskLayer
  }
  
}
