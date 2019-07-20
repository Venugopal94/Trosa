//
//  ImageExtension.swift
//  Assignment
//
//  Created by Venugopal S A on 20/07/19.
//  Copyright © 2019 Venugopal S A. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func imageWithAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage(named: "")
        UIGraphicsEndImageContext()
        return newImage!
    }
}
