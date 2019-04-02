;
(function() {

 window.teads = {
 
 };
 window.onerror = function(msg, url, lineNo, columnNo, error) {
 var string = msg.toLowerCase();
 var substring = "Teads.js script error";
 var errorJson = {
 message: msg,
 url: url,
 line: lineNo,
 column: columnNo,
 object: JSON.stringify(error)
 };
 window.teads.error(JSON.stringify(errorJson));
 return false;
 };
 
 window.teads.stopSlotVisibility = function stopSlotVisibility(){
 window.webkit.messageHandlers.stopSlotVisibility.postMessage("");
 };
 
 window.teads.error = function error(errorJson) {
 window.webkit.messageHandlers.error.postMessage(errorJson);
 };
 
 window.teads.engineLoaded = function engineLoaded() {
 window.webkit.messageHandlers.engineLoaded.postMessage("");
 };
 
 window.teads.engineInitiated = function engineInitiated() {
 window.webkit.messageHandlers.engineInitiated.postMessage("");
 };
 
 window.teads.preload = function preload() {
 window.webkit.messageHandlers.preload.postMessage("");
 };
 
 window.teads.getUserId = function getUserId(userId) {
 var jsonVariables = {
 "userId": userId
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.getUserId.postMessage(jsonString)
 }
 
 window.teads.httpCall = function httpCall(callId, url, method, headersString, formString, timeout) {
 var jsonVariables = {
 "callId": callId,
 "url": url,
 "method": method,
 "headersString": headersString,
 "formString": formString,
 "timeOut": timeout
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.httpCall.postMessage(jsonString)
 }
 
 window.teads.slotRequest = function slotRequest() {
 window.webkit.messageHandlers.slotRequest.postMessage("");
 };
 
 window.teads.noAd = function noAd(message) {
 var jsonVariables = {
 "message": message
 }
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.noAd.postMessage(jsonString)
 }
 
 window.teads.ad = function ad(mimeType, ratio, response, adParameters) {
 var jsonVariables = {
 "mimeType": mimeType,
 "ratio": ratio,
 "response": response,
 "adParameters": adParameters
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.ad.postMessage(jsonString)
 }
 
 window.teads.configureViews = function configureViews(json) {
 var jsonVariables = {
 "json": json
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.configureViews.postMessage(jsonString)
 }
 
 window.teads.updateView = function updateView(json) {
 var jsonVariables = {
 "json": json
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.updateView.postMessage(jsonString)
 }
 
 window.teads.start = function start() {
 window.webkit.messageHandlers.start.postMessage("");
 };
 
 window.teads.resume = function resume() {
 window.webkit.messageHandlers.resume.postMessage("");
 };
 
 window.teads.pause = function pause() {
 window.webkit.messageHandlers.pause.postMessage("");
 };
 
 window.teads.openSlot = function openSlot(duration) {
 var jsonVariables = {
 "duration": duration
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.openSlot.postMessage(jsonString)
 }
 
 window.teads.closeSlot = function closeSlot(duration) {
 var jsonVariables = {
 "duration": duration
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.closeSlot.postMessage(jsonString)
 }
 
 window.teads.setVolume = function setVolume(volume, transitionDuration) {
 var jsonVariables = {
 "volume": volume,
 "transitionDuration": transitionDuration
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.setVolume.postMessage(jsonString);
 };
 window.teads.showEndScreen = function showEndScreen() {
 window.webkit.messageHandlers.showEndScreen.postMessage("");
 }
 
 window.teads.hideEndScreen = function hideEndScreen() {
 window.webkit.messageHandlers.hideEndScreen.postMessage("");
 }
 
 window.teads.openFullscreen = function openFullscreen(json) {
 var jsonVariables = {
 "json": json
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.openFullscreen.postMessage(jsonString);
 }
 
 window.teads.closeFullscreen = function closeFullscreen() {
 window.webkit.messageHandlers.closeFullscreen.postMessage("");
 }
 
 window.teads.reset = function reset() {
 window.webkit.messageHandlers.reset.postMessage("");
 }
 
 window.teads.rewind = function rewind() {
 window.webkit.messageHandlers.rewind.postMessage("");
 }
 
 window.teads.openBrowser = function openBrowser(url) {
 var jsonVariables = {
 "url": url
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.openBrowser.postMessage(jsonString);
 }
 
 window.teads.openDialog = function openDialog(id, title, description, cancelButton, cancelButtonId, okButton, okButtonId) {
 var jsonVariables = {
 "id": id,
 "title": title,
 "description": description,
 "cancelButton": cancelButton,
 "cancelButtonId": cancelButtonId,
 "okButton": okButton,
 "okButtonId": okButtonId
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.openDialog.postMessage(jsonString);
 }
 
 window.teads.reward = function reward(value, type) {
 var jsonVariables = {
 "value": value,
 "type": type
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.reward.postMessage(jsonString);
 }
 
 window.teads.closeDialog = function closeDialog() {
 window.webkit.messageHandlers.closeDialog.postMessage("");
 }
 
 window.teads.debug = function debug(message) {
 var jsonVariables = {
 "message": message
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.debug.postMessage(jsonString);
 }
 
 })();

;
(function() {
 
 window.teadsSdkPlayerInterface = {
 
 };
 
 window.teadsSdkPlayerInterface.handleVpaidEvent = function handleVpaidEvent(json) {
 var jsonVariables = {
 "json": json
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.handleVpaidEvent.postMessage(jsonString);
 }
 
 window.teadsSdkPlayerInterface.vpaidLoaded = function vpaidLoaded() {
 window.webkit.messageHandlers.vpaidLoaded.postMessage("");
 }
 
 window.teadsSdkPlayerInterface.loadError = function loadError(error) {
 var jsonVariables = {
 "message": error
 };
 var jsonString = JSON.stringify(jsonVariables);
 window.webkit.messageHandlers.loadError.postMessage(jsonString);
 }
 })();
