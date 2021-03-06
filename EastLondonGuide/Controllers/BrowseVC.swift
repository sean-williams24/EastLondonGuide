//
//  BrowseVC.swift
//  EastLondonGuide
//
//  Created by Sean Williams on 26/09/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class BrowseVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets

    @IBOutlet var areaMenu: UIView!
    @IBOutlet var centerPopupConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundButton: UIButton!
    @IBOutlet var categorySelector: UISegmentedControl!
    @IBOutlet var showFavouritesButton: UIBarButtonItem!
    
    
    // MARK: - Properties

    let allVenuesViewModel = AllVenuesViewModel()
    var venueViewModels = [VenueViewModel]()
    var chosenVenue: VenueViewModel!
    var filteredByArea = false
    var alreadyFilteredByCategory = false
    var alreadyFilteredVenues = [VenueViewModel]()
    
    
    //MARK: - Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        venueViewModels = allVenuesViewModel.allVenueViewModels
        areaMenu.layer.cornerRadius = 10
        areaMenu.layer.masksToBounds = true
        setSegmentedControlAttributes(control: categorySelector)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if FavouritesModel.favourites.count == 0 {
            showFavouritesButton.isEnabled = false
            FavouritesModel.viewingFavourites = false
            venueViewModels = allVenuesViewModel.allVenueViewModels
            tableView.reloadData()
        }

        if FavouritesModel.viewingFavourites == true {
            showFavouritesButton.isEnabled = false
        } else if FavouritesModel.viewingFavourites == false && FavouritesModel.favourites.count > 0 {
            showFavouritesButton.isEnabled = true
        }

        if FavouritesModel.favouriteRemoved == true && FavouritesModel.viewingFavourites == true {
            showFavouritesButton.isEnabled = false
            venueViewModels = FavouritesModel.favourites
            animateTableviewReload(tableView: self.tableView, transitionType: .fromBottom)
        } else if FavouritesModel.favouriteRemoved == true && FavouritesModel.viewingFavourites == false {
            venueViewModels = allVenuesViewModel.allVenueViewModels
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FavouritesModel.favouriteRemoved = false
    }
    

    // MARK: - Helper Methods
    
    fileprivate func filterLocation(for venueArea: String) {
        if !alreadyFilteredByCategory {
            venueViewModels = allVenuesViewModel.allVenueViewModels.filter() {$0.area == venueArea}
            animateTableviewReload(tableView: self.tableView, transitionType: .fromBottom)
        } else {
            venueViewModels = alreadyFilteredVenues.filter() {$0.area == venueArea}
            filteredByArea = true
            animateTableviewReload(tableView: self.tableView, transitionType: .fromBottom)
        }
    }
    
    func filterCategory(for category: String) {
        alreadyFilteredByCategory = true
        venueViewModels = []
        alreadyFilteredVenues = []
        
        for venue in allVenuesViewModel.allVenueViewModels {
            if venue.category == category {
                venueViewModels.append(venue)
                alreadyFilteredVenues.append(venue)
            }
        }
        animateTableviewReload(tableView: self.tableView, transitionType: .fromBottom)
    }
    
    
     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let vc = segue.destination as! VenueDetailsVC
         vc.venueViewModel = chosenVenue
     }
     
    
    // MARK: - Action Methods
    
    @IBAction func areaButtonTapped(_ sender: Any) {
        centerPopupConstraint.constant = 0
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundButton.alpha = 0.6
        }
    }
    
    @IBAction func areaSelected(_ sender: UIButton) {
        showFavouritesButton.isEnabled = true
        centerPopupConstraint.constant = 1200
        
        UIView.animate(withDuration: 0.4, delay: 0.5, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
                        
            if sender.tag == 0 {
                self.filterLocation(for: self.allVenuesViewModel.shoreditch)
            } else if sender.tag == 1 {
                self.filterLocation(for: self.allVenuesViewModel.bethnalGreen)
            } else if sender.tag == 2 {
                self.filterLocation(for: self.allVenuesViewModel.londonFields)
            } else if sender.tag == 3 {
                self.filterLocation(for: self.allVenuesViewModel.hackney)
            }  else if sender.tag == 4 {
                self.filterLocation(for: self.allVenuesViewModel.bow)
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.backgroundButton.alpha = 0
        }
    }
    
    @IBAction func categorySelection(_ sender: Any) {
        
        switch categorySelector.selectedSegmentIndex {
        case 0:
            venueViewModels = allVenuesViewModel.allVenueViewModels
            animateTableviewReload(tableView: self.tableView, transitionType: .fromBottom)
        case 1:
            filterCategory(for: "Food")
        case 2:
            filterCategory(for: "Drinks")
        case 3:
            filterCategory(for: "Coffee")
        case 4:
            filterCategory(for: "Shopping")
        case 5:
            filterCategory(for: "Markets")
        default:
            print("No Selection")
        }
    }
    
    @IBAction func showFavourites(_ sender: Any) {
        FavouritesModel.viewingFavourites = !FavouritesModel.viewingFavourites
        venueViewModels = FavouritesModel.favourites

        if FavouritesModel.viewingFavourites {
            showFavouritesButton.isEnabled = false
        } else {
            showFavouritesButton.isEnabled = true
        }
        animateTableviewReload(tableView: self.tableView, transitionType: .fromBottom)
    }
    

    @IBAction func resetToAllVenues(_ sender: Any) {
        alreadyFilteredByCategory = false
        filteredByArea = false
        venueViewModels = allVenuesViewModel.allVenueViewModels
        FavouritesModel.viewingFavourites = false

        if FavouritesModel.favourites.count > 0 {
            showFavouritesButton.isEnabled = true
        }
        animateTableviewReload(tableView: self.tableView, transitionType: .fromBottom)
        categorySelector.selectedSegmentIndex = 0
    }
    
    
    // MARK: - TableView delegates & data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseCell", for: indexPath) as! BrowseCell
        let venueViewModel = venueViewModels[indexPath.row]
        
        cell.venueViewModel = venueViewModel

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenVenue = venueViewModels[indexPath.row]
        performSegue(withIdentifier: "VenueDetails2", sender: self)
    }
}
