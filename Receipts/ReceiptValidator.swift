//  Created by Geoff Pado on 8/11/19.
//  Copyright © 2019 Cocoatype, LLC. All rights reserved.

import Foundation
#if canImport(IOKit)
import IOKit
#endif
import OpenSSL
import UIKit

public class ReceiptValidator {
    public static func validatedAppReceipt() throws -> AppReceipt {
        let receiptURL = ReceiptValidator.receiptURL

        #if targetEnvironment(macCatalyst)
        if FileManager.default.fileExists(atPath: receiptURL.path) == false {
            exit(173)
        }
        #endif

        let receiptData = try Data(contentsOf: receiptURL)
        let container = try decrypt(receiptData)
        // TODO (#121): Fix receipt validation
//        try validate(container)
        let receipt = try parse(container)

        try checkHash(for: receipt)
        return receipt
    }

    private static func decrypt(_ data: Data) throws -> UnsafeMutablePointer<PKCS7> {
        let receiptBIO = BIO_new(BIO_s_mem())
        defer { BIO_free(receiptBIO) }

        let writtenByteCount = BIO_write(receiptBIO, [UInt8](data), Int32(data.count))
        guard writtenByteCount == data.count else { throw ReceiptValidatorError.badDecryptWrite }

        guard let container = d2i_PKCS7_bio(receiptBIO, nil) else { throw ReceiptValidatorError.missingPKCS7 }

        let asn1Obj = container.pointee.d.sign.pointee.contents.pointee.type
        let dataTypeCode = OBJ_obj2nid(asn1Obj)

        guard dataTypeCode == NID_pkcs7_data else { throw ReceiptValidatorError.receiptNotPKCS7Data }
        return container
    }

    private static func validate(_ container: UnsafeMutablePointer<PKCS7>) throws {
        #if DEBUG
        do {
            try validate(container, withCertificate: ReceiptValidator.testCertificateData)
        } catch {
            try validate(container, withCertificate: ReceiptValidator.appleCertificateData)
        }
        #else
            try validate(container, withCertificate: ReceiptValidator.appleCertificateData)
        #endif

    }

    private static func validate(_ container: UnsafeMutablePointer<PKCS7>, withCertificate certificateData: Data) throws {
        guard OBJ_obj2nid(container.pointee.type) == NID_pkcs7_signed else { throw ReceiptValidatorError.receiptNotSigned }

        let appleCertificateBIO = BIO_new(BIO_s_mem())
        defer { BIO_free(appleCertificateBIO) }

        let rootCertBytes = [UInt8](certificateData)
        let writtenByteCount = BIO_write(appleCertificateBIO, rootCertBytes, Int32(certificateData.count))
        guard writtenByteCount == rootCertBytes.count else { throw ReceiptValidatorError.badValidateWrite }
        guard let appleCertificate = d2i_X509_bio(appleCertificateBIO, nil) else { throw ReceiptValidatorError.missingCertificate }

        let certificateStore = X509_STORE_new()
        guard X509_STORE_add_cert(certificateStore, appleCertificate) == 1 else { throw ReceiptValidatorError.unableToAddCertificateToStore }

        guard OPENSSL_init_crypto(UInt64(OPENSSL_INIT_ADD_ALL_DIGESTS), nil) == 1 else { throw ReceiptValidatorError.cryptoInitError }

        guard PKCS7_verify(container, nil, certificateStore, nil, nil, 0) == 1 else { throw ReceiptValidatorError.invalidReceipt }
    }

    private static func checkHash(for receipt: AppReceipt) throws {
        guard let deviceIdentifierData = deviceIdentifierData else { throw ReceiptParserError.invalidReceipt }

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

    private static func data(forCertificateNamed certificateFileName: String) -> Data {
        guard let dataURL = Bundle.main.url(forResource: certificateFileName, withExtension: "cer"), let data = try? Data(contentsOf: dataURL) else {
            fatalError("Error locating Apple root certificate data")
        }

        return data
    }

    private static let testCertificateData: Data = data(forCertificateNamed: "StoreKitTestCertificate")

    private static let appleCertificateData: Data = data(forCertificateNamed: "AppleIncRootCertificate")

    private static let receiptURL: URL = {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            fatalError("Error locating app receipt")
        }

        return receiptURL
    }()

    #if targetEnvironment(macCatalyst)
    private static let deviceIdentifierData: Data? = {
        var masterPort: mach_port_t = 0

        guard IOMasterPort(UInt32(MACH_PORT_NULL), &masterPort) == KERN_SUCCESS else { return nil }

        guard let matchingDict = IOBSDNameMatching(masterPort, 0, "en0") else { return nil }

        var iterator = io_iterator_t()
        guard IOServiceGetMatchingServices(masterPort, matchingDict, &iterator) == KERN_SUCCESS else { return nil }

        var service = io_object_t()
        repeat {
            service = IOIteratorNext(iterator)
            var parentService = io_object_t()

            defer {
                IOObjectRelease(service)
                IOObjectRelease(parentService)
            }

            let result = IORegistryEntryGetParentEntry(service, kIOServicePlane, &parentService)

            if result == KERN_SUCCESS {
                var typeRef =
                    IORegistryEntryCreateCFProperty(parentService, "IOMACAddress" as CFString, kCFAllocatorDefault, 0)
                if let object = typeRef?.takeRetainedValue(), let data = object as? Data {
                    return data
                }
            }
        } while service != 0

        return nil
    }()
    #else
    private static let deviceIdentifierData: Data? = {
        guard var deviceIdentifier = UIDevice.current.identifierForVendor?.uuid else { return nil }
        let rawDeviceIdentifierPointer = withUnsafePointer(to: &deviceIdentifier) { UnsafeRawPointer($0) }
        let deviceIdentifierData = Data(bytes: rawDeviceIdentifierPointer, count: 16)
        return deviceIdentifierData
    }()
    #endif
}

enum ReceiptValidatorError: Error {
    case badDecryptWrite
    case missingPKCS7
    case receiptNotPKCS7Data
    case receiptNotSigned
    case badValidateWrite
    case missingCertificate
    case unableToAddCertificateToStore
    case cryptoInitError
    case invalidReceipt
}
