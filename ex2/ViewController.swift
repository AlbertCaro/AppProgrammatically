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
        label.font = UIFont(name: "Arial", size: 30.0)
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
        image.layer.cornerRadius = 15.0
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

    override func viewWillAppear(_ animated: Bool) {

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.image.image = selectedImage
            dismiss(animated: true)
        }

    }

    func handleFaces(resquest: VNRequest, error: Error?) {
        guard let observations = resquest.results as? [VNFaceObservation] else {
            print("Resultado inesperado.")
            return
        }

        DispatchQueue.main.async {
            self.handleFaces(observations: observations)
        }
    }

    func handleFaces(observations: [VNFaceObservation]) {
        text.text = "Hay \(observations.count) rostro(s)."

        for face in observations {
            let boxOne = face.boundingBox
            let boxTwo = image.bounds

            let width = boxOne.size.width * boxTwo.width
            let height = boxOne.size.height * boxTwo.height

            let x = boxOne.origin.x * boxTwo.width
            let y = abs((boxOne.origin.y * boxTwo.height) - boxTwo.height) - height

            let subView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))

            subView.layer.borderColor = UIColor.red.cgColor
            subView.layer.borderWidth = 2.0
            subView.tag = 8
            image.addSubview(subView)
        }
    }

    func handlePlaces(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation] else {
            print("Error inesperado para VNCoreMLRequest")
            return
        }

        guard let bestResult = observations.first else {
            print("No hay clasificación válida")
            return
        }

        DispatchQueue.main.async {
            self.text.text = "\(bestResult.identifier) - \(bestResult.confidence)"
        }
    }

    func deleteRectangles () {
        if let foundView = view.viewWithTag(8) {
            foundView.removeFromSuperview()
            deleteRectangles()
        } else {
            return
        }
    }

    @objc func clicked() {
        let leNetPlaces = GoogLeNetPlaces()
        var test: VNRequest!

        if let model = try? VNCoreMLModel(for: leNetPlaces.model) {
            let mlRequest = VNCoreMLRequest(model: model, completionHandler: handlePlaces)
            test = mlRequest
        }

        // Paso 1
        guard let cgImage = image.image?.cgImage else {
            return
        }
        // Paso 2
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.image!.imageOrientation.rawValue))

        // Paso 3
        let faceRequest = VNDetectFaceRectanglesRequest(completionHandler: handleFaces)
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation!)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([faceRequest, test])
            } catch {
                print("Error de manejo de visión.")
            }
        }
    }

    @objc func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        deleteRectangles()
        /*
        var existRectangles = true
        while existRectangles {
            if let foundView = view.viewWithTag(8) {
                foundView.removeFromSuperview()
            } else {
                existRectangles = false
            }
        }
        */
    }

}
