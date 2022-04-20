//
//  DependencyReferenceProtocol.swift
//  
//
//  Created by Баян Евгений Вячеславович on 17.04.2022.
//

import Foundation

internal protocol DependencyReferenceProtocol: AnyObject {

    var dependency: AnyObject? { get }

    init(_ dependency: AnyObject)
}
