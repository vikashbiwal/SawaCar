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
        NSScanner(string: normalizedHexString).scanHexInt(&c)
        self.init(red:UIColorMasks.redValue(c), green:UIColorMasks.greenValue(c), blue:UIColorMasks.blueValue(c), alpha:UIColorMasks.alphaValue(c))
    }
    
    /**
     Returns a hex equivalent of this UIColor.
     
     - Parameter includeAlpha:   Optional parameter to include the alpha hex.
     
     color.hexDescription() -> "ff0000"
     
     color.hexDescription(true) -> "ff0000aa"
     
     - Returns: A new string with `String` with the color's hexidecimal value.
     */
    public func hexDescription(includeAlpha: Bool = false) -> String {
        if CGColorGetNumberOfComponents(self.CGColor) == 4 {
            let components = CGColorGetComponents(self.CGColor)
            let red = Float(components[0]) * 255.0
            let green = Float(components[1]) * 255.0
            let blue = Float(components[2]) * 255.0
            let alpha = Float(components[3]) * 255.0
            if (includeAlpha) {
                return String.init(format: "%02x%02x%02x%02x", Int(red), Int(green), Int(blue), Int(alpha))
            } else {
                return String.init(format: "%02x%02x%02x", Int(red), Int(green), Int(blue))
            }
        } else {
            return "Color not RGB."
        }
    }
    
    private enum UIColorMasks: CUnsignedInt {
        case RedMask    = 0xff000000
        case GreenMask  = 0x00ff0000
        case BlueMask   = 0x0000ff00
        case AlphaMask  = 0x000000ff
        
        static func redValue(value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & RedMask.rawValue) >> 24
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
        
        static func greenValue(value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & GreenMask.rawValue) >> 16
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
        
        static func blueValue(value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = (value & BlueMask.rawValue) >> 8
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
        
        static func alphaValue(value: CUnsignedInt) -> CGFloat {
            let i: CUnsignedInt = value & AlphaMask.rawValue
            let f: CGFloat = CGFloat(i)/255.0;
            return f;
        }
    }

    private static func normalize(hex: String?) -> String {
        guard var hexString = hex else {
            return "00000000"
        }
        let hasHash : Bool = hexString.hasPrefix("#")
        if (hasHash) {
            hexString = String(hexString.characters.dropFirst())
            
        }
        if hexString.characters.count == 3 || hexString.characters.count == 4 {
            let redHex = hexString.substringToIndex(hexString.startIndex.advancedBy(1))
            let greenHex = hexString.substringWithRange(Range(hexString.startIndex.advancedBy(1) ..< hexString.startIndex.advancedBy(2)))
                //Range<String.Index>(start: hexString.startIndex.advancedBy(1), end: hexString.startIndex.advancedBy(2)))
            let blueHex = hexString.substringWithRange(Range(hexString.startIndex.advancedBy(1) ..< hexString.startIndex.advancedBy(2)))
                //Range<String.Index>(start: hexString.startIndex.advancedBy(2), end: hexString.startIndex.advancedBy(3)))
            var alphaHex = ""
            if hexString.characters.count == 4 {
                alphaHex = hexString.substringFromIndex(hexString.startIndex.advancedBy(3))
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
    private static func hexFromCssName(cssName: String) -> String {
        var s: String = cssName
        if (cssName.caseInsensitiveCompare("Clear") == .OrderedSame) {
            s = "00000000"
        } else if (cssName.caseInsensitiveCompare("Transparent") == .OrderedSame) {
            s = "00000000"
        } else if (cssName.caseInsensitiveCompare("") == .OrderedSame) {
            s = "00000000"
        } else if(cssName.caseInsensitiveCompare("AliceBlue") == .OrderedSame) {
            s = "F0F8FF"
        } else if(cssName.caseInsensitiveCompare("AntiqueWhite") == .OrderedSame) {
            s = "FAEBD7"
        } else if(cssName.caseInsensitiveCompare("Aqua") == .OrderedSame) {
            s = "00FFFF"
        } else if(cssName.caseInsensitiveCompare("Aquamarine") == .OrderedSame) {
            s = "7FFFD4"
        } else if(cssName.caseInsensitiveCompare("Azure") == .OrderedSame) {
            s = "F0FFFF"
        } else if(cssName.caseInsensitiveCompare("Beige") == .OrderedSame) {
            s = "F5F5DC"
        } else if(cssName.caseInsensitiveCompare("Bisque") == .OrderedSame) {
            s = "FFE4C4"
        } else if(cssName.caseInsensitiveCompare("Black") == .OrderedSame) {
            s = "000000"
        } else if(cssName.caseInsensitiveCompare("BlanchedAlmond") == .OrderedSame) {
            s = "FFEBCD"
        } else if(cssName.caseInsensitiveCompare("Blue") == .OrderedSame) {
            s = "0000FF"
        } else if(cssName.caseInsensitiveCompare("BlueViolet") == .OrderedSame) {
            s = "8A2BE2"
        } else if(cssName.caseInsensitiveCompare("Brown") == .OrderedSame) {
            s = "A52A2A"
        } else if(cssName.caseInsensitiveCompare("BurlyWood") == .OrderedSame) {
            s = "DEB887"
        } else if(cssName.caseInsensitiveCompare("CadetBlue") == .OrderedSame) {
            s = "5F9EA0"
        } else if(cssName.caseInsensitiveCompare("Chartreuse") == .OrderedSame) {
            s = "7FFF00"
        } else if(cssName.caseInsensitiveCompare("Chocolate") == .OrderedSame) {
            s = "D2691E"
        } else if(cssName.caseInsensitiveCompare("Coral") == .OrderedSame) {
            s = "FF7F50"
        } else if(cssName.caseInsensitiveCompare("CornflowerBlue") == .OrderedSame) {
            s = "6495ED"
        } else if(cssName.caseInsensitiveCompare("Cornsilk") == .OrderedSame) {
            s = "FFF8DC"
        } else if(cssName.caseInsensitiveCompare("Crimson") == .OrderedSame) {
            s = "DC143C"
        } else if(cssName.caseInsensitiveCompare("Cyan") == .OrderedSame) {
            s = "00FFFF"
        } else if(cssName.caseInsensitiveCompare("DarkBlue") == .OrderedSame) {
            s = "00008B"
        } else if(cssName.caseInsensitiveCompare("DarkCyan") == .OrderedSame) {
            s = "008B8B"
        } else if(cssName.caseInsensitiveCompare("DarkGoldenRod") == .OrderedSame) {
            s = "B8860B"
        } else if(cssName.caseInsensitiveCompare("DarkGray") == .OrderedSame) {
            s = "A9A9A9"
        } else if(cssName.caseInsensitiveCompare("DarkGrey") == .OrderedSame) {
            s = "A9A9A9"
        } else if(cssName.caseInsensitiveCompare("DarkGreen") == .OrderedSame) {
            s = "006400"
        } else if(cssName.caseInsensitiveCompare("DarkKhaki") == .OrderedSame) {
            s = "BDB76B"
        } else if(cssName.caseInsensitiveCompare("DarkMagenta") == .OrderedSame) {
            s = "8B008B"
        } else if(cssName.caseInsensitiveCompare("DarkOliveGreen") == .OrderedSame) {
            s = "556B2F"
        } else if(cssName.caseInsensitiveCompare("DarkOrange") == .OrderedSame) {
            s = "FF8C00"
        } else if(cssName.caseInsensitiveCompare("DarkOrchid") == .OrderedSame) {
            s = "9932CC"
        } else if(cssName.caseInsensitiveCompare("DarkRed") == .OrderedSame) {
            s = "8B0000"
        } else if(cssName.caseInsensitiveCompare("DarkSalmon") == .OrderedSame) {
            s = "E9967A"
        } else if(cssName.caseInsensitiveCompare("DarkSeaGreen") == .OrderedSame) {
            s = "8FBC8F"
        } else if(cssName.caseInsensitiveCompare("DarkSlateBlue") == .OrderedSame) {
            s = "483D8B"
        } else if(cssName.caseInsensitiveCompare("DarkSlateGray") == .OrderedSame) {
            s = "2F4F4F"
        } else if(cssName.caseInsensitiveCompare("DarkSlateGrey") == .OrderedSame) {
            s = "2F4F4F"
        } else if(cssName.caseInsensitiveCompare("DarkTurquoise") == .OrderedSame) {
            s = "00CED1"
        } else if(cssName.caseInsensitiveCompare("DarkViolet") == .OrderedSame) {
            s = "9400D3"
        } else if(cssName.caseInsensitiveCompare("DeepPink") == .OrderedSame) {
            s = "FF1493"
        } else if(cssName.caseInsensitiveCompare("DeepSkyBlue") == .OrderedSame) {
            s = "00BFFF"
        } else if(cssName.caseInsensitiveCompare("DimGray") == .OrderedSame) {
            s = "696969"
        } else if(cssName.caseInsensitiveCompare("DimGrey") == .OrderedSame) {
            s = "696969"
        } else if(cssName.caseInsensitiveCompare("DodgerBlue") == .OrderedSame) {
            s = "1E90FF"
        } else if(cssName.caseInsensitiveCompare("FireBrick") == .OrderedSame) {
            s = "B22222"
        } else if(cssName.caseInsensitiveCompare("FloralWhite") == .OrderedSame) {
            s = "FFFAF0"
        } else if(cssName.caseInsensitiveCompare("ForestGreen") == .OrderedSame) {
            s = "228B22"
        } else if(cssName.caseInsensitiveCompare("Fuchsia") == .OrderedSame) {
            s = "FF00FF"
        } else if(cssName.caseInsensitiveCompare("Gainsboro") == .OrderedSame) {
            s = "DCDCDC"
        } else if(cssName.caseInsensitiveCompare("GhostWhite") == .OrderedSame) {
            s = "F8F8FF"
        } else if(cssName.caseInsensitiveCompare("Gold") == .OrderedSame) {
            s = "FFD700"
        } else if(cssName.caseInsensitiveCompare("GoldenRod") == .OrderedSame) {
            s = "DAA520"
        } else if(cssName.caseInsensitiveCompare("Gray") == .OrderedSame) {
            s = "808080"
        } else if(cssName.caseInsensitiveCompare("Grey") == .OrderedSame) {
            s = "808080"
        } else if(cssName.caseInsensitiveCompare("Green") == .OrderedSame) {
            s = "008000"
        } else if(cssName.caseInsensitiveCompare("GreenYellow") == .OrderedSame) {
            s = "ADFF2F"
        } else if(cssName.caseInsensitiveCompare("HoneyDew") == .OrderedSame) {
            s = "F0FFF0"
        } else if(cssName.caseInsensitiveCompare("HotPink") == .OrderedSame) {
            s = "FF69B4"
        } else if(cssName.caseInsensitiveCompare("IndianRed") == .OrderedSame) {
            s = "CD5C5C"
        } else if(cssName.caseInsensitiveCompare("Indigo") == .OrderedSame) {
            s = "4B0082"
        } else if(cssName.caseInsensitiveCompare("Ivory") == .OrderedSame) {
            s = "FFFFF0"
        } else if(cssName.caseInsensitiveCompare("Khaki") == .OrderedSame) {
            s = "F0E68C"
        } else if(cssName.caseInsensitiveCompare("Lavender") == .OrderedSame) {
            s = "E6E6FA"
        } else if(cssName.caseInsensitiveCompare("LavenderBlush") == .OrderedSame) {
            s = "FFF0F5"
        } else if(cssName.caseInsensitiveCompare("LawnGreen") == .OrderedSame) {
            s = "7CFC00"
        } else if(cssName.caseInsensitiveCompare("LemonChiffon") == .OrderedSame) {
            s = "FFFACD"
        } else if(cssName.caseInsensitiveCompare("LightBlue") == .OrderedSame) {
            s = "ADD8E6"
        } else if(cssName.caseInsensitiveCompare("LightCoral") == .OrderedSame) {
            s = "F08080"
        } else if(cssName.caseInsensitiveCompare("LightCyan") == .OrderedSame) {
            s = "E0FFFF"
        } else if(cssName.caseInsensitiveCompare("LightGoldenRodYellow") == .OrderedSame) {
            s = "FAFAD2"
        } else if(cssName.caseInsensitiveCompare("LightGray") == .OrderedSame) {
            s = "D3D3D3"
        } else if(cssName.caseInsensitiveCompare("LightGrey") == .OrderedSame) {
            s = "D3D3D3"
        } else if(cssName.caseInsensitiveCompare("LightGreen") == .OrderedSame) {
            s = "90EE90"
        } else if(cssName.caseInsensitiveCompare("LightPink") == .OrderedSame) {
            s = "FFB6C1"
        } else if(cssName.caseInsensitiveCompare("LightSalmon") == .OrderedSame) {
            s = "FFA07A"
        } else if(cssName.caseInsensitiveCompare("LightSeaGreen") == .OrderedSame) {
            s = "20B2AA"
        } else if(cssName.caseInsensitiveCompare("LightSkyBlue") == .OrderedSame) {
            s = "87CEFA"
        } else if(cssName.caseInsensitiveCompare("LightSlateGray") == .OrderedSame) {
            s = "778899"
        } else if(cssName.caseInsensitiveCompare("LightSlateGrey") == .OrderedSame) {
            s = "778899"
        } else if(cssName.caseInsensitiveCompare("LightSteelBlue") == .OrderedSame) {
            s = "B0C4DE"
        } else if(cssName.caseInsensitiveCompare("LightYellow") == .OrderedSame) {
            s = "FFFFE0"
        } else if(cssName.caseInsensitiveCompare("Lime") == .OrderedSame) {
            s = "00FF00"
        } else if(cssName.caseInsensitiveCompare("LimeGreen") == .OrderedSame) {
            s = "32CD32"
        } else if(cssName.caseInsensitiveCompare("Linen") == .OrderedSame) {
            s = "FAF0E6"
        } else if(cssName.caseInsensitiveCompare("Magenta") == .OrderedSame) {
            s = "FF00FF"
        } else if(cssName.caseInsensitiveCompare("Maroon") == .OrderedSame) {
            s = "800000"
        } else if(cssName.caseInsensitiveCompare("MediumAquaMarine") == .OrderedSame) {
            s = "66CDAA"
        } else if(cssName.caseInsensitiveCompare("MediumBlue") == .OrderedSame) {
            s = "0000CD"
        } else if(cssName.caseInsensitiveCompare("MediumOrchid") == .OrderedSame) {
            s = "BA55D3"
        } else if(cssName.caseInsensitiveCompare("MediumPurple") == .OrderedSame) {
            s = "9370DB"
        } else if(cssName.caseInsensitiveCompare("MediumSeaGreen") == .OrderedSame) {
            s = "3CB371"
        } else if(cssName.caseInsensitiveCompare("MediumSlateBlue") == .OrderedSame) {
            s = "7B68EE"
        } else if(cssName.caseInsensitiveCompare("MediumSpringGreen") == .OrderedSame) {
            s = "00FA9A"
        } else if(cssName.caseInsensitiveCompare("MediumTurquoise") == .OrderedSame) {
            s = "48D1CC"
        } else if(cssName.caseInsensitiveCompare("MediumVioletRed") == .OrderedSame) {
            s = "C71585"
        } else if(cssName.caseInsensitiveCompare("MidnightBlue") == .OrderedSame) {
            s = "191970"
        } else if(cssName.caseInsensitiveCompare("MintCream") == .OrderedSame) {
            s = "F5FFFA"
        } else if(cssName.caseInsensitiveCompare("MistyRose") == .OrderedSame) {
            s = "FFE4E1"
        } else if(cssName.caseInsensitiveCompare("Moccasin") == .OrderedSame) {
            s = "FFE4B5"
        } else if(cssName.caseInsensitiveCompare("NavajoWhite") == .OrderedSame) {
            s = "FFDEAD"
        } else if(cssName.caseInsensitiveCompare("Navy") == .OrderedSame) {
            s = "000080"
        } else if(cssName.caseInsensitiveCompare("OldLace") == .OrderedSame) {
            s = "FDF5E6"
        } else if(cssName.caseInsensitiveCompare("Olive") == .OrderedSame) {
            s = "808000"
        } else if(cssName.caseInsensitiveCompare("OliveDrab") == .OrderedSame) {
            s = "6B8E23"
        } else if(cssName.caseInsensitiveCompare("Orange") == .OrderedSame) {
            s = "FFA500"
        } else if(cssName.caseInsensitiveCompare("OrangeRed") == .OrderedSame) {
            s = "FF4500"
        } else if(cssName.caseInsensitiveCompare("Orchid") == .OrderedSame) {
            s = "DA70D6"
        } else if(cssName.caseInsensitiveCompare("PaleGoldenRod") == .OrderedSame) {
            s = "EEE8AA"
        } else if(cssName.caseInsensitiveCompare("PaleGreen") == .OrderedSame) {
            s = "98FB98"
        } else if(cssName.caseInsensitiveCompare("PaleTurquoise") == .OrderedSame) {
            s = "AFEEEE"
        } else if(cssName.caseInsensitiveCompare("PaleVioletRed") == .OrderedSame) {
            s = "DB7093"
        } else if(cssName.caseInsensitiveCompare("PapayaWhip") == .OrderedSame) {
            s = "FFEFD5"
        } else if(cssName.caseInsensitiveCompare("PeachPuff") == .OrderedSame) {
            s = "FFDAB9"
        } else if(cssName.caseInsensitiveCompare("Peru") == .OrderedSame) {
            s = "CD853F"
        } else if(cssName.caseInsensitiveCompare("Pink") == .OrderedSame) {
            s = "FFC0CB"
        } else if(cssName.caseInsensitiveCompare("Plum") == .OrderedSame) {
            s = "DDA0DD"
        } else if(cssName.caseInsensitiveCompare("PowderBlue") == .OrderedSame) {
            s = "B0E0E6"
        } else if(cssName.caseInsensitiveCompare("Purple") == .OrderedSame) {
            s = "800080"
        } else if(cssName.caseInsensitiveCompare("Red") == .OrderedSame) {
            s = "FF0000"
        } else if(cssName.caseInsensitiveCompare("RosyBrown") == .OrderedSame) {
            s = "BC8F8F"
        } else if(cssName.caseInsensitiveCompare("RoyalBlue") == .OrderedSame) {
            s = "4169E1"
        } else if(cssName.caseInsensitiveCompare("SaddleBrown") == .OrderedSame) {
            s = "8B4513"
        } else if(cssName.caseInsensitiveCompare("Salmon") == .OrderedSame) {
            s = "FA8072"
        } else if(cssName.caseInsensitiveCompare("SandyBrown") == .OrderedSame) {
            s = "F4A460"
        } else if(cssName.caseInsensitiveCompare("SeaGreen") == .OrderedSame) {
            s = "2E8B57"
        } else if(cssName.caseInsensitiveCompare("SeaShell") == .OrderedSame) {
            s = "FFF5EE"
        } else if(cssName.caseInsensitiveCompare("Sienna") == .OrderedSame) {
            s = "A0522D"
        } else if(cssName.caseInsensitiveCompare("Silver") == .OrderedSame) {
            s = "C0C0C0"
        } else if(cssName.caseInsensitiveCompare("SkyBlue") == .OrderedSame) {
            s = "87CEEB"
        } else if(cssName.caseInsensitiveCompare("SlateBlue") == .OrderedSame) {
            s = "6A5ACD"
        } else if(cssName.caseInsensitiveCompare("SlateGray") == .OrderedSame) {
            s = "708090"
        } else if(cssName.caseInsensitiveCompare("SlateGrey") == .OrderedSame) {
            s = "708090"
        } else if(cssName.caseInsensitiveCompare("Snow") == .OrderedSame) {
            s = "FFFAFA"
        } else if(cssName.caseInsensitiveCompare("SpringGreen") == .OrderedSame) {
            s = "00FF7F"
        } else if(cssName.caseInsensitiveCompare("SteelBlue") == .OrderedSame) {
            s = "4682B4"
        } else if(cssName.caseInsensitiveCompare("Tan") == .OrderedSame) {
            s = "D2B48C"
        } else if(cssName.caseInsensitiveCompare("Teal") == .OrderedSame) {
            s = "008080"
        } else if(cssName.caseInsensitiveCompare("Thistle") == .OrderedSame) {
            s = "D8BFD8"
        } else if(cssName.caseInsensitiveCompare("Tomato") == .OrderedSame) {
            s = "FF6347"
        } else if(cssName.caseInsensitiveCompare("Turquoise") == .OrderedSame) {
            s = "40E0D0"
        } else if(cssName.caseInsensitiveCompare("Violet") == .OrderedSame) {
            s = "EE82EE"
        } else if(cssName.caseInsensitiveCompare("Wheat") == .OrderedSame) {
            s = "F5DEB3"
        } else if(cssName.caseInsensitiveCompare("White") == .OrderedSame) {
            s = "FFFFFF"
        } else if(cssName.caseInsensitiveCompare("WhiteSmoke") == .OrderedSame) {
            s = "F5F5F5"
        } else if(cssName.caseInsensitiveCompare("Yellow") == .OrderedSame) {
            s = "FFFF00"
        } else if(cssName.caseInsensitiveCompare("YellowGreen") == .OrderedSame) {
            s = "9ACD32"
        }
        return s
    }
}
