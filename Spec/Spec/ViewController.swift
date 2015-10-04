//
//  ViewController.swift
//  Spec
//
//  Created by Frederick Mfinanga on 2015-10-03.
//  Copyright © 2015 Frederick Mfinanga. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox
import CoreMotion



class ViewController: UIViewController, ESTIndoorLocationManagerDelegate , ESTBeaconManagerDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var clocker: UILabel!
    @IBOutlet weak var myLocationView: ESTIndoorLocationView!
    @IBOutlet weak var myPositionLabel: UILabel!
    @IBOutlet weak var offSideTrackerLabel: UILabel!
    @IBOutlet weak var closestbeaconRangeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var scorer: UIButton!
    let locationManager : ESTIndoorLocationManager = ESTIndoorLocationManager()
    let CLlocationManager = CLLocationManager()
    var location: ESTLocation!
    
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    
    
    let beaconManager = ESTBeaconManager()
    //let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,identifier: "mint")
    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Estimotes")

    let colors = [
        60039: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        48778: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        49061: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        18255: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        17610: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1),
        53852: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]
    
    let names = [
        60039: "blueberry1",
        48778: "blueberry2",
        49061: "ice2",
        18255: "ice1",
        17610: "mint1",
        53852: "mint2"
    ]
    
    var mainTimerLabel = 60
    var mainTimerTime = NSTimer()
    var q1 = 0
    var q2 = 0
    var q3 = 0
    var q4 = 0
    var q1bool = false
    var q2bool = false
    var q3bool = false
    var q4bool = false
    var final = resultss()
    
    func mainCount(){
        mainTimerLabel -= 1
        clocker.text = "00:00:\(mainTimerLabel)"
        switch whichQuad(){
            case 1: q1 = q1 + 1
            break
        case 2: q2 = q2 + 1
            break
        case 3: q3 = q3 + 1
            break
        case 4: q4 = q4 + 1
            break
        default: ""
        }
        
    }
    func runTime(){
        mainTimerTime = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("mainCount"), userInfo: nil, repeats: true)
    }
    
    func thisQuad(var qA:Bool,var qB:Bool,var qC:Bool) -> Bool{
        qA = false
        qB = false
        qC = false
        return !qA
    }
    
    func whichQuad() -> Int {
        var x = 0
        if (q1bool){
            x = 1
        }
        else if (q2bool){
            x = 2
        }
        else if (q3bool){
            x = 3
        }
        else {
            x = 4
        }
        return x
    }

    var positionView: ESTPositionView?
    
    var estimotePositionView: ESTPositionView?
    
    var estimotePosition: ESTPositionedBeacon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scorer.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
        self.CLlocationManager.delegate = self
         self.beaconManager.delegate = self
         self.beaconManager.requestAlwaysAuthorization()
         self.CLlocationManager.startUpdatingLocation()
        
        
        ESTConfig.setupAppID("spec", andAppToken: "2fd863dcd062f2f64bd039880264b0a5")
        self.locationManager.fetchLocationByIdentifier("wearhacks",
            withSuccess: { (result) -> Void in
                self.location = result as! ESTLocation
                
                self.myLocationView.backgroundColor = UIColor.clearColor()
                self.myLocationView.showTrace = false
                self.myLocationView.showWallLengthLabels = true
                self.myLocationView.rotateOnPositionUpdate = false
                
                self.myLocationView.locationBorderColor = UIColor.blackColor()
                self.myLocationView.locationBorderThickness = 6
                self.myLocationView.doorColor = UIColor.blackColor()
                self.myLocationView.doorThickness = 6
                self.myLocationView.traceColor = UIColor.yellowColor()
                self.myLocationView.traceThickness = 2
                self.myLocationView.wallLengthLabelsColor = UIColor.blackColor()
                self.myLocationView.drawLocation(self.location)
                self.locationManager.startIndoorLocation(self.location)
  
            }, failure: { (error) -> Void in
                print("can't fetch location: \(error)")
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        runTime()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func indoorLocationManager(manager: ESTIndoorLocationManager!, didFailToUpdatePositionWithError error: NSError!) {
        mainTimerTime.invalidate()
        scorer.hidden = false
    }
    
    func indoorLocationManager(manager: ESTIndoorLocationManager!, didUpdatePosition position: ESTOrientedPoint!, inLocation location: ESTLocation!) {
        if(mainTimerLabel > 0) {
        
        if (position.y > 0){
            offSideTrackerLabel.text = "Attacking"
            q1bool = thisQuad(q2bool, qB: q3bool, qC: q4bool)
            
            //q1runTime()
        }
        else if (position.y<0){
             offSideTrackerLabel.text = "Defending"
            q2bool = thisQuad(q1bool, qB: q3bool, qC: q4bool)
            //q2runTime()
        }
        if(position.x>0){
            myPositionLabel.text = "Out of position"
             self.view.backgroundColor = UIColor.redColor()
            q3bool = thisQuad(q1bool, qB: q2bool, qC: q4bool)
            //q3runTime()
        }
        else if (position.x<0){
            myPositionLabel.text = "In position"
            self.view.backgroundColor = self.colors[18255]
            //q4runTime()
            q4bool = thisQuad(q1bool, qB: q2bool, qC: q3bool)
        }
        myLocationView.updatePosition(position)
        } else {
            mainTimerTime.invalidate()
            final.final1 = q1
            final.final2 = q2
            final.final3 = q3
            final.final4 = q4
            
            clocker.text = "Finished!"
            scorer.hidden = false
        }
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        if startLocation == nil {
            startLocation = latestLocation as! CLLocation
        }
        let distanceBetween: CLLocationDistance = latestLocation.distanceFromLocation(startLocation)
        
        traveledDistance += distanceBetween
        print(String(format: "%.2f", distanceBetween))
        distanceLabel.text = "\(Int(traveledDistance)) meters"
    }


}

