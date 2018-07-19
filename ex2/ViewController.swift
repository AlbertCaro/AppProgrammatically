//
//  ViewController.swift
//  ex2
//
//  Created by alumno on 19/07/18.
//  Copyright © 2018 CUValles. All rights reserved.
//

import UIKit


class UDGViewController: UIViewController {

    let text: UILabel = {
        var label = UILabel()
        label.text = "Hola CUValles"
        label.font = UIFont(name: "Arial", size: 40.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let button: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Click", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        view.addSubview(text)
        view.addSubview(button)

        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 8).isActive = true
    }


}
