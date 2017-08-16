package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	public class Hero extends MovieClip{

		public var hp:Number;//血量
		public var score:Number;//分数
		public var kills:Number;//杀敌数
		public var active:Number;//目标数
		private var _speed:Number = 0.1 * 1.4;
		private var xy_speed:Number = 0.1;
		private var friction = 0.95;
		private var xseat = 0;
		private var yseat = 0;
		public var status="play";

		public var movingUp:Boolean = false;
		public var movingDown:Boolean = false;
		public var movingLeft:Boolean = false;
		public var movingRight:Boolean = false;

		public function Hero(){
			// constructor code
			init();
			this.addEventListener(Event.ADDED_TO_STAGE,toStageKeyA);
		}

		public function init(){
			hp = 100;
			score = 0;
			kills = 0;
			active = 0;
			this.x = 600;
			this.y = 350;
			
		}

		public function toStageKeyA(e:Event){
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			stage.addEventListener(Event.ENTER_FRAME,the_area);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,OnPress);
			stage.addEventListener(KeyboardEvent.KEY_UP,OnRelease);
		}
		
		
		//限制舞台边界
		private function the_area(event:Event):void{
			if (this.x - this.width/2 < 0){
				xseat +=  _speed;
			}
			if (this.y - this.height/2 < 0){
				yseat +=  _speed;
			}
			if (this.x + this.width/2> FWConstants.STAGE_WIDTH){
				xseat -=  _speed;
			}
			if (this.y + this.height/2> FWConstants.STAGE_HEIGHT){
				yseat -=  _speed;
			}
			xseat *=  friction;
			yseat *=  friction;
			this.x +=  xseat;
			this.y +=  yseat;
		}
		
		//方向速度
		private function enterFrameHandler(event:Event):void{
			
			if (movingLeft && !movingDown && !movingUp){
				xseat -=  _speed;
			}
			if (movingRight && !movingDown&& !movingUp ){
				xseat +=  _speed;
			}
			if (movingUp && !movingRight && !movingLeft ){
				yseat -=  _speed;
			}
			if (movingDown && !movingRight && !movingLeft ){
				yseat +=  _speed;
			}
			
			
			//打斜着走
			if (movingLeft &&movingUp && !movingRight && !movingDown ){
				xseat -=  xy_speed;
				yseat -=  xy_speed;
			}
			if (movingRight &&movingUp && !movingLeft && !movingDown ){
				xseat +=  xy_speed;
				yseat -=  xy_speed;
			}
			if (movingLeft &&movingDown && !movingRight && !movingUp ){
				xseat -=  xy_speed;
				yseat +=  xy_speed;
			}
			if (movingRight &&movingDown && !movingLeft && !movingUp ){
				xseat +=  xy_speed;
				yseat +=  xy_speed;
			}
			xseat *=  friction;
			yseat *=  friction;
			this.x +=  xseat;
			this.y +=  yseat;
		}
		
		//按下
		public function OnPress(event:KeyboardEvent):void{
			switch (event.keyCode){
				case 87 :
					movingUp = true;
					break;
				case 83 :
					movingDown = true;
					break;
				case 65 :
					movingLeft = true;
					break;
				case 68 :
					movingRight = true;
					break;
			}
		}
		
		//松开
		public function OnRelease(event:KeyboardEvent):void{
			switch ( event.keyCode ){
				case 87 :
					movingUp = false;
					break;
				case 83 :
					movingDown = false;
					break;
				case 65 :
					movingLeft = false;
					break;
				case 68 :
					movingRight = false;
					break;
			}
		}
		
		//暂停
		public function Pause(){
			stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			this.status="stop";
		}
		
		//开始
		public function Play(){
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			this.status="play";
		}
		
		//击中
		public function Hit(){
			this.hp-=0.1;
			if(this.hp<=0){
				this.status="dead";
			}
		}

	}

}