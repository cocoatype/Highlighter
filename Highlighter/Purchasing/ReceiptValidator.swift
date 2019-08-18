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
            guard let receipt = parse(container) else { return .invalid }
            dump(receipt)
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

    private func parse(_ container: UnsafeMutablePointer<PKCS7>) -> AppReceipt? {
        return try? ReceiptParser().parse(container: container)
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

class ReceiptParser {
    func parse(container: UnsafeMutablePointer<PKCS7>) throws -> AppReceipt {
        guard let contents = container.pointee.d.sign.pointee.contents,
          let octets = contents.pointee.d.data,
          var cursor = UnsafePointer(octets.pointee.data)
        else {
            throw ReceiptParserError.malformedReceipt
        }


        let payloadLength = Int(octets.pointee.length)
        let endOfPayload = cursor.advanced(by: payloadLength)

        var type = Int32(0)
        var xclass = Int32(0)
        var length = 0

        ASN1_get_object(&(cursor.optional), &length, &type, &xclass, payloadLength)

        guard type == V_ASN1_SET else { throw ReceiptParserError.malformedReceipt }

        var bundleIdentifier: String?
        var bundleIdentifierData: Data?
        var appVersion: String?
        var opaqueValue: Data?
        var sha1Hash: Data?
        var purchaseReceipts = [PurchaseReceipt]()
        var originalAppVersion: String?
        var receiptCreationDate: Date?
        var expirationDate: Date?

        while cursor < endOfPayload {
            ASN1_get_object(&(cursor.optional), &length, &type, &xclass, cursor.distance(to: endOfPayload))
            guard type == V_ASN1_SEQUENCE else { throw ReceiptParserError.malformedReceipt }

            let attributeType = ReceiptAttributeType(startingAt: &(cursor.optional), length: cursor.distance(to: endOfPayload))
            guard Int(startingAt: &(cursor.optional), length: cursor.distance(to: endOfPayload)) != nil else { throw ReceiptParserError.malformedReceipt }

            ASN1_get_object(&(cursor.optional), &length, &type, &xclass, cursor.distance(to: endOfPayload))

            guard type == V_ASN1_OCTET_STRING else { throw ReceiptParserError.malformedReceipt }

            switch attributeType {
            case .bundleIdentifier?:
                var start = cursor.optional
                bundleIdentifierData = Data(bytes: &start, count: length)
                bundleIdentifier = String(startingAt: &start, length: length)
            case .appVersion?:
                var start = cursor.optional
                appVersion = String(startingAt: &start, length: length)
            case .opaqueValue?:
                var start = cursor.optional
                opaqueValue = Data(bytes: &start, count: length)
            case .sha1Hash?:
                var start = cursor.optional
                sha1Hash = Data(bytes: &start, count: length)
            case .purchaseReceipt?:
                var start = cursor.optional
                try purchaseReceipts.append(parsePurchase(startingAt: &start, length: length))
            case .receiptCreationDate?:
                var start = cursor.optional
                receiptCreationDate = Date(startingAt: &start, length: length)
            case .originalAppVersion?:
                var start = cursor.optional
                originalAppVersion = String(startingAt: &start, length: length)
            case .expirationDate?:
                var start = cursor.optional
                expirationDate = Date(startingAt: &start, length: length)
            case .none:
                break
            }

            cursor = cursor.advanced(by: length)
        }

        return try AppReceipt(bundleIdentifier: bundleIdentifier, bundleIdentifierData: bundleIdentifierData, appVersion: appVersion, opaqueValue: opaqueValue, sha1Hash: sha1Hash, purchaseReceipts: purchaseReceipts, originalAppVersion: originalAppVersion, receiptCreationDate: receiptCreationDate, expirationDate: expirationDate)
    }

    func parsePurchase(startingAt intPointer: inout UnsafePointer<UInt8>?, length: Int) throws -> PurchaseReceipt {
        return PurchaseReceipt()
    }
}

enum ReceiptParserError: Error {
    case malformedReceipt
    case incompleteData
}

enum ReceiptAttributeType {
    case bundleIdentifier
    case appVersion
    case opaqueValue
    case sha1Hash
    case purchaseReceipt
    case receiptCreationDate
    case originalAppVersion
    case expirationDate

    init?(startingAt intPointer: inout UnsafePointer<UInt8>?, length: Int) {
        var type = Int32(0)
        var xclass = Int32(0)
        var intLength = 0

        ASN1_get_object(&intPointer, &intLength, &type, &xclass, length)

        guard type == V_ASN1_INTEGER else { return nil }
        let integer = c2i_ASN1_INTEGER(nil, &intPointer, intLength)
        let result = ASN1_INTEGER_get(integer)
        ASN1_INTEGER_free(integer)

        switch result {
        case 2: self = .bundleIdentifier
        case 3: self = .appVersion
        case 4: self = .opaqueValue
        case 5: self = .sha1Hash
        case 17: self = .purchaseReceipt
        case 12: self = .receiptCreationDate
        case 19: self = .originalAppVersion
        case 21: self = .expirationDate
        default: return nil
        }
    }
}

private extension Int {
    init?(startingAt intPointer: inout UnsafePointer<UInt8>?, length: Int) {
        var type = Int32(0)
        var xclass = Int32(0)
        var intLength = 0

        ASN1_get_object(&intPointer, &intLength, &type, &xclass, length)

        guard type == V_ASN1_INTEGER else { return nil }
        let integer = c2i_ASN1_INTEGER(nil, &intPointer, intLength)
        self = ASN1_INTEGER_get(integer)
        ASN1_INTEGER_free(integer)
    }
}

private extension String {
    init?(startingAt stringPointer: inout UnsafePointer<UInt8>?, length: Int) {
        // These will be set by ASN1_get_object
        var type = Int32(0)
        var xclass = Int32(0)
        var stringLength = 0

        ASN1_get_object(&stringPointer, &stringLength, &type, &xclass, length)

        if type == V_ASN1_UTF8STRING {
            let mutableStringPointer = UnsafeMutableRawPointer(mutating: stringPointer!)
            guard let string = String(bytesNoCopy: mutableStringPointer, length: stringLength, encoding: String.Encoding.utf8, freeWhenDone: false) else { return nil }

            self = string
        } else if type == V_ASN1_IA5STRING {
            let mutableStringPointer = UnsafeMutableRawPointer(mutating: stringPointer!)
            guard let string = String(bytesNoCopy: mutableStringPointer, length: stringLength, encoding: String.Encoding.ascii, freeWhenDone: false) else { return nil }
            self = string
        } else {
            return nil
        }
    }
}

extension Date {
    init?(startingAt datePointer: inout UnsafePointer<UInt8>?, length: Int) {
        // Date formatter code from https://www.objc.io/issues/17-security/receipt-validation/#parsing-the-receipt
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let dateString = String(startingAt: &datePointer, length:length), let date = dateFormatter.date(from: dateString) else { return nil }

        self = date
    }
}

private extension UnsafePointer {
    var optional: Optional<UnsafePointer<Pointee>> {
        get { return Optional(self) }
        set(newOptional) { if let newSelf = newOptional { self = newSelf} }
    }
}

struct AppReceipt {
    let bundleIdentifier: String
    let bundleIdentifierData: Data
    let appVersion: String
    let opaqueValue: Data
    let sha1Hash: Data
    let purchaseReceipts: [PurchaseReceipt]
    let originalAppVersion: String
    let receiptCreationDate: Date
    let expirationDate: Date?

    init(bundleIdentifier: String?, bundleIdentifierData: Data?, appVersion: String?, opaqueValue: Data?, sha1Hash: Data?, purchaseReceipts: [PurchaseReceipt], originalAppVersion: String?, receiptCreationDate: Date?, expirationDate: Date?) throws {
        guard
          let bundleIdentifier = bundleIdentifier,
          let bundleIdentifierData = bundleIdentifierData,
          let appVersion = appVersion,
          let opaqueValue = opaqueValue,
          let sha1Hash = sha1Hash,
          let originalAppVersion = originalAppVersion,
          let receiptCreationDate = receiptCreationDate
        else { throw ReceiptParserError.incompleteData } // checking required values

        self.bundleIdentifier = bundleIdentifier
        self.bundleIdentifierData = bundleIdentifierData
        self.appVersion = appVersion
        self.opaqueValue = opaqueValue
        self.sha1Hash = sha1Hash
        self.purchaseReceipts = purchaseReceipts
        self.originalAppVersion = originalAppVersion
        self.receiptCreationDate = receiptCreationDate
        self.expirationDate = expirationDate
    }
}

struct PurchaseReceipt {

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
