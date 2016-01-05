//
//  Workflow.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 05/01/2016.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import UIKit
import PromiseKit

class Workflow {
  // I know, mutability is very bad. That's not the point of the demo here.
  var model: DataModel
  init(model: DataModel) {
    self.model = model
  }
  
  func startOn(vc: UIViewController) {
    let nc = UINavigationController()
    vc.presentViewController(nc, animated: true, completion: nil)
    
    print(model)
    
    // === The workflow starts here ===
    firstly {
      self.pushScreen1(nc)
    }
    .then {
      self.pushScreen2(nc)
    }
    .then {
      self.pushScreen3(nc)
    }
      
    // Handle the fact that the workflow can be cancelled at _any_ point
    .recover { (error: ErrorType) -> Void in
      try self.handleCancellation(error) // Cancellation errors are handled, other errors are rethrown
    }
    .recover { e in
      // Error not handled by the previous block
      print("Wooops, something bad (other than a cancellation) happened: \(e)")
    }
    .always {
      // End the workflow properly
      vc.dismissViewControllerAnimated(true, completion: nil)
      print(self.model)
    }
  }
  
  
  
  
  private func pushScreen1(nc: UINavigationController) -> Promise<Void> {
    let firstNameEntry = FormEntry<String>(label: "First Name", value: model.firstName) { $0?.characters.count > 0 }
    let lastNameEntry = FormEntry<String>(label: "Last Name", value: model.lastName) { $0?.characters.count > 0 }
    let checkEntry = FormEntry<Bool>(label: "Is above 21", value: model.isLegal) { $0 == true }
    let listItems: [FormEntryType] = [firstNameEntry, lastNameEntry, checkEntry]
    let form = FormViewController.instance(items: listItems, editable: true)
    
    nc.pushViewController(form, animated: false)
    
    return form.promise().then { [unowned self] () -> Void in
      // Process result of this screen before moving to next screen
      let (surname, lastname, okAge) = (firstNameEntry.value!, lastNameEntry.value!, checkEntry.value)
      print("\(surname) \(lastname) — Age OK = \(okAge ?? false)")
      self.model.isLegal = okAge
    }
  }
  
  
  
  
  private func pushScreen2(nc: UINavigationController) -> Promise<Void> {
    let licenseEntry = FormEntry<String>(label: "License number", value: String(model.licenseNum)) { $0?.characters.count > 0 }
    let cbEntry = FormEntry<String>(label: "Credit Card", value: "**** **** \(model.creditCardDigits)") { $0?.characters.count > 0 }
    let form = FormViewController.instance(items: [licenseEntry, cbEntry])
    
    nc.pushViewController(form, animated: true)
    
    return form.promise().then { () -> Void in
      // Process result of this screen before moving to next screen
      print("License \(licenseEntry.value!), CB = \(cbEntry.value!)")
    }
  }
  
  
  private func pushScreen3(nc: UINavigationController) -> Promise<Void> {
    let streetEntry = FormEntry<String>(label: "Street", value: model.street) { $0?.characters.count > 0 }
    let cityEntry = FormEntry<String>(label: "City", value: model.city) { $0?.characters.count > 0 }
    let countryEntry = FormEntry<String>(label: "Country", value: model.country) { $0?.characters.count > 0 }
    let form = FormViewController.instance(items: [streetEntry, cityEntry, countryEntry])
    
    nc.pushViewController(form, animated: true)
    
    return form.promise().then { () -> Void in
      // Process result of this screen before moving to next screen
      print("\(streetEntry.value!), \(cityEntry.value!), \(countryEntry.value!)")
    }
  }
  
  
  
  private func handleCancellation(error: ErrorType) throws -> Void {
    guard let exitError = error as? ExitPointError else { throw error }
    switch exitError {
    case .CancelWorkflow:
      print("Cancelled the workflow")
    }
  }

}
