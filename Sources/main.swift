import Foundation
import Kitura
import HeliumLogger

HeliumLogger.use()

let router = Router()

router.get("/") { request, response, next in
    response.send("Hello, World!")
    next()
}

let port: Int = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8090") ?? 8090
Kitura.addHTTPServer(onPort: port, with: router)

Kitura.run()
