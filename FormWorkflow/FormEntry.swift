//
//  FormEntry.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 12/12/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation

protocol FormEntryType: class, CustomStringConvertible {
  var label: String { get }
  var placeholder: String { get }
  var isValid: Bool { get }
  func commit()
}

final class FormEntry<T> : FormEntryType {
  var label: String
  var placeholder: String
  var value: T? {
    didSet {
      editValue = value
    }
  }

  private var validationClosure: T? -> Bool
  init(label: String, placeholder: String = "", value: T? = nil, validationClosure: T? -> Bool) {
    self.label = label
    self.placeholder = placeholder
    self.value = value
    self.editValue = value
    self.validationClosure = validationClosure
  }
  var isValid: Bool { return validationClosure(value) }
  var description: String { return "\(self.dynamicType) > \(value)" }
  
  var editValue: T?
  func commit() {
    value = editValue
  }
}
