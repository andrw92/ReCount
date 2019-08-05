//
//  CounterListViewController.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/2/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import UIKit

class CounterListViewController: UIViewController, UISearchBarDelegate, CounterListDisplayLogic, UIPopoverPresentationControllerDelegate, SortDelegate, UISearchResultsUpdating, CounterUpdateCountDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var averageCountLb: UILabel!
    @IBOutlet weak var totalCountLb: UILabel!
    @IBOutlet weak var stadisticsHolder: UIView!
    @IBOutlet weak var stadisticsHeight: NSLayoutConstraint!
    
    private var router: CounterListRoutingLogic?
    private var interactor: (CounterListActions & CounterListBusinessLogic)?
    private let searchController = UISearchController.init(searchResultsController: nil)
    private var shouldReloadCounters = false
    
    private var viewModel: CounterListViewModel?{
        didSet{
            DispatchQueue.main.async { self.updateView() }
        }
    }

    var selectedSortOption: SortOptionsForCounterList?
    var isSearching: Bool{
        return searchController.isActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interactor?.loadCounters()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(!isEditing, animated: true)
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    
    //MARK: - Setup methods
    func setup(){
        let counterListLoader = RemoteCounterListLoader.init(client: URLSessionHTTPClient())
        let presenter = CounterListPresenter.init(viewController: self)
        interactor = CounterListInteractor.init(loader: counterListLoader, presenter: presenter)
        router = CounterListRouter.init(viewController: self)
        setupSearchBar()
        setupTableView()
    }
    
    func setupSearchBar(){
        definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func setupTableView(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.delaysContentTouches = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 62
    }
    
    func updateView(){
        tableView.reloadData()
        let counterListSize = viewModel?.counterList.count ?? 0
        toggleStadistics(isHidden: counterListSize <= 0 || isSearching)
        tableView.updateBackgroundView(animated: true, newBackground: getTableViewBackground())
        tableView.setFooterViewWithMessage(viewModel?.messageForFooter ?? "")
        totalCountLb.text = viewModel?.countTotal
        averageCountLb.text = viewModel?.countAverage
    }
    
    //MARK: - DisplayLogic
    func displayCounters(with viewModel: CounterListViewModel?) {
        self.viewModel = viewModel
    }
    
    func displayError(error viewModel: ErrorViewModel) {
        DispatchQueue.main.async {
            self.updateView()
            self.router?.presentErrorAlert(title: viewModel.title, message: viewModel.message)
        }
    }
    
    func displayLoadingStatus(isLoading: Bool) {
        DispatchQueue.main.async { self.presentLoader(isLoading: isLoading) }
    }
    
    //MARK: - Counter CRUD actions
    func createCounter(title: String){
        interactor?.createCounter(title: title)
    }
    
    func confirmDeleteCounter(counter: Counter){
        router?.presentDeleteCounterConfirmation(counter: counter, confirmedAction: { [weak self] in
            self?.interactor?.deleteCounter(id: counter.id)
        })
    }
    
    func increment(from cell: UITableViewCell) {
        if let idxPath = tableView.indexPath(for: cell), let counterId = viewModel?.counterList[idxPath.row]{
            interactor?.incrementCounter(id: counterId.id)
        }
    }
    
    func decrement(from cell: UITableViewCell) {
        if let idxPath = tableView.indexPath(for: cell), let counterId = viewModel?.counterList[idxPath.row]{
            interactor?.decrementCounter(id: counterId.id)
        }
    }
    
    //MARK: - Counter utils actions
    func selectedSortOption(_ option: SortOptionsForCounterList) {
        tableView.contentOffset = .zero
        interactor?.sortCounters(sortOption: option)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text{
            interactor?.filterCounters(filterQuery: query)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toggleStadistics(isHidden: viewModel?.counterList.count ?? 0 <= 0)
        interactor?.endFiltering()
    }
    //MARK: - Popover Boilerplate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK: - Views utils
    private func toggleStadistics(isHidden: Bool){
        let newHeigth: CGFloat = isHidden ? 1.0 : 96.0
        stadisticsHeight.constant = newHeigth
        let toAlpha: CGFloat = isHidden ? 0.0 : 1.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.stadisticsHolder.subviews.forEach({ $0.alpha = toAlpha })
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func getTableViewBackground()->EmptyBackgroundView?{
        guard let counterList = viewModel?.counterList else { return nil }
        if counterList.count > 0 || isSearching{
            return nil
        }
        return EmptyBackgroundView.init(title: "No counters", info: "Tap (+) button to add some counters")
    }
    
    //MARK: - Buttons Actions
    @IBAction func addCounterAction(_ sender: Any) {
        router?.presentAddCounterAlert()
    }
    
    @IBAction func showSortOptionsAction(_ sender: Any) {
        router?.presentSortPopOver(sender)
    }
}
// MARK: - UITableViewDataSource
extension CounterListViewController: UITableViewDataSource, UITableViewDelegate{
    //Esperamos a que el user termine de hacer el pull de la tabla para comenzar a recargar la lista porque hay un tiempo de desfase en la animación del pull to refresh por defecto de iOS, por eso no se recarga directamente en el metodo `refreshTable()`
    @objc func refreshTable(_ sender: UIRefreshControl){
        sender.endRefreshing()
        shouldReloadCounters = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == tableView else { return }
        if shouldReloadCounters{
            interactor?.loadCounters()
            shouldReloadCounters = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.counterList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard viewModel != nil else { return }
        guard let counterToMove = viewModel?.counterList[sourceIndexPath.row] else{ return }
        viewModel!.counterList.remove(at: sourceIndexPath.row)
        viewModel!.counterList.insert(counterToMove, at: destinationIndexPath.row)
        interactor?.updateCounterList(newList: viewModel!.counterList)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let counterToDelete = viewModel?.counterList[indexPath.row]{
            confirmDeleteCounter(counter: counterToDelete)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CounterTableViewCell.storyboardIdentifier, for: indexPath)
        if let cell = cell as? CounterTableViewCell, let counter = viewModel?.counterList[indexPath.row]{
            cell.updateInfo(counter: counter)
            cell.delegate = self
        }
        return cell
    }
}

