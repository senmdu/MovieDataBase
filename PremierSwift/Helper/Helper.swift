//
//  Helper.swift
//  PremierSwift
//
//  Created by Senthil Kumar on 27/04/23.
//  Copyright © 2023 Deliveroo. All rights reserved.
//

import Foundation


func PSDispatchOnMainThread(_ block: @escaping ()->())
{
    if Thread.isMainThread {
        block()
    }
    else {
        DispatchQueue.main.async(execute: block)
    }
}
