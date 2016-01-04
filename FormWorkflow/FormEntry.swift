//
//  FormEntry.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 12/12/2015.
//  Copyright © 2015 AliSoftware. All rights reserved.
//

import Foundation

protocol FormEntryType : CustomStringConvertible {
  var label: String { get }
  var placeholder: String { get }
  var isValid: Bool { get }
}

class FormEntry<T> : FormEntryType {
  var label: String
  var placeholder: String
  var value: T?

  private var validationClosure: T? -> Bool
  init(label: String, placeholder: String = "", value: T? = nil, validationClosure: T? -> Bool) {
    self.label = label
    self.placeholder = placeholder
    self.value = value
    self.validationClosure = validationClosure
  }
  var isValid: Bool { return validationClosure(value) }
  var description: String { return "\(self.dynamicType) > \(value)" }
}
