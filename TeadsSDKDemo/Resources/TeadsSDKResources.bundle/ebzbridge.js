/**
 * This script adds Ebuzzing special sauce to the standard window.mraid object,
 *      in order to provide more native functionalities to the ad formats.
 *
 * @author Alex Hoyau <alexandre.hoyau@ebuzzing.com>
 * @copyright 2014 Ebuzzing <http://www.ebuzzing.com>
 */
(function (mraid, bridge) {
    /**
     * this is a mixin pattern
     */
    function EbzBridge(){
        // check that mraid is loaded
        if (!mraid || !bridge){
            throw new Error('mraid.js not loaded');
        }
        // check that this is the first time
        // that an instance of EbzBridge is created
        if (mraid.ebzBridge){
            throw new Error('EbzBridge has already been "mixed in" with mraid');
        }
        // reference to this EbzBridge instance
        mraid.ebzBridge = this;
        // add the method to mraid
        mraid.reward = this.reward;
        // add the method to mraid
        mraid.share = this.share;
        // add the method to mraid
        mraid.playVideo = this.playVideo;
        // add the method to mraid
        mraid.log = this.log;
    }
    /**
     * notify the native app
     * @param   {string} message         console message
     * @example mraid.log("message log")
     */
    EbzBridge.prototype.log = function(message) {
    // TODO: handle possible errors?
    // call the bridge
    bridge.executeNativeCall('log', 'message', message);
    };
    /**
     * notify the native app
     * @example mraid.reward()
     */
    EbzBridge.prototype.reward = function() {
        // TODO: handle possible errors?
        // call the bridge
        bridge.executeNativeCall('reward');
    };
    /**
     * notify the native app
     * @param   {string} platform    the network on which to share
     * @param   {string} title       title of the content
     * @param   {string} url         URL to share
     * @param   {string} imageUrl    thumbnail
     * @example mraid.share('facebook',
     *                      "share title",
     *                      "http://www.shareurl.com/",
     *                      "http://www.shareurl.com/thumb.jpeg")
     */
    EbzBridge.prototype.share = function(platform, title, url, imageUrl) {
        // TODO: handle possible errors?
        // call the bridge
        bridge.executeNativeCall('share', 'platform', platform, 'title', title, 'url', url, 'imageUrl', imageUrl);
    };
    /**
     * notify the native app
     * @param   {string} url         video URL
     * @example mraid.playVideo("http://static.ebz.io/dyn/media/ec/e5/4/4e5ec.mp4")
     */
    EbzBridge.prototype.playVideo = function(url) {
    // TODO: handle possible errors?
    // call the bridge
    bridge.executeNativeCall('playVideo', 'url', url);
    };
    // init the mixin
    var ebzBridge = new EbzBridge();
})(window.mraid, window.mraidbridge);
