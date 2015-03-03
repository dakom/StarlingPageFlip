package book.nav
{
	public class NavigationAnimationInfo
	{
		public var targetPage:uint;
		public var targetDir:String;
		
		public function NavigationAnimationInfo(_targetPage:uint, _targetDir:String)
		{
			targetPage = _targetPage;
			targetDir = _targetDir;
		}
		
		public function getTargetSpeed(currentPage:uint):Number {
			var diff:Number = Math.abs(currentPage - targetPage);
			
			//this is kinda ugly, I'm sure there's a more elegant solution, but it works...
			switch(diff) {
				case 0:		diff = 1; break;
				case 1:		diff = .75; break;
				default:	break;
			}
			return(1/ diff);
		}
	}
}