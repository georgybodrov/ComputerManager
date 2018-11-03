//
//  ViewController.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 25.09.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import UIKit

class CurrentComputerVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelNameCompanyCurrentComputer: UILabel!
    @IBOutlet weak var labelIntroducedCurrentComputer: UILabel!
    @IBOutlet weak var labelDescriptionCurrentComputer: UILabel!
    @IBOutlet weak var imageCurrentComputer: UIImageView!
    @IBOutlet weak var firstButtonSimilarComputer: UIButton!
    @IBOutlet weak var secondButtonSimilarComputer: UIButton!
    @IBOutlet weak var thirdButtonSimilarComputer: UIButton!
    
    var computerId = 1
    var companyName = ""
    private var arraySimilarComputer = [SimilarComputer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        print("--------------------")
        print(computerId)
        print("--------------------")
        fetchCurrentComputer(forId: computerId)
        fetchSimilarComputer(forId: computerId)
    }
    
    func fetchCurrentComputer(forId id: Int) {
        APIComputerManager().fetchCurrentComputerWith(computerID: ComputerID(id: id)) { (result) in
            switch result {
            case .Success(let currentComputer):
                self.updateUIWith(currentComputer: currentComputer)
            case .Failure(let error as NSError):
                let alertController = AlertManager()
                let alertControllerForCurrentComputer = alertController.creatAlert(title: "Unable to get data", error: error)
                self.present(alertControllerForCurrentComputer, animated: true, completion: nil)
                
            default: break
            }
        }
    }
    
    func creatAlert(title: String, error: NSError) -> UIAlertController {
        
        
        let alertController = UIAlertController(title: title, message: "\(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        return alertController
    }
    
    //MARK: Parsing SimilarComputer - start
    
    private func fetchSimilarComputer(forId id: Int) {
        
        guard let url = URL(string: "http://testwork.nsd.naumen.ru/rest/computers/\(id)/similar") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                self.arraySimilarComputer = try JSONDecoder().decode([SimilarComputer].self, from: data)
                print(self.arraySimilarComputer)
                
                DispatchQueue.main.async {
                    // TODO: Show similar computers
                    self.updateSimilarComputersButton(withComputers: self.arraySimilarComputer)
                }
            } catch let error {
                print("Error serialization json", error)
            }
            
            }.resume()
    }
    
    func updateSimilarComputersButton(withComputers computers: [SimilarComputer]) {
        let number = computers.count
        
        if number >= 1 {
            firstButtonSimilarComputer.setTitle(computers[0].name, for: .normal)
            firstButtonSimilarComputer.isEnabled = true
        } else {
            firstButtonSimilarComputer.setTitle("", for: .normal)
            firstButtonSimilarComputer.isEnabled = false
        }
        
        if number >= 2 {
            secondButtonSimilarComputer.setTitle(computers[1].name, for: .normal)
            secondButtonSimilarComputer.isEnabled = true
        } else {
            secondButtonSimilarComputer.setTitle("", for: .normal)
            secondButtonSimilarComputer.isEnabled = false
        }
        
        if number >= 3 {
            thirdButtonSimilarComputer.setTitle(computers[2].name, for: .normal)
            thirdButtonSimilarComputer.isEnabled = true
        } else {
            thirdButtonSimilarComputer.setTitle("", for: .normal)
            thirdButtonSimilarComputer.isEnabled = false
        }
    }
    //MARK: Download img from URL
    
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageCurrentComputer.image = UIImage(data: data)
            }
        }
    }
    //MARK: Download img from URL - end
    
    func updateUIWith(currentComputer: CurrentComputer) {
        DispatchQueue.main.async {
            self.labelNameCompanyCurrentComputer.text = currentComputer.company?.name
            self.labelIntroducedCurrentComputer.text = currentComputer.introduced
            self.labelDescriptionCurrentComputer.text = currentComputer.description
            
            //TODO: функцию для "заголовка"
            self.navigationItem.title = currentComputer.name
            if currentComputer.imageUrl != nil{
                if let url = URL(string: currentComputer.imageUrl!){
                    self.downloadImage(url: url)
                }
            }
        }
    }
    
    @IBAction func similarComputerTouched(_ sender: UIButton) {
        
        let index = sender.tag
        
        guard self.arraySimilarComputer.count > index else { return } // Количество элементов должно быть как минимум на 1 больше чем index (в массиве из 3-х элементов максимальный индекс 2)
        
        let computer = arraySimilarComputer[index]
        
        self.computerId = computer.id
        self.companyName = computer.name
        
        self.navigationItem.title = companyName
//        clearImage()
        fetchCurrentComputer(forId: computerId)
        fetchSimilarComputer(forId: computerId)
        
        DispatchQueue.main.async{
            print("Scroll to top")
            self.scrollView.setContentOffset(CGPoint.init(x: 0.0, y: 0.0), animated: true)
        }
    }
    
}

extension CurrentComputerVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //                print("Scroll view content offset = \(scrollView.contentOffset)")
    }
}

