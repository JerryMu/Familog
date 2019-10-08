//
//  DesignableView.swift
//  Familog
//
//  Created by Ziyuan on 8/10/19.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
