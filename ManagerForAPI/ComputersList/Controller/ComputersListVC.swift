//
//  ComputersListVC.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 08.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import UIKit

class ComputersListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var pagesLabel: UILabel!
    
    // MARK: variable for search
    var searchController: UISearchController!
    var filteredResultArray: [Computer] = []
    // variable for search - end
    private let computersOnPage: Int = 10
    var currentPage: Int = 0
    var arrayComputers: [Computer] = []
    var numberOfPages: Int = 1
    
    @IBAction func close(segue: UIStoryboardSegue){
        
    }
    // MARK: functional for search
    func filterContentFor(searchText text: String) {
        filteredResultArray = arrayComputers.filter { (computers) -> Bool in
            return (computers.name.lowercased().contains(text.lowercased()))
        }
    }
    // functional for search - end
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: functional for search
        //// searchResultsController - показывает нашу выдачу поверх остальных компьютеров
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //// dimsBackgroundDuringPresentation - затемнение экрана
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        searchController.searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        definesPresentationContext = true
        // functional for search - end
        configureTableView()
        updateButtons()
        fetchComputers(forPage: currentPage)
    }
    
    
    private func fetchComputers(forPage page: Int) {
        APIComputersListManager().fetchAPIComputersListManagerWith(ComputerListID: ComputerListID(id: page)) { (result) in
            switch result {
            case .Success(let computerList):
                self.arrayComputers = computerList.items
                let pages = Double(computerList.total) / Double(self.computersOnPage)
                self.numberOfPages = Int(ceil(pages))
                
                DispatchQueue.main.async {
                    self.updateLabel()
                    self.updateButtons()
                    self.tableView.reloadData()
                }
                
            // MARK: Alert for error loading data
            case .Failure(let error as NSError):
                
                let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            default: break
            }
        }
    }
    
    // MARK: Private
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateLabel() {
        pagesLabel.text = "Page \(currentPage + 1) of \(numberOfPages)"
    }
    private func updateButtons() {
        set(button: previousButton, isEnabled: currentPage > 0)
        set(button: nextButton, isEnabled: currentPage < numberOfPages - 1)
    }
    
    
    func showDetailViewController(withId id: Int, withName name: String) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "CurrentComputerVC")
        guard let currentComputerVC = viewController as? CurrentComputerVC else { return }
    
        currentComputerVC.computerId = id
        currentComputerVC.companyName = name
        self.navigationController?.pushViewController(currentComputerVC, animated: true)
    }
    
    func set(button: UIButton, isEnabled: Bool) {
        guard button.isEnabled != isEnabled else { return }
        
        button.isEnabled = isEnabled
        UIView.animate(withDuration: 0.3) {
            button.alpha = isEnabled ? 1.0 : 0.5
        }
    }
    
    // MARK: Actions when the button is pressed
    @IBAction func previousButtonTouched(_ sender: UIButton) {
        guard currentPage > 0 else { return }
        
        currentPage -= 1
        
        updateLabel()
        fetchComputers(forPage: currentPage)
        updateButtons()
    }
    
    @IBAction func nextButtonTouched(_ sender: UIButton) {
        guard currentPage < numberOfPages - 1 else { return }
        
        currentPage += 1
        
        updateLabel()
        fetchComputers(forPage: currentPage)
        updateButtons()
    }
    // MARK: Actions when the button is pressed - end
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let addToCart = UITableViewRowAction(style: .default, title: "Добавить в корзину") { (action, indexPath) in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext{
                let computer = ComputersCoreData(context: context)
                computer.id = Int16(self.arrayComputers[indexPath.row].id)
                computer.name = self.arrayComputers[indexPath.row].name
                do {
                    try context.save()
                    print("Сохранение удалось!")
                } catch let error as NSError {
                    print("не удалось сохранить\(error)")
                }
            }
        }
        addToCart.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        return [addToCart]
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ComputersListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // MARK: functional for search
        //// #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return arrayComputers.count
        // functional for search - end
    }
    
    // MARK: functional for search
    //// Выбираем что отобржаем в таблице(все компьюетры или из поиска)
    func computersToDisplayAt(indexPath: IndexPath) -> Computer {
        let computers: Computer
        if searchController.isActive && searchController.searchBar.text != "" {
            computers = filteredResultArray[indexPath.row]
        } else {
            computers = arrayComputers[indexPath.row]
        }
        return computers
    }
    // functional for search - end
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ComputersListTVCell"
//        let computer = arrayComputers[indexPath.row]
        let computers = computersToDisplayAt(indexPath: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ComputersListTVCell else { return UITableViewCell() }
        cell.comuterName.text = computers.name
        cell.companyName.text = computers.company?.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let computer = computersToDisplayAt(indexPath: indexPath)
        print("Name+id: \(computer.name) - \(computer.id)")
        showDetailViewController(withId: computer.id, withName: computer.name)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension ComputersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}
// не позволяет прятать поисковую строку
extension ComputersListVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    func ComputersListVC(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
