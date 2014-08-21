package book.pf
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
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
		private static var sHelperTouches:Vector.<Touch> = new <Touch>[];
		private var currentIndex:int;
		
		
		
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
					
					
					img.addEventListener(TouchEvent.TOUCH,onTouchHandler);
				}
			}
			
			
		}
		
		private function onTouchHandler(evt:TouchEvent) {
			var touch:Touch;
			var idx:uint;
			var img:Image = evt.target as Image;
			
			sHelperTouches.length = 0;
			evt.getTouches(img, TouchPhase.BEGAN, sHelperTouches);
			for each(touch in sHelperTouches) {
				idx = imgs.indexOf(img);
				
				
				if(idx != currentIndex) {
					dispatchEventWith(Event.CHANGE, false, idx);
				}
			}
		}
		
		public function showImage(num:int) {
			var idx:int;
			var img:Image;
			var spacing:Number = 10;
			var offset:int;
			
			removeChildren();
			
			currentIndex = num;
			
			
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
			
			//This causes more and more textures to allocate (in Scout), eventually crashing the app
			//this.flatten();
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