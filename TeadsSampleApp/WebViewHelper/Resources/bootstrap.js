/**
 * @module Teads JS Utils for inRead
 * @author RonanDrouglazet <ronan.drouglazet@ebuzzing.com>
 * @date 10-2014
 * @copyright Teads <http://www.teads.tv>
 *
 * ⚠️ This bootstrap has been provided to give you a hand in your integration webview.
 * It's not designed to work on every integration, it may need to be customised to suit your needs
 *
 */

(function() {

  var verticalSpacer = 10;
  var showHideTimerDuration = 100; 
  var intervalCheckPosition = 500;
  var opened = false;
  var bridge, teadsContainer, finalSize, intervalPosition, offset, heightSup, ratio, maxHeight;
  var transitionType = "height [DURATION]ms ease-in-out";
  // command use to communicate with WebViewController JS Bridge
  var command = {
    trigger: {
      ready: "onTeadsJsLibReady",
      error: "handleError",
      position: "onSlotUpdated",
      startShow: "onSlotStartShow",
      startHide: "onSlotStartHide"
    },
    handler: {
      insert: "nativePlayerToJsInsertPlaceholder",
      update: "nativePlayerToJsUpdatePlaceholder",
      remove: "nativePlayerToJsRemovePlaceholder",
      show: "nativePlayerToJsShowPlaceholder",
      hide: "nativePlayerToJsHidePlaceholder",
      getCoo: "nativePlayerToJsGetTargetGeometry"
    }
  };

  // The platform int
  var UNKNOWN_OS = 0;
  var ANDROID_OS = 1;
  var IOS_OS = 2;

  // The running platform int (ANDROID, IOS, UNKNOWN)
  var platformType;

  /*****************************************
   * Method called by WebViewController (through bridge) *
   *****************************************/

  // Check if WebViewController JS Bridge is present, set handler, and say JS Ready for WebViewController
  var sendJsLibReady = function() {
    platformType = getPlatformType();
    if (platformType === IOS_OS) {
      setBridgeHandler(window.webkit.messageHandlers);
    } else {
      setBridgeHandler(window.TeadsSDK);
    }
    bridge.callHandler(command.trigger.ready);
  };

  // find a slot on the document with selector and set placeholder (closed)
  var insertPlaceholder = function(selector) {
    var insertionSlot = findSlot(selector);

    if (insertionSlot) {
      setPlaceholderDiv(insertionSlot);
      // inform native about the placeholder geometry
      sendTargetGeometry();
    } else {
      bridge.callHandler(command.trigger.error, 'noSlotAvailable');
    }
  };

  var updatePlaceholder = function(data) {
    heightSup = data.offsetHeight;
    ratio = data.ratioVideo;
    maxHeight = data.maxHeight;
    // send to native the coo
    sendTargetGeometry();

    if (opened) {
      // if already opened when updating size, update placeholder to !
      showPlaceholder(0)
    }
  };

  // remove placeholder from document
  var removePlaceholder = function() {
    tryOrLog(function() {
      if (teadsContainer && teadsContainer.parentNode) {
        teadsContainer.parentNode.removeChild(teadsContainer);
      }
    }, 'removePlaceholder')
  };

  // open placeholder with transition
  var showPlaceholder = function(duration) {
    tryOrLog(function() {
      opened = true;
      // set transition on teadsContainer
      teadsContainer.style.transition = transitionType.replace('[DURATION]', duration);
      // need to wait a little for css transition activation...thanks web mobile :)
      setTimeout(function() {
        // set height to active transition
        teadsContainer.style.height = finalSize.height + "px";
        // send status on native side
        bridge.callHandler(command.trigger.startShow);
        // start interval position check, if position change, informe native side
        intervalPosition = setInterval(checkPosition, intervalCheckPosition);
      }, showHideTimerDuration);
    }, 'showPlaceholder')
  };

  // close placeholder with transition
  var hidePlaceholder = function(duration) {
    tryOrLog(function() {
      opened = false;
      // set transition on teadsContainer
      teadsContainer.style.transition = transitionType.replace('[DURATION]', duration);

      // need to wait a little for css transition activation...thanks web mobile :)
      setTimeout(function() {
        // set height to active transition
        teadsContainer.style.height = "0px";
          
        //teadsContainer.remove();
          
        // send status on native side
        bridge.callHandler(command.trigger.startHide);
        clearInterval(intervalPosition);
        intervalPosition = null;
      }, showHideTimerDuration);
    }, 'hidePlaceholder')
  };

  // send placeholder's coordinate to WebViewController for player positioning
  var sendTargetGeometry = function() {
    tryOrLog(function() {
      if (teadsContainer) {
        offset = getPageOffset(teadsContainer);

        var height = ratio ? (offset.w / ratio) + heightSup : 0;
        finalSize = {
          width: height > maxHeight ? (maxHeight - heightSup) * ratio : offset.w,
          height: height > maxHeight ? maxHeight : height
        };

        //Left margin is equal to the x offset + half of the delta between the
        //width offset and the real player width
        var leftMargin = offset.x + (offset.w - finalSize.width) / 2;
        var json = {
          "top": parseInt(offset.y),
          "left": parseInt(leftMargin),
          "bottom": parseInt(offset.y + finalSize.height),
          "right": parseInt(leftMargin + finalSize.width),
          "ratio": parseFloat(window.devicePixelRatio)
        }

        bridge.callHandler(command.trigger.position, json);
      }
    }, 'sendTargetGeometry')
  };

  /**************************
   *     Internal method    *
   **************************/

  var getPlatformType = function() {
    return tryOrLog(function() {
      // when running in WKWebView, messageHandlers is defined if WKScriptMessageHandler is added to webview controller
      // this detection logic is more accurate than userAgent evaluation
      if (window.webkit && window.webkit.messageHandlers !== undefined) {
        return IOS_OS
      }
        
      const hasTouchPoints = !!(navigator.maxTouchPoints && navigator.maxTouchPoints > 0)
      const userAgent = navigator.userAgent.toLowerCase()
      if (/android/i.test(userAgent)) {
        return ANDROID_OS;
      } else if (/iphone|ipad|ipod/i.test(userAgent) || (/mac\s+os/i.test(userAgent) && hasTouchPoints)) {
        return IOS_OS;
      } else return UNKNOWN_OS;
    }, 'getPlatformType')
  };

  // register handler on the WebViewController JS Bridge
  var setBridgeHandler = function(wvBridge) {
    tryOrLog(function() {
      bridge = wvBridge;
      window.teads = {
        insertPlaceholder: insertPlaceholder,
        updatePlaceholder: updatePlaceholder,
        showPlaceholder: showPlaceholder,
        hidePlaceholder: hidePlaceholder,
        removePlaceholder: removePlaceholder,
        sendTargetGeometry: sendTargetGeometry
      };

      bridge.callHandler = function(fct, params) {
        var platformType = getPlatformType()
        if (this[fct]) {
          if (typeof params === 'object') {
            if (platformType === IOS_OS) {
              this[fct].postMessage(JSON.stringify(params));
            } else {
              var p = [];
              for (var i in params) {
                p.push(params[i]);
              }
              this[fct].apply(this, p);
            }
          } else {
            if (platformType === IOS_OS) {
              this[fct].postMessage(params);
            } else {
              this[fct].apply(this, params);
            }
          }
        } else {
          console.error(fct, 'not present on bridge', params)
        }
      };
    }, 'setBridgeHandler')
  };

  // set placeholder size, create it, and put it before "element" on document, then send coordinates to WebViewController
  var setPlaceholderDiv = function(element) {
    tryOrLog(function() {
      var parent = element.parentNode;

      teadsContainer = createTeadsContainer();
      parent.insertBefore(teadsContainer, element);
    }, 'setPlaceholderDiv')
  };

  // create and return a set div
  var createTeadsContainer = function() {
    return tryOrLog(function() {
      var container = document.createElement("center");
      container.style.margin = verticalSpacer + "px auto " + verticalSpacer + "px auto";
      container.style.padding = "0";
      container.style.backgroundColor = "transparent";
      container.style.width = "100%";
      container.style.height = "0px";
      return container;
    }, 'createTeadsContainer')
  };

  // get element position on document (coordinate)
  var getPageOffset = function(element) {
    return tryOrLog(function() {
      var box = element.getBoundingClientRect();
      var scrollCoord = getDocumentScroll();

      var pos = {
        x: box.left + scrollCoord.x,
        y: box.top + scrollCoord.y,
        w: box.right - box.left,
        h: box.bottom - box.top
      };
      return pos;
    }, 'getPageOffset')
  };

  // get the scroll of window
  var getDocumentScroll = function() {
    return tryOrLog(function() {
      return {
        x: window.pageXOffset,
        y: window.pageYOffset
      }
    }, 'getDocumentScroll')
  };

  // find a slot in document with a CSS selector given by WebViewController (or automatic if no selector provided)
  var findSlot = function(selector) {
    return tryOrLog(function() {

      var items = document.querySelectorAll(selector);

      if (items.length) {
        return items[0]
      }

      return null;

    }, 'findSlot')
  };


  var checkPosition = function() {
    tryOrLog(function() {
      if (JSON.stringify(offset) !== JSON.stringify(getPageOffset(teadsContainer))) {
        sendTargetGeometry();
      }
    }, 'checkPosition')
  };

  var tryOrLog = function(cbk, fctName) {
      try {
        return cbk()
      } catch (e) {
        if (bridge && bridge.callHandler) {
          if (window.TeadsSDK || window.webkit.messageHandlers) {
            bridge.callHandler(command.trigger.error, fctName + ": " + e)
          }
        } else {
          console.error(fctName, e)
        }
      }
    }
    // START !
  sendJsLibReady();
})();
