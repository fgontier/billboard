package classes.loading 
{
    import flash.events.*;
    import flash.net.*;
    
	public class LoadURL extends EventDispatcher 
	{
		private var _loader:URLLoader;
		private var _loaderData:*;
		private var _verbose:Boolean = false;
		private var _loadProgress:String = "";
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		
		function LoadURL(path:String, verbose:Boolean=false, format:String="text") 
		{	
			_loader = new URLLoader();
			_verbose = verbose;
			//if (format != "text") {
				_loader.dataFormat = format;
			//}
			
            _loader.addEventListener(Event.OPEN, onOpen, false, 0, true);
            _loader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
            _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent, false, 0, true);
            _loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
			
			try {
            	_loader.load(new URLRequest(path));
            } catch (err:Error) {
                trace("Unable to load document:\n" + err.message);
            }
		}

        private function onProgress(evt:ProgressEvent):void 
		{
			var loadPercent:int = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
			_bytesLoaded = evt.bytesLoaded;
			_bytesTotal = evt.bytesTotal;
            _loadProgress = ("The document is " + loadPercent + " % loaded: " + _bytesLoaded + " bytes of " + _bytesTotal + " total bytes");
			if (_verbose) { trace("_loadProgress: " + _loadProgress); }
        }
		
        private function onComplete(evt:Event):void 
		{
            _loader.removeEventListener(Event.OPEN, onOpen);
            _loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
            _loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatusEvent);
            _loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			_loaderData = evt.target.data;						
			dispatchEvent(new Event("dataLoaded"));				
        }
		
		//getter to send data when requested. optionally change to returning from complete handler.
		public function get urlData():* 
		{
			//dataFormat: URLLoaderDataFormat.TEXT / "text" returns String;
			//dataFormat: URLLoaderDataFormat.BINARY / "binary" returns ByteArray;
			//dataFormat: URLLoaderDataFormat.VARIABLES / "variables" returns URLVariables;
			return _loaderData;
		}
		
		//example getters to return data for use at runtime, rather than just tracing to Output panel
		//use when default string is desired (e.g. status field), once or with repeating event (enter frame, timer, etc.)
		public function get progressString():String 
		{
			return _loadProgress
		}
		
		//use when number data is desired (e.g. progress bar), once or with repeating event (enter frame, timer, etc.)
		public function get progressNumberArray():Array 
		{
			return [_bytesLoaded, _bytesTotal];
		}

		//if desired, add getter to return info from below when requested.
		//currently diagnostic tools tracing to Output panel

        private function onOpen(evt:Event):void 
		{
            if (_verbose) { trace("Loading has begun."); }
        }
		
        private function onHTTPStatusEvent(evt:HTTPStatusEvent):void 
		{
            if (_verbose) { trace("HTTP status code: " + evt.status); }
        }
		
        private function onSecurityError(evt:SecurityErrorEvent):void 
		{
            if (_verbose) { trace("A security error occured:\n", evt.text); }
        }

		private function onIOError(evt:IOErrorEvent):void 
		{
			if (_verbose) { trace("A loading error occurred:\n", evt.text) }
		}
	}
}