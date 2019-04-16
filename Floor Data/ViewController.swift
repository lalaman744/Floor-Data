import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var floors: [Floor] = []
    
    var managedContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate!.persistentContainer.viewContext
        refreshTable()
    }

    @IBAction func addFloor(_ sender: Any) {
        addFloor()
        refreshTable()
    }
    
    
    @IBAction func increasePrice(_ sender: Any) {
        increasePriceForSelectedFloor()
        refreshTable()
    }
    
    @IBAction func deleteFloor(_ sender: Any) {
        deleteSelectedFloor()
        refreshTable()
    }
    
    
    //function that is called by clicking add button and adds random cells for testing
    //typically cells/data would be added by user
    func addFloor() {
        
        let floor = Floor(context: managedContext!)
        
        //random values for type and price
        let price = Float((20...30).randomElement()!)
        let type = ["Carpet", "Wood", "Tile"].randomElement()
        
        floor.type = type
        floor.price = price
        
        do {
            try managedContext!.save()
        } catch {
            print("Error saving, \(error)")
        }
    }
    
    //gets data from objects
    func loadFloors() {
        
        let fetchRequest =  NSFetchRequest<Floor>(entityName: "Floor")
        
        do {
            floors = try managedContext!.fetch(fetchRequest)
        } catch {
            print("error fetching data because \(error)")
        }
    }
    
    override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorCell")!
        let floor = floors[indexPath.row]
        cell.textLabel?.text = floor.type
        cell.detailTextLabel?.text = "$\(floor.price) per square foot"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floors.count
    }
    
    
    //refreshes table data
    func refreshTable() {
        loadFloors()
        tableView.reloadData()
    }
    
    func deleteSelectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else {return}
        let row = selectedPath.row
        
        let floor = floors[row]
        
        managedContext!.delete(floor)
        
        do{
            try managedContext!.save()
        } catch {
            print("Error deleting \(error)")
        }
    }
    
    func increasePriceForSelectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else{return}
        let row = selectedPath.row
        
        let floor = floors[row]
        floor.price += 1
        
        do {
            try managedContext!.save()
        } catch {
            print("Error updating price because \(error)")
        }
    }
    
}

