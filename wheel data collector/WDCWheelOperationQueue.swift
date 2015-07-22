private let _WDCWheelOperationQueue = WDCWheelOperationQueue.defaultQueue()

/// MARK: - WDCWheelOperationQueue
class WDCWheelOperationQueue: ISHTTPOperationQueue {

    class var sharedInstance: WDCWheelOperationQueue {
        _WDCWheelOperationQueue.maxConcurrentOperationCount = 1
        return _WDCWheelOperationQueue
    }

    override init() {
        super.init()
        self.maxConcurrentOperationCount = 1
    }

}
