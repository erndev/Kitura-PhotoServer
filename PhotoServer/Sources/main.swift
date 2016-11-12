
import Kitura
import HeliumLogger
import LoggerAPI


HeliumLogger.use(.debug)


let store = CacheStore(photos: InitialData.photos)
let controller = Controller(store: store)
// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: controller.router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
