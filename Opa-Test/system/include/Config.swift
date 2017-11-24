import UIKit;




// Plist
let WS_BASE_URL = Bundle.main.infoDictionary!["WS_BASE_URL"] as! String
let WS_PATH_URL = Bundle.main.infoDictionary!["WS_PATH_URL"] as! String
let WS_TIME_OUT = 60.0;




/* ------------------------------------------------------------------------------------------------------------------------------------ *
 * Engine                                                                                                                               *
 * ------------------------------------------------------------------------------------------------------------------------------------ */
let PATH_CACHE_JSON     = "json/"
let PATH_CACHE_IMAGE    = "image/"
let PATH_CACHE_AUDIO    = "audio/"
let PATH_CACHE_VIDEO    = "video/"
let PATH_CACHE_DOCUMENT = "document/"




func APP() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate;
}
