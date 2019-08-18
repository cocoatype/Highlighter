//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import OpenSSL

class ReceiptValidator {
    var appReceiptStatus: ReceiptStatus { return .valid }
    var unlockPurchaseStatus: ReceiptStatus {
        do {
            let receiptData = try Data(contentsOf: ReceiptValidator.receiptURL)
            guard let container = decrypt(receiptData) else { return .invalid }
            guard validate(container) else { return .invalid }
            return .valid
        } catch {
            return .missing
        }
    }

    private func decrypt(_ data: Data) -> UnsafeMutablePointer<PKCS7>? {
        let receiptBIO = BIO_new(BIO_s_mem())
        BIO_write(receiptBIO, (data as NSData).bytes, Int32(data.count))

        let container = d2i_PKCS7_bio(receiptBIO, nil)
        guard container != nil else { return nil }

        let asn1Obj = container?.pointee.d.sign.pointee.contents.pointee.type
        let dataTypeCode = OBJ_obj2nid(asn1Obj)

        guard dataTypeCode == NID_pkcs7_data else { return nil }
        return container
    }

    private func validate(_ container: UnsafeMutablePointer<PKCS7>) -> Bool {
        guard OBJ_obj2nid(container.pointee.type) == NID_pkcs7_signed else { return false }

        let appleCertificateBIO = BIO_new(BIO_s_mem())
        let appleCertificateData = ReceiptValidator.appleCertificateData
        BIO_write(appleCertificateBIO, (appleCertificateData as NSData).bytes, Int32(appleCertificateData.count))
        guard let appleCertificate = d2i_X509_bio(appleCertificateBIO, nil) else { return false }

        let certificateStore = X509_STORE_new()
        X509_STORE_add_cert(certificateStore, appleCertificate)

        OpenSSL_add_all_digests()

        let result = PKCS7_verify(container, nil, certificateStore, nil, nil, 0)
        return result == 1
    }

    // MARK: Boilerplate

    private static let appleCertificateData: Data = {
        guard let dataURL = Bundle.main.url(forResource: "AppleIncRootCertificate", withExtension: "cer"), let data = try? Data(contentsOf: dataURL) else {
            fatalError("Error locating Apple root certificate data")
        }

        return data
    }()

    private static let receiptURL: URL = {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            fatalError("Error locating app receipt")
        }

        return receiptURL
    }()
}

enum ReceiptStatus {
    case valid
    case invalid
    case missing
}

extension Data {
    var hex: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
