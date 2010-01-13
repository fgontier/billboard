package classes
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.net.URLRequest;
	
	import classes.GetEase;
	import classes.CreateText;

	import gs.*;
	
	public class CreateItem extends Sprite
	{
		public var type:String;
		public var tween:TweenLite;	
		
		private var _xml:XML;
		private var _itemPath:String;
		
		public function CreateItem(itemPath:String, xml:XML) 
		{
			_xml = xml;													
			_itemPath = itemPath;	
	
			// get the property values:
			var x_scale:int = _xml.prop.attribute("x_scale");					
			var y_scale:int = _xml.prop.attribute("y_scale");
			var transparency:Number = _xml.prop.attribute("transparency");
			var filter:String = _xml.prop.attribute("filter");	
							
			// get the animation values:
			var start_x:Number = _xml.anim.attribute("start_x");			
			var start_y:Number = _xml.anim.attribute("start_y");		
			var	end_x:Number  = _xml.anim.attribute("end_x");
			var end_y:Number  = _xml.anim.attribute("end_y");
			var fade_in:String = _xml.anim.attribute("fade_in");
			var duration:Number = _xml.anim.attribute("duration");
			var delay:Number = _xml.anim.attribute("delay");						//trace("delay " + delay)
			var easing:String = _xml.anim.attribute("easing");				
						
			// get the type of item:
			type = _xml.attribute("type");				
				
			switch(type)
			{
				case "button":
				{			
					var _button:CreateButton = new CreateButton (itemPath, _xml);
					addChild(_button);
	
				}	 
					break;				
				
				case "image":
				{
					var _image:CreateImage = new CreateImage (itemPath, _xml);			
					addChild(_image);
				}	
					break;
				

				case "text":
				{
					var _text:CreateText = new CreateText(_itemPath, _xml); 
					addChild(_text);
				}					
					break;
					
				case "flash":
				{
					var _flash:CreateFlash = new CreateFlash(_itemPath, _xml); 
					addChild(_flash);
				}	
					break;
					
				case "video":
					// code here to create a video
					break;
					
				case "sound":
					// code here to create a sound
					break;
					
				default:
					//Display "incorrect input"
					break;
					
			}	
			
			this.x = start_x;		
			this.y = start_y;			
			this.scaleX = x_scale;
			this.scaleY = y_scale;
			this.alpha = transparency;
			
			if (fade_in == "true") { this.alpha = 0 }	// if fade_in is true, set alpha to zero to reveal the slide.
			// assign a tween to each created items to make them fadeIn, move, etc ...)
			tween = new TweenLite(this, duration, { alpha:transparency, x:end_x, y:end_y, ease:GetEase.getEase(easing), delay:delay } );	
			
		}
			
	
	}
}