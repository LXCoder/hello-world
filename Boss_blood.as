package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Boss_blood extends MovieClip {
		private var rock:Rock_man;
		
		public function Boss_blood(_rock:Rock_man) {
			// constructor code
			rock=_rock;
			this.addEventListener(Event.ADDED_TO_STAGE,onStageHandler);
			
			
		}
		
		public function onStageHandler(e:Event){
        	init();
        	this.removeEventListener(Event.ADDED_TO_STAGE,onStageHandler);
        }
		
		public function init(){
			stage.addEventListener(Event.ENTER_FRAME,goto);
		}
		
		public function goto(e:Event){
			var currentFrame:int=Math.ceil(100*(rock.blood/rock.TOTAL_HP));
			this.gotoAndStop(currentFrame);
			if(rock.blood<=0){
				stage.removeEventListener(Event.ENTER_FRAME,goto);
			}
		}
		
	}
	
}
