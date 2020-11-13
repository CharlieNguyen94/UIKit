//
//  ViewController.swift
//  FavouriteEvents
//
//  Created by Charlie Nguyen on 02/11/2020.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var page = 0
    var container: NSPersistentContainer!
    
    
    private var paginations: Pagination?
    private var items = [Item]()
    private let eventURL = "https://us-central1-techtaskapi.cloudfunctions.net/events"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getEvents()
        getPaginatedData(page: page)
        UserDefaults.standard.bool(forKey: "eventFav")
        
        container = NSPersistentContainer(name: "FavouriteEvents")

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
        
        performSelector(inBackground: #selector(getEvents), with: nil)
        
    }
    
    // MARK: - Core Data
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    func configure(event: Event, usingJSON json: JSON) {
        event.title = json["title"].stringValue
        event.image = json["image"].stringValue
        
        let formatter = ISO8601DateFormatter()
        event.date = formatter.date(from: json["startDate"].stringValue) ?? Date()
    }
    
    // MARK - : Functions
    
    @objc func getEvents() {
        guard let url = URL(string: eventURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            
            // Parse JSON data
            if let data = data {
                self.items = self.parseJsonData(data: data)
                
                
                // Reload table view
                OperationQueue.main.addOperation ({
                    self.tableView.reloadData()
                })
                
                self.saveContext()
            }
        })
        task.resume()
    }
    
    func parseJsonData(data: Data) -> [Item] {
        
        var items = [Item]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            // Parse JSON Data
            let jsonItems = jsonResult?["items"] as! [AnyObject]
            for jsonItem in jsonItems {
                var item = Item()
                
                item.title = jsonItem["title"] as! String
                item.image = jsonItem["image"] as! String
                
                
                item.startDate = jsonItem["startDate"] as! Int
                
                
                items.append(item)
                
            }
        } catch {
            print(error)
        }
        
        print("Parsed JSON data successfully!")
        return items
        
    }
    
    
    func getPaginatedData(page: Int) {
        
        var urlComponents = URLComponents(string: eventURL)
        
        let queryPages = URLQueryItem(name: "page", value: String(page))
        
        
        urlComponents?.queryItems = [queryPages]
        
        guard let url = urlComponents?.url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                self.paginations = try JSONDecoder().decode(Pagination.self, from: data)
                DispatchQueue.main.async { [self] in
                    self.tableView.reloadData()
                    print(response!)
                }
            } catch {
                print(error)
            }
        } .resume()
    }
    
    
    // MARK: - TableView & Scroll View Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        cell.selectionStyle = .none
        
        
        cell.eventNameLabel.text = items[indexPath.row].title
        
        // Date formatting
        let timeInterval = TimeInterval(items[indexPath.row].startDate)
        let myDate = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let strDate = dateFormatter.string(from: myDate)
        
        cell.startDateLabel.text = "\(strDate)"
        
        // Image for eventImageView
        if let imageURL = URL(string: items[indexPath.row].image) {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: imageURL) else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.eventImageView.image = image
                }
            }
        }
        
        return cell
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height {
            page += 1
            getPaginatedData(page: page)
        }
    }
    
    
    
}

