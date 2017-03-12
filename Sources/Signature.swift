import Foundation
import Kitura
import Cryptor

extension HMAC.Algorithm {

    init?(algorithm: String) {
        switch algorithm {
        case "md5":
            self = .md5
        case "sha1":
            self = .sha1
        case "sha224":
            self = .sha224
        case "sha256":
            self = .sha256
        case "sha384":
            self = .sha384
        case "sha512":
            self = .sha512
        default:
            return nil
        }
    }
}

class Signature {

    static func veriry(withSignature signature: String, requestBody: String) -> Bool {
        let pair = signature.components(separatedBy: "=")
        if pair.count != 2 { return false }

        guard let algorithm = HMAC.Algorithm(algorithm: pair[0]) else { return false }
        guard let secret = ProcessInfo.processInfo.environment["GITHUB_WEBHOOK_SECRET"] else { return false }

        let key = CryptoUtils.byteArray(from: secret)
        let data = CryptoUtils.byteArray(from: requestBody)
        guard let hmac = HMAC(using: algorithm, key: key).update(byteArray: data)?.final() else { return false }

        print("signature:\(pair[1])")
        print("generated:\(CryptoUtils.hexString(from: hmac))")
        return CryptoUtils.hexString(from: hmac) == pair[1]
    }
}
