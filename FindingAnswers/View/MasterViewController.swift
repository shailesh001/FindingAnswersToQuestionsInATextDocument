/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Table view controller that manages content for the master table view.
*/

import UIKit

class MasterViewController: UITableViewController {
    //static private let exampleText = "The quick brown fox jumps over the lethargic dog."
    static private let exampleText =
    """
    The Moon is Earth's only proper natural satellite. It is one quarter the diameter of Earth (comparable to the width of Australia[13]) making it the largest natural satellite in the Solar System relative to the size of its planet. It is the fifth largest satellite in the Solar System and is larger than any dwarf planet. The Moon orbits Earth at an average lunar distance of 384,400 km (238,900 mi),[14] or 1.28 light-seconds. Its gravitational influence produces Earth's tides and slightly lengthens Earth's day. It is considered a planetary-mass moon and a differentiated rocky body; its surface gravity is about one-sixth of Earth's (0.1654 g) and it lacks any significant atmosphere, hydrosphere, or magnetic field. Jupiter's moon Io is the only satellite in the Solar System known to have a higher surface gravity and density.

    The Moon's orbit around Earth has a sidereal period of 27.3 days, and a synodic period of 29.5 days. The synodic period drives its lunar phases, which form the basis for the months of a lunar calendar. The Moon is tidally locked to Earth, which means that the length of a full rotation of the Moon on its own axis (a lunar day) is the same as the synodic period, resulting in its same side (the near side) always facing Earth. That said, 59% of the total lunar surface can be seen from Earth through shifts in perspective (its libration).[15]
    """
    
    var detailViewController: DetailViewController?
    var objects: [Document] = [
        Document(title: "From the Earth to the Moon", body: MasterViewController.exampleText)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        if let split = splitViewController {
            detailViewController = split.viewControllers.last as? DetailViewController
        }
        // Select the first row to show the example.
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(Document(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues
    
    @IBSegueAction func makeDetailViewController(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> UINavigationController? {
        guard let navigationController = UINavigationController(coder: coder) else {
            print("Unable to create UINavigationController")
            return nil
        }
        
        guard let indexPath = tableView.indexPathForSelectedRow else {
            print("Unable to determine the selected row")
            return nil
        }
        
        guard let detailController = navigationController.topViewController as? DetailViewController else {
            print("The UINavigationController's topViewController is not a DetailViewController")
            return nil
        }
        
        detailController.detailItem = objects[indexPath.row]
        detailController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        detailController.navigationItem.leftItemsSupplementBackButton = true
        
        return navigationController
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.title
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
