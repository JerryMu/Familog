//
//  NotificationViewController.swift
//  Familog
//
//  Created by shishengliu on 2019/10/10.
//
//  The entire file is working for the notification page

import UIKit


//  judge if the scroll is at bottom
extension UIScrollView {
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
