//
//  DependenciesRegisterResolvable.swift
//  
//
//  Created by Женя on 21.04.2022.
//

import Foundation

protocol DependenciesRegisterResolvable: AnyObject {
    
    func isExist(key: String) -> Bool
    
    func resolve<D>(by key: String, diContainer: DIContainer) -> D
}
