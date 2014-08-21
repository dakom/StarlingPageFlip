package foundation
{
	import starling.core.Starling;

	public class Constants
	{
		
		public static var isMobile:Boolean;
		
		public static const DESIGN_WIDTH:Number = 1024;
		public static const DESIGN_HEIGHT:Number = 768;
		
		public static const TEXTURESIZE_SD:String = 'SD';
		public static const TEXTURESIZE_HD:String = 'HD';
		
		public static function getTextureSize():String {
			return((Starling.contentScaleFactor > 1) ? TEXTURESIZE_HD : TEXTURESIZE_SD);
		}
	}
}