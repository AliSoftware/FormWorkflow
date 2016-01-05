//
//  FormViewController.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 12/12/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import UIKit
import PromiseKit

enum ExitPointError: ErrorType {
  case CancelWorkflow
}




class FormViewController: UITableViewController {
  
  private var items: [FormEntryType]
  private var editMode: Bool = false
  
  static func instance(items items: [FormEntryType], editable: Bool = false) -> FormViewController {
    let form = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FormViewController") as! FormViewController
    form.items = items
    form.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: form, action: "cancel")
    let validateBtn = UIBarButtonItem(title: "Validate", style: UIBarButtonItemStyle.Plain, target: form, action: "next")
    if editable {
      let editBtn = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: form, action: "edit")
      form.navigationItem.rightBarButtonItems = [validateBtn, editBtn]
    } else {
      form.navigationItem.rightBarButtonItem = validateBtn
    }
    return form
  }

  required init?(coder aDecoder: NSCoder) {
    self.items = []
    super.init(coder: aDecoder)
  }
  
  var isValid: Bool {
    return items.reduce(true) { (acc, item) in acc && item.isValid }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let item = items[indexPath.row]

    let cell: UITableViewCell
    
    switch item {
    case let e as FormEntry<String>:
      let textCell = tableView.dequeueReusableCell(indexPath: indexPath) as TextCell
      textCell.fill(e, editMode: editMode)
      cell = textCell
    case let e as FormEntry<Bool>:
      let boolCell = tableView.dequeueReusableCell(indexPath: indexPath) as BoolCell
      boolCell.fill(e, editMode: editMode)
      cell = boolCell
    default:
      fatalError("No Cell type matching item of \(item)")
    }

    return cell
  }
  
  private let (_promise, fulfill, reject) = Promise<Void>.pendingPromise()
  func promise() -> Promise<Void> {
    return _promise
  }

  func cancel() {
    reject(ExitPointError.CancelWorkflow)
  }
  func next() {
    if isValid {
      fulfill()
    }
    else {
      let alert = UIAlertController(title: "Form incomplete", message: "All fields must be valid", preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "Woops", style: .Cancel, handler: nil))
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
  func edit() {
    if editMode {
      for i in self.items { i.commit() }
    }
    editMode = !editMode
    self.navigationItem.rightBarButtonItems?[0].enabled = !editMode
    self.tableView.reloadData()
  }
  
  var stressCount = 0
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    stressCount += 1
    if stressCount >= 5 {
      let stressError = NSError(domain: "UserStressLevelTooHigh", code: 5, userInfo: [NSLocalizedDescriptionKey: "Chill, man!"])
      reject(stressError)
    }
  }
}
