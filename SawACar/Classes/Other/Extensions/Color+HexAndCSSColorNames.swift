//
//  Color+HexAndCSSColorNames.swift
//
//  Created by Norman Basham on 12/8/15.
//  Copyright © 2015 Black Labs. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

public extension UIColor {
    
    /**
     Creates an immuatble UIColor instance specified by a hex string, CSS color name, or nil.
     
     - parameter hexString: A case insensitive String? representing a hex or CSS value e.g.
     
     - **"abc"**
     - **"abc7"**
     - **"#abc7"**
     - **"00FFFF"**
     - **"#00FFFF"**
     - **"00FFFF77"**
     - **"Orange", "Azure", "Tomato"** Modern browsers support 140 color names (<http://www.w3schools.com/cssref/css_colornames.asp>)
     - **"Clear"** [UIColor clearColor]
     - **"Transparent"** [UIColor clearColor]
     - **nil** [UIColor clearColor]
     - **empty string** [UIColor clearColor]
     */
    public convenience init(hex: String?) {
        let normalizedHexString: String = UIColor.normalize(hex)
        var c: CUnsignedInt = 0
        Scanner(string: normalizedHexString).scanHexInt32(&c)
        self.init(red:UIColorMasks.redValue(c), green:UIColorMasks.greenValue(c), blue:UIColorMasks.blueValue(c), alpha:UIColorMasks.alphaValue(c))
    }
    
    /**
     Returns a hex equivalent of this UIColor.
     
     - Parameter includeAlpha:   Optional parameter to include the alpha hex.
     
     color.hexDescription() -> "ff0000"
     
     color.hexDescription(true) -> "ff0000aa"
     
     - Returns: A new string with `String` with the color's hexidecimal value.
     */
    public func hexDescription(_ includeAlpha: Bool = false) -> String {
        if self.cgColor.numberOfComponents == 4 {
            let components = self.cgColor.components
            let red = Float((components?[0])!) * 255.0
            let green = Float((components?[1])!) * 255.0
            let blue = Float((components?[2])!) * 255.0
            let alpha = Float((components?[3])!) * 255.0
            if (includeAlpha) {
                return String.init(format: "%02x%02x%02x%02x", Int(red), Int(green), Int(blue), Int(alpha))
            } else {
                return String.init(format: "%02x%02x%02x", Int(red), Int(green), Int(blue))
            }
        } else {
            return "Color not RGB."
        }
    }
    
    fileprivate enum UIColorMasks: CUnsignedInt {
        case redMask    = 0xff000000
        case greenMask  = 0x00ff0000
        case blueMask   = 0x0000ff00
        case alphaMask  = 0x000000ff
        
        static func redValue(_ value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & redMask.rawValue) >> 24
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
        
        static func greenValue(_ value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & greenMask.rawValue) >> 16
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
        
        static func blueValue(_ value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & blueMask.rawValue) >> 8
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
        
        static func alphaValue(_ value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = value & alphaMask.rawValue
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
    }

    fileprivate static func normalize(_ hex: String?) -> String {
        guard var hexString = hex else {
            return "00000000"
        }
        let hasHash : Bool = hexString.hasPrefix("#")
        if (hasHash) {
            hexString = String(hexString.characters.dropFirst())
            
        }
        if hexString.characters.count == 3 || hexString.characters.count == 4 {
            let redHex = hexString.substring(to: hexString.characters.index(hexString.startIndex, offsetBy: 1))
            let greenHex = hexString.substring(with: Range(hexString.characters.index(hexString.startIndex, offsetBy: 1) ..< hexString.characters.index(hexString.startIndex, offsetBy: 2)))
                //Range<String.Index>(start: hexString.startIndex.advancedBy(1), end: hexString.startIndex.advancedBy(2)))
            let blueHex = hexString.substring(with: Range(hexString.characters.index(hexString.startIndex, offsetBy: 1) ..< hexString.characters.index(hexString.startIndex, offsetBy: 2)))
                //Range<String.Index>(start: hexString.startIndex.advancedBy(2), end: hexString.startIndex.advancedBy(3)))
            var alphaHex = ""
            if hexString.characters.count == 4 {
                alphaHex = hexString.substring(from: hexString.characters.index(hexString.startIndex, offsetBy: 3))
            }
            
            hexString = redHex + redHex + greenHex + greenHex + blueHex + blueHex + alphaHex + alphaHex
        }
        hexString = UIColor.hexFromCssName(hexString)
        let hasAlpha = hexString.characters.count > 7
        if (!hasAlpha) {
            hexString = hexString + "ff"
        }
        return hexString;
    }
    
    /**
     All modern browsers support the following 140 color names (see http://www.w3schools.com/cssref/css_colornames.asp)
     */
    fileprivate static func hexFromCssName(_ cssName: String) -> String {
        var s: String = cssName
        if (cssName.caseInsensitiveCompare("Clear") == .orderedSame) {
            s = "00000000"
        } else if (cssName.caseInsensitiveCompare("Transparent") == .orderedSame) {
            s = "00000000"
        } else if (cssName.caseInsensitiveCompare("") == .orderedSame) {
            s = "00000000"
        } else if(cssName.caseInsensitiveCompare("AliceBlue") == .orderedSame) {
            s = "F0F8FF"
        } else if(cssName.caseInsensitiveCompare("AntiqueWhite") == .orderedSame) {
            s = "FAEBD7"
        } else if(cssName.caseInsensitiveCompare("Aqua") == .orderedSame) {
            s = "00FFFF"
        } else if(cssName.caseInsensitiveCompare("Aquamarine") == .orderedSame) {
            s = "7FFFD4"
        } else if(cssName.caseInsensitiveCompare("Azure") == .orderedSame) {
            s = "F0FFFF"
        } else if(cssName.caseInsensitiveCompare("Beige") == .orderedSame) {
            s = "F5F5DC"
        } else if(cssName.caseInsensitiveCompare("Bisque") == .orderedSame) {
            s = "FFE4C4"
        } else if(cssName.caseInsensitiveCompare("Black") == .orderedSame) {
            s = "000000"
        } else if(cssName.caseInsensitiveCompare("BlanchedAlmond") == .orderedSame) {
            s = "FFEBCD"
        } else if(cssName.caseInsensitiveCompare("Blue") == .orderedSame) {
            s = "0000FF"
        } else if(cssName.caseInsensitiveCompare("BlueViolet") == .orderedSame) {
            s = "8A2BE2"
        } else if(cssName.caseInsensitiveCompare("Brown") == .orderedSame) {
            s = "A52A2A"
        } else if(cssName.caseInsensitiveCompare("BurlyWood") == .orderedSame) {
            s = "DEB887"
        } else if(cssName.caseInsensitiveCompare("CadetBlue") == .orderedSame) {
            s = "5F9EA0"
        } else if(cssName.caseInsensitiveCompare("Chartreuse") == .orderedSame) {
            s = "7FFF00"
        } else if(cssName.caseInsensitiveCompare("Chocolate") == .orderedSame) {
            s = "D2691E"
        } else if(cssName.caseInsensitiveCompare("Coral") == .orderedSame) {
            s = "FF7F50"
        } else if(cssName.caseInsensitiveCompare("CornflowerBlue") == .orderedSame) {
            s = "6495ED"
        } else if(cssName.caseInsensitiveCompare("Cornsilk") == .orderedSame) {
            s = "FFF8DC"
        } else if(cssName.caseInsensitiveCompare("Crimson") == .orderedSame) {
            s = "DC143C"
        } else if(cssName.caseInsensitiveCompare("Cyan") == .orderedSame) {
            s = "00FFFF"
        } else if(cssName.caseInsensitiveCompare("DarkBlue") == .orderedSame) {
            s = "00008B"
        } else if(cssName.caseInsensitiveCompare("DarkCyan") == .orderedSame) {
            s = "008B8B"
        } else if(cssName.caseInsensitiveCompare("DarkGoldenRod") == .orderedSame) {
            s = "B8860B"
        } else if(cssName.caseInsensitiveCompare("DarkGray") == .orderedSame) {
            s = "A9A9A9"
        } else if(cssName.caseInsensitiveCompare("DarkGrey") == .orderedSame) {
            s = "A9A9A9"
        } else if(cssName.caseInsensitiveCompare("DarkGreen") == .orderedSame) {
            s = "006400"
        } else if(cssName.caseInsensitiveCompare("DarkKhaki") == .orderedSame) {
            s = "BDB76B"
        } else if(cssName.caseInsensitiveCompare("DarkMagenta") == .orderedSame) {
            s = "8B008B"
        } else if(cssName.caseInsensitiveCompare("DarkOliveGreen") == .orderedSame) {
            s = "556B2F"
        } else if(cssName.caseInsensitiveCompare("DarkOrange") == .orderedSame) {
            s = "FF8C00"
        } else if(cssName.caseInsensitiveCompare("DarkOrchid") == .orderedSame) {
            s = "9932CC"
        } else if(cssName.caseInsensitiveCompare("DarkRed") == .orderedSame) {
            s = "8B0000"
        } else if(cssName.caseInsensitiveCompare("DarkSalmon") == .orderedSame) {
            s = "E9967A"
        } else if(cssName.caseInsensitiveCompare("DarkSeaGreen") == .orderedSame) {
            s = "8FBC8F"
        } else if(cssName.caseInsensitiveCompare("DarkSlateBlue") == .orderedSame) {
            s = "483D8B"
        } else if(cssName.caseInsensitiveCompare("DarkSlateGray") == .orderedSame) {
            s = "2F4F4F"
        } else if(cssName.caseInsensitiveCompare("DarkSlateGrey") == .orderedSame) {
            s = "2F4F4F"
        } else if(cssName.caseInsensitiveCompare("DarkTurquoise") == .orderedSame) {
            s = "00CED1"
        } else if(cssName.caseInsensitiveCompare("DarkViolet") == .orderedSame) {
            s = "9400D3"
        } else if(cssName.caseInsensitiveCompare("DeepPink") == .orderedSame) {
            s = "FF1493"
        } else if(cssName.caseInsensitiveCompare("DeepSkyBlue") == .orderedSame) {
            s = "00BFFF"
        } else if(cssName.caseInsensitiveCompare("DimGray") == .orderedSame) {
            s = "696969"
        } else if(cssName.caseInsensitiveCompare("DimGrey") == .orderedSame) {
            s = "696969"
        } else if(cssName.caseInsensitiveCompare("DodgerBlue") == .orderedSame) {
            s = "1E90FF"
        } else if(cssName.caseInsensitiveCompare("FireBrick") == .orderedSame) {
            s = "B22222"
        } else if(cssName.caseInsensitiveCompare("FloralWhite") == .orderedSame) {
            s = "FFFAF0"
        } else if(cssName.caseInsensitiveCompare("ForestGreen") == .orderedSame) {
            s = "228B22"
        } else if(cssName.caseInsensitiveCompare("Fuchsia") == .orderedSame) {
            s = "FF00FF"
        } else if(cssName.caseInsensitiveCompare("Gainsboro") == .orderedSame) {
            s = "DCDCDC"
        } else if(cssName.caseInsensitiveCompare("GhostWhite") == .orderedSame) {
            s = "F8F8FF"
        } else if(cssName.caseInsensitiveCompare("Gold") == .orderedSame) {
            s = "FFD700"
        } else if(cssName.caseInsensitiveCompare("GoldenRod") == .orderedSame) {
            s = "DAA520"
        } else if(cssName.caseInsensitiveCompare("Gray") == .orderedSame) {
            s = "808080"
        } else if(cssName.caseInsensitiveCompare("Grey") == .orderedSame) {
            s = "808080"
        } else if(cssName.caseInsensitiveCompare("Green") == .orderedSame) {
            s = "008000"
        } else if(cssName.caseInsensitiveCompare("GreenYellow") == .orderedSame) {
            s = "ADFF2F"
        } else if(cssName.caseInsensitiveCompare("HoneyDew") == .orderedSame) {
            s = "F0FFF0"
        } else if(cssName.caseInsensitiveCompare("HotPink") == .orderedSame) {
            s = "FF69B4"
        } else if(cssName.caseInsensitiveCompare("IndianRed") == .orderedSame) {
            s = "CD5C5C"
        } else if(cssName.caseInsensitiveCompare("Indigo") == .orderedSame) {
            s = "4B0082"
        } else if(cssName.caseInsensitiveCompare("Ivory") == .orderedSame) {
            s = "FFFFF0"
        } else if(cssName.caseInsensitiveCompare("Khaki") == .orderedSame) {
            s = "F0E68C"
        } else if(cssName.caseInsensitiveCompare("Lavender") == .orderedSame) {
            s = "E6E6FA"
        } else if(cssName.caseInsensitiveCompare("LavenderBlush") == .orderedSame) {
            s = "FFF0F5"
        } else if(cssName.caseInsensitiveCompare("LawnGreen") == .orderedSame) {
            s = "7CFC00"
        } else if(cssName.caseInsensitiveCompare("LemonChiffon") == .orderedSame) {
            s = "FFFACD"
        } else if(cssName.caseInsensitiveCompare("LightBlue") == .orderedSame) {
            s = "ADD8E6"
        } else if(cssName.caseInsensitiveCompare("LightCoral") == .orderedSame) {
            s = "F08080"
        } else if(cssName.caseInsensitiveCompare("LightCyan") == .orderedSame) {
            s = "E0FFFF"
        } else if(cssName.caseInsensitiveCompare("LightGoldenRodYellow") == .orderedSame) {
            s = "FAFAD2"
        } else if(cssName.caseInsensitiveCompare("LightGray") == .orderedSame) {
            s = "D3D3D3"
        } else if(cssName.caseInsensitiveCompare("LightGrey") == .orderedSame) {
            s = "D3D3D3"
        } else if(cssName.caseInsensitiveCompare("LightGreen") == .orderedSame) {
            s = "90EE90"
        } else if(cssName.caseInsensitiveCompare("LightPink") == .orderedSame) {
            s = "FFB6C1"
        } else if(cssName.caseInsensitiveCompare("LightSalmon") == .orderedSame) {
            s = "FFA07A"
        } else if(cssName.caseInsensitiveCompare("LightSeaGreen") == .orderedSame) {
            s = "20B2AA"
        } else if(cssName.caseInsensitiveCompare("LightSkyBlue") == .orderedSame) {
            s = "87CEFA"
        } else if(cssName.caseInsensitiveCompare("LightSlateGray") == .orderedSame) {
            s = "778899"
        } else if(cssName.caseInsensitiveCompare("LightSlateGrey") == .orderedSame) {
            s = "778899"
        } else if(cssName.caseInsensitiveCompare("LightSteelBlue") == .orderedSame) {
            s = "B0C4DE"
        } else if(cssName.caseInsensitiveCompare("LightYellow") == .orderedSame) {
            s = "FFFFE0"
        } else if(cssName.caseInsensitiveCompare("Lime") == .orderedSame) {
            s = "00FF00"
        } else if(cssName.caseInsensitiveCompare("LimeGreen") == .orderedSame) {
            s = "32CD32"
        } else if(cssName.caseInsensitiveCompare("Linen") == .orderedSame) {
            s = "FAF0E6"
        } else if(cssName.caseInsensitiveCompare("Magenta") == .orderedSame) {
            s = "FF00FF"
        } else if(cssName.caseInsensitiveCompare("Maroon") == .orderedSame) {
            s = "800000"
        } else if(cssName.caseInsensitiveCompare("MediumAquaMarine") == .orderedSame) {
            s = "66CDAA"
        } else if(cssName.caseInsensitiveCompare("MediumBlue") == .orderedSame) {
            s = "0000CD"
        } else if(cssName.caseInsensitiveCompare("MediumOrchid") == .orderedSame) {
            s = "BA55D3"
        } else if(cssName.caseInsensitiveCompare("MediumPurple") == .orderedSame) {
            s = "9370DB"
        } else if(cssName.caseInsensitiveCompare("MediumSeaGreen") == .orderedSame) {
            s = "3CB371"
        } else if(cssName.caseInsensitiveCompare("MediumSlateBlue") == .orderedSame) {
            s = "7B68EE"
        } else if(cssName.caseInsensitiveCompare("MediumSpringGreen") == .orderedSame) {
            s = "00FA9A"
        } else if(cssName.caseInsensitiveCompare("MediumTurquoise") == .orderedSame) {
            s = "48D1CC"
        } else if(cssName.caseInsensitiveCompare("MediumVioletRed") == .orderedSame) {
            s = "C71585"
        } else if(cssName.caseInsensitiveCompare("MidnightBlue") == .orderedSame) {
            s = "191970"
        } else if(cssName.caseInsensitiveCompare("MintCream") == .orderedSame) {
            s = "F5FFFA"
        } else if(cssName.caseInsensitiveCompare("MistyRose") == .orderedSame) {
            s = "FFE4E1"
        } else if(cssName.caseInsensitiveCompare("Moccasin") == .orderedSame) {
            s = "FFE4B5"
        } else if(cssName.caseInsensitiveCompare("NavajoWhite") == .orderedSame) {
            s = "FFDEAD"
        } else if(cssName.caseInsensitiveCompare("Navy") == .orderedSame) {
            s = "000080"
        } else if(cssName.caseInsensitiveCompare("OldLace") == .orderedSame) {
            s = "FDF5E6"
        } else if(cssName.caseInsensitiveCompare("Olive") == .orderedSame) {
            s = "808000"
        } else if(cssName.caseInsensitiveCompare("OliveDrab") == .orderedSame) {
            s = "6B8E23"
        } else if(cssName.caseInsensitiveCompare("Orange") == .orderedSame) {
            s = "FFA500"
        } else if(cssName.caseInsensitiveCompare("OrangeRed") == .orderedSame) {
            s = "FF4500"
        } else if(cssName.caseInsensitiveCompare("Orchid") == .orderedSame) {
            s = "DA70D6"
        } else if(cssName.caseInsensitiveCompare("PaleGoldenRod") == .orderedSame) {
            s = "EEE8AA"
        } else if(cssName.caseInsensitiveCompare("PaleGreen") == .orderedSame) {
            s = "98FB98"
        } else if(cssName.caseInsensitiveCompare("PaleTurquoise") == .orderedSame) {
            s = "AFEEEE"
        } else if(cssName.caseInsensitiveCompare("PaleVioletRed") == .orderedSame) {
            s = "DB7093"
        } else if(cssName.caseInsensitiveCompare("PapayaWhip") == .orderedSame) {
            s = "FFEFD5"
        } else if(cssName.caseInsensitiveCompare("PeachPuff") == .orderedSame) {
            s = "FFDAB9"
        } else if(cssName.caseInsensitiveCompare("Peru") == .orderedSame) {
            s = "CD853F"
        } else if(cssName.caseInsensitiveCompare("Pink") == .orderedSame) {
            s = "FFC0CB"
        } else if(cssName.caseInsensitiveCompare("Plum") == .orderedSame) {
            s = "DDA0DD"
        } else if(cssName.caseInsensitiveCompare("PowderBlue") == .orderedSame) {
            s = "B0E0E6"
        } else if(cssName.caseInsensitiveCompare("Purple") == .orderedSame) {
            s = "800080"
        } else if(cssName.caseInsensitiveCompare("Red") == .orderedSame) {
            s = "FF0000"
        } else if(cssName.caseInsensitiveCompare("RosyBrown") == .orderedSame) {
            s = "BC8F8F"
        } else if(cssName.caseInsensitiveCompare("RoyalBlue") == .orderedSame) {
            s = "4169E1"
        } else if(cssName.caseInsensitiveCompare("SaddleBrown") == .orderedSame) {
            s = "8B4513"
        } else if(cssName.caseInsensitiveCompare("Salmon") == .orderedSame) {
            s = "FA8072"
        } else if(cssName.caseInsensitiveCompare("SandyBrown") == .orderedSame) {
            s = "F4A460"
        } else if(cssName.caseInsensitiveCompare("SeaGreen") == .orderedSame) {
            s = "2E8B57"
        } else if(cssName.caseInsensitiveCompare("SeaShell") == .orderedSame) {
            s = "FFF5EE"
        } else if(cssName.caseInsensitiveCompare("Sienna") == .orderedSame) {
            s = "A0522D"
        } else if(cssName.caseInsensitiveCompare("Silver") == .orderedSame) {
            s = "C0C0C0"
        } else if(cssName.caseInsensitiveCompare("SkyBlue") == .orderedSame) {
            s = "87CEEB"
        } else if(cssName.caseInsensitiveCompare("SlateBlue") == .orderedSame) {
            s = "6A5ACD"
        } else if(cssName.caseInsensitiveCompare("SlateGray") == .orderedSame) {
            s = "708090"
        } else if(cssName.caseInsensitiveCompare("SlateGrey") == .orderedSame) {
            s = "708090"
        } else if(cssName.caseInsensitiveCompare("Snow") == .orderedSame) {
            s = "FFFAFA"
        } else if(cssName.caseInsensitiveCompare("SpringGreen") == .orderedSame) {
            s = "00FF7F"
        } else if(cssName.caseInsensitiveCompare("SteelBlue") == .orderedSame) {
            s = "4682B4"
        } else if(cssName.caseInsensitiveCompare("Tan") == .orderedSame) {
            s = "D2B48C"
        } else if(cssName.caseInsensitiveCompare("Teal") == .orderedSame) {
            s = "008080"
        } else if(cssName.caseInsensitiveCompare("Thistle") == .orderedSame) {
            s = "D8BFD8"
        } else if(cssName.caseInsensitiveCompare("Tomato") == .orderedSame) {
            s = "FF6347"
        } else if(cssName.caseInsensitiveCompare("Turquoise") == .orderedSame) {
            s = "40E0D0"
        } else if(cssName.caseInsensitiveCompare("Violet") == .orderedSame) {
            s = "EE82EE"
        } else if(cssName.caseInsensitiveCompare("Wheat") == .orderedSame) {
            s = "F5DEB3"
        } else if(cssName.caseInsensitiveCompare("White") == .orderedSame) {
            s = "FFFFFF"
        } else if(cssName.caseInsensitiveCompare("WhiteSmoke") == .orderedSame) {
            s = "F5F5F5"
        } else if(cssName.caseInsensitiveCompare("Yellow") == .orderedSame) {
            s = "FFFF00"
        } else if(cssName.caseInsensitiveCompare("YellowGreen") == .orderedSame) {
            s = "9ACD32"
        }
        return s
    }
}
