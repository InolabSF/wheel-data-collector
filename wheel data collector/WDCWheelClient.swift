import Foundation


/// MARK: - WDCWheelClient
class WDCWheelClient: AnyObject {

    /// MARK: - property

    /// MARK: - class method

    static let sharedInstance = WDCWheelClient()


    /// MARK: - public api

    /**
     * POST /wheel/stub_data
     * @param json Dictionary
     * @param completionHandler (json: JSON?) -> Void
     */
    func postWheelData(#json: [[String: String]], completionHandler: (json: JSON?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: WDCWheel.API.Stub)!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(["wheel_datas" : json], options: nil, error: nil)

        // request
        var operation = ISHTTPOperation(
            request: request,
            handler:{ (response: NSHTTPURLResponse!, object: AnyObject!, error: NSError!) -> Void in
                var responseJSON: JSON = nil
                if object != nil { responseJSON = JSON(data: object as! NSData) }
                let applicationCode = responseJSON["application_code"]
                if applicationCode == nil { responseJSON = nil }
                else { if applicationCode.intValue != 200 { responseJSON = nil } }

                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(json: responseJSON)
                })
            }
        )
        WDCWheelOperationQueue.sharedInstance.addOperation(operation)
    }

    /**
     * cancel POST wheel/stub_data
     **/
    func cancelPostWheelData() {
        WDCWheelOperationQueue.sharedInstance.cancelOperationsWithPath(NSURL(string: WDCWheel.API.Stub)!.path)
    }

}
