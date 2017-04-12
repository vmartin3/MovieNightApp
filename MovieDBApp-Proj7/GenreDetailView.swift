
import UIKit
var personOne = PersonOne()
var personTwo = PersonTwo()
var vc = ViewController()
class GenreDetailView: UITableViewController {
    
    @IBOutlet weak var topRightNavButton: UIBarButtonItem!
    let cellReuseIdentifier = "genreCell"
    var homePage = ViewController()
    @IBOutlet var genreTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert()
        genreTableView.delegate = self
        genreTableView.dataSource = self
        self.genreTableView.allowsMultipleSelection = true
        setupView()
    }
    
    func setupView(){
        if allSelectionsComplete {
            topRightNavButton.title = "Done"
            self.navigationItem.title = "Movie Titles"
        } else {
            self.navigationItem.title = "Select Genres"
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Hey There!", message: "Please select a 3 of your favorite movie genres! Your input will be used to curate a custom list of movies you might like!", preferredStyle: UIAlertControllerStyle.Alert)
        if personOne.completedSelections == true && personTwo.completedSelections == false {
            alert.title = "Hey There!"
            alert.message = "Please select 2 of your favorite movie genres! Your input will be used to curate a custom list of movies you might like!"
        } else if allSelectionsComplete == true && finalResultsJson[0]["total_results"] as? Int == 0{
            alert.title = "Oops!"
            alert.message = "We didn't find any movie results with those genre combinations, please try again!"
        }
        else if allSelectionsComplete == true {
            alert.title = "All Set!"
            alert.message = "Below are a list of movies you and your friend might enjoy!"
        }
        else {
            alert.title = "Now It's Your Turn"
            alert.message = "Your friend just shared their inputs, now we need your 2. We'll take if from there!"
        }
        alert.addAction(UIAlertAction(title: "Got It!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allSelectionsComplete == true {
            return (finalResultsJson[0]["results"]?.count)!
        } else {
            return (allCachedJsonData[0]["genres"]?.count)!
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        if cell.selected {
            cell.accessoryType = .Checkmark
        }
        cell.selectionStyle = .None
        if allSelectionsComplete == true {
            cell.textLabel?.text = (finalResultsJson[0]["results"]![indexPath.row]?["title"] as? String);
        }else {
            cell.textLabel?.text = (allCachedJsonData[0]["genres"]![indexPath.row]?["name"] as? String);
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let maxSelections = 2
        if tableView.indexPathsForSelectedRows?.count > maxSelections || allSelectionsComplete == true {
             tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        }
        else {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            personOne.selectedOptions.append((allCachedJsonData[0]["genres"]?[indexPath.row] as? [String : AnyObject])!)
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
    }
    
}
