//
//  WeakDependencyReference.swift
//  
//
//  Created by Баян Евгений Вячеславович on 17.04.2022.
//

import Foundation

final public class WeakDependencyReference: DependencyReferenceProtocol {

    private weak var weakReferenceDependency: AnyObject?

    public var dependency: AnyObject? {
        return weakReferenceDependency
    }

    public init(_ dependency: AnyObject) {
        self.weakReferenceDependency = dependency
    }
}
