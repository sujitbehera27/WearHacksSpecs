//
//  EndPageViewController.swift
//  Spec
//
//  Created by Tanuj Sharma on 10/4/2558 BE.
//  Copyright © 2558 Frederick Mfinanga. All rights reserved.
//

import UIKit

class EndPageViewController: UIViewController {

    @IBOutlet weak var aT: UILabel!
    @IBOutlet weak var dE: UILabel!
    @IBOutlet weak var bA: UILabel!
    @IBOutlet weak var gO: UILabel!
    var q1:Int?
    var q2:Int?
    var q3:Int?
    var q4:Int?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        if q1 != nil{
            aT.text = "\(q1!)"
        }
        
        if q2 != nil{
            dE.text = "\(q2!)"
        }
        
        if q3 != nil{
        bA.text = "\(q3!)"
        }
        
        if q4 != nil{
           gO.text = "\(q4!)"
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
