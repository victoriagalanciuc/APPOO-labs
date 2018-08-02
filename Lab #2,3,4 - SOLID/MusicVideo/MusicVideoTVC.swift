//
//  MusicVideoTVC.swift
//  MusicVideo
//
//  Created by Victoria on 7/10/18.
//  Copyright © 2018 Victoria. All rights reserved.
//


import UIKit

class MusicVideoTVC: UITableViewController {

    var videos = [Video]()
    
    var filterSearch = [Video]()
    
    let resultSearchController = UISearchController(searchResultsController: nil)
    
    
    var limit = 10
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if swift(>=2.2)
            
        NotificationCenter.default.addObserver(self, selector: #selector(MusicVideoTVC.reachabilityStatusChanged), name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(MusicVideoTVC.preferredFontChange), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
            
        #else
            
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferredFontChange", name: UIContentSizeCategoryDidChangeNotification, object: nil)
            
        #endif
        
       
        
        
        reachabilityStatusChanged()
        
    }
    
    func preferredFontChange() {
        
        print("The preferred Font has changed")
    }
    
    
    func didLoadData(videos: [Video]) {
        
        print("reachability status: ", reachabilityStatus)
        
        self.videos = videos
        
//        for item in videos {
//            print("name = \(item.vName)")
//        }
        
        for (index, item) in videos.enumerated() {
            print("\(index) name = \(item.vName)")
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        
        title = ("The iTunes Top \(limit) Music Videos")
        
        // Setup the Search Controller
        
        resultSearchController.searchResultsUpdater = self
        
        definesPresentationContext = true
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        
        resultSearchController.searchBar.placeholder = "Search for Artist, Name, Rank"
        
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        // add the search bar to your tableview
        tableView.tableHeaderView = resultSearchController.searchBar

        
        
        
        
        tableView.reloadData()
        
        //        for i in 0..<videos.count {
        //            let video = videos[i]
        //            print("\(i) name = \(video.vName)")
        //        }
        
        //        for var i = 0; i < videos.count; i++ {
        //            let video = videos[i]
        //            print("\(i) name = \(video.vName)")
        //        }
        
    }
    
    func reachabilityStatusChanged()
    {
        
        switch reachabilityStatus {
        case NOACCESS :
            //view.backgroundColor = UIColor.redColor()
            // move back to Main Queue
            DispatchQueue.main.async() {
                let alert = UIAlertController(title: "No Internet Access", message: "Please make sure you are connected to the Internet", preferredStyle: .alert)
            
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
                action -> () in
                print("Cancel")
            }
            
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
                action -> () in
                print("delete")
            }
                let okAction = UIAlertAction(title: "ok", style: .default) { action -> Void in
                print("Ok")
                
                //do something if you want
                //alert.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            
                self.present(alert, animated: true, completion: nil)
            }
            
        default:
            //view.backgroundColor = UIColor.greenColor()
            if videos.count > 0 {
                print("do not refresh API")
            } else {
                runAPI()    
                
            }
            
        }

            
            
        
        
    }
    
    func getAPICount() {
    
        if (UserDefaults.standard.object(forKey: "APICNT") != nil)
    {
        let theValue = UserDefaults.standard.object(forKey: "APICNT") as! Int
    limit = theValue
    }
     
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        let refreshDte = formatter.string(from: NSDate() as Date)
        
        refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDte)")
        
        
        

    }
    
    
    
    @IBAction func refresh(_ sender: Any) {
        refreshControl?.endRefreshing()
        if resultSearchController.isActive {
             refreshControl?.attributedTitle = NSAttributedString(string: "No refresh allowed in search")
        } else {
           runAPI()
        }
        
        
        
        
    }
    
    func runAPI() {
        
        getAPICount()
        
        
        //Call API
        let api = APIManager()
        api.loadData(urlString: "https://itunes.apple.com/us/rss/topmusicvideos/limit=\(limit)/json", completion: didLoadData)
        
    }
    
    // Is called just as the object is about to be deallocated
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReachStatusChanged"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return filterSearch.count
        }
        return videos.count
    }

    
    private struct musicVideoStoryboard {
        static let cellReuseIdentifier = "cell"
        static let segueIdentifier = "musicDetail"
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: musicVideoStoryboard.cellReuseIdentifier, for: indexPath) as! MusicVideoTableViewCell
        
        

        if resultSearchController.isActive {
            cell.video = filterSearch[indexPath.row]
        } else {
            cell.video = videos[indexPath.row]

        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == musicVideoStoryboard.segueIdentifier
        {
            if let indexpath = tableView.indexPathForSelectedRow {
                print(indexpath)
                let video: Video
                
                if resultSearchController.isActive {
                    video = filterSearch[indexpath.row]
                    
                } else {
                    print("videooo")
                    video = videos[indexpath.row]
                }
                
                let dvc = segue.destination as! MusicVideoDetailVC
                dvc.videos = video
                
            }
            
        }
    }

//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        searchController.searchBar.text!.lowercaseString
//        filterSearch(searchController.searchBar.text!)
//    }
    
    
    func filterSearch(searchText: String) {
        filterSearch = videos.filter { videos in
            return
                videos.vArtist.lowercased().contains(searchText.lowercased()) || videos.vName.lowercased().contains(searchText.lowercased()) || "\(videos.vRank)".lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}

//extension MusicVideoTVC: UISearchResultsUpdating {
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        searchController.searchBar.text!.lowercaseString
//        filterSearch(searchController.searchBar.text!)
//    }
//}


