//
//  designabletextfield.swift
//  textfield
//
//  Created by Aakarsh S on 10/01/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    

    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leadingPadding
        return textRect
    }
    
    // Provides right padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leadingPadding
        return textRect
    }
    
    @IBInspectable var leadingImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leadingPadding: CGFloat = 5
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rtl: Bool = false {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        rightViewMode = UITextField.ViewMode.never
        rightView = nil
        leftViewMode = UITextField.ViewMode.never
        leftView = nil
        
        if let image = leadingImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16 , height: 16))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            
            if rtl {
                rightViewMode = UITextField.ViewMode.always
                rightView = imageView
            } else {
                leftViewMode = UITextField.ViewMode.always
                leftView = imageView
            }
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
