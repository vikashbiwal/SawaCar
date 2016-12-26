//
//  Main.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 30/05/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit

//UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(LocalizedApplication), NSStringFromClass(AppDelegate))
//UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(LocalizedApplication), NSStringFromClass(AppDelegate))
UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(LocalizedApplication),
    NSStringFromClass(AppDelegate.self)
)
