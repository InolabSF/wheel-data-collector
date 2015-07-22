/// MARK: - WDCLocation
class WDCLocation: NSObject {

    /// MARK: - property

    var location: CLLocation!
    var date: NSDate!


    /// MARK: - initialization

    /**
     * initialization
     * @param location CLLocation
     * @return WDCLocation
     */
    init(location: CLLocation) {
        super.init()

        self.location = location
        self.date = NSDate()
    }

}
