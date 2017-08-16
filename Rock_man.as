package  {
	
	import flash.display.MovieClip;
	
	
	public class Rock_man extends MovieClip {
		public const TOTAL_HP:Number=100;
		public const SPEED:Number=1.5;
		public const TRUN_SPEED=0.3;
		public const RANG:Number=1000;//距离
		public const FRICTION:Number=0.96;//摩擦力
		public const SCORE:Number=100;
		public var blood:Number;
		public var vx:Number;
		public var vy:Number;
		
		public function Rock_man() {
			// constructor code
			vx=0;
			vy=0;
			blood=this.TOTAL_HP;
		}
		
		public function EnemyHit(){
			this.gotoAndPlay("dead");
			MovieClip(parent).removeEnemy(this);
		}
	}
	
}
