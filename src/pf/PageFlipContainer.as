package pf
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 *
	 * @original-author shaorui
	 * 
	 */	
	public class PageFlipContainer extends Sprite
	{
		
		private var cachedImagesLeft:CachedImages;
		private var cachedImagesRight:CachedImages;
		
		private var flipImage:PageFlipImage;
		
		private var textures:Vector.<Texture>;
		
		private var isDraging:Boolean = false;
		
		private var bookWidth:Number;
		
		private var bookHeight:Number;
		
		private var pageCount:Number;
		
		private var leftPageNum:int = -1;
		
		private var rightPageNum:int = 0;
		
		private var flipingPageNum:int = -1;
		
		public var flipingPageLocationX:Number = -1;
		
		public var flipingPageLocationY:Number = -1;
		
		public var begainPageLocationX:Number = -1;
		
		public var begainPageLocationY:Number = -1;
		
		private var needUpdate:Boolean = true;
		
		private var debugGraphics:Graphics;
		private var debugShape:Shape;
		
		private var softContainer:SoftContainer = null;
		
		public function PageFlipContainer(bmps:Array, _bookWidth:Number, _bookHeight:Number)
		{
			var bmp:Bitmap;
			var texture:Texture;
			
			super();
			
			this.bookWidth = _bookWidth;
			this.bookHeight = _bookHeight;
			this.pageCount = bmps.length;
			
			ShadowUtil.addShadowsToBMPs(bmps, bookWidth, bookHeight);
			this.textures = new Vector.<Texture>();
			
			for each(bmp in bmps) {
				texture = Texture.fromBitmap(bmp);	
				textures.push(texture);
			}
			
			debugShape = new Shape();
			
			this.debugGraphics = debugShape.graphics;
			
			initPage();
		}
		
		private function initPage():void
		{
			
			cachedImagesLeft = new CachedImages(CachedImages.LEFT, textures);
			cachedImagesRight = new CachedImages(CachedImages.RIGHT, textures);
			cachedImagesRight.x = bookWidth/2;
			
			addChild(cachedImagesLeft);
			addChild(cachedImagesRight);
			
			flipImage = new PageFlipImage(textures[0], debugGraphics);
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			addEventListener(Event.ADDED_TO_STAGE,firstFrameInit);
			addEventListener(TouchEvent.TOUCH,onTouchHandler);
			
			cachedImagesLeft.addEventListener(Event.CHANGE, cachedImageChanged);
			cachedImagesRight.addEventListener(Event.CHANGE, cachedImageChanged);
		}
		
		private function firstFrameInit():void
		{
			
			
			
			removeEventListener(Event.ADDED_TO_STAGE,firstFrameInit);
			
			validateNow();
			needUpdate = false;
		}
		
		
		
		private function enterFrameHandler(event:Event=null):void
		{
			if(stage == null || !needUpdate) {
				return;
			} 
			
			
			if(flipingPageNum >= 0)
			{
				leftPageNum = flipingPageNum - 1;
				rightPageNum = flipingPageNum + 2;
			}
			
			/*
			if(validatePageNumber(leftPageNum))
			{
				cachedImagesLeft.showImage(leftPageNum);
			} else {
				cachedImagesLeft.nullify();
			}
			
			if(validatePageNumber(rightPageNum))
			{
				cachedImagesRight.showImage(rightPageNum);
			}  else {
				cachedImagesRight.nullify();
			}
			*/
			
			if(validatePageNumber(flipingPageNum))
			{
				if(flipImage.softMode)
				{
					
					if(softContainer == null) {
						softContainer = new SoftContainer();
						addChild(softContainer);
					} else {
						softContainer.resetQuads();
					}
					
					//setChildIndex(softContainer, numChildren);
					flipImage.texture = begainPageLocationX>=0?textures[flipingPageNum]:textures[flipingPageNum+1];
					flipImage.anotherTexture = begainPageLocationX<0?textures[flipingPageNum]:textures[flipingPageNum+1];
					flipImage.readjustSize();
					flipImage.setLocationSoft(softContainer,begainPageLocationX,begainPageLocationY,flipingPageLocationX,flipingPageLocationY);
				}
				else
				{
					flipImage.texture = flipingPageLocationX>=0?textures[flipingPageNum]:textures[flipingPageNum+1];
					flipImage.readjustSize();
					flipImage.setLocation(flipingPageLocationX);	
					
					if(!contains(flipImage)) {
						addChild(flipImage);
					}
				}
				
				
				
				
			} else {
				if(softContainer != null) {
					softContainer.dispose();
					removeChild(softContainer);
					softContainer = null;
				}
			}
		}
		
		
		
		private function onTouchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if(touch != null && (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED || touch.phase == TouchPhase.ENDED))
			{
				var point:Point = touch.getLocation(this);
				var imgWidth:Number = bookWidth/2;
				var imgHeight:Number = bookHeight/2;
				if(touch.phase == TouchPhase.BEGAN)
				{
					begainPageLocationX = (point.x-imgWidth)/imgWidth;
					begainPageLocationY = (point.y-imgHeight)/imgHeight;
					isDraging = true;
					if(point.x >= imgWidth)
					{
						if(validatePageNumber(rightPageNum))
						{
							flipingPageNum = rightPageNum;
						}
					}
					else
					{
						if(validatePageNumber(leftPageNum))
						{
							flipingPageNum = leftPageNum-1;
						}
					}
					resetSoftMode();
					if(flipImage.softMode && !flipImage.validateBegainPoint(begainPageLocationX,begainPageLocationY))
					{
						isDraging = false;
						flipingPageNum = -1;
						return;
					}
					
				}
				else if(touch.phase == TouchPhase.MOVED)
				{
					if(isDraging)
					{
						flipingPageLocationX = (point.x-imgWidth)/imgWidth;
						flipingPageLocationY = (point.y-imgHeight)/imgHeight;
						if(flipingPageLocationX > 1)
							flipingPageLocationX = 1;
						if(flipingPageLocationX < -1)
							flipingPageLocationX = -1;
						if(flipingPageLocationY > 1)
							flipingPageLocationY = 1;
						if(flipingPageLocationY < -1)
							flipingPageLocationY = -1;
						validateNow();
					}
				}
				else
				{
					if(isDraging)
					{
						finishTouchByMotion(point.x);
						isDraging = false;
					}
				}
			}
			else
			{
				needUpdate = false;
			}
		}
		
		private function resetSoftMode():void
		{
			if(flipingPageNum > 0 && flipingPageNum < (pageCount-2))
				flipImage.softMode = true;
			else
				flipImage.softMode = false;
		}
		
		private function finishTouchByMotion(endX:Number):void
		{
			var imgWidth:Number = bookWidth/2;
			var targetPage:int;
			
			needUpdate = true;
			touchable = false;
			
			
			//This could probably be a little less hacky... figured out by reverse engineering more than logic. But it works :)
			
			if(flipingPageLocationX >= 0) {
				targetPage = flipingPageNum-1;	
			} else {
				targetPage = flipingPageNum+1;
			}
			
			if(targetPage != leftPageNum) {
				targetPage--;
			}
			
			dispatchEventWith(Event.CHANGE, false, targetPage);
			
			addEventListener(Event.ENTER_FRAME,executeMotion);
			function executeMotion(event:Event):void
			{
				if(endX >= imgWidth)
				{
					
					flipingPageLocationX += (1-flipingPageLocationX)/4;
					flipingPageLocationY = flipingPageLocationX;
					if(flipingPageLocationX >= 0.999)
					{
						flipingPageLocationX = 1;
						flipingPageLocationY = 1;
						removeEventListener(Event.ENTER_FRAME,executeMotion);
						tweenCompleteHandler();
					}
				}
				else
				{
					
					flipingPageLocationX += (-1-flipingPageLocationX)/4;
					flipingPageLocationY = -flipingPageLocationX;
					if(flipingPageLocationX <= -0.999)
					{
						flipingPageLocationX = -1;
						flipingPageLocationY = 1;
						removeEventListener(Event.ENTER_FRAME,executeMotion);
						tweenCompleteHandler();
					}
				}
			}
		}
		
		private function tweenCompleteHandler():void
		{
			
			
			
			if(flipingPageLocationX == 1)
			{
				leftPageNum = flipingPageNum-1;
				rightPageNum = flipingPageNum;
			}
			else if(flipingPageLocationX == -1)
			{
				leftPageNum = flipingPageNum+1;
				rightPageNum = flipingPageNum+2;
			}
			
			flipingPageNum = -1;
			resetSoftMode();
			validateNow();
			touchable = true;
			debugGraphics.clear();
			
		}
		
		private function redrawCachedPages() {
			cachedImagesLeft.showImage(leftPageNum);
			cachedImagesRight.showImage(rightPageNum);
		}
		
		private function validatePageNumber(pageNum:int):Boolean
		{
			if(pageNum >= 0 && pageNum < pageCount)
				return true;
			else
				return false;
		}
		
		public function get pageNumber():int
		{
			if(leftPageNum >= 0)
				return leftPageNum;
			else
				return rightPageNum;
		}
		
		public function validateNow():void
		{
			needUpdate = true;
			redrawCachedPages();
			enterFrameHandler();
			needUpdate = false;
		}
		
		private function cachedImageChanged(evt:Event) {
			var idx:int = evt.data as int;
			
			gotoPage(idx);
			
			dispatchEventWith(Event.CHANGE, false, idx-1);
		}
		
		public function gotoPage(pn:int):void
		{	
			
			
			if(contains(flipImage)) {
				removeChild(flipImage);
			}
			
			
			if(!pn) {
				leftPageNum = -1;
				rightPageNum = 0;
			} else if(pn == pageCount-1) {
				leftPageNum = pn;
				rightPageNum = -1;
			} else {
				if(pn%2==0) {
					leftPageNum = pn-1;
					rightPageNum = pn;
				} else {
					leftPageNum = pn;
					rightPageNum = pn+1;
				}
			}
			
			flipingPageNum = -1;
			resetSoftMode();
			validateNow();
			
			if(leftPageNum >= 0) {
				cachedImagesLeft.showImage(leftPageNum);
			}
			
			if(rightPageNum >= 0) {
				cachedImagesRight.showImage(rightPageNum);
			}
		}
	}
}