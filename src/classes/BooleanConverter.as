package classes
{
	public class BooleanConverter
	{
		public static function parse( value:String ):Boolean
		{
			var isBoolean:Boolean = false;
			
			switch ( value.toLowerCase() )
			{
				case "1":
				case "true":
				case "yes":
				case "y":
				case "on":
				case "enabled":
				isBoolean = true;
				break;
			}
			
			return isBoolean;
		   
		}
	}
}