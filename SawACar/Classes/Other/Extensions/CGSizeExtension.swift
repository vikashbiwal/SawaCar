//
//  CGSizeExtension.swift
//  manup
//
//  Created by Tom Swindell on 10/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import Foundation
import UIKit

func / (lhs: CGSize, rhs: CGSize) -> CGSize {
    let newSize = CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
    return newSize
}

func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
    let newSize = CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
    return newSize
}

func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
    let newSize = CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    return newSize
}

func - (lhs: CGSize, rhs: CGFloat) -> CGSize {
    let newSize = CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
    return newSize
}


