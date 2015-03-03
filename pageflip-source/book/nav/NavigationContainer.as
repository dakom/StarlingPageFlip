package book.nav
{
	import com.greensock.easing.Back;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import display.TouchSprite;
	
	import foundation.Constants;
	
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	
	public class NavigationContainer extends Sprite
	{
		
		private static const COVER:String = 'cover';
		private static const BACK_COVER:String = 'back_cover';
		
		private var totalPages:uint;
		private var bookWidth:Number;
		private var bookHeight:Number;
		private var startButton:TouchSprite;
		private var endButton:TouchSprite;
		private var middleButtons:Array;
		
		private var arrowSize:Number = 50;
		
		
		private var _currentIndex:int = -1;
		
		
		public function NavigationContainer(_totalPages:uint, _bookWidth:Number, _bookHeight:Number)
		{
			super();
			
			
			this.totalPages = _totalPages;
			this.bookWidth = _bookWidth;
			this.bookHeight = _bookHeight;
			
			initButtons();
			
			setCurrentIndex(0);
		}
		
		private function getButtonSprite(chosen:Boolean):TouchSprite {
			var spr:TouchSprite = new TouchSprite();
			var shape:Shape = getButtonShape(chosen);
			
			spr.addChild(shape);
			
			return(spr); 
		}
		
		private function getButtonShape(chosen:Boolean):Shape {
			var shape:Shape = new Shape();
			
			shape.graphics.lineStyle(1, 0x0000FF);
			if(chosen) {
				shape.graphics.beginFill(0xFFFF00);
			} else {
				shape.graphics.beginFill(0x2a2a2a);
			}
			shape.graphics.drawCircle(0,0,10);
			shape.graphics.endFill();
			
			return(shape); 
		}
		private function initButtons() {
			
			var idx:uint;
			var btn:TouchSprite;	
			
			startButton = getButtonSprite(true);
			startButton.addEventListener(TouchPhase.BEGAN, doStart);
			addChild(startButton);
		
			middleButtons = new Array();
			
			
			for(idx = 1; idx < totalPages; idx++) {
				btn = getButtonSprite(false);
				btn.name = idx.toString();
				btn.addEventListener(TouchPhase.BEGAN, doMiddle);
				btn.x = this.width + 10;
				addChild(btn);
				middleButtons.push(btn);
			}
			
			endButton = getButtonSprite(false);
			endButton.addEventListener(TouchPhase.BEGAN, doEnd);
			addChild(endButton);
			endButton.x = this.width + 10;
			addChild(endButton);
		}
		
		private function doStart(evt:Event) {
			setCurrentIndex(0);
		}
		private function doEnd(evt:Event) {
			setCurrentIndex(totalPages);
		}
		
		private function doMiddle(evt:Event) {
			var btn:TouchSprite = evt.target as TouchSprite;
			var idx:uint = uint(btn.name);
			
			setCurrentIndex(idx);
		}
		
		public function setCurrentIndex(targetIndex:uint, dispatchAfter:Boolean = true) {
			var btn:Button;
			
			
			
			toggleIndex(_currentIndex, false);
			toggleIndex(targetIndex, true);
			
			_currentIndex = targetIndex;
			
			if(dispatchAfter) {
				dispatchEventWith(Event.CHANGE, false, _currentIndex);
			}
		}
		
		private function toggleIndex(targetIndex, flag:Boolean) {
			if(targetIndex >= 0) {
				if(targetIndex == 0) {
					swapButtonSprite(startButton, flag);
				} else if(targetIndex < totalPages) {
					targetIndex--;
					
					swapButtonSprite(middleButtons[targetIndex], flag);
				} else {
					swapButtonSprite(endButton, flag);
				}
			}
		}
		
		private function swapButtonSprite(spr:TouchSprite, chosen:Boolean) {
			spr.removeChildren();
			spr.addChild(getButtonShape(chosen));
			
		}
		
		public function get currentIndex():uint {
			return(_currentIndex);
		}
		
		public function getTotalPages():uint {
			return(totalPages);
		}
	}
}