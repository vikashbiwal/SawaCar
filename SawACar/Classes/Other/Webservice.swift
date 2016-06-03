//
//  WebServicesCalls.swift
//  BitonMessanger
//
//  Created by Yudiz Solutions Pvt. Ltd. on 17/09/15.
//  Copyright (c) 2015 Yudiz Solutions Pvt. Ltd. All rights reserved.
//


import UIKit


typealias WSBlock = (response: vResponse, flag: Int) -> ()
var wsCall = {  return Webservice()}()
var kWSBaseUrl = "https://sawacar.com/Services/Sawacar.ashx"

//MARK: General WebService
extension Webservice {
    func getAllCoutries(block: WSBlock) {
        jprint("=======WS = GetAllCountries=======")
        getRequest(urlWithMethod("GetAllCountries"), param: nil, block: block)
    }
    
    func getActiveCoutries(block: WSBlock) {
        jprint("=======WS = GetActiveCountries=======")
        getRequest(urlWithMethod("GetActiveCountries"), param: nil, block: block)
    }
    
    func GetAllCurrencies(block: WSBlock) {
        jprint("=======WS = GetAllCurrencies=======")
        getRequest(urlWithMethod("GetAllCurrencies"), param: nil, block: block)
    }
}

//MARK: User related WebServices
extension Webservice {
    func signUp(params: [String : AnyObject], block: WSBlock) {
        //parameters  -  Email, FirstName, LastName, Password, Gender, YearOfBirth,
        //NationalityID, CountryID, MobileCountryCode, MobileNumber
        jprint("=======WS = SignUp=======")
        postRequest(urlWithMethod("SignUp"), param: params, block: block)
    }
    
    func login(params: [String : String!], block : WSBlock)  {
        //parameters - Email, Password
        jprint("=======WS = Login=======")
        postRequest(urlWithMethod("Login"), param: params, block: block)
    }
    
    func loginWithFacebook(params: [String : AnyObject], block: WSBlock) {
        //parameters - Email, FacebookID, FirstName, LastName, Gender
        jprint("=======WS = LoginWithFacebook=======")
        postRequest(urlWithMethod("LoginWithFacebook"), param: params, block: block)
    }
    
    func changePassword(params: [String : String], block : WSBlock)  {
        //parameters - Email, OldPassword, NewPassword
        jprint("=======WS = ChangePassword=======")
        postRequest(urlWithMethod("ChangePassword"), param: params, block: block)
    }
    
    func GetUserInformation(userId: String, block : WSBlock)  {
        //parameters - UserID
        jprint("=======WS = GetUserInformation=======")
        postRequest(urlWithMethod("GetUserInformation"), param: ["UserID" : userId], block: block)
    }
}



//MARK: Webservice Inialization and Afnetworking setup
class Webservice: NSObject {
    
    var manager : AFHTTPSessionManager!
    lazy var downloadManager: AFURLSessionManager = AFURLSessionManager()
    
    var succBlock: (dataTask :NSURLSessionDataTask!, responseObj :AnyObject!, relPath: String, block: WSBlock) -> Void
    var errBlock: (dataTask :NSURLSessionDataTask!, error :NSError!, relPath: String, block: WSBlock) -> Void
    
    override init() {
        manager = AFHTTPSessionManager(baseURL: NSURL(string: kWSBaseUrl))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer.acceptableContentTypes = Set(["text/html", "text/plain", "application/json"])
        // Success and Error response block, singletone block for all responses
        succBlock = { (dataTask, responseObj, relPath, block) in
            let response = dataTask.response! as! NSHTTPURLResponse
            print("Response Code : \(response.statusCode)")
            print("Response ((\(relPath)): \(responseObj)")
            block(response: vResponse(rJson: responseObj), flag: response.statusCode)
        }
        errBlock = { (dataTask, error, relPath, block) in
            let dat = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData
            if let errData = dat {
                let erInfo =  (try! NSJSONSerialization.JSONObjectWithData(errData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                print("Error - json(\(relPath)): \(erInfo)")
            } else {
                print("Error(\(relPath)): \(error)")
            }
            block(response: vResponse(rJson: nil) , flag: error.code)
        }
        
        super.init()
        manager.reachabilityManager.setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
            if status == AFNetworkReachabilityStatus.NotReachable {
                self.showAlert("No internet", message: "Your internet connection seems to be down")
            } else if status == AFNetworkReachabilityStatus.ReachableViaWiFi ||
                status == AFNetworkReachabilityStatus.ReachableViaWWAN {
                // do nothing for now
            }
        }
        manager.reachabilityManager.startMonitoring()
    }
    
    // sign manager with access token
    func addAccesTokenToHeader(token: String){
        manager.requestSerializer.setValue("\(token)", forHTTPHeaderField: "")
        print("Token added: \(token)")
    }
    
    func accessTokenForHeader() -> String? {
        return manager.requestSerializer.valueForHTTPHeaderField("")
    }
    
    // MARK: Utility methods
    func isInternetAvailable() -> Bool {
        let bl = manager.reachabilityManager.networkReachabilityStatus != AFNetworkReachabilityStatus.NotReachable
        if bl == false {
            self.showAlert("No internet", message: "Your internet connection seems to be down")
        }
        return bl
    }
    
    private func showAlert(title:NSString, message:String) {
        let alert :UIAlertView = UIAlertView(title: title as String, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    // MARK: Private Methods
    private func postRequest(relativePath: String, param: NSDictionary?, block: WSBlock) {
        print("Parameters %@", param)
        manager.POST(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativePath, block: block)
            }, failure: { (task, error) -> Void in
                self.succBlock(dataTask: task, responseObj: error, relPath: relativePath, block: block)
        })
    }
    
    
    private func getRequest(relativePath: String, param: NSDictionary?, block: WSBlock) {
        print("Parameters %@", param)
        manager.GET(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativePath, block: block)
            }, failure:  { (task, error) -> Void in
                self.succBlock(dataTask: task, responseObj: error, relPath: relativePath, block: block)
        })
    }
    
    private func uploadImage(imgData: NSData, relativepath: String, param: NSDictionary?, block: WSBlock) {
        print("Parameters %@", param)
        manager.POST(relativepath, parameters: param, constructingBodyWithBlock: { (formData) -> Void in
            formData.appendPartWithFileData(imgData, name: "vImage", fileName: "image.jpeg", mimeType: "image/jpeg")
            }, success: { (task, responseObj) -> Void in
                self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativepath, block: block)
            }, failure:  { (task, error) -> Void in
                self.succBlock(dataTask: task, responseObj: error, relPath: relativepath, block: block)
        })
    }
    
    private func uploadContacts(relativepath: String, param: [String], block: WSBlock) {
        manager.POST(relativepath, parameters: param, constructingBodyWithBlock: { (formData) -> Void in
            for contc in param as [NSString] {
                formData.appendPartWithFormData(contc.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "phonehash[]")
            }
            }, success: { (task, responseObj) -> Void in
                self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativepath, block: block)
            }, failure:  { (task, error) -> Void in
                self.succBlock(dataTask: task, responseObj: error, relPath: relativepath, block: block)
        })
    }
}

//MARK: Create WS url with api name
func urlWithMethod(method: String) -> String {
    let url = kWSBaseUrl + "?Method=" + method
    jprint("Requested url -" + url)
    return url
}

//Structure will be used for manage the ws response.
struct vResponse {
    var isSuccess  = false
    let json: AnyObject?
    var message: String?
    
    init(rJson : AnyObject?) {
        if let rJson = rJson {
            isSuccess = ((rJson as! [String : AnyObject])["IsSuccess"] as! Int)  == 1 ? true : false
            
            //assign message, if any get with response.
            if let messageObj = (rJson as! [String : AnyObject])["Messages"] {
                message = (messageObj as! [String]).first
            }
        } else {
          message = "Server Error"
        }
        json = rJson
    }
}