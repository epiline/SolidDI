//
//  DependencyReference.swift
//  InjectionLesson
//
//  Created by Женя on 03.12.2021.
//

import Foundation

public protocol DependencyReferenceProtocol: AnyObject {
    
    var dependency: AnyObject? { get }
    
    init(_ dependency: AnyObject)
}
