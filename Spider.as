package  {
	
	import flash.display.MovieClip;
	
	
	public class Spider extends MovieClip {
		public const SPEED:Number=2;
		public const TRUN_SPEED=0.3;
		public const RANG:Number=1000;//距离
		public const FRICTION:Number=0.96;//摩擦力
		public const SCORE:Number=30;
		public var blood:Number;
		public var vx:Number;
		public var vy:Number;
		
		public function Spider() {
			// constructor code
			vx=0;
			vy=0;
			blood=30;
		}
		
		public function EnemyHit(){
			this.gotoAndPlay("dead");
			MovieClip(parent).removeEnemy(this);
		}
	}
	
}
