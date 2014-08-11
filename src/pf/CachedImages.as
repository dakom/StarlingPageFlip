package pf
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	public class CachedImages extends Sprite
	{
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		
		private var imgs:Object;
		private var side:String;
		private var totalCount:uint;
		
		public function CachedImages(_side:String, textures:Vector.<Texture>)
		{
			var idx:uint;
			
			super();
			
			side = _side;
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
			var img:Image;
			var spacing:Number = 10;
			var offset:int;
			
			removeChildren();
			
			if(side == RIGHT) {
				for(idx = totalCount-1, offset = (idx-num); idx >= num; idx--, offset--) {
					img = imgs[idx];
					
					img.x = (offset*spacing);
					
					addChild(img);
				}
			} else {
				for(idx = 0, offset = num; idx <= num; idx++, offset--) {
					img = imgs[idx];
					
					img.x = -(offset * spacing);
					
					addChild(img);
					
				}
			}
			
		}
		
		public function nullify() {
			removeChildren();
		}
	}
}