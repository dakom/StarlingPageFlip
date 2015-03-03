package book.page
{
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import away3d.bounds.NullBounds;
	
	import book.nav.NavigationAnimationInfo;
	
	import display.TouchSprite;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	
	
	public class PageManager extends TouchSprite
	{
		public static const CONSERVE_MEMORY:Boolean = false; //this will conserve memory but be less responsive at runtime
		public static const SAFE_TOUCHES:Boolean = true; //this will wait till flips are done till allowing touch events... setting to false can have unexpected results when going crazy
		
		private static const NEXT:String = 'next';
		private static const PREV:String = 'prev';
		
		protected static var sHelperPoint:Point = new Point();
		
		private var pages:Array;
		private var currentPageIndex:uint = 0;
		private var currentAnimationInfo:NavigationAnimationInfo = null;
		
		
		public function PageManager(bmps:Array)
		{
			super();
			var pageXML:XML;
			var pageName:String;
			var idx:uint = 0;
			var bmpFront:Bitmap;
			var bmpBack:Bitmap;
			var page:Page;
			
			pages = new Array();
			
			for(idx = 0; idx < bmps.length; idx += 2) {
				
				bmpFront = bmps[idx];
				bmpBack = bmps[idx+1];
				
				page = new Page(bmpFront, bmpBack, idx, bmps.length); 
				pages.push(page);
			}
			
			this.addEventListener(TouchPhase.BEGAN, touchBegan);
			
			for(idx = 0; idx < pages.length; idx++) {
				page = pages[(pages.length-idx)-1];
				
				if(!CONSERVE_MEMORY || idx == pages.length-1) {
					page.createImages();
				}
				addChild(page);
			}
		}
		
		
		private function touchBegan(evt:Event) {
			var touch:Touch = evt.data.touch;
			var page:Page;
			var targetPageIndex:uint;
			var navTarget:String = null;
			
			touch.getLocation(this, sHelperPoint);
			
			if(sHelperPoint.x < 0) {
				targetPageIndex = currentPageIndex-1;
				page = pages[targetPageIndex];
				if(sHelperPoint.x < -(page.getCurrentWidth() * .8)) {
					navTarget = PREV;
					dispatchEventWith(Event.CHANGE, false, currentPageIndex);
				} else {
					dispatchEventWith(Event.OPEN, false, {pageIndex: targetPageIndex, side: Page.BACK});
				}
			} else {
				targetPageIndex = currentPageIndex;
				page = pages[targetPageIndex];
				if(sHelperPoint.x > (page.getCurrentWidth() * .8)) {
					navTarget = NEXT;
				} else {
					dispatchEventWith(Event.OPEN, false, {pageIndex: targetPageIndex, side: Page.FRONT});
				}
			}
			
			if(navTarget != null) {
				currentAnimationInfo = null;
				navToPage(navTarget);
				dispatchEventWith(Event.CHANGE, false, currentPageIndex);
			}
			
		}
		
		private function navToPage(dir:String, speed:Number = 1) {
			var page:Page;
			var flipSide:String;
			var validated:Boolean = false;
			
			if(dir == NEXT && (currentPageIndex < pages.length)) {
				page = pages[currentPageIndex];
				flipSide = Page.BACK;
				currentPageIndex++;
				validated = true;
			} else if(dir == PREV && currentPageIndex > 0) {
				page = pages[currentPageIndex-1];
				flipSide = Page.FRONT;
				currentPageIndex--;
				validated = true;
			}
			
			if(validated) {
				conserveMemory();
				if(SAFE_TOUCHES) {
					this.touchable = false;
				}
				page.flipPage(flipSide, speed, checkAnimationInfo);
				setChildIndex(page, numChildren-1);
			}
			
		}
		
		private function conserveMemory() {
			var idx:uint;
			var page:Page;
			
			if(CONSERVE_MEMORY) {
				for(idx = 0; idx < pages.length; idx++) {
					page = pages[idx];
					if(idx < (currentPageIndex-2)) {
						page.disposeImages();
					} else if(idx > (currentPageIndex+1)) {
						page.disposeImages();
					} else {
						page.createImages();
					}
				}
			}
		}
		
		
		private function checkAnimationInfo() {
			
			
			if(currentAnimationInfo != null) {
				if(currentAnimationInfo.targetPage == currentPageIndex) {
					currentAnimationInfo = null;
				} else {
					navToPage(currentAnimationInfo.targetDir, currentAnimationInfo.getTargetSpeed(currentPageIndex));
				}
			} 
			
			if(currentAnimationInfo == null) {
				if(SAFE_TOUCHES) {
					this.touchable = true;
				}
			}
			
			
		}
		
		
		public function gotoPage(num:uint) {
			var diff:int = num - currentPageIndex;
			if(diff < 0) {
				currentAnimationInfo = new NavigationAnimationInfo(num, PREV);
			} else if(diff > 0) {
				currentAnimationInfo = new NavigationAnimationInfo(num, NEXT);
			} else {
				currentAnimationInfo = null;
			}
			
			if(currentAnimationInfo != null) {
				checkAnimationInfo();
			}
		}
	}
}