package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	
	public class intro_screen extends MovieClip {
		public var main_class:main_control;
		
		public function intro_screen(passed_class:main_control) {
			// constructor code
			main_class=passed_class;
			this.addEventListener(Event.ADDED_TO_STAGE,onStageHandler);
		}
		
		public function onStageHandler(e:Event){
        	init();
        	this.removeEventListener(Event.ADDED_TO_STAGE,onStageHandler);
        }
		
		public function init(){
			Mouse.hide();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseFollow);
			play_bt.addEventListener(MouseEvent.CLICK,onPlay);
			help_bt.addEventListener(MouseEvent.CLICK,onHelp);
			team_bt.addEventListener(MouseEvent.CLICK,onRank);
			
			
			
		}
		
		public function mouseFollow(e:MouseEvent){
			
			mouse.x=mouseX;
			mouse.y=mouseY;
			
		}
		
		public function onPlay(e:MouseEvent){
			main_class.show_game();
		}
		
		public function onHelp(e:MouseEvent){
			main_class.show_help();
		}
		
		public function onRank(e:MouseEvent){
			main_class.show_rank(3);
		}
	}
	
}
