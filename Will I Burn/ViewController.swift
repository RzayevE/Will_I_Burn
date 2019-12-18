//
//  ViewController.swift
//  Will I Burn
//
//  Created by Elnur Rzayev on 11/09/2019.
//  Copyright © 2019 Elnur Rzayev. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate{

    
    @IBOutlet weak var bigTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var skinTypeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    var coords = CLLocationCoordinate2D(latitude: 40, longitude: 40)
    var skinType = SkinType().type1{
        didSet{
            skinTypeLabel.text = "Skin:  " + self.skinType
            Utilities().setSkinType(value: skinType)
            getWeatherData()
        }
    }
    var uvIndex = 8
    var burnTime : Double = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        skinType = Utilities().getSkinType()
        skinTypeLabel.text = "Skin:  " + SkinType().type1
    }

    @IBAction func setReminderClicked(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Time's up!", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "You start burning. Please get on the shelter!", arguments: nil)
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest(identifier: "willburn", content: content, trigger: trigger)
                
                center.add(request)
            }
        }
    )}
    
    @IBAction func ChangeSkinClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Skin Type", message: "Please choose your Skin Type", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: SkinType().type1, style: .default, handler: { (action) in
            self.skinType = SkinType().type1
        }))
        alert.addAction(UIAlertAction(title: SkinType().type2, style: .default, handler: { (action) in
            self.skinType = SkinType().type2
        }))
        alert.addAction(UIAlertAction(title: SkinType().type3, style: .default, handler: { (action) in
            self.skinType = SkinType().type3
        }))
        alert.addAction(UIAlertAction(title: SkinType().type4, style: .default, handler: { (action) in
            self.skinType = SkinType().type4
        }))
        alert.addAction(UIAlertAction(title: SkinType().type5, style: .default, handler: { (action) in
            self.skinType = SkinType().type5
        }))
        alert.addAction(UIAlertAction(title: SkinType().type6, style: .default, handler: { (action) in
            self.skinType = SkinType().type6
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location Location Changed !")
        
        if status == .authorizedWhenInUse{
            getLocation()
        } else if status == .denied{
            let alert = UIAlertController(title: "Error", message: "Go to settings and allow app to access your location", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getLocation(){
        if let loc = locationManager.location?.coordinate{
            coords = loc
        }
//        getWeatherData()
    }
    
    func getWeatherData(){
//        let url = WeatherUrl(lat: String(coords.latitude), long: String(coords.longitude)).getFullUrl()
        let url = WeatherUrl().getFullUrl()

        print("URL is \(url)")
        
        Alamofire.request(url, method: .get).responseJSON { response in
            print("Alamo \(response.result)")
            if let JSON = response.result.value as? AnyObject{
                print("JSON : \(JSON)")
                
                if let current = JSON["current"] as? Dictionary<String, AnyObject>{
                    if let uv = current["uv_index"] as? Int{
//                        if let uvI = Int(uv){
//                            self.uvIndex = uvI
//                            print("UV INDEX = \(uvI)")
//                        }else {
//                            print("Error 3")
//                        }
                        self.uvIndex = uv
                        print("UV_Index : \(self.uvIndex)")
                        self.updateUI(dataSuccess: true)
                        return
                    }
                }
                self.updateUI(dataSuccess: false)
            }
        }
    }
    
    func updateUI(dataSuccess: Bool) {
//        failed
        if !dataSuccess{
            statusLabel.text = "Failed...Retrying..."
            getWeatherData()
            return
        }
//        successed
        activityIndicator.alpha = 0
        statusLabel.text = "Got UV data !"
        calcBurnTime()
        print("Burn Time is \(self.burnTime)")
        self.bigTimeLabel.text = String(format: "%.f", self.burnTime)
    }

    func calcBurnTime() {
        var minToBurn : Double = 10
        
        switch skinType {
        case SkinType().type1:
            minToBurn = BurnTime().burnTime1
             print("Skin Type is : \(BurnTime().burnTime1)")
        case SkinType().type2:
            minToBurn = BurnTime().burnTime2
             print("Skin Type is : \(BurnTime().burnTime2)")
        case SkinType().type3:
            minToBurn = BurnTime().burnTime3
             print("Skin Type is : \(BurnTime().burnTime3)")
        case SkinType().type4:
            minToBurn = BurnTime().burnTime4
             print("Skin Type is : \(BurnTime().burnTime4)")
        case SkinType().type5:
            minToBurn = BurnTime().burnTime5
             print("Skin Type is : \(BurnTime().burnTime5)")
        case SkinType().type6:
            minToBurn = BurnTime().burnTime6
             print("Skin Type is : \(BurnTime().burnTime6)")
        default:
            minToBurn = BurnTime().burnTime1
             print("Skin Type is : \(BurnTime().burnTime1)")
        }
        burnTime = minToBurn/Double(self.uvIndex)
    }
}

