//
//  Helpers.swift
//  BoroKit
//
//  Created by Joss Manger on 10/4/21.
//

import Foundation

// User Defaults Property Wrapper
@propertyWrapper
public struct UserDefault<T: RawRepresentable> {

  private let store: UserDefaults
  private let key: Key
  private let defaultValue: T

  enum Key: String {
    case kCachedBorough
  }

  init(store: UserDefaults = UserDefaults.standard, key: Key, defaultValue: T) {
    self.store = store
    self.key = key
    self.defaultValue = defaultValue
  }

  public var wrappedValue: T {
    get {

      let obj = store.object(forKey: key.rawValue)
      guard let tRaw = obj as? T.RawValue, let returnValue = T(rawValue: tRaw) else {
        #if DEBUG
        print("returning defaultValue:\(obj)")
        #endif
        return defaultValue
      }
      #if DEBUG
      print("returning validated value \(returnValue)")
      #endif
      return returnValue
    }
    set {
      store.setValue(newValue.rawValue, forKey: key.rawValue)
      #if DEBUG
      print("\(key) now \(newValue)")
      #endif
    }
  }
}
