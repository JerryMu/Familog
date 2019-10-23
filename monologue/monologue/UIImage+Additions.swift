//
//  NotificationViewController.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/10.
//
//  The entire file is working for the notification page


import UIKit


extension UIImage {
    // create scaledToSafeUploadSize for chatting function
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 480
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        return image(scaledTo: newImageSize)
    }
  
    // draw the image
    func image(scaledTo size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
