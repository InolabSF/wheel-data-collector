/// Base URI
#if LOCAL_SERVER
let kURIBase =                          "http://localhost:3000"
#else
let kURIBase =                          "https://connected-bicycle-platform.herokuapp.com"
#endif


/// MARK: - Google Map

struct WDCGoogleMap {
    /// API key
    static let APIKey =                 "AIzaSyD-LfTAS86ANcfKWfTvGxfrhffEa_0b6ZQ"
    static let BrowserAPIKey =          "AIzaSyCOs8WfaB_hP6ZJCb0mmMGqlXCLleOYDQc"

    /// Initial Location (San Francisco)
    static let Latitude: CLLocationDegrees =        37.7833
    static let Longitude: CLLocationDegrees =       -122.4167

    /// Zoom
    static let Zoom: Float =            13.0
}


/// MARK: - Wheel

struct WDCWheel {
    /// MARK: - API
    struct API {
        static let Stub = kURIBase + "/wheel/stub_data"          /// wheel data stub API
    }

    /// MARK: - dataType
    struct DataType {
        static let Speed =                              9
        static let Slope =                              10
        static let EnergyEfficiency =                   11
        static let TotalOdometer =                      12
        static let TripOdometer =                       13
        static let TripAverageSpeed =                   14
        static let TripEnergyEfficiency =               15
        static let MotorTemperature =                   16
        static let MotorDriveTemperature =              17
        static let RiderTorque =                        18
        static let RiderPower =                         19
        static let BatteryCharge =                      20
        static let BatteryHealth =                      21
        static let BatteryPower =                       22
        static let BatteryVoltage =                     23
        static let BatteryCurrent =                     24
        static let BatteryTemperature =                 25
        static let BatteryTimeToFull =                  26
        static let BatteryTimeToEmpty =                 27
        static let BatteryRange =                       28
        static let RawDebugData =                       29
        static let BatteryPowerNormalized =             30
        static let Acceleration =                       31
    }
}
