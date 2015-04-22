//
//  MapPopupViewController.swift
//  Cole Dunsby
//
//  Created by James Cole Dunsby on 2015-04-21.
//  Copyright (c) 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MapKit

protocol MapPopupViewControllerDelegate : NSObjectProtocol {
    func mapPopupViewControllerDidDismiss(mapPopupViewController: MapPopupViewController)
}

class MapPopupViewController: UIViewController {

    weak var delegate: MapPopupViewControllerDelegate!
    var location = CLLocationCoordinate2D()
    var name = "Location"
    
    @IBOutlet weak var navigationBar: UINavigationBar?
    @IBOutlet weak var mapView: MKMapView?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar?.topItem?.title = name
        
        let pin = MKPointAnnotation()
        pin.coordinate = location
        pin.title = "Montreal, Canada"
        mapView!.addAnnotation(pin)
        
        mapView?.setCenterCoordinate(location, animated: false)
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("zoomMapView"), userInfo: nil, repeats: false)
    }
    
    // MARK: Instance Methods
    
    func zoomMapView() {
        mapView!.setRegion(MKCoordinateRegion(center: mapView!.centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)), animated: true)
    }
    
    // MARK: IBActions
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        delegate.mapPopupViewControllerDidDismiss(self)
    }

}
