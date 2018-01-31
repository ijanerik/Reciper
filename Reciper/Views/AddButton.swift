//
//  AddButton.swift
//  Reciper
//
//  Extend a UIButton with a nice white background a blue rounded border.
//
//  Created by Jan Erik van Woerden on 29-01-18.
//  Copyright © 2018 Jan Erik van Woerden. All rights reserved.
//

import UIKit

class AddButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.borderWidth = 1.0
        layer.borderColor = tintColor.cgColor
        layer.cornerRadius = 5.0
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        setTitleColor(tintColor, for: .highlighted)
        setTitleColor(tintColor, for: .normal)
    }

}
