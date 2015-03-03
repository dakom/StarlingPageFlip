package display
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public dynamic class TouchSprite extends Sprite
	{
		
		private var isDragging:Boolean = false;
		private var dragOffsetX:Number = 0;
		private var dragOffsetY:Number = 0;
		private var isMoving:Boolean = false;
		private static var sHelperRect:Rectangle = new Rectangle();
		private static var sHelperTouches:Vector.<Touch> = new <Touch>[];
		protected static var sHelperPoint:Point = new Point();
		private var allowX:Boolean;
		private var allowY:Boolean;
		
		public function TouchSprite(autoDisposeWhenRemovedFromStage:Boolean = true)
		{
			super();
			
			
			addTouchListener();
			
			if(autoDisposeWhenRemovedFromStage) {
				this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			}
		}
		
		private function removedFromStage(evt:Event) {
			dispose();
		}
		
		override public function dispose():void {
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			removeTouchListener();
			
			
			super.dispose();	
		}
		
		//Meant to be overridden for testing drag area
		public function inDragArea(touch:Touch):Boolean {
			return(true);
		}
		
		public function adjustXAfterDrag():void {
			
		}
		public function adjustYAfterDrag():void {
			
		}
		
		public function addTouchListener() {
			this.addEventListener(TouchEvent.TOUCH, gotTouch);
		}
		public function removeTouchListener() {
			this.removeEventListener(TouchEvent.TOUCH, gotTouch);
		}
		
		private function gotTouch(touchEvent:TouchEvent) {
			var touch:Touch;
			
			sHelperTouches.length = 0;
			touchEvent.getTouches(this, null, sHelperTouches);
			for each(touch in sHelperTouches) {
				if(isDragging && this.parent != null) {
					touch.getLocation(this.parent,sHelperPoint);
					if(touch.phase == TouchPhase.BEGAN) {
						if(inDragArea(touch)) {
							isMoving = true;
							dragOffsetX = (sHelperPoint.x - this.x);
							dragOffsetY = (sHelperPoint.y - this.y);
							updateDrag();
						}
					} else if(touch.phase == TouchPhase.MOVED && isMoving) {
						updateDrag();
					}
				}
				if(touch.phase == TouchPhase.ENDED) {
					isMoving = false;
				}
				dispatchEventWith(touch.phase, false, {touch: touch}); 
				//using generic object because maybe we'll want to exapand this with more data, and data.touch is better support for legacy than data = touch. 
				//Maybe it should be custom object so we always know what properties are available
			}
			
			
		}
		
		public function startDrag(_allowX:Boolean = true, _allowY:Boolean = true) {
			allowX = _allowX;
			allowY = _allowY;
			isDragging = true;
		}
		
		public function stopDrag() {
			isDragging = false;
		}
		
		private function updateDrag() {
			var targetX:Number = sHelperPoint.x - dragOffsetX;
			var targetY:Number = sHelperPoint.y - dragOffsetY;
			
			//Update Dec 10 2013, used sHelperPoint instead of new point!
			if(allowX) {
				this.x = targetX;
				adjustXAfterDrag();
			}
			if(allowY) {
				this.y = targetY;
				adjustYAfterDrag();
			}
		}
		
		
	}
}