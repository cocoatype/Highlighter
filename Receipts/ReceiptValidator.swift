//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
import OpenSSL
import UIKit

public class ReceiptValidator {
    public static func validatedAppReceipt() throws -> AppReceipt {
        let receiptData = try Data(contentsOf: ReceiptValidator.receiptURL)
        guard let container = decrypt(receiptData) else { throw ReceiptParserError.invalidReceipt }
        guard validate(container) else { throw ReceiptParserError.invalidReceipt }
        let receipt = try parse(container)

        try checkHash(for: receipt)
        return receipt
    }

    private static func decrypt(_ data: Data) -> UnsafeMutablePointer<PKCS7>? {
        let receiptBIO = BIO_new(BIO_s_mem())
        BIO_write(receiptBIO, (data as NSData).bytes, Int32(data.count))

        let container = d2i_PKCS7_bio(receiptBIO, nil)
        guard container != nil else { return nil }

        let asn1Obj = container?.pointee.d.sign.pointee.contents.pointee.type
        let dataTypeCode = OBJ_obj2nid(asn1Obj)

        guard dataTypeCode == NID_pkcs7_data else { return nil }
        return container
    }

    private static func validate(_ container: UnsafeMutablePointer<PKCS7>) -> Bool {
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

    private static func checkHash(for receipt: AppReceipt) throws {
        let receiptHashData = receipt.sha1Hash

        guard var deviceIdentifier = UIDevice.current.identifierForVendor?.uuid else { return }
        let rawDeviceIdentifierPointer = withUnsafePointer(to: &deviceIdentifier) { UnsafeRawPointer($0) }
        let deviceIdentifierData = Data(bytes: rawDeviceIdentifierPointer, count: 16)

        var computedHash = [UInt8](repeating: 0, count: 20)
        var context = SHA_CTX()

        func update(_ context: UnsafeMutablePointer<SHA_CTX>, with data: Data) throws {
            try data.withUnsafeBytes { bufferPointer in
                guard let pointer = bufferPointer.baseAddress else { throw ReceiptParserError.invalidReceipt }
                SHA1_Update(context, pointer, data.count)
            }
        }

        SHA1_Init(&context)
        try update(&context, with: deviceIdentifierData)
        try update(&context, with: receipt.opaqueValue)
        try update(&context, with: receipt.bundleIdentifierData)
        SHA1_Final(&computedHash, &context)

        let computedHashData = Data(bytes: &computedHash, count: 20)
        guard computedHashData == receipt.sha1Hash else { throw ReceiptParserError.invalidReceipt }
    }

    private static func parse(_ container: UnsafeMutablePointer<PKCS7>) throws -> AppReceipt {
        return try ReceiptParser().parse(container: container)
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