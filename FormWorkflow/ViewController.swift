//
//  ViewController.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 12/12/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import UIKit
import PromiseKit

struct DataModel {
  let firstName: String
  let lastName: String
  var isLegal: Bool?
  let licenseNum: Int
  let creditCardDigits: Int
  let street: String
  let city: String
  let country: String
}

class ViewController: UIViewController {
  var model = DataModel(
    firstName: "Paul", lastName: "Auchon",
    isLegal: true,
    licenseNum: 12345054321, creditCardDigits: 4242,
    street: "San Francisco", city: "California", country: "United States"
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  @IBAction func startWorkflow(sender: UIButton) {
    Workflow(model: model).startOn(self)
  }
  
}
