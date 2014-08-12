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
		
		private var side:String;
		
		private static var totalCount:uint;
		private static var imgs:Array;
		
		public function CachedImages(_side:String, textures:Vector.<Texture>)
		{
			var idx:uint;
			
			super();
			
			side = _side;
			
			if(imgs == null) {
				totalCount = textures.length;
				imgs = new Array();
			
				for(idx = 0; idx < textures.length; idx++) {
					imgs.push(new Image(textures[idx]));
				}
			}
		}
		
		public function showImage(num:int) {
			var idx:int;
			var img:Image;
			var spacing:Number = 10;
			var offset:int;
			
			removeChildren();
			
			if(side == RIGHT) {
				for(idx = totalCount-1, offset = (idx-num); idx >= num; idx--, offset--) {
					if(idx %2 == 0) {
						img = imgs[idx];
						img.x = (offset*spacing);
						addChild(img);
					}
				}
			} else {
				for(idx = 0, offset = num; idx <= num; idx++, offset--) {
					if(idx % 2 != 0) {
						img = imgs[idx];
						img.x = -(offset * spacing);
						addChild(img);
					}
					
				}
			}
		}
		
		public function nullify() {
			removeChildren();
		}
		
	}
}