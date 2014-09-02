package book.pf
{
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.VertexData;

	/**
	 *
	 * @original-author shaorui
	 */	
	public class PageFlipImage extends Image
	{
		
		
		public var LEFT_UP_POINT:Point;
		public var LEFT_BOTTOM_POINT:Point;
		public var RIGHT_UP_POINT:Point;
		public var RIGHT_BOTTOM_POINT:Point;
		public var MID_UP_POINT:Point;
		public var MID_BOTTOM_POINT:Point;
		
		private var bookWidth:Number;
		private var bookHeight:Number;
		
		private var _dragPoint:Point = new Point();
		private var _dragPointCopy:Point = new Point();
		private var _edgePoint:Point = new Point();
		private var _edgePointCopy:Point = new Point();
		
		
		private var _k1:Number = new Number(0);
		private var _k2:Number = new Number(0);
		private var _b:Number = new Number(0);
		/**@private*/
		private var currentPoint:Point = new Point();
		private var currentPointCopy:Point = new Point();
		private var targetPoint:Point = new Point();
		private var targetPointCopy:Point = new Point();
		private var interPoint:Point  = new Point();
		private var interPointCopy:Point = new Point();
		private var swapPoint:Point = new Point();
		/**@private*/
		private var limitedPoint:Point = new Point();
		private var limitedPointCopy:Point = new Point();
		private var radius:Number;
		private var radiusCopy:Number;
		
		
		public var softMode:Boolean;
		
		public var anotherTexture:Texture;
		
		private var currentHotType:String;
		
		private var debugGraphics:starling.display.Graphics;
		
		/**@private*/
		public function PageFlipImage(texture:Texture, _debugGraphics:starling.display.Graphics, _bookWidth:Number, _bookHeight:Number)
		{
			super(texture);
			
			debugGraphics = _debugGraphics;
			
			bookWidth = _bookWidth;
			bookHeight = _bookHeight;
			
			LEFT_UP_POINT      = new Point(0 , 0);
			LEFT_BOTTOM_POINT  = new Point(0 , bookHeight);
			RIGHT_UP_POINT     = new Point(bookWidth , 0);
			RIGHT_BOTTOM_POINT = new Point(bookWidth , bookHeight);
			MID_UP_POINT       = new Point(bookWidth/2 , 0);
			MID_BOTTOM_POINT   = new Point(bookWidth/2 , bookHeight);
			
			radius = bookWidth/2;
			radiusCopy = Math.sqrt(Math.pow(bookHeight,2) + Math.pow(bookWidth/2,2));
		}
		/**@override*/
		override public function readjustSize():void
		{
			super.readjustSize();
			resetAllTexCoords();
			onVertexDataChanged();
		}
		/**重置UV坐标*/
		protected function resetAllTexCoords():void
		{
			mVertexData.setTexCoords(0, 0, 0);
			mVertexData.setTexCoords(1, 1, 0);
			mVertexData.setTexCoords(2, 0, 1);
			mVertexData.setTexCoords(3, 1.0, 1.0);
		}
		/**
		 * 设置顶点位置
		 * @param flipingPageLocation 从-1到1
		 */		
		public function setLocation(flipingPageLocation:Number):void
		{
			var fpl:Number = Math.abs(flipingPageLocation);
			var w:Number = bookWidth/2;
			var h:Number = bookHeight;
			var topOffset:Number = h/8;
			if(flipingPageLocation>=0)
			{
				mVertexData.setPosition(0,w,0);
				mVertexData.setPosition(2,w,h);
				mVertexData.setPosition(1,w+w*fpl,-topOffset*(1-fpl));
				mVertexData.setPosition(3,w+w*fpl,h+topOffset*(1-fpl));
			}
			else
			{
				mVertexData.setPosition(1,w,0);
				mVertexData.setPosition(3,w,h);
				mVertexData.setPosition(0,w-w*fpl,-topOffset*(1-fpl));
				mVertexData.setPosition(2,w-w*fpl,h+topOffset*(1-fpl));
			}
			resetAllTexCoords();
		}
		/**设置顶点位置：软皮模式*/
		public function setLocationSoft(softContainer:SoftContainer,begainPageLocationX:Number, begainPageLocationY:Number, flipingPageLocationX:Number, flipingPageLocationY:Number):void
		{
			var bx:Number = begainPageLocationX;
			var by:Number = begainPageLocationY;
			var fx:Number = flipingPageLocationX;
			var fy:Number = flipingPageLocationY;
			var w:Number = bookWidth/2;
			var h:Number = bookHeight;
			
			if(validateBegainPoint(bx,by))
			{
				
				currentHotType = getBegainPointType(bx, by);
				var mouseLocation:Point = new Point(bookWidth/2+fx*bookWidth/2,bookHeight/2+fy*bookHeight/2);
				_dragPoint.x = mouseLocation.x;
				_dragPoint.y = mouseLocation.y;
				onTurnPageByHand(mouseLocation);
				
				if(currentPointCount == 3)
				{
					
					
					if(bx > 0)
					{
						mVertexData.setPosition(0,w,0);
						mVertexData.setPosition(1,w,0);
						mVertexData.setTexCoords(1, 0, 0);
						mVertexData.setPosition(2,w,h);
						mVertexData.setPosition(3,_edgePointCopy.x,h);
						mVertexData.setTexCoords(3, (_edgePointCopy.x-w)/w, 1);
						softContainer.addImage(this);
						readjustSize();
						mVertexData.setPosition(0,w,0);
						mVertexData.setPosition(1,2*w,0);
						mVertexData.setPosition(2,_edgePointCopy.x,h);
						mVertexData.setTexCoords(2, (_edgePointCopy.x-w)/w, 1);
						mVertexData.setPosition(3,w*2,_edgePoint.y);
						mVertexData.setTexCoords(3,1,_edgePoint.y/h);
						softContainer.addImage(this);
						texture = anotherTexture;
						readjustSize();
						mVertexData.setPosition(0,w*2,_edgePoint.y);
						mVertexData.setTexCoords(0, 0, _edgePoint.y/h);
						mVertexData.setPosition(1,w*2,_edgePoint.y);
						mVertexData.setTexCoords(1, 0, _edgePoint.y/h);
						mVertexData.setPosition(2,_dragPoint.x,_dragPoint.y);
						mVertexData.setPosition(3,_edgePointCopy.x,h);
						mVertexData.setTexCoords(3, (2*w-_edgePointCopy.x)/w, 1);
						softContainer.addImage(this);
					}
					else
					{
						mVertexData.setPosition(2,0,_edgePoint.y);
						mVertexData.setTexCoords(2,0,_edgePoint.y/h);
						mVertexData.setPosition(3,_edgePointCopy.x,h);
						mVertexData.setTexCoords(3,_edgePointCopy.x/w,1);
						softContainer.addImage(this);
						readjustSize();
						mVertexData.setPosition(0,w,0);
						mVertexData.setTexCoords(0,1,0);
						mVertexData.setPosition(1,w,0);
						mVertexData.setTexCoords(1,1,0);
						mVertexData.setPosition(2,_edgePointCopy.x,h);
						mVertexData.setTexCoords(2,_edgePointCopy.x/w,1);
						softContainer.addImage(this);
						texture = anotherTexture;
						readjustSize();
						mVertexData.setPosition(0,0,_edgePoint.y);
						mVertexData.setTexCoords(0,1,_edgePoint.y/h);
						mVertexData.setPosition(1,0,_edgePoint.y);
						mVertexData.setTexCoords(1,1,_edgePoint.y/h);
						mVertexData.setPosition(2,_edgePointCopy.x,h);
						mVertexData.setTexCoords(2,(w-_edgePointCopy.x)/w,1);
						mVertexData.setPosition(3,_dragPoint.x,_dragPoint.y);
						softContainer.addImage(this);
					}
				}
				if(currentPointCount == 4)
				{
					
					if(bx > 0)
					{
						mVertexData.setPosition(0,w,0);
						mVertexData.setPosition(1,_edgePoint.x,0);
						mVertexData.setTexCoords(1, (_edgePoint.x-w)/w, 0);
						mVertexData.setPosition(2,w,h);
						mVertexData.setPosition(3,_edgePointCopy.x,h);
						mVertexData.setTexCoords(3, (_edgePointCopy.x-w)/w, 1);
						softContainer.addImage(this);
						texture = anotherTexture;
						readjustSize();
						mVertexData.setPosition(0,_dragPointCopy.x,_dragPointCopy.y);
						mVertexData.setPosition(1,_edgePoint.x,0);
						mVertexData.setTexCoords(1, (2*w-_edgePoint.x)/w, 0);
						mVertexData.setPosition(2,_dragPoint.x,_dragPoint.y);
						mVertexData.setPosition(3,_edgePointCopy.x,h);
						mVertexData.setTexCoords(3, (2*w-_edgePointCopy.x)/w, 1);
						softContainer.addImage(this);
					}
					else
					{
						mVertexData.setPosition(0,_edgePoint.x,0);
						mVertexData.setTexCoords(0,_edgePoint.x/w,0);
						mVertexData.setPosition(2,_edgePointCopy.x,h);
						mVertexData.setTexCoords(2,_edgePointCopy.x/w,1);
						softContainer.addImage(this);
						texture = anotherTexture;
						readjustSize();
						mVertexData.setPosition(0,_edgePoint.x,0);
						mVertexData.setTexCoords(0,(w-_edgePoint.x)/w,0);
						mVertexData.setPosition(1,_dragPointCopy.x,_dragPointCopy.y);
						mVertexData.setPosition(2,_edgePointCopy.x,h);
						mVertexData.setTexCoords(2,(w-_edgePointCopy.x)/w,1);
						mVertexData.setPosition(3,_dragPoint.x,_dragPoint.y);
						softContainer.addImage(this);
					}
				}
				drawPage(_dragPoint , _edgePoint , _edgePointCopy , _dragPointCopy);
			}
			else
			{
				setLocation(bx>=0?1:-1);
			}
		}
		
		
		
		private function onTurnPageByHand(mouseLocation:Point):void
		{
			if(mouseLocation.x >= 0 && mouseLocation.x <= bookWidth)
			{
				_dragPoint.x += (mouseLocation.x - _dragPoint.x)*0.4;
				_dragPoint.y += (mouseLocation.y - _dragPoint.y)*0.4;
			}
			else
			{
				switch(currentHotType)
				{
					case(PageVerticeType.TOP_LEFT):
						if(mouseLocation.x > bookWidth)
						{
							_dragPoint.x += (targetPoint.x - _dragPoint.x)*0.5;
							_dragPoint.y += (targetPoint.y - _dragPoint.y)*0.5;
						}
						break;
					case(PageVerticeType.BOTTOM_LEFT):
						if(mouseLocation.x > bookWidth)
						{
							_dragPoint.x += (targetPoint.x - _dragPoint.x)*0.5;
							_dragPoint.y += (targetPoint.y - _dragPoint.y)*0.5;
						}
						break;
					case(PageVerticeType.TOP_RIGHT):
						if(mouseLocation.x < 0)
						{
							_dragPoint.x += (targetPoint.x - _dragPoint.x)*0.5;
							_dragPoint.y += (targetPoint.y - _dragPoint.y)*0.5;
						}
						break;
					case(PageVerticeType.BOTTOM_RIGHT):
						if(mouseLocation.x < 0)
						{
							_dragPoint.x += (targetPoint.x - _dragPoint.x)*0.5;
							_dragPoint.y += (targetPoint.y - _dragPoint.y)*0.5;
						}
						break;
				}
			}
			limitationCalculator(_dragPoint);
			_dragPointCopy.x = currentPointCopy.x;
			_dragPointCopy.y = currentPointCopy.y;
			mathematicsCalculator(_dragPoint);
			adjustPointCalculator(currentHotType);
		}
		/**用来限制_dragPoint的活动范围，从而达到翻书时最大和最小可能效果*/
		private function limitationCalculator(_dragPoint:Point):void
		{
			if(_dragPoint.y > bookHeight-0.1)
				_dragPoint.y = bookHeight-0.1;
			if(_dragPoint.x <= 0.1)
				_dragPoint.x = 0.1;
			if(_dragPoint.x > bookWidth-0.1)
				_dragPoint.x = bookWidth-0.1;
			_dragPoint.x -= bookWidth/2;
			_dragPoint.y -= bookHeight/2;
			limitedPoint.x -= bookWidth/2;
			limitedPoint.y -= bookHeight/2;
			limitedPointCopy.x -= bookWidth/2;
			limitedPointCopy.y -= bookHeight/2;
			if(currentHotType == PageVerticeType.TOP_LEFT || currentHotType == PageVerticeType.TOP_RIGHT)
			{
				if(_dragPoint.y >= Math.sqrt(Math.pow(radius,2)-Math.pow(_dragPoint.x,2))+limitedPoint.y)
				{
					_dragPoint.y = Math.sqrt(Math.pow(radius,2)-Math.pow(_dragPoint.x,2))+limitedPoint.y;
				}
				if(_dragPoint.y <= -Math.sqrt(Math.pow(radiusCopy,2)-Math.pow(_dragPoint.x,2))+limitedPointCopy.y)
				{
					_dragPoint.y = -Math.sqrt(Math.pow(radiusCopy,2)-Math.pow(_dragPoint.x,2))+limitedPointCopy.y;
				}
			}
			else
			{
				if(_dragPoint.y <= -Math.sqrt(Math.pow(radius,2)-Math.pow(_dragPoint.x,2))+limitedPoint.y)
				{
					_dragPoint.y = -Math.sqrt(Math.pow(radius,2)-Math.pow(_dragPoint.x,2))+limitedPoint.y;
				}
				if(_dragPoint.y >= Math.sqrt(Math.pow(radiusCopy,2)-Math.pow(_dragPoint.x,2))+limitedPointCopy.y)
				{
					_dragPoint.y = Math.sqrt(Math.pow(radiusCopy,2)-Math.pow(_dragPoint.x,2))+limitedPointCopy.y;
				}
			}
			_dragPoint.x += bookWidth/2;
			_dragPoint.y += bookHeight/2;
			limitedPoint.x += bookWidth/2;
			limitedPoint.y += bookHeight/2;
			limitedPointCopy.x += bookWidth/2;
			limitedPointCopy.y += bookHeight/2;
		}
		/**计算一系列数学系数*/
		private function mathematicsCalculator(_dragPoint:Point):void
		{
			interPoint = Point.interpolate(_dragPoint,currentPoint,0.5);
			_k1 = (_dragPoint.y - currentPoint.y)/(_dragPoint.x - currentPoint.x);
			_k2 = -1/_k1;
			if(Math.abs(_k2) == Infinity){
				if(_k2 >= 0){
					_k2 = 1000000000000000;
				}else{
					_k2 = -1000000000000000;}
			}
			_b = interPoint.y - _k2*interPoint.x;
			_edgePoint.x = currentPoint.x;
			if(currentHotType == PageVerticeType.TOP_LEFT || currentHotType == PageVerticeType.BOTTOM_RIGHT)
			{
				_edgePoint.y = -Math.abs(_k2)*_edgePoint.x + _b;
			}
			if(currentHotType == PageVerticeType.BOTTOM_LEFT || currentHotType == PageVerticeType.TOP_RIGHT)
			{
				_edgePoint.y = Math.abs(_k2)*_edgePoint.x + _b;
			}
			_edgePointCopy.y = currentPoint.y;
			_edgePointCopy.x = (_edgePointCopy.y - _b)/_k2;
		}
		/**当翻页翻至_edgePoint到达下页脚时，开启第四点计算，并修改第四点x,y的值*/
		private function adjustPointCalculator(currentHotType:String):void
		{
			switch(currentHotType)
			{
				case(PageVerticeType.TOP_LEFT):
					if(_edgePoint.y >= currentPointCopy.y)
					{
						_edgePoint.y     = currentPointCopy.y;
						_edgePoint.x     = (currentPointCopy.y - _b)/_k2;
						_dragPointCopy.x = 2*(_b - (currentPointCopy.y - _k1*currentPointCopy.x))/(_k1 - _k2) - currentPointCopy.x;
						_dragPointCopy.y = _k1*_dragPointCopy.x + currentPointCopy.y - _k1*currentPointCopy.x;
					}
					break;
				case(PageVerticeType.BOTTOM_LEFT):
					if(_edgePoint.y <= currentPointCopy.y)
					{
						_edgePoint.y     = currentPointCopy.y;
						_edgePoint.x     = (currentPointCopy.y - _b)/_k2;
						_dragPointCopy.x = 2*(_b - (currentPointCopy.y - _k1*currentPointCopy.x))/(_k1 - _k2) - currentPointCopy.x;
						_dragPointCopy.y = _k1*_dragPointCopy.x + currentPointCopy.y - _k1*currentPointCopy.x;
					}
					break;
				case(PageVerticeType.TOP_RIGHT):
					if(_edgePoint.y >= currentPointCopy.y)
					{
						_edgePoint.y     = currentPointCopy.y;
						_edgePoint.x     = (currentPointCopy.y - _b)/_k2;
						_dragPointCopy.x = 2*(_b - (currentPointCopy.y - _k1*currentPointCopy.x))/(_k1 - _k2) - currentPointCopy.x;
						_dragPointCopy.y = _k1*_dragPointCopy.x + currentPointCopy.y - _k1*currentPointCopy.x;
					}
					break;
				case(PageVerticeType.BOTTOM_RIGHT):
					if(_edgePoint.y <= currentPointCopy.y)
					{
						_edgePoint.y     = currentPointCopy.y;
						_edgePoint.x     = (currentPointCopy.y - _b)/_k2;
						_dragPointCopy.x = 2*(_b - (currentPointCopy.y - _k1*currentPointCopy.x))/(_k1 - _k2) - currentPointCopy.x;
						_dragPointCopy.y = _k1*_dragPointCopy.x + currentPointCopy.y - _k1*currentPointCopy.x;
					}
					break;
			}
		}
		/**测试用*/
		private function drawPage(point1:Point , point2:Point , point3:Point , point4:Point):void
		{
			var g:starling.display.Graphics = debugGraphics;
			g.clear();
			if(_k1 != 0)//当_k1=0且_dragPoint接近targetPoint时说明页面完全翻过
			{
				g.lineStyle(1,0x000000,0.6);
				g.moveTo(point1.x , point1.y);
				//_edgePointCopy红色
				g.lineTo(point3.x , point3.y);
				//_edgePoint绿色
				g.lineTo(point2.x , point2.y);
				var fourthDot:Boolean = false;
				if(_dragPointCopy.x != currentPointCopy.x && _dragPointCopy.y != currentPointCopy.y)
				{
					fourthDot = true;
					//_dragPointCopy蓝色
					g.lineTo(point4.x , point4.y);
				}
				//_dragPoint
				g.lineTo(point1.x , point1.y);
				return;
				//dots
				g.beginFill(0x000000,1);
				g.drawCircle(point1.x , point1.y,5);
				g.endFill();
				g.beginFill(0x00FF00,1);
				g.drawCircle(point2.x , point2.y,5);
				g.endFill();
				g.beginFill(0xFF0000,1);
				g.drawCircle(point3.x , point3.y,5);
				g.endFill();
				if(fourthDot)
				{
					g.beginFill(0x0000FF,1);
					g.drawCircle(point4.x , point4.y,10);
					g.endFill();
				}
			}
		}
		
		private function get currentPointCount():int
		{
			if(_dragPointCopy.x != currentPointCopy.x && _dragPointCopy.y != currentPointCopy.y)
				return 4;
			else
				return 3;
		}
		
		public function validateBegainPoint(begainPageLocationX:Number, begainPageLocationY:Number):Boolean
		{
			var bx:Number = Math.abs(begainPageLocationX);
			var by:Number = begainPageLocationY;
			
			
			if(bx > 0.8 && by > 0.8)
				return true;
			else
				return false;
		}
		
		public function getBegainPointType(begainPageLocationX:Number, begainPageLocationY:Number):String
		{
			var bpType:String;
			var bx:Number = begainPageLocationX;
			var by:Number = begainPageLocationY;
			if(bx < 0 && by < 0)
				bpType = PageVerticeType.TOP_LEFT;
			if(bx > 0 && by < 0)
				bpType = PageVerticeType.TOP_RIGHT;
			if(bx < 0 && by > 0)
				bpType = PageVerticeType.BOTTOM_LEFT;
			if(bx > 0 && by > 0)
				bpType = PageVerticeType.BOTTOM_RIGHT;
			switch(bpType)
			{
				case(PageVerticeType.TOP_LEFT):
					currentPoint      = LEFT_UP_POINT;
					currentPointCopy  = LEFT_BOTTOM_POINT;
					targetPoint       = RIGHT_UP_POINT;
					targetPointCopy   = RIGHT_BOTTOM_POINT;
					limitedPoint      = MID_UP_POINT;
					limitedPointCopy  = MID_BOTTOM_POINT;
					break;
				case(PageVerticeType.BOTTOM_LEFT):
					currentPoint      = LEFT_BOTTOM_POINT;
					currentPointCopy  = LEFT_UP_POINT;
					targetPoint       = RIGHT_BOTTOM_POINT;
					targetPointCopy   = RIGHT_UP_POINT;
					limitedPoint      = MID_BOTTOM_POINT;
					limitedPointCopy  = MID_UP_POINT;
					break;
				case(PageVerticeType.TOP_RIGHT):
					currentPoint      = RIGHT_UP_POINT;
					currentPointCopy  = RIGHT_BOTTOM_POINT;
					targetPoint       = LEFT_UP_POINT;
					targetPointCopy   = LEFT_BOTTOM_POINT;
					limitedPoint      = MID_UP_POINT;
					limitedPointCopy  = MID_BOTTOM_POINT;
					break;
				case(PageVerticeType.BOTTOM_RIGHT):
					currentPoint      = RIGHT_BOTTOM_POINT;
					currentPointCopy  = RIGHT_UP_POINT;
					targetPoint       = LEFT_BOTTOM_POINT;
					targetPointCopy   = LEFT_UP_POINT;
					limitedPoint      = MID_BOTTOM_POINT;
					limitedPointCopy  = MID_UP_POINT;
					break;
			}
			
			return bpType;
		}
	}
}
class PageVerticeType
{
	public static const TOP_LEFT:String = "topLeft";
	public static const TOP_RIGHT:String = "topRight";
	public static const BOTTOM_LEFT:String = "bottomLeft";
	public static const BOTTOM_RIGHT:String = "bottomRight";
}