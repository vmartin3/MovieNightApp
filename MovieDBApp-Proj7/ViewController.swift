import UIKit

var allSelectionsComplete: Bool = false

//Extension to take the id values of the genre and join them by a comma so they can be appended to the end of the URL query
extension Array {
    var joinedValues:String {
        return self.map { String($0) }.joinWithSeparator(",")
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var personOneBubble: UIButton!
    @IBOutlet weak var seeResults: UIBarButtonItem!
    @IBOutlet weak var personOneBubbleSelected: UIButton!
    @IBOutlet weak var personTwoBubble: UIButton!
    @IBOutlet weak var personTwoBubbleSelected: UIButton!
    let networkingRequest:MovieNetworking = MovieNetworking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.hidden = true
        seeResults.enabled = false
        seeResults.target = self
        seeResults.action = #selector(ViewController.seeResults(_:))
        checkTurn()
        
        //Make API call to get genre once view loads but only once, not everytime the view loads
        var token: dispatch_once_t = 0
        dispatch_once(&token) { () -> Void in
            networkingRequest.fetchData("https://api.themoviedb.org/3/genre/movie/list?api_key=a112ce13136b883dc2d339cee0885e19&language=en-US")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func personOneBubbleSelected(sender: AnyObject) {
        personOne.completedSelections = true
    }
    @IBAction func personTwoBubbleSelected(sender: AnyObject) {
        personTwo.completedSelections = true
    }
    
    //This method adds the selected genre ids into an array of their own and appends them to the movedb discover request to get movies that match both users inputs
    func seeResults(sender: AnyObject) {
        allSelectionsComplete = true
        var genreIdArray = [AnyObject]()
        var counter = 0
        for genre in personOne.selectedOptions {
            genreIdArray.append(personOne.selectedOptions[counter]["id"]!)
            counter += 1
        }
        let joinedArray = genreIdArray.joinedValues
        print(finalResultsJson.description)
        networkingRequest.fetchData("https://api.themoviedb.org/3/discover/movie?api_key=a112ce13136b883dc2d339cee0885e19&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=\(joinedArray)")
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))),
            dispatch_get_main_queue())
        {
            self.performSegueWithIdentifier("SeeResults", sender: sender)
        }
    }
    
    //Hides and unhides buttons depending on whose turn it is
    @IBOutlet weak var personTwoSelected: UIButton!
    func checkTurn(){
        if personOne.completedSelections == true {
            personOneBubble.hidden = true
            personOneBubbleSelected.hidden = false
            personOneBubbleSelected.enabled = false
        }
        if personTwo.completedSelections == true {
            personTwoBubble.hidden = true
            personTwoBubbleSelected.hidden = false
            personTwoBubbleSelected.enabled = false
        }
        if personOne.completedSelections == true && personTwo.completedSelections == true{
            seeResults.enabled = true
            print(personOne.selectedOptions.description)
        }
    }
}

