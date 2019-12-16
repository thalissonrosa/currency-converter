//
//  SideImageTextField.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 16/12/19.
//

import UIKit

@IBDesignable
class SideImageTextField: UITextField {
    
    //MARK: IBInspectables
    @IBInspectable var padding: CGFloat = 0.0
    @IBInspectable var sideImage: UIImage? = nil {
        didSet {
            if let image = sideImage {
                rightViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                rightView = imageView
            } else {
                rightViewMode = UITextField.ViewMode.never
                rightView = nil
            }
        }
    }
    
    //MARK: Overrides
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= padding //+ (imageHeight / 2)
        //let heightDiff = (textRect.size.height - imageHeight) / 2
        //textRect.origin.y += heightDiff
        //textRect.size.width = imageHeight
        //textRect.size.height = imageHeight
        return textRect
    }

}
