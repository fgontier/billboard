package classes
{
	
    import flash.display.*;
    import flash.events.*;
    import flash.net.URLRequest;

    public class LoadDisplayObject extends Sprite {
		
		public static const PHOTO_LOADED:String	= "photo_loaded";
		public var _loader:Loader;
		private var _loaderInfo:LoaderInfo;
		private var _verbose:Boolean = false;
		private var _loadProgressString:String = "";
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		
        public function LoadDisplayObject(path:String, verbose:Boolean) {
			_verbose = verbose;
			_loader = new Loader();
            //_loader.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			_loaderInfo = _loader.contentLoaderInfo;
            _loaderInfo.addEventListener(Event.OPEN, onOpen, false, 0, true);
            _loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
            _loaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent, false, 0, true);
            _loaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
            _loaderInfo.addEventListener(Event.INIT, onInit, false, 0, true);
            _loaderInfo.addEventListener(Event.UNLOAD, onUnloadContent, false, 0, true);
			
			try {
            	_loader.load(new URLRequest(path));
            } catch (err:Error) {
                trace("Unable to load content:\n" + err.message);
            }

        }

/*        private function onClick(evt:MouseEvent):void {
            _loader.unload();
        }*/

		private function onComplete(evt:Event):void {
            _loaderInfo.removeEventListener(Event.OPEN, onOpen);
            _loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            _loaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
            _loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			addChild(_loader);
			dispatchEvent(new Event("photo_loaded"));
        }
		
		private function onProgress(evt:ProgressEvent):void {
			var loadPercent:int = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
            _loadProgressString = (loadPercent + " % loaded: " + _bytesLoaded + " bytes of " + _bytesTotal + " total bytes");
			if (_verbose) { trace(_loadProgressString); }
        }
		
		//example getters to return data for use at runtime, rather than just tracing to Output panel
		
		//use when default string is desired (e.g. status field), once or with repeating event (enter frame, timer, etc.)
		public function get progressString():String {
			return _loadProgressString
		}
		
		//use when number data is desired (e.g. progress bar), once or with repeating event (enter frame, timer, etc.)
		public function get progressNumberArray():Array {
			return [_bytesLoaded, _bytesTotal];
		}

		//if desired, add getter to return info from below. currently diagnostic tools, only tracing to Output panel

        private function onOpen(evt:Event):void {
            if (_verbose) { trace("Loading has begun."); }
        }
		
        private function onHTTPStatusEvent(evt:HTTPStatusEvent):void {
            if (_verbose) { trace("HTTP status code: " + evt.status); }
        }

		private function onIOError(evt:IOErrorEvent):void {
			if (_verbose) { trace("A loading error occurred:\n", evt.text); }
		}

        private function onInit(evt:Event):void {
            _loaderInfo.removeEventListener(Event.INIT, onInit);
			//properties of loaded asset now accessable
            if (_verbose) { 
				trace("Content initialized. Properties:"); 
				trace("    url:", evt.target.url)
				trace("    Same Domain:", evt.target.sameDomain)
				if (evt.target.contentType == "application/x-shockwave-flash") {
					trace("    SWF Version:", evt.target.swfVersion)
					trace("    AS Version:", evt.target.actionScriptVersion)
					trace("    Frame Rate:", evt.target.frameRate)
				}
			}
        }

        private function onUnloadContent(evt:Event):void {
			//halt streams in loaded content first
            _loaderInfo.removeEventListener(Event.UNLOAD, onUnloadContent);
            if (_verbose) { trace("unLoadHandler:\n", evt); }
        }
    }
}