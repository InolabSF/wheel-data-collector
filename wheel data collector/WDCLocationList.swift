/// MARK: - WDCLocationList
class WDCLocationList: NSObject {

    /// MARK: - property

    var locations: [WDCLocation] = []


    /// MARK: - public api

    func startUpdating() {
        self.locations = []
    }

    func appendLocation(location: CLLocation) {
        let loc = WDCLocation(location: location)
        self.locations.append(loc)
    }

    func accelerationJSON() -> [[String: String]] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")

        // create wheel datas (data_type, lat, long, timestamp, velocity)
        var wheelDatas: [[String: String]] = []
        for var i = 1; i < self.locations.count; i++ {
            let from = self.locations[i-1]
            let to = self.locations[i]

            var wheelData: [String: String] = [:]
            // data_type
            wheelData["data_type"] = "\(WDCWheel.DataType.Acceleration)"
            // location
            wheelData["lat"] = "\(to.location.coordinate.latitude)"
            wheelData["long"] = "\(to.location.coordinate.longitude)"
            // timestamp
            wheelData["timestamp"] = dateFormatter.stringFromDate(to.date)
            // velocity (meter / second)
            let distance = Double(GMSGeometryDistance(from.location.coordinate, to.location.coordinate))    // meter
            let second = to.date.timeIntervalSinceDate(from.date)                                           // second
            wheelData["velocity"] = "\(distance / second)"

            wheelDatas.append(wheelData)
        }

        // add acceleration to wheel datas
        for var i = 1; i < wheelDatas.count; i++ {
            let from = wheelDatas[i-1]
            let to = wheelDatas[i]

            // acceleration (meter / second^2)
            let velocityDifference = (to["velocity"] as NSString?)!.doubleValue - (from["velocity"] as NSString?)!.doubleValue
            let second = dateFormatter.dateFromString(to["timestamp"]!)!.timeIntervalSinceDate(dateFormatter.dateFromString(from["timestamp"]!)!) // second

            wheelDatas[i]["value"] = "\(velocityDifference / second)"

            wheelDatas[i-1].removeValueForKey("velocity")
        }
        if wheelDatas.count > 0 { wheelDatas.removeAtIndex(0) }
        if wheelDatas.count > 0 { wheelDatas[wheelDatas.count-1].removeValueForKey("velocity") }

        return wheelDatas
    }

}
