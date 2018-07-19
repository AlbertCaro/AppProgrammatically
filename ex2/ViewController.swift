//
//  ViewController.swift
//  ex2
//
//  Created by alumno on 19/07/18.
//  Copyright © 2018 CUValles. All rights reserved.
//

import UIKit
import Vision
import ImageIO


class UDGViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let text: UILabel = {
        var label = UILabel()
        label.text = "Hola CUValles"
        label.font = UIFont(name: "Arial", size: 40.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let button: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Detectar rostros", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        return button
    }()

    let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "unknow")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20.0
        image.clipsToBounds = true
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pickImage))
        view.backgroundColor = UIColor.white

        view.addSubview(text)
        view.addSubview(button)
        view.addSubview(image)

        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        text.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 8).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: text.topAnchor, constant: -20).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.image.image = selectedImage
            dismiss(animated: true)
        }

    }

    override func viewWillAppear(_ animated: Bool) {

    }

    @objc func clicked() {
        print("Click")
    }

    @objc func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

}
