package classes
{
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	
	public class XmlLoader extends EventDispatcher{
		
		private var _loader:URLLoader;
		private var _xml:XML;
		
		public function XmlLoader(path:String){
			_loader = new URLLoader();
			try{
				_loader.load(new URLRequest(path));
			}catch(e:Error){
				trace("error in loading the XML file")
			}
			_loader.addEventListener(Event.COMPLETE,onLoadXml);
		}
		
		private function onLoadXml(event:Event):void{
			trace("xml loaded")
			_xml = XML(URLLoader(event.target).data)
			dispatchEvent(new Event(Event.COMPLETE));
		}	
		
		public function get xml():XML{
			return _xml;
		}
	}
}
