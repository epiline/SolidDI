//
//  StrongReference.swift
//  
//
//  Created by Баян Евгений Вячеславович on 17.04.2022.
//

import Foundation

final public class StrongReference: DependencyReferenceProtocol {

    private var strongReferenceDependency: AnyObject?

    public var dependency: AnyObject? {
        return strongReferenceDependency
    }

    public init(_ dependency: AnyObject) {
        strongReferenceDependency = dependency
    }
}
