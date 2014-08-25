package book.nav
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import foundation.Constants;
	
	import starling.display.Graphics;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	
	
	public class NavigationContainer extends Sprite
	{
		private var totalPages:uint;
		private var bookWidth:Number;
		private var bookHeight:Number;
		private var leftArrow:Shape;
		private var rightArrow:Shape;
		private var circles:Array;
		
		private var arrowSize:Number = 50;
		private var circleSize:Number = arrowSize/2;
		private var buttonLineColor:uint = 0x00FF00;
		private var buttonFillColor:uint = 0x0000FF;
		
		private var _currentIndex:int = -1;
		
		private static var sHelperRect:Rectangle = new Rectangle();
		private static var sHelperTouches:Vector.<Touch> = new <Touch>[];
		private static var sHelperPoint:Point = new Point();
		
		private var bgRect:Shape;
		
		
		public function NavigationContainer(_totalPages:uint, _bookWidth:Number, _bookHeight:Number)
		{
			super();
			
			this.totalPages = _totalPages;
			this.bookWidth = _bookWidth;
			this.bookHeight = _bookHeight;
			
			initButtons();
			
			setCurrentIndex(0);
			
			this.addEventListener(TouchEvent.TOUCH, gotTouch);
			
		
			this.x = arrowSize/2 + (Constants.DESIGN_WIDTH - (this.width))/2;
			this.y = 630;
		}
		
		private function initButtons() {
			
			var idx:uint;
			var circle:Shape;
			var bg:Graphics;
			var lastRect:Rectangle = new Rectangle();
			
			leftArrow = drawTriangle(new Shape(), arrowSize, buttonLineColor, buttonFillColor);
			leftArrow.pivotX = leftArrow.width  / 2;
			leftArrow.pivotY = leftArrow.height / 2;
			leftArrow.rotation = deg2rad(-90);
			addChild(leftArrow);
		
			circles = new Array();
			
			bgRect = new Shape();
			bg = bgRect.graphics;
			bg.beginFill(0xFF0000, .3);
			bg.lineStyle(1, 0xFFFFFF, .5);
			
			for(idx = 0; idx < totalPages; idx++) {
				
				circle = drawCircle(new Shape(), circleSize, buttonLineColor, -1);
				circle.name = idx.toString();
				circle.x = this.width + 10;
				addChild(circle);
				circles.push(circle);
				
				if(!idx || idx == totalPages-1) {
					lastRect.x = circle.x - circleSize;
					lastRect.y = circle.y - circleSize;
					lastRect.width = circle.width;
					lastRect.height = circle.height;
				} else if((idx % 2)) {
					lastRect.x = circle.x - circleSize;
					lastRect.y = circle.y - circleSize;
					lastRect.width = circle.width;
					lastRect.height = circle.height;
				} else {
					lastRect.width = (circle.width*2)+10;
				}
				
				
				if(!idx || !(idx % 2) || idx == totalPages-1) {
					bg.drawRect(lastRect.x, lastRect.y, lastRect.width, lastRect.height);
				}
			}
			
			rightArrow = drawTriangle(new Shape(), arrowSize, buttonLineColor, buttonFillColor);
			rightArrow.pivotX = rightArrow.width  / 2;
			rightArrow.pivotY = rightArrow.height / 2;
			rightArrow.rotation = deg2rad(90);
			rightArrow.x = this.width + 10;
			addChild(rightArrow);
			
			
			addChildAt(bgRect, 0);
		}
		
		private function drawTriangle(shape:Shape, height:Number, lineColor:int, fillColor:int):Shape {
			var g:Graphics = shape.graphics;
			
			g.clear();
			if(fillColor >= 0) {
				g.beginFill(fillColor);
			}
			if(lineColor >= 0) {
				g.lineStyle(1,lineColor);
			}
			g.moveTo(height/2, 0);
			g.lineTo(height, height);
			g.lineTo(0, height);
			g.lineTo(height/2, 0);
			 
			return(shape);
		}
		
		private function drawCircle(shape:Shape, radius:Number, lineColor:int, fillColor:int):Shape {
			var g:Graphics = shape.graphics;
			
			g.clear();
			if(fillColor >= 0) {
				g.beginFill(fillColor);
			}
			if(lineColor >= 0) {
				g.lineStyle(1,lineColor);
			}
			g.drawCircle(0,0,radius);
			
			return(shape);
		}
		
		private function gotTouch(touchEvent:TouchEvent) {
			var touch:Touch;
			var circle:Shape;
			
			sHelperTouches.length = 0;
			touchEvent.getTouches(this, TouchPhase.BEGAN, sHelperTouches);
			for each(touch in sHelperTouches) {
				touch.getLocation(this,sHelperPoint);
				
				if(leftArrow.bounds.containsPoint(sHelperPoint)) {
					doPrevious();
				} else if(rightArrow.bounds.containsPoint(sHelperPoint)) {
					doNext();
				} else {
					for each(circle in circles) {
						if(circle.bounds.containsPoint(sHelperPoint)) {
							doJump(uint(circle.name));
							break;
						}
					}
				}
			}
		}
		
		private function doPrevious() {
			if(_currentIndex > 0) {
				setCurrentIndex(_currentIndex-1);
			}
		}
		
		private function doNext() {
			if(_currentIndex < (totalPages-1)) {
				setCurrentIndex(_currentIndex+1);
			}
		}
		
		private function doJump(idx:uint) {
			setCurrentIndex(idx);
		}
		
		
		public function setCurrentIndex(targetIndex:uint, dispatchAfter:Boolean = true) {
			var circle:Shape;
			
			if(_currentIndex >= 0) {
				circle = circles[_currentIndex];
				drawCircle(circle, circleSize, buttonLineColor, -1);
			}
			_currentIndex = targetIndex;
			
			circle = circles[_currentIndex];
			drawCircle(circle, circleSize, buttonLineColor, buttonFillColor);
			
			if(!_currentIndex) {
				leftArrow.alpha = .3;
			} else {
				leftArrow.alpha = 1;
			}
			
			if(_currentIndex == totalPages-1) {
				rightArrow.alpha = .3;
			} else {
				rightArrow.alpha = 1;
			}
			
			
			if(dispatchAfter) {
				dispatchEventWith(Event.CHANGE, false, _currentIndex);
			}
		}
		
		public function get currentIndex():uint {
			return(_currentIndex);
		}
	}
}