//  Created by Geoff Pado on 6/17/24.
//  Copyright © 2024 Cocoatype, LLC. All rights reserved.

import UIKit

import FactoryKit

import Defaults

public class OverlayPreferencesHostingController: UITableViewController {
    public init() {
        super.init(style: .insetGrouped)

        sheetPresentationController?.detents = [.medium()]
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        tableView.allowsSelection = false
    }

    // MARK: UITableViewDataSource

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        OverlayPreference.allCases.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        let preference = OverlayPreference.allCases[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = preference.title
        cell.contentConfiguration = content

        let toggle = (cell.accessoryView as? UISwitch) ?? UISwitch()
        toggle.removeTarget(nil, action: nil, for: .valueChanged)
        toggle.onTintColor = preference.tintColor
        toggle.isOn = defaults.value(for: preference.key)
        toggle.tag = indexPath.row
        toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
        cell.accessoryView = toggle

        return cell
    }

    @objc private func toggleChanged(_ sender: UISwitch) {
        let preference = OverlayPreference.allCases[sender.tag]
        defaults.set(sender.isOn, for: preference.key)
    }

    // MARK: Boilerplate

    private static let cellIdentifier = "OverlayPreferencesHostingController.cellIdentifier"

    @Injected(\.defaults) private var defaults

    @available(*, unavailable)
    required init(coder: NSCoder) {
        let typeName = NSStringFromClass(type(of: self))
        fatalError("\(typeName) does not implement init(coder:)")
    }
}

enum OverlayPreference: CaseIterable {
    case detectedText
    case detectedCharacters
    case recognizedText
    case calculated
    case combined

    var title: String {
        switch self {
        case .detectedText: "Detected Text"
        case .detectedCharacters: "Detected Characters"
        case .recognizedText: "Recognized Text"
        case .calculated: "Calculated Area"
        case .combined: "Combined Area"
        }
    }

    var tintColor: UIColor {
        switch self {
        case .detectedText: .systemRed
        case .detectedCharacters: .systemBlue
        case .recognizedText: .systemYellow
        case .calculated: .systemGreen
        case .combined: .systemPurple
        }
    }

    var key: Key<Bool> {
        switch self {
        case .detectedText: Keys.showDetectedTextOverlay
        case .detectedCharacters: Keys.showDetectedCharactersOverlay
        case .recognizedText: Keys.showRecognizedTextOverlay
        case .calculated: Keys.showCalculatedOverlay
        case .combined: Keys.showCombinedOverlay
        }
    }
}
