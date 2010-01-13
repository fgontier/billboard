package classes
{
	import flash.display.Sprite;	
	import classes.CreateItem;
	import flash.events.Event;
	import gs.TweenGroup;
	
	public class CreateSlide extends Sprite
	{
		private var _item:CreateItem;
		private var _xml:XML;
		private var _itemPath:String;	
		private var _itemsContainer:Sprite;
		private var myGroup:TweenGroup = new TweenGroup();	

		public var slideDuration:int;	
		public var slideID:int;
		
		public function CreateSlide(itemPath:String, xml:XML) 
		{
			_xml = xml;	
			_itemPath = itemPath;											
			
			_itemsContainer = new Sprite; addChild(_itemsContainer);

			//////////////////////// create items ///////////////////////////////////////////////
			
			for(var i:Number = 0; i<_xml.item.length(); i++)				
			{
				_item = new CreateItem(_itemPath, _xml.item[i]);
				_itemsContainer.addChild(_item);		
				// adds the item tween to myGroup array:
				myGroup.push(_item.tween);
			}
			
			myGroup.align = TweenGroup.ALIGN_INIT;	
		}
		

		// function to restart flash movie with a timeline
/*		private	function restartFlashAnim(event:Event):void 
		{	
			var flashChildrenNum:int = event.target._itemsContainer.numChildren;
			for (var j:Number = 0;  j < flashChildrenNum; j++)	
			{
				var flashChildrenType:String = event.target._itemsContainer.getChildAt(j).type;
				if (flashChildrenType == "flash" && event.target.oLoader.getItemAt(j) != null)
				{				
					event.target.oLoader.getItemAt(j).target.content.gotoAndPlay(0);
				}
			}
		}
				

				
		
		private function getCurrentSlide(e:Event):void 
		{
			//trace("e.target " + e.target  + "    e.currentTarget " + e.currentTarget)
		}
*/
		public function restartGroup():void
		{
			myGroup.restart();
			//trace ("restartGroup")
		}
		
	}
}

//trace ("stuff to preload::::::::::: " + _xml.descendants("item").(@type == "image" || @type == "flash").file_name)
