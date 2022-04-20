//
//  File.swift
//  
//
//  Created by Баян Евгений Вячеславович on 20.04.2022.
//

import Foundation

internal final class DependencyKey<T> {

    public static func create() -> String {
        let typeKey: String = "\(T.self)"

        // TODO: Реализовать анврап опционала в дженерик типе
        return typeKey
            .replacingOccurrences(of: "Optional<", with: "")
            .replacingOccurrences(of: ">", with: "")
    }
}
