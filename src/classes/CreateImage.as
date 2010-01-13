package classes
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class CreateImage extends Sprite
	{
		private var _slideImage:LoadDisplayObject;
		private var _preloader:CircleSlicePreloader;
		private var _itemNode:XML;
		private var _itemPath:String;

		public function CreateImage(itemPath:String, itemNode:XML):void 
		{
			_itemNode = itemNode;	
			_itemPath = itemPath;
			
			// add a listener to know when the image is laoded:
			this.addEventListener(LoadDisplayObject.PHOTO_LOADED, photoLoaded, true);
			
			showPreloader();
			loadImage();
		}		
		
		private function showPreloader():void
		{
			_preloader = new CircleSlicePreloader();
			addChild(_preloader);
		}
		
		private function loadImage():void
		{
			_slideImage = new LoadDisplayObject(this._itemPath  + this._itemNode.file_name, false);
			addChild(_slideImage);
		}
		
		private function photoLoaded(e:Event):void
		{	
			e.target._loader.content.smoothing = true;	// smooth the image when rezised.
			removeChild(_preloader);					// remove preloader.
			
		}
		
	}
}







