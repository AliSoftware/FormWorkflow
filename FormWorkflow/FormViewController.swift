//
//  FormViewController.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 12/12/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import UIKit

class FormViewController: UITableViewController {
  
  var items: [FormEntryType]
  
  static func instance(items items: [FormEntryType]) -> FormViewController {
    let form = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FormViewController") as! FormViewController
    form.items = items
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
    case is FormEntry<String>:
      cell = tableView.dequeueReusableCell(indexPath: indexPath) as TextCell
    case is FormEntry<Bool>:
      cell = tableView.dequeueReusableCell(indexPath: indexPath) as BoolCell
    default:
      fatalError("No Cell type matching item of \(item)")
    }

    (cell as! FormEntryFillable).fill(item)
    
    return cell
  }
}
