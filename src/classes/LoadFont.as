package classes 
{
 	import flash.display.*;
 	import flash.events.*;
 	import flash.text.*;
 	import flash.errors.*;
 	import flash.system.*;
 	import flash.net.*;
	
 	public class LoadFont extends EventDispatcher {
 	 	public static const COMPLETE:String = "complete";
 	 	public static const ERROR:String = "error loading font";
 	 	private var loader:Loader = new Loader();
 	 	private var _fontsDomain:ApplicationDomain;
 	 	private var _fontName:Array;
		
 	 	public function LoadFont(url:String, fontName:Array):void  
		{
 	 	 	_fontName = fontName;						
 	 	 	loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, font_ioErrorHandler);
 	 	 	loader.contentLoaderInfo.addEventListener(Event.COMPLETE, finished);
 	 	 	loadAsset(url);
 	 	}

 	 	private function loadAsset(url:String):void 
		{
 	 	 	var request:URLRequest = new URLRequest(url);
 	 	 	loader.load(request);
 	 	 }	
		
		private function finished(evt:Event):void 
		{
			_fontsDomain = loader.contentLoaderInfo.applicationDomain;  
			registerFonts(_fontName);	
 	 	 	this.dispatchEvent(new Event(LoadFont.COMPLETE));
 	 	}
			
 	 	private function font_ioErrorHandler(evt:Event):void {
 	 	 	dispatchEvent(new Event(LoadFont.ERROR));
			trace("ERROR " + evt.type)
 	 	 }
		 
 	 	public function registerFonts(fontList:Array):void {

 	 	 	for (var i:uint = 0; i < fontList.length; i++) 
			{
 	 	 	 	Font.registerFont(getFontClass(fontList[i]));
 	 	 	}
 	 	}	
			
 	 	public function getFontClass(id:String):Class 
		{
 	 	 	return _fontsDomain.getDefinition(id) as Class;
 	 	}
		
 	 	public function getFont(id:String):Font 
		{
 	 	 	var fontClass:Class = getFontClass(id);
 	 	 	return new fontClass as Font;				
 	 	}
 	}
}