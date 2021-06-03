//
//  Mono.swift
//  Mono Test
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation
import UIKit

let Mono = MonoController()

public class MonoController {

    var widget: UIViewController?

    init(){

    }

    public func create(configuration: MonoConfiguration) -> UIViewController {

        let widget = MonoWidget(configuration: configuration)

        return widget

    }

}
