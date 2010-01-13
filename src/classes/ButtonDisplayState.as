package classes 
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;

	public class ButtonDisplayState extends Sprite 
	{
		private var _buttonStateNode:XMLList;
		private var _itemPath:String;
		private var _itemsContainer:Sprite;
		private var _item:CreateItem;

		public function ButtonDisplayState(itemPath:String, buttonStateNode:XMLList) 
		{
			_buttonStateNode = buttonStateNode;				
			_itemPath = itemPath;
			
			_itemsContainer = new Sprite; addChild(_itemsContainer);

			//////////////////////// create items ///////////////////////////////////////////////

			for(var i:Number = 0; i<_buttonStateNode.item.length(); i++)				
			{	
				_item = new CreateItem(_itemPath, _buttonStateNode.item[i]);		
				//trace("_buttonStateNode " + _buttonStateNode.item[i])
				_itemsContainer.addChild(_item);	
			}	
				
		}

	}	
}