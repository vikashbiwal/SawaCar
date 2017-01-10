//
//  VExtensions.swift
//  SawACar
//
//  Created by Vikash Kumar. on 17/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

//MARK:============================= Extensions ===================================

typealias VCounterRange = (min: Int, value: Int, max: Int)

//MARK: String
extension String {
  
    //func for get localized string from localizable file. 
    func localizedString()-> String {
        return NSLocalizedString(self, comment: "")//
    }
}

//MARK: Int
extension Int {
    func ToString() -> String {
        return "\(self)"
    }
}

extension Double {
    func ToString() -> String {
        return "\(self)"
    }
}

//MARK: UIView
extension UIView {
    //Draw a shadow
    func drawShadow() {
        self.layer.masksToBounds = true;
        self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0);
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowColor  = UIColor.black.cgColor
    }
    
    func drawShadowWithCornerRadius() {
        
    }
}

//MARK: UIImage
extension UIImage {
    //MARK: Compressed image
    var uncompressedPNGData: Data      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: Data { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: Data    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: Data  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: Data     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:Data   { return UIImageJPEGRepresentation(self, 0.0)!  }
}

extension Array where Element: Equatable {
    mutating func removeElement(_ element: Element) {
        if let ind = self.index(of: element) {
            remove(at: ind)
        }
    }
}

//MARK: DateFormator
extension DateFormatter {
    func stringFromDate(_ date: Date, format: String) -> String {
        self.dateFormat = format
        return self.string(from: date)
    }
    
    func stringFromDate(_ date: Date, style:DateFormatter.Style) -> String {
        self.dateStyle = style
        return self.string(from: date)
    }
    
    func dateFromString(_ strDate: String, fomat: String) -> Date? {
        self.dateFormat = fomat
        return self.date(from: strDate)
    }
    
    func dateString(_ strDate: String, fromFomat: String, toFromat: String) -> String {
        self.dateFormat = fromFomat
        let date = self.date(from: strDate)
        if let date = date {
         self.dateFormat = toFromat
            return string(from: date)
        }
        return ""
    }
    
    func dateString(_ strDate: String, fromFomat: String, style: DateFormatter.Style) -> String {
        self.dateFormat = fromFomat
        let date = self.date(from: strDate)
        if let date = date {
            self.dateStyle = style
            return string(from: date)
        }
        return ""
    }

}

//MARK: NSDate
extension Date {
 //
    func dateByAddingYearOffset(_ offset: Int) -> Date? {
        let calendar  =     Calendar(identifier: Calendar.Identifier.gregorian)
        var offsetComponent = DateComponents()
        offsetComponent.year = offset
        let date = (calendar as NSCalendar?)?.date(byAdding: offsetComponent, to: self, options: NSCalendar.Options.wrapComponents)
        return date
    }
}

//MARK: TableView
extension UITableView {
    func addRefreshControl(_ target: UIViewController, selector: Selector) -> UIRefreshControl {
        let refControl = UIRefreshControl()
        refControl.addTarget(target, action: selector, for: UIControlEvents.valueChanged)
        self.addSubview(refControl)
        return refControl
    }
}

//MARK: UILocalizedIndexedCollaction configuration
extension UILocalizedIndexedCollation {
   
    //Add below commented line in your viewController for accesing func partitionObjects(_:)
    // let indexedCollation = UILocalizedIndexedCollation.currentCollation()

    func partitionObjects(_ array:[AnyObject], collationStringSelector:Selector) -> ([AnyObject], [String]) {
        var unsortedSections = [[AnyObject]]()
        
        //Create a array to hold the data for each section
        for _ in self.sectionTitles {
            //var array = [AnyObject]()
            unsortedSections.append([])
        }
        
        //put each objects into a section
        for item in array {
            let index:Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        
        var sectionTitles = [String]()
        var sections = [AnyObject]()
        //sort each sections
        //sectionTitles  = NSMutableArray()
        for index in 0  ..< unsortedSections.count
        {
            if unsortedSections[index].count > 0 {
                sectionTitles.append(self.sectionTitles[index])
                sections.append(self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as AnyObject)
            }
        }
        return (sections, sectionTitles)
    }

}

//MARK:============================= SubClasses ===================================
//Swift view resize as per device ratio
class VkUISwitch: UISwitch {
    override func awakeFromNib() {
        super.awakeFromNib()
        //
        let constantValue: CGFloat = 0.9 //Default Scale value which changed as per device base.
        let scale = constantValue * _widthRatio
        self.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}

// This view is used for Maintain TblHeaderview's height
class TblWidthHeaderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        var frame = self.frame
        frame.size.height = frame.size.height * _widthRatio
        self.frame = frame
    }
}


class IndexPathButton: JPWidthButton {
    var indexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class IndexPathTextField: JPWidthTextField {
    var indexpath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class CornerRadiusView: ConstrainedView {
    @IBInspectable var cornerRadius : CGFloat = 3.0
    @IBInspectable var topLeft      : Bool = true
    @IBInspectable var topRight     : Bool = true
    @IBInspectable var bottomLeft   : Bool = true
    @IBInspectable var bottomRight  : Bool = true
    @IBInspectable var blurEffect   : Bool = false
    
    var corners : UIRectCorner!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        corners = UIRectCorner()
        if topLeft {
            corners.insert(.topLeft)
        }
        if topRight {
            corners.insert(.topRight)
        }
        if bottomLeft {
            corners.insert(.bottomLeft)
        }
        
        if bottomRight {
            corners.insert(.bottomRight)
        }
        

        if corners.isEmpty {
            
        } else {
            
            if (topLeft && topRight && bottomLeft && bottomRight) {
                self.layer.cornerRadius = cornerRadius * _widthRatio
                self.clipsToBounds = true
                
            } else {
                var fr = self.bounds
                fr.size.width = fr.size.width * _widthRatio
                fr.size.height = fr.size.height * _widthRatio
                
                let path = UIBezierPath(roundedRect:fr, byRoundingCorners:corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                self.layer.mask = maskLayer
            }

        }
        
        if blurEffect {
            self.backgroundColor = UIColor.clear
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(blurEffectView)
            self.sendSubview(toBack: blurEffectView)

        }
    }
}

//Operation for call location related API :
//Added by vikash
class VPOperation: Operation {
    var url : URL!
    var block: ((NSDictionary) -> Void)?
    
    init(strUrl: String, block:@escaping (NSDictionary?) -> Void) {
        self.url = URL(string: strUrl)
        self.block = block
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        print("Request URL : \(url.absoluteString)")
        let data = try? Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        if self.isCancelled {
            return
        }
        block?(json as! NSDictionary)
    }
}

//MARK:============================= Enums ===================================
enum VAction {
    case cancel, done, share
}

//MARK:============================= Functions ===================================

func getCurrencyCode(forCountryCode code: String)-> String? {
//    let components = [NSLocale.Key.countryCode : code]
//    let localeIdent = Locale.identifier(fromComponents: components as! [String : String])
//    let locale = Locale(localeIdentifier: localeIdent)
//    let currencyCode = locale.object(forKey: NSLocale.Key.currencyCode) as? String
    return nil
}

func getCountryCodeFromCurrentLocale()-> String? {
    let locale = Locale.current
    let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String
    return code
}

//Store Any custom object to UserDefault with a key
func archiveObject(_ obj: Any, key: String) {
    let archive = NSKeyedArchiver.archivedData(withRootObject: obj)
    _userDefault.set(archive, forKey: key)
}

//Get a object from userDefault with key
func unArchiveObjectForKey(_ key: String) -> Any? {
    if let data = _userDefault.object(forKey: key) as? Data {
        let unarchiveObj = NSKeyedUnarchiver.unarchiveObject(with: data)
        return unarchiveObj
    }
    return nil
}

//MARK:============================= Protocols ===================================

//should import GoogleMaps sdk in your project
//MARK: Google Map Route Path Protocol
import GoogleMaps
protocol GoogleMapRoutePath {
    var mapView: GMSMapView {get set}
}

extension GoogleMapRoutePath {
    //Get route beween two location using google map direction api.
    func getRoutesFromGoogleApi(_ originCoordinates: CLLocationCoordinate2D, _ destinationCoordinates: CLLocationCoordinate2D) {
        var paths = [GMSPath]()
        let fromLatLong = "\(originCoordinates.latitude),\(originCoordinates.longitude)"
        let toLatLong = "\(destinationCoordinates.latitude),\(destinationCoordinates.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(fromLatLong)&destination=\(toLatLong)&sensor=false"
        
        let operation = VPOperation(strUrl: url) { (response) in
            if let response = response as? [String : AnyObject] {
                jprint("Route API Request URL: \(url)\nResponse:\n\(response)")
                if let routes = response["routes"] as? [[String : AnyObject]] {
                    if let firstRoute = routes.first {
                        if let legs = firstRoute["legs"] as? [[String : AnyObject]] {
                            if let firstLeg = legs.first {
                                if let steps = firstLeg["steps"] as? [[String : AnyObject]] {
                                    for step in steps {
                                        
                                        if let encodedPolyline = step["polyline"] as? [String : AnyObject] {
                                            if let encodedPolylinePoints = encodedPolyline["points"] as? String {
                                                let path = GMSPath(fromEncodedPath: encodedPolylinePoints)!
                                                paths.append(path)
                                                print(encodedPolylinePoints)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                print(paths)
                DispatchQueue.main.async(execute: {
                    self.drawRouteOnGoogleMap(paths, zoomLocation: originCoordinates)
                })
            }
        }
        let operationQueue = OperationQueue()
        operationQueue.addOperation(operation)
    }
    
    //Draw route path on map
    func drawRouteOnGoogleMap(_ paths: [GMSPath], zoomLocation: CLLocationCoordinate2D) {
        let startPositionCoordinates = zoomLocation
        let cameraPositionCoordinates = startPositionCoordinates
        let cameraPosition = GMSCameraPosition.camera(withTarget: cameraPositionCoordinates, zoom: 8)
        mapView.animate(to: cameraPosition)
        
        
        for path in paths {
            let rectangle = GMSPolyline(path: path)
            rectangle.strokeWidth = 3.0
            rectangle.strokeColor = UIColor.scHeaderColor()
            rectangle.map = mapView
        }
    }
    
}


