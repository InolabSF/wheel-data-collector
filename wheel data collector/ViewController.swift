import UIKit


class ViewController: UIViewController {

    /// MARK: - property

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    var mapView: GMSMapView!

    var locationManager: CLLocationManager!
    var locationList: WDCLocationList!


    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = UIScreen.mainScreen().bounds

        // google map view
        self.mapView = GMSMapView()
        self.mapView.frame = rect
        self.mapView.delegate = self
        self.mapView.myLocationEnabled = true
        self.mapView.settings.compassButton = false
        self.mapView.settings.myLocationButton = true
        self.mapView.settings.indoorPicker = false
        self.mapView.buildingsEnabled = false
        self.mapView.accessibilityElementsHidden = true
        self.mapView.padding = UIEdgeInsetsMake(0.0, 0.0, self.button.frame.size.height, 0.0)
        self.view.addSubview(self.mapView)
        self.mapView.camera = GMSCameraPosition.cameraWithLatitude(
            WDCGoogleMap.Latitude,
            longitude: WDCGoogleMap.Longitude,
            zoom: WDCGoogleMap.Zoom
        )

        self.view.bringSubviewToFront(self.button)
        self.view.bringSubviewToFront(self.label)

        // location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 300

        // location list
        self.locationList = WDCLocationList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /// MARK: - event listener

    @IBAction func touchedUpInsideButton(button: UIButton) {
        if button == self.button {
            var title = self.button.titleForState(.Normal)
            if title == "Start" {
                self.locationManager.startUpdatingLocation()
                self.locationList.startUpdating()
                title = "End"
            }
            else if title == "End" {
                let location = self.mapView.myLocation
                if location != nil { self.locationList.appendLocation(location!) }
                self.locationManager.stopUpdatingLocation()
                title = "Start"

                let json = self.locationList.accelerationJSON()
                let message = ["wheel_datas":json]
                let alertView = UIAlertView(title: "OK to post?", message: "\(message)", delegate: self, cancelButtonTitle: "No")
                alertView.addButtonWithTitle("Yes")
                alertView.show()
            }

            self.button.setTitle(title, forState: .Normal)
            self.label.text = ""
        }
    }

}


/// MARK: - UIAlertViewDelegate
extension ViewController: UIAlertViewDelegate {

    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex < 0 { return }

        let json = self.locationList.accelerationJSON()
        WDCWheelClient.sharedInstance.cancelPostWheelData()
        WDCWheelClient.sharedInstance.postWheelData(
            json: json,
            completionHandler: { [unowned self] (responseJSON) in
                // resend?
                if responseJSON == nil {
                    let message = ["wheel_datas":json]
                    let alertView = UIAlertView(title: "Post failed. Do you send it again?", message: "\(message)", delegate: self, cancelButtonTitle: "No")
                    alertView.addButtonWithTitle("Yes")
                    alertView.show()
                }
            }
        )
    }

}


/// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        dispatch_async(dispatch_get_main_queue(), { [unowned self] () in
            self.label.text = "coordinate: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)"
            self.locationList.appendLocation(newLocation)
            self.locationManager.startUpdatingLocation()
        })
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    }

}


/// MARK: - GMSMapViewDelegate
extension ViewController: GMSMapViewDelegate {

    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
    }

    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        return true
    }

    func mapView(mapView: GMSMapView,  didBeginDraggingMarker marker: GMSMarker) {
    }

    func mapView(mapView: GMSMapView,  didEndDraggingMarker marker: GMSMarker) {
    }

    func mapView(mapView: GMSMapView, didChangeCameraPosition position: GMSCameraPosition) {
    }

    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
    }

    func mapView(mapView: GMSMapView,  didDragMarker marker:GMSMarker) {
    }

    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
    }

}
