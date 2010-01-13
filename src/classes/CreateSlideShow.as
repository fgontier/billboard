package classes
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import gs.*;
	import gs.easing.*;
	import gs.plugins.*;

	
	public class CreateSlideShow extends Sprite
	{

		private var _xml:XML;
		private var _itemPath:String;
		private var _slideContainer:Sprite;		
		private var _slide:CreateSlide;
		private var _navigationContainer:Sprite;		
		private var _nav:CreateSlide;
		
		private var _spinTimer:Timer;	
		private var _totalSlide:int;
		private var _currentSlideIndex:int = 0;
		
		private var _currentSlide:DisplayObject;

		public function CreateSlideShow(itemPath:String, xml:XML) 
		{
			_xml = xml;	
			
			_itemPath = itemPath;
			_totalSlide = _xml.slides.slide.length();
			TweenPlugin.activate([ColorTransformPlugin]);
						
			
			/////////////////// create the slides //////////////////////
			
			_slideContainer = new Sprite(); addChild(_slideContainer);
						
			for (var i:Number = 0;  i < _totalSlide; i++)	
			{
				_slide = new CreateSlide(_itemPath, _xml.slides.slide[i]);
				// sets the slide name:				
				_slide.name = String(i) ;
				// sets the slide duration for that slide:
				_slide.slideDuration = _xml.slides.slide[i].attribute("slideDuration");
				_slide.visible = false;
				_slideContainer.addChild(_slide);
			}
						
			/////////////////// if we have a navigation //////////////////////
			
			if (_xml.navigations.@active == true) 										
			{
				_navigationContainer = new Sprite(); addChild(_navigationContainer);
				
				for (var j:Number = 0;  j < _xml.navigations.navigation.length(); j++)
				{			
					_nav = new CreateSlide(_itemPath, _xml.navigations.navigation[j]);		
					_navigationContainer.addChild(_nav);
					// sets the _nav name:				
					_nav.name = String(j);
				}
				
			}
			
			/////////////////// show the first slide at level 0 and start the timer ///////////////////
			
			_currentSlide = _slideContainer.getChildByName("0");
			_currentSlide.visible = true;
			var newSlideDuration:int = CreateSlide(_slideContainer.getChildByName(String(_currentSlideIndex))).slideDuration;
			// starts the slide show:
			startTimer(newSlideDuration);
			
			/////////////////// listen to event dispatched by nav button ///////////////////

			this.addEventListener("from_button", events_From_Nav_Button, true);
			this.addEventListener("restart_slideShow", mouseOut_restart_slideShow, true);		
		}	
		
		private function mouseOut_restart_slideShow(e:Event):void 
		{
			_spinTimer.start();
		}
		
		private function events_From_Nav_Button(e:Event):void 
		{
			//////////////////////////// google analytics ///////////////////////////////////////
			// if we have an eventCategory, send events to Google Analytics tracker in Main class:			
			if (e.target.eventCategory != "") 
			{
				(this.parent as MovieClip).tracker.trackEvent(e.target.eventCategory, e.target.eventAction, e.target.eventLabel, e.target.eventValue);	
				
			}
			
			//////////////////////////// goto slide ///////////////////////////////////////
			// set the slide to go to. 
			if (e.target.gotoSlide) 
			{ 
				_currentSlideIndex = e.target.gotoSlide;  
				showSlide(String(_currentSlideIndex - 1));
				_spinTimer.stop();
				
				// TODO implement "nextSlide" and "previousSlide" possible values for gotoSlide.
			}
			
			//////////////////////////// goto external page ///////////////////////////////////////
			// set the href page to go to.
			if (e.target.href) 
			{ 
				_currentSlideIndex = e.target.href;  
				var request:URLRequest = new URLRequest(e.target.href);
				navigateToURL(request, "_top");	
				// TODO "_top" is hard codded ... go to: "http://www.broadskies.net/flexmerge/2008/06/30/opening-external-links-from-as3/" for "_blank" multi browser solution...
			}		
		}
		
		
		private function startTimer(newSlideDuration:int):void
		{
			_spinTimer = new Timer(newSlideDuration * 1000);
			_spinTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_spinTimer.start();		
		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			setNextSlide();
		}
		
		private function setNextSlide():void
		{
			if (_currentSlideIndex < _totalSlide -1) 
			{ 
				_currentSlideIndex++;
			}
			else
			{
				_currentSlideIndex = 0 
			};

			// show the next slide:
			showSlide(String(_currentSlideIndex ));
			
		}
		
		
		private function showSlide(myNewSlide:String):void
		{	
			// kill any current tweening:
			TweenMax.killTweensOf(_slideContainer.getChildByName(myNewSlide), true);
			
			
			// if the current slide is not alreday on top of the _slideContainer display list (remove flashing effect when roll over nav button):
			if (_slideContainer.getChildIndex(_slideContainer.getChildByName(myNewSlide)) < _slideContainer.numChildren -1) 
			{				
				// moves the new slide to the top level in _slideContainer:
				_slideContainer.setChildIndex(_slideContainer.getChildByName(myNewSlide), (_slideContainer.numChildren -1));
				
				// makes the slide transition:
				_slideContainer.getChildByName(myNewSlide).visible = true;
				TweenMax.from(_slideContainer.getChildByName(myNewSlide), 0.5, { colorTransform: { exposure:2, alphaMultiplier:0.5 }, onComplete:onFinishTween } );
								
				// re-set the timer delay with the new slide duration:
				var newSlideDuration:int = CreateSlide(_slideContainer.getChildByName(String(myNewSlide))).slideDuration; 
				_spinTimer.delay = newSlideDuration * 1000;
				
				// restart the animations (tween) ofr all the items in the new slide:
				CreateSlide(_slideContainer.getChildByName(String(myNewSlide))).restartGroup();
			}
		
		}
		
		private function onFinishTween():void
		{
			
		}
		
	}
}