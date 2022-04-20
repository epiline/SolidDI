//
//  ConfigurationsStore.swift
//  
//
//  Created by Женя on 21.04.2022.
//

import Foundation

final internal class ConfigurationsStore {

    private var configurators: [String: DependencyConfiguration] = [:]

    func get(key: String) -> DependencyConfiguration? {
        return configurators[key]
    }

    func set(key: String, dependencyConfigurator: @escaping DependencyConfiguration) {
        configurators[key] = dependencyConfigurator
    }
}
