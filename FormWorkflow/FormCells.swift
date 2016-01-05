//
//  FormCells.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 12/12/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import UIKit

final class TextCell: UITableViewCell, Reusable {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var valueLabel: UILabel!
  
  func fill(entry: FormEntry<String>, editMode: Bool) {
//    guard let entry = entry as? FormEntry<String> else { fatalError("Inconsistent FormEntryType type for this cell") }
    titleLabel.text = entry.label
    valueLabel.text = entry.value
    valueLabel.enabled = editMode
  }
}

final class BoolCell: UITableViewCell, Reusable {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var boolSwitch: UISwitch!
  var entry: FormEntry<Bool>!
  
  func fill(entry: FormEntry<Bool>, editMode: Bool) {
//    guard let entry = entry as? FormEntry<Bool> else { fatalError("Inconsistent FormEntryType type for this cell") }
    self.entry = entry
    titleLabel.text = entry.label
    boolSwitch.on = entry.editValue ?? false
    boolSwitch.enabled = editMode
  }
  
  @IBAction func onSwitchChanged(sender: UISwitch) {
    entry.editValue = sender.on
  }
}
