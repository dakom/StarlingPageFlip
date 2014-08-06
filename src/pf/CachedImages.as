package pf
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	
	public class CachedImages extends Sprite
	{
		private var imgs:Object;
		private var currentShowing:int = -1;
		private var reversedOrder:Boolean;
		private var totalCount:uint;
		
		public function CachedImages(_reversedOrder:Boolean, textures:Vector.<Texture>)
		{
			var idx:uint;
			
			super();
			
			reversedOrder = _reversedOrder;
			totalCount = textures.length;
			imgs = new Object();
			
			for(idx = 0; idx < textures.length; idx++) {
				imgs[idx] = new Image(textures[idx]);
			}
		}
		
		public function hasImage(num:int) {
			
			return(imgs[num] ? true : false);
		}
		
		
		public function showImage(num:int) {
			var idx:int;
			
			if(currentShowing != num) {
				removeChildren();
				
				if(reversedOrder) {
					for(idx = totalCount-1; idx >= num; idx--) {
						addChild(imgs[idx]);	
					}
				} else {
					for(idx = 0; idx <= num; idx++) {
						addChild(imgs[idx]);
					}
				}
				
				currentShowing = num;
				
				
			}
		}
		
		public function nullify() {
			currentShowing = NaN;
			removeChildren();
		}
	}
}