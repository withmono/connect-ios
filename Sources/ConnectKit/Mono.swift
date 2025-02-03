//
//  Mono.swift
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation
import UIKit

public class Mono {

    init() {}

    public static func create(configuration: MonoConfiguration)
        -> UIViewController
    {
        let flagError = configuration.accountId != nil

        if flagError {
            print(
                "You cannot pass an accountId: String to the default create function, use Mono.reauthorise() instead."
            )
        }

        let widget = MonoWidget(configuration: configuration)

        return widget
    }

    public static func reauthorise(configuration: MonoConfiguration)
        -> UIViewController
    {
        let flagError = configuration.accountId == nil

        if flagError {
            print(
                "Reauthorisation requires you to pass an accountId: String to the configuration object."
            )
        }

        let widget = MonoWidget(configuration: configuration)

        return widget
    }

}
