//
//  Reusable.swift
//  FormWorkflow
//
//  Created by Olivier Halligon on 04/01/2016.
//  Copyright © 2016 AliSoftware. All rights reserved.
//

import UIKit

protocol Reusable: class {
  static var identifier: String { get }
  static var nib: UINib? { get }
}

extension Reusable {
  static var identifier: String { return "\(self)" }
  static var nib: UINib? { return nil }
}

extension UITableView {
  func dequeueReusableCell<T: UITableViewCell where T: Reusable>(indexPath indexPath: NSIndexPath) -> T {
    return self.dequeueReusableCellWithIdentifier(T.identifier, forIndexPath: indexPath) as! T
  }
  
  func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView where T: Reusable>() -> T? {
    return self.dequeueReusableHeaderFooterViewWithIdentifier(T.identifier) as! T?
  }
  
  func register<T: UITableViewCell where T: Reusable>(cellClass: T.Type) {
    if let nib = T.nib {
      self.registerNib(nib, forCellReuseIdentifier: T.identifier)
    } else {
      self.registerClass(T.self, forCellReuseIdentifier: T.identifier)
    }
  }
  
  func register<T: UITableViewHeaderFooterView where T: Reusable>(headerFooterClass: T.Type) {
    if let nib = T.nib {
      self.registerNib(nib, forHeaderFooterViewReuseIdentifier: T.identifier)
    } else {
      self.registerClass(T.self, forHeaderFooterViewReuseIdentifier: T.identifier)
    }
  }
}
