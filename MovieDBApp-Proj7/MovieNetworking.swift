
import Foundation
import UIKit

//Holds JSON Data Retrieved from API Calls
var jsonData = [String:AnyObject]()
//Holds the genre Selections and their details
var allCachedJsonData = [[String:AnyObject]]()
//Holds the final movie list and their detials
var finalResultsJson = [[String:AnyObject]]()

class MovieNetworking {
    
    //Fetches api data from url string that is passed in
    func fetchData(endpoint: String){
        guard let url:NSURL = NSURL(string: endpoint) else {
            print("Not able to create URL")
            return
        }
        let request: NSURLRequest = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { (data, response, error) in
            //Check for errors
            guard error == nil else {
                print("Error calling getting data: \(error)")
                return
            }
            //Making sure we get some data from the api
            guard let resposneData = data else {
                print("Error did not recieve data")
                return
            }
            //Converting data into JSON
            dispatch_async(dispatch_get_main_queue()) {
                do{
                    jsonData = try NSJSONSerialization.JSONObjectWithData(resposneData, options: []) as! [String:AnyObject]
                    //If both users selected their genres then add the movie data that matches both their genre inputs into this array if not then add json results into the array holding their genre selections
                    if allSelectionsComplete == true {
                        finalResultsJson.append(jsonData)
                        //print(finalResultsJson.description)
                    } else {
                        allCachedJsonData.append(jsonData)
                    }
                }catch {
                    print("Error converting to JSON")
                    return
                }
            }
        }
        task.resume()
    }
    
}
