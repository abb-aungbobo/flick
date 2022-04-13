//
//  UIImageView.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import SDWebImage
import UIKit

extension UIImageView {
    func setImage(with url: URL?, placeholderImage placeholder: UIImage? = nil) {
        sd_setImage(with: url, placeholderImage: placeholder)
    }
}
