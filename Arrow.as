package  {
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	
	
	public class Arrow extends MovieClip {
		
		private var dx:Number;//速度
		private var dy:Number;//速度
		
		public function Arrow(x,y:Number) {
			// constructor code
			//设置开始位置
			this.x=x;
			this.y=y;
			dx=0.05;
			dy=0.05;
			
		}
		
		//删除炮弹
		public function deleteArrow(){
			MovieClip(parent).removeArrow(this);
			//parent.removeChild(this);
			this.gotoAndPlay(45);
		}
	}
	
}
