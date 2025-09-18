//  Created by Geoff Pado on 8/3/20.
//  Copyright © 2020 Cocoatype, LLC. All rights reserved.

#if targetEnvironment(macCatalyst)
import FactoryKit
import UniformTypeIdentifiers

class ShareItem: NSSharingServicePickerToolbarItem, UIActivityItemsConfigurationReading {
    static let identifier = NSToolbarItem.Identifier("ShareItem.identifier")

    init(delegate: ShareItemDelegate?) {
        self.delegate = delegate
        super.init(itemIdentifier: Self.identifier)

        image = UIImage(systemName: "square.and.arrow.up")
        label = Strings.ShareItem.label
        isEnabled = true

        activityItemsConfiguration = self
    }

    weak var delegate: ShareItemDelegate?

    var itemProvidersForActivityItemsConfiguration: [NSItemProvider] {
        guard let delegate = delegate, delegate.canExportImage else { return [] }

        let itemProvider = NSItemProvider()
        itemProvider.registerFileRepresentation(forTypeIdentifier: UTType.png.identifier, visibility: .all) { [weak self] loadHandler -> Progress? in
            Task { @MainActor [weak self] in
                do {
                    let url = try await self?.delegate?.exportedURL()
                    loadHandler(url, false, nil)
                    self?.delegate?.didExportImage()
                } catch {
                    Container.shared.errorHandler()
                        .log(error, module: "Core", type: "ShareItem")
                    loadHandler(nil, false, error)
                }
            }
            return nil
        }

        return [itemProvider]
    }
}

@MainActor protocol ShareItemDelegate: AnyObject {
    var canExportImage: Bool { get }
    func exportedURL() async throws -> URL?
    func didExportImage()
}
#endif
