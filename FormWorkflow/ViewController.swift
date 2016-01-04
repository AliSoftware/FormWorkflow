//
//  ViewController.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 12/12/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let d = NSDate()
    d.timeIntervalSinceNow
  }
  
  @IBAction func startWorkflow(sender: UIButton) {
    let nc = UINavigationController(rootViewController: firstScreen)
    firstScreen.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "next")
    self.presentViewController(nc, animated: true, completion: nil)
  }
  
  private lazy var firstScreen: UIViewController = {
    let firstNameEntry = FormEntry<String>(label: "Prénom", value: "Paul") { $0?.characters.count > 0 }
    let lastNameEntry = FormEntry<String>(label: "Nom", value: "Auchon") { $0?.characters.count > 0 }
    //    let dobEntry = FormEntry<NSDate>(label: "Date Naissance") { $0?.timeIntervalSinceNow < -86400 }
    let checkEntry = FormEntry<Bool>(label: "Plus de 21 ans") { $0 == true }
    
    return FormViewController.instance(items: [firstNameEntry, lastNameEntry, checkEntry])
  }()
  
  func next() {
    print("NEXT!")
  }
}

