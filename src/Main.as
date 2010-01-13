package 
{
	import classes.BooleanConverter;
	import classes.CreateSlideShow;
	import classes.XmlLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import com.perkstoveland.utils.Scroller;	
	
	import com.google.analytics.GATracker;
	
	public class Main extends MovieClip 
	{
		public var xmlData:XML;
		public var itemPath:String;	
		public var tracker:GATracker; // @ Creating the GA Object
	
		
		private var _loader:XmlLoader;
		private var _slideShow:CreateSlideShow;

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			// entry point
			
			// get the xml file:
			var _slideshowData:String = root.loaderInfo.parameters.slideshow_data; 
			if ( _slideshowData == null ) _slideshowData = "../images/billboard/slides.xml"; 
			//trace("_slideshowData " + _slideshowData)
			
			_loader = new XmlLoader(_slideshowData); 					
			_loader.addEventListener(Event.COMPLETE, onXmlReady); 	
		}
		
		private function onXmlReady(e:Event):void 
		{
			_loader.removeEventListener(Event.COMPLETE, onXmlReady); 
			
			xmlData = e.target.xml as XML;
			itemPath = xmlData.properties.item_host.toString() + xmlData.properties.item_root.toString();	// get the itemPath		
			
			/** create the GA Object**/
			if (xmlData.properties.ga.@active == true)
			{
				var _account_id:String = xmlData.properties.ga.account_id.toString();
				var _bridge_mode:String = xmlData.properties.ga.bridge_mode.toString();
				var _debug_mode:Boolean = BooleanConverter.parse(xmlData.properties.ga.debug_mode);
				tracker = new GATracker( this, _account_id, _bridge_mode, _debug_mode ); 
			}
			
			/** create the slide show **/
			_slideShow = new CreateSlideShow(itemPath, xmlData);
			addChild(_slideShow);
	
			
			// if we have debugXML = true:
			var _debugXML:String = root.loaderInfo.parameters.debugXML; 
			//_debugXML = "true";
			if (_debugXML == "true") 
			{
			  var txt:TextField = new TextField();
			  txt.multiline = true;
			  txt.wordWrap = true;
			  txt.autoSize = TextFieldAutoSize.LEFT;
			  txt.background = true
			  txt.width = 600;
			  txt.text = "xmlData " + xmlData;
			  // Lastly we create the scroller, position it, and add it to the display stack.
			  var scroller:Scroller = new Scroller( txt, 320, 0x333333 );
			  scroller.x = 0;
			  scroller.y = 0;
			  addChild( scroller );	
			}	
				
		}	
		
	}
}