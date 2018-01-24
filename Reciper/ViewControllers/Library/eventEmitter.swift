// https://gist.github.com/tomconroy/9f699d5207802427c46f
class Event <T:Any> {
    var handlers = Array<(T) -> Void>()
    
    func listen(handler: @escaping (T) -> Void) {
        handlers.append(handler)
    }
    
    func emit(object: T) {
        for handler in handlers {
            handler(object)
        }
    }
}
