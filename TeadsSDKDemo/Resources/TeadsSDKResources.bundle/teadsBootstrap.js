!function(){var a,b,c,d=10,e="height 1s ease-in-out",f={trigger:{ready:"onTeadsJsLibReady",noAd:"handleNoSlotAvailable",init:"onInitialContainerPosition",startShow:"onPlaceholderStartShow",startHide:"onPlaceholderStartHide"},handler:{insert:"nativePlayerToJsInsertPlaceholder",remove:"nativePlayerToJsRemovePlaceholder",show:"nativePlayerToJsShowPlaceholder",showAnimate:"nativePlayerToJsShowPlaceholderWithAnimation",hide:"nativePlayerToJsHidePlaceholder",hideAnimate:"nativePlayerToJsHidePlaceholderWithAnimation",getCoo:"nativePlayerToJsGetTargetGeometry"}},g=500,h=300,i={SPAN:!0,STRONG:!0,EM:!0,B:!0,I:!0,U:!0},j={DIV:10,P:4,ARTICLE:20,SECTION:5,SPAN:2,FORM:4,STRONG:2,EM:3,B:1,I:1,U:1,MAIN:2},k={article:4,"ob-text":6,"ob-section-html":4,contenuArticle:6},l={score:0,node:null,underWaterline:null},m=function(){window.WebViewJavascriptBridge?(u(window.WebViewJavascriptBridge),a.callHandler(f.trigger.ready)):document.addEventListener("WebViewJavascriptBridgeReady",m)},n=function(b){var c=A(b.selector);c?v(c,b.labelSize):a.callHandler(f.trigger.noAd)},o=function(){b&&b.parentNode&&b.parentNode.removeChild(b)},p=function(){b.style.height=c.height+"px",a.callHandler(f.trigger.startShow)},q=function(){C(),b.style.height=c.height+"px"},r=function(){b.style.height="0.1px",a.callHandler(f.trigger.startHide)},s=function(){C(),b.style.height="0.1px"},t=function(){if(b){var d=x(b);a.callHandler(f.trigger.init,{top:d.y,left:d.x,bottom:d.y+c.height,right:d.x+c.width,ratio:window.devicePixelRatio})}},u=function(b){a=b,a.init(),a.registerHandler(f.handler.insert,n),a.registerHandler(f.handler.remove,o),a.registerHandler(f.handler.getCoo,t),a.registerHandler(f.handler.show,q),a.registerHandler(f.handler.showAnimate,p),a.registerHandler(f.handler.hide,s),a.registerHandler(f.handler.hideAnimate,r)},v=function(a,d){var e=a.parentNode,f=e.getBoundingClientRect(),g=f.right-f.left,h=9/16*g+d,i={width:g,height:h};c=B(i),b=w(c.width),e.insertBefore(b,a),t()},w=function(a){var b=document.createElement("div");return b.style.margin=d+"px auto "+d+"px auto",b.style.padding="0",b.style.backgroundColor="transparent",b.style.width=a+"px",b.style.height="0px",b.style.transition=e,b},x=function(a){var b=a.getBoundingClientRect(),c=y(),d={x:b.left+c.x,y:b.top+c.y};return d},y=function(){return{x:window.pageXOffset,y:window.pageYOffset}},z=function(a){var b=x(a);return b.y>1.1*window.innerHeight},A=function(a){if(a){if("#TEADS_INBOARD#"===a)return d=0,document.body.children[0];for(var b=document.querySelectorAll(a),c=0;c<b.length;c++)if(z(b[c]))return b[c];return null}return D(document.body),l.underWaterline},B=function(a){var b=window.innerHeight-2*d,c=window.innerWidth,e={width:0,height:0};if(0===b||0===c)return e;a.width<c&&(c=a.width);var f,g=a.height/a.width,h=b/c;return h>g?(f=c/a.width,e.height=f*a.height,e.width=f*a.width):(f=b/a.height,e.height=f*a.height,e.width=f*a.width),e},C=function(){b.style.transition="none",setTimeout(function(){b.style.transition=e},100)},D=function(a){if(l.node)return l;var b,c,d={length:0,currentScore:0,childrenScore:0,minWidthReach:!1},e=a.innerText||a.textContent||a.nodeValue;if(e&&(3===a.nodeType||i[a.nodeName.toUpperCase()]))d.length=e.replace(/\s+/g," ").length;else if(a===document.body||1===a.nodeType&&j[a.nodeName.toUpperCase()]){var f=0,m=0;for(b=0,c=a.childNodes.length;c>b;b++){var n=D(a.childNodes[b]);f+=n.length,m+=n.currentScore,(n.minWidthReach||a.offsetWidth>=h)&&(d.minWidthReach=!0)}d.currentScore=f,d.childrenScore=m}if(d.childrenScore&&d.minWidthReach&&d.childrenScore>g){var o,p=j[a.nodeName.toUpperCase()]||0,q=a.className.split(" "),r=1;for(b=0,c=q.length;c>b;b++)o=q[b].replace(/^\s+|\s+$/g,""),r+=k[o]||0;var s=d.childrenScore*p*r;s>l.score&&(l={score:s,node:a,underWaterline:E(a)},console.log("found a better node scoring "+l.score+" "+l.node))}return d},E=function(a){var b,c,d,e=a.children||a.childNodes,f=window.innerHeight+y().y,g=0;d=e[0];do b=e[g++],c=x(b).y;while(e[g]&&(f>c||3===b.nodeType));if(f>c&&(b.children||b.childNodes)&&(b.children||b.childNodes.length>0)){a=b,e=a.children||a.childNodes;do b=e[g],c=x(b).y;while(e[g++]&&(f>c||3===b.nodeType))}return b};m()}();