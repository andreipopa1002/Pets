import UIKit

final class PetsViewController: UIViewController {
    var presenter: PetsPresenter?

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: UIView!
    private var viewModels = [PetViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.isHidden = true
    }
}

extension PetsViewController: PetsPresenterOutput {
    func startLoading() {
        loadingView.isHidden = false
    }

    func stopLoading() {
        loadingView.isHidden = true
    }

    func show(viewModels: [PetViewModel]) {
        self.viewModels = viewModels
        self.tableView.reloadData()
    }
}

extension PetsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.search(breed: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

extension PetsViewController: UITableViewDataSource {
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
