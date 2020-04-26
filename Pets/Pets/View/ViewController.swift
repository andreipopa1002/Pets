import UIKit

final class ViewController: UIViewController {
    var presenter: PetsPresenter?

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var viewModels = [PetViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ViewController: PetsPresenterOutput {
    func show(viewModels: [PetViewModel]) {
        self.viewModels = viewModels
        self.tableView.reloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.search(breed: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as? PetTableViewCell else {
            return UITableViewCell()
        }

        cell.setup(withViewModel: viewModels[indexPath.row])
        return cell
    }
}
