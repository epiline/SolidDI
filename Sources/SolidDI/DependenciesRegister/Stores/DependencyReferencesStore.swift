//
//  DependencyReferencesStore.swift
//  
//
//  Created by Женя on 21.04.2022.
//

import Foundation

final internal class DependencyReferencesStore {

    private var dependencies: [String: DependencyReferenceProtocol] = [:]

    func get(key: String) -> DependencyReferenceProtocol? {
        return dependencies[key]
    }

    func set(key: String, dependency: DependencyReferenceProtocol) {
        dependencies[key] = dependency
    }
}
