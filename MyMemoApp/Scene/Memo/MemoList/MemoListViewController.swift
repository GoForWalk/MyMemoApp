//
//  MemoListViewController.swift
//  MyMemoApp
//
//  Created by sae hun chung on 2022/08/31.
//

import UIKit
import Toast
import RealmSwift

final class MemoListViewController: BaseViewController {
    
    let memoView = MemoListViewUI()
    let memoViewModel = MemoListViewModel()
    let numberFormatter = NumberFormatter()
    var tempTableType: TableType?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        self.view = memoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        memoViewModel.getAllData()
        memoView.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWalkThrough()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func configureViewController() {
        memoView.tableView.delegate = self
        memoView.tableView.dataSource = self
        memoView.tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: MemoListTableViewCell.reusableIdentifier)
    }
    
    override func setNavigationController() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppUIColor.gray.color
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: AppUIColor.white.color]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: AppUIColor.white.color]
        
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
                
        navigationController?.view.backgroundColor = AppUIColor.black.color
        
        title = "0개의 메모"
                
        self.navigationController?.navigationBar.backgroundColor = AppUIColor.gray.color
        
        self.navigationItem.searchController = searchController
        let searchBarView = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchBarView?.textColor = AppUIColor.white.color
        
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.tintColor = AppUIColor.darkYellow.color
        
    }

    private func setToolbar() {
        var barItems = [UIBarButtonItem]()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolbarItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeButtonTapped(_:)))
        
        toolbarItem.tintColor = AppUIColor.darkYellow.color
        barItems.append(flexibleSpace)
        barItems.append(toolbarItem)
        memoView.toolbar.setItems(barItems, animated: true)
    }
    
    @objc func writeButtonTapped(_ sender: UIBarButtonItem) {
        presentVC(viewController: MemoEditViewController(), transitionType: .push)
    }
    
    // MARK: bindData
    override func bindData() {
        
        memoViewModel.memoData.bind { data in
            guard let data = data else { return }

            self.numberFormatter.numberStyle  = .decimal
            self.title = "\(self.numberFormatter.string(for: data.count)!)개의 메모"
            self.memoView.tableView.reloadData()
        }
        
        memoViewModel.pinnedMemoData.bind { data in
            self.memoView.tableView.reloadData()
            if self.memoViewModel.tableType.value == .searching { return }
                
            if data?.count == 0 {
                self.memoViewModel.tableType.value = .memoOnly
            } else {
                self.memoViewModel.tableType.value = .memoAndPinnedMemo
            }
        }
        
        memoViewModel.isSearching.bind { bool in
            
            switch bool {
            case true:
                self.tempTableType = self.memoViewModel.tableType.value
                self.memoViewModel.tableType.value = .searching
            
            case false:
                guard let tempTableType = self.tempTableType else {
                    return
                }
                self.memoViewModel.tableType.value = tempTableType
            }
            
            self.memoView.tableView.reloadData()
        }
        
        memoViewModel.searchMemoData.bind { modelArray in
            self.memoView.tableView.reloadData()
        }
    }
    
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension MemoListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch memoViewModel.tableType.value {
        case .memoAndPinnedMemo:
            return 2
        case .memoOnly:
            return 1
        case .searching:
            return 1
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        switch memoViewModel.tableType.value {
        case .searching:
            return memoViewModel.searchMemoData.value?.count ?? 0

        case .memoOnly:
            return memoViewModel.memoData.value?.count ?? 0

        case .memoAndPinnedMemo:
            switch section {
            case TableSectionType.pinnedMemo.rawValue:
                
                guard let pinnedMemo = memoViewModel.pinnedMemoData.value else { return 0}
                
                if pinnedMemo.count > 5 {
                    self.view.makeToast(AppToastMessage.message)
                    return 5
                } else {
                    return pinnedMemo.count
                }
                
            case TableSectionType.memo.rawValue:
                return memoViewModel.memoData.value?.count ?? 0
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.reusableIdentifier) as? MemoListTableViewCell else { return UITableViewCell()}
        
        switch memoViewModel.tableType.value {
        case .searching:
            return setMemoListCell(cell: cell, observable: memoViewModel.searchMemoData, indexPath: indexPath, searchQuery: memoViewModel.searchQuery.value)

        case .memoOnly:
            return setMemoListCell(cell: cell, observable: memoViewModel.memoData, indexPath: indexPath)

        case .memoAndPinnedMemo:
            switch indexPath.section {
            case TableSectionType.pinnedMemo.rawValue:
                return setMemoListCell(cell: cell, observable: memoViewModel.pinnedMemoData, indexPath: indexPath)
                
            case TableSectionType.memo.rawValue:
                return setMemoListCell(cell: cell, observable: memoViewModel.memoData, indexPath: indexPath)

            default:
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.reusableIdentifier) as? TableHeaderView else { return UIView()}

        switch memoViewModel.tableType.value {
        case .searching:
            headerView.headerTitleLabel.text = "\(memoViewModel.searchMemoData.value?.count ?? 0)개 찾음"
//            return headerView

        case .memoOnly:
            headerView.headerTitleLabel.text = TableSectionType.memo.sectionTitle
//            return headerView

        case .memoAndPinnedMemo:
            switch section {
            case TableSectionType.pinnedMemo.rawValue:
                headerView.headerTitleLabel.text = TableSectionType.pinnedMemo.sectionTitle
                
            case TableSectionType.memo.rawValue:
                headerView.headerTitleLabel.text = TableSectionType.memo.sectionTitle
            default:
                return UIView()
            }
            
//            return headerView
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = MemoEditViewController()
        
        switch memoViewModel.tableType.value {
        case .searching:
            guard let searchMemo = memoViewModel.searchMemoData.value else { return }
            self.searchController.searchBar.resignFirstResponder()
            vc.isSearching = true
            vc.originalModel = searchMemo[indexPath.row]
            
        case .memoOnly:
            vc.originalModel = memoViewModel.memoData.value?[indexPath.row]
            
        case .memoAndPinnedMemo:
            switch indexPath.section {
            case TableSectionType.pinnedMemo.rawValue:
                vc.originalModel = memoViewModel.pinnedMemoData.value?[indexPath.row]
                
            case TableSectionType.memo.rawValue:
                vc.originalModel = memoViewModel.memoData.value?[indexPath.row]
            default:
                return
            }
        }
      
        presentVC(viewController: vc, transitionType: .push)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let pin = UIContextualAction(style: .normal, title: "") { action, view, handler in
            
            self.memoViewModel.setpinned(indexPath: indexPath)
        }
        
        pin.image = setpinImage(indexPath: indexPath).withTintColor(AppUIColor.white.color)
        pin.backgroundColor = AppUIColor.yellow.color
        
        return UISwipeActionsConfiguration(actions: [pin])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "") {[weak self] action, view, handler in
            
            self?.showAlert(title: "정말 삭제하시겠습니까?", message: nil, onOK: { _ in
                self?.memoViewModel.deleteData(indexpath: indexPath)
            })
        }
        
        delete.image = AppUIImage.delete.image.withTintColor(AppUIColor.white.color)
        delete.backgroundColor = AppUIColor.red.color
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func setMemoListCell (cell: MemoListTableViewCell, observable: Observable<Results<Model>?>, indexPath: IndexPath ,searchQuery: String = "") -> MemoListTableViewCell {
        
        guard let data = observable.value else { return cell }
        
        cell.titleLabel.attributedText = setCellTitle(searchQuery: searchQuery, memo: data[indexPath.row])
        cell.bodyLabel.attributedText = setCellContext(searchQuery: searchQuery, memo: data[indexPath.row])
        return cell
    }
    
    private func setpinImage(indexPath: IndexPath) -> UIImage {

        switch memoViewModel.tableType.value {
        case .searching:
            guard let data = memoViewModel.searchMemoData.value else { return UIImage()}
            return data[indexPath.row].isPinned ? AppUIImage.pinCross.image : AppUIImage.pin.image

        case .memoOnly:
            guard let data = memoViewModel.memoData.value else { return UIImage() }
            return data[indexPath.row].isPinned ? AppUIImage.pinCross.image : AppUIImage.pin.image

        case .memoAndPinnedMemo:
            switch indexPath.section {
            case TableSectionType.pinnedMemo.rawValue:
                guard let data = memoViewModel.pinnedMemoData.value else { return UIImage() }
                return data[indexPath.row].isPinned ? AppUIImage.pinCross.image : AppUIImage.pin.image
                
            case TableSectionType.memo.rawValue:
                guard let data = memoViewModel.memoData.value else { return UIImage() }
                return data[indexPath.row].isPinned ? AppUIImage.pinCross.image : AppUIImage.pin.image
            default:
                return UIImage()
            }

        }
    }
    
}

// MARK: UISearchBarDelegate
extension MemoListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.memoViewModel.isSearching.value = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let text = searchBar.text else { return }
        
        self.memoViewModel.searchQuery.value = text
        self.memoViewModel.fetchData(tableType: .searchingMemo, searchQuery: text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.memoViewModel.isSearching.value = false
        self.memoViewModel.searchQuery.value = ""
        self.memoViewModel.fetchData(tableType: .searchingMemo, searchQuery: memoViewModel.searchQuery.value)
    }
}

// MARK: ShowWalkThrough
extension MemoListViewController {
    
    fileprivate func showWalkThrough() {
        if UserDefaults.standard.bool(forKey: WalkThroughConstant.userDefaultKey) == false {

            let vc = WalkThroughView()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
    }
    
}
