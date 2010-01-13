package com.sitedaniel.text
{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.EventDispatcher;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.text.Font;
 
    public class FontControl extends EventDispatcher
    {
        public static  const COMPLETE:String = "font_load_complete";
        public static  const ERROR:String = "font_load_error";
        public static  var FONTS:Array;
 
        private var _loader:Loader;
        private var _domain:ApplicationDomain;
 
        public function FontControl() {
        }
        public function load(path:String, fontArr:Array):void
        {
            FONTS = fontArr;
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, _ioErrHdlr);
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loadComplete);
            _loader.load(new URLRequest(path));
        }
 
        private function _loadComplete(e:Event):void
        {
            _domain = _loader.contentLoaderInfo.applicationDomain;
            _registerFonts();
            var embeddedFonts:Array = Font.enumerateFonts(false);
        }
 
        private function _registerFonts():void
        {
            for (var i:uint = 0; FONTS[i]; i++)
            {
                Font.registerFont(_domain.getDefinition(FONTS[i].id) as Class);
            }
            dispatchEvent(new Event(COMPLETE));
        }
 
        private function _ioErrHdlr(e:IOErrorEvent):void
        {
            trace(e);
            dispatchEvent(new Event(ERROR));
        }
    }
}
