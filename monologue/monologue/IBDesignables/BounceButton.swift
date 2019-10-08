//
//  BounceButton.swift
//  Familog
//
//  Created by Ziyuan on 8/10/19.
//

import Foundation
import UIKit

class BounceButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 6,options:. allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
        super.touchesBegan(touches, with: event)
    }
}
