//
//  Mono.swift
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation
import UIKit

public class Mono {

    init(){ }

    public static func create(configuration: MonoConfiguration) -> UIViewController {

        let widget = MonoWidget(configuration: configuration)

        return widget

    }

}
