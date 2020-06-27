//
//  Extensions.swift
//  Quick Whatsapp
//
//  Created by Raz on 27/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    func setup(view: UIView) {
        self.center = view.center
        self.hidesWhenStopped = true
        self.style = UIActivityIndicatorView.Style.large
        self.color = #colorLiteral(red: 0.102494448, green: 0.102494448, blue: 0.102494448, alpha: 1)
        self.startAnimating()
        view.addSubview(self)
    }
    
    
}
