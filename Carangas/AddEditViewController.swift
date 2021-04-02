//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Car!

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if car != nil {
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = String(car.price)
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar Carro", for: .normal)

        }
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {

        if car == nil {
            car = Car(id: nil)
        }
        
        car.name = tfName.text!
        car.brand = tfBrand.text!
        car.price = Double(tfPrice.text ?? "")!
        car.gasType = scGasType.selectedSegmentIndex
        
        
        if car.id == nil {
            ApiCars.saveCar(car: car) { (sucess) in
                self.goBack()
            }
        } else {
            ApiCars.updateCar(car: car) { (success) in
                self.goBack()
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
