//
//  WeakReference.swift
//  
//
//  Created by Баян Евгений Вячеславович on 17.04.2022.
//

import Foundation

final public class WeakReference: DependencyReferenceProtocol {

    private weak var weakReferenceDependency: AnyObject?

    public var dependency: AnyObject? {
        return weakReferenceDependency
    }

    public init(_ dependency: AnyObject) {
        weakReferenceDependency = dependency
    }
}
