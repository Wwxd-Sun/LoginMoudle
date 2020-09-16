//
//  AppRouter.swift
//  Carlisle_Example
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import LoginMoudle
import BaseMoudle
import URLNavigator

public struct AppRouter {
    
    public static func initialize(navigator: NavigatorType) {
        UtilCoreNavigatorMap.initialize(navigator: navigator)
        Carlisle_router.initialize(navigator: navigator)
    }
}
