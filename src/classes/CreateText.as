package classes 
{
	import flash.display.Sprite;
	import flash.text.*
	import flash.events.*;
	import classes.LoadFont;
	
	public class CreateText extends TextField
	{
		private var _itemNode:XML;
		private var _itemPath:String;
		
		private var _textFont:String;
		private var _format:TextFormat;
	
		public var loadFont:LoadFont;
		
		public function CreateText(itemPath:String, itemNode:XML) 
		{																	
			_itemPath = itemPath;
			_itemNode = itemNode;		
			
			_textFont = itemNode.text.attribute("font");
			loadFont = new LoadFont(_itemPath + _textFont, ["MyFont"]);
			
			/////// IMPORTANT //////
			// in order to not have a security sand box problem with relative path, 
			// add in C:\Users\fgontier\AppData\Roaming\Macromedia\Flash Player\#Security\FlashPlayerTrust
			// a lines with the URL of the loaded assets, like:
			// C:\Users\fgontier\Documents\boulot\globalworks\Hughes\Enterprise\SlideShow2\bin
			// C:\Users\fgontier\Documents\boulot\globalworks\Hughes\Enterprise\SlideShow2\bin\images
			///////
			
 	 	 	loadFont.addEventListener(LoadFont.COMPLETE, successLoadFont);
		}
		
 	 	private function successLoadFont(e:Event):void
		{ 
			_format				= new TextFormat();
			_format.color		= _itemNode.text.attribute("color");
			_format.size		= _itemNode.text.attribute("size");
			_format.leading		= _itemNode.text.attribute("leading");	
			_format.align		= "left";	
			
 	 	 	var embeddedFonts:Array = Font.enumerateFonts(false);  //trace (Font.enumerateFonts())
			
 	 	 	_format.font = e.target.getFont("MyFont").fontName;	
			
			antiAliasType		= AntiAliasType.ADVANCED;
			autoSize			= TextFieldAutoSize.LEFT;
			border				= BooleanConverter.parse(_itemNode.text.attribute("border"));
			multiline			= true;
			selectable			= false;
			sharpness			= 0;
			wordWrap			= true;
			width				= _itemNode.text.attribute("width");
			embedFonts			= true;	
			
			defaultTextFormat	= _format;	
			text 				= _itemNode.text;
		}
		
	}	

}