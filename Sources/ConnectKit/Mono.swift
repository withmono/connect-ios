//
//  Mono.swift
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation
import UIKit

let MonoConnect = MonoController()

class MonoController {

    init(){ }

    public func create(configuration: MonoConfiguration) -> UIViewController {

        let widget = MonoWidget(configuration: configuration)

        return widget

    }

}
