//
//  DetailsViewController.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 01/08/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var presenter: DetailsViewPresenter!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        title = presenter.viewTitle
        navigationItem.largeTitleDisplayMode = .never
    }

}

extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let selectedInfo = presenter.item(at: indexPath) else { return nil }
        
        switch selectedInfo.key {
        case Person.InfoKey.phone:
            
            guard let blankPhoneURL = URL(string: "tel://"),
                UIApplication.shared.canOpenURL(blankPhoneURL) else {
                    
                    let alert = UIAlertController(title: "Device Issue", message: "This device cannot make phone calls", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    
                    present(alert, animated: true, completion: nil)
                    
                return nil
            }
            return indexPath
            
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedInfo = presenter.item(at: indexPath) else { return }
        
        switch selectedInfo.key {
        case Person.InfoKey.phone:
            
            guard let phoneURL = URL(string: selectedInfo.value) else { return }
            
            let alert = UIAlertController(title: "Make Call", message: "Are you sure you want to call \(presenter.viewTitle)", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "Make Call", style: .default) { action in
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            }
            
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            present(alert, animated: true, completion: nil)
            
        default:
            // Should handle, send email as well
            break
        }
        
    }
    
}

extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150.0
        case 1:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarImageTableViewCell", for: indexPath) as? AvatarImageTableViewCell else { fatalError("Issues here") }
            
            cell.configuire(using: presenter.favouriteColor)
            
            presenter.imageData { imageData in
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    cell.update(image)
                }
            }
            
        case 1:
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath)
            
            guard let info = presenter.item(at: indexPath) else { return cell }
            
            cell.textLabel?.text = info.key
            cell.detailTextLabel?.text = info.value
            
            return cell
            
        default: fatalError("Invalid Section")
        }
        return UITableViewCell()
    }
}

extension DetailsViewController: DetailsView {
    
}

extension DetailsViewController: NetworkingView {
    func shouldBeLoading(_ loading: Bool) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
    }
}
