package pf
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	public class CachedImages extends Sprite
	{
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		
		private var side:String;
		
		private static var totalCount:uint;
		private static var imgs:Array;
		
		public function CachedImages(_side:String, textures:Vector.<Texture>)
		{
			var idx:uint;
			var img:Image;
			
			super();
			
			side = _side;
			
			if(imgs == null) {
				totalCount = textures.length;
				imgs = new Array();
			
				for(idx = 0; idx < textures.length; idx++) {
					imgs.push(new Image(textures[idx]));
				}
			}
			
			for(idx = 0; idx < textures.length; idx++) {
				if(willShow(idx)) {
					img = imgs[idx];
					
					if(side == RIGHT) {
						img.filter = BlurFilter.createDropShadow(4, deg2rad(45), 0, .5,3,.5);
					} else {
						img.filter = BlurFilter.createDropShadow(4, deg2rad(135), 0, .5,3,.5);
					}
				}
			}
		}
		
		public function showImage(num:int) {
			var idx:int;
			var img:Image;
			var spacing:Number = 10;
			var offset:int;
			
			removeChildren();
			
			if(num >= 0 && num < totalCount) {
				if(side == RIGHT) {
					for(idx = totalCount-1, offset = (idx-num); idx >= num; idx--, offset--) {
						if(willShow(idx)) {
							img = imgs[idx];
							img.x = (offset*spacing);
							addChild(img);
						}
					}
				} else {
					for(idx = 0, offset = num; idx <= num; idx++, offset--) {
						if(willShow(idx)) {
							img = imgs[idx];
							img.x = -(offset * spacing);
							addChild(img);
						}
					
					}
				}
			}
		}
		
		
		private function willShow(idx:int):Boolean {
			var ret:Boolean;
			
			if(((idx%2 == 0) && side == RIGHT) || ((idx%2 != 0) && side == LEFT)) {
				ret = true;
			} else {
				ret = false;
			}
			
			return(ret);
		}
		
	}
}