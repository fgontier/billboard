package classes 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CreateButton extends SimpleButton 
	{
		private var _itemNode:XML;
		private var _itemPath:String;
		private var _type:String;
		
		public var href:String;
		public var target:String;							
		public var gotoSlide:String;
		public var eventCategory:String;	
		public var eventAction:String;		
		public var eventLabel:String;			
		public var eventValue:Number;	
		
		public function CreateButton(itemPath:String, itemNode:XML) 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			_itemNode = itemNode;	
			_itemPath = itemPath;
		}
		
		private function init(evt:Event):void  
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// gets data for that button:
			href = _itemNode.a.attribute("href");
			target = _itemNode.a.attribute("target");
			gotoSlide = _itemNode.a.attribute("gotoSlide"); 
			_type = _itemNode.a.attribute("type");
			
			// gets Google analytics data:
			eventCategory = _itemNode.analytics.attribute("eventCategory");	
			eventAction = _itemNode.analytics.attribute("eventAction");		
			eventLabel = _itemNode.analytics.attribute("eventLabel");			
			eventValue = _itemNode.analytics.attribute("eventValue");	

			// creates the button states:
			upState = new ButtonDisplayState(_itemPath, _itemNode.upState);
			overState = new ButtonDisplayState(_itemPath, _itemNode.overState);
			downState = new ButtonDisplayState(_itemPath, _itemNode.downState);  
			hitTestState = upState;
			useHandCursor  = true;	
			
			// TODO : add the href, target, gotoslide in the downState or overState.
			
			// adds button event:
			if (_type == "mouseover")
			{
				this.addEventListener (MouseEvent.MOUSE_OVER, buttonEvent);
				this.addEventListener (MouseEvent.MOUSE_OUT, buttonMouseOut);
			}
			if (_type == "mousedown")
			{
				this.addEventListener (MouseEvent.CLICK, buttonEvent);
			}	
			
//this.upState = overState
//this.parent.stage.addEventListener("testEvent", testEventHandler);
			
			//trace("_itemNode " + _itemNode.a.@gotoSlide)
		}
		
		private function buttonMouseOut(e:MouseEvent):void 
		{
			this.dispatchEvent(new Event("restart_slideShow"));
		}
		
		private function buttonEvent(e:Event):void 
		{
			this.dispatchEvent(new Event("from_button"));
			//trace("click " + gotoSlide)
		}
		
		
		
		
		
		
		
		private function testEventHandler(e:Event):void
		{
				trace ("e " + e.type)
		}
		
		
	}
}