package classes 
{
	import flash.display.Sprite;
	import gs.easing.*;
	
	/**
	 * ...
	 * @author fred
	 */
	public class GetEase 
	{
		
		public static function getEase(str:String):Function 
		{
			switch (str) {
						
				case "Back.easeOut":
					return Back.easeOut;
				case "Back.easeIn":
					return Back.easeIn;
				case "Back.easeInOut":
					return Back.easeInOut;
		 
				case "Bounce.easeOut":
					return Bounce.easeOut;
				case "Bounce.easeIn":
					return Bounce.easeIn;
				case "Bounce.easeInOut":
					return Bounce.easeInOut;
		 
				case "Elastic.easeOut":
					return Elastic.easeOut;
				case "Elastic.easeIn":
					return Elastic.easeIn;
				case "Elastic.easeInOut":
					return Elastic.easeInOut;
		 
				case "Strong.easeOut":
					return Strong.easeOut;
				case "Strong.easeIn":
					return Strong.easeIn;
				case "Strong.easeInOut":
					return Strong.easeInOut;
					
					default:
					return Strong.easeIn;
		 
			}
		}

	}
	
}