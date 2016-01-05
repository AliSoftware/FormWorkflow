//
//  FormCells.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 12/12/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import UIKit

protocol FormEntryFillable {
  func fill(entry: FormEntryType)
}

final class TextCell: UITableViewCell, Reusable, FormEntryFillable {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var valueLabel: UILabel!
  
  func fill(entry: FormEntryType) {
    guard let entry = entry as? FormEntry<String> else { fatalError("Inconsistent FormEntryType type for this cell") }
    titleLabel.text = entry.label
    valueLabel.text = entry.value
  }
}

final class BoolCell: UITableViewCell, Reusable, FormEntryFillable {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var boolSwitch: UISwitch!
  var entry: FormEntry<Bool>!
  
  func fill(entry: FormEntryType) {
    guard let entry = entry as? FormEntry<Bool> else { fatalError("Inconsistent FormEntryType type for this cell") }
    self.entry = entry
    titleLabel.text = entry.label
    boolSwitch.on = entry.value ?? false
  }
  
  @IBAction func onSwitchChanged(sender: UISwitch) {
    entry.value = sender.on
  }
}
