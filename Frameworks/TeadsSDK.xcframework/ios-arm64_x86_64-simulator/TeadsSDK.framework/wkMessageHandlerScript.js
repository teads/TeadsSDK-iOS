;
(function() {
    window.onerror = function(message, url, lineNumber, columnNumber, error) {
        var string = message.toLowerCase();
        var errorJson = {
            message: message,
            url: url,
            line: lineNumber,
            column: columnNumber,
            object: JSON.stringify(error)
        };
        window.adPlayerOutput.error(JSON.stringify(errorJson));
        return false;
    };
    
    window.adPlayerOutput = {};
 
    window.adPlayerOutput.error = function error(jsonValue) {
        window.webkit.messageHandlers.error.postMessage(jsonValue);
    };
    
    window.adPlayerOutput.notifyPlayerReady = function notifyPlayerReady() {
        window.webkit.messageHandlers.notifyPlayerReady.postMessage("");
    };
    
    window.adPlayerOutput.notifyPlayerFailToLoad = function notifyPlayerFailToLoad(error) {
        window.webkit.messageHandlers.notifyPlayerFailToLoad.postMessage(error);
    };
    
    window.adPlayerOutput.notifyPlayerEvent = function notifyPlayerEvent(jsonEventString) {
        window.webkit.messageHandlers.notifyPlayerEvent.postMessage(jsonEventString);
    };
    
    window.adPlayerOutput.setFixedBackgroundImage = function setFixedBackgroundImage(imageSrc) {
        const message = JSON.stringify({"mediaUrl": imageSrc})
        window.webkit.messageHandlers.setFixedBackgroundImage.postMessage(message);
    };
})();
