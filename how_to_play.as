package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	
	public class how_to_play extends MovieClip {
		public var main_class:main_control;
		
		public function how_to_play(passed_class:main_control) {
			// constructor code
			main_class=passed_class;
			this.addEventListener(Event.ADDED_TO_STAGE,onStageHandler);
			
		}
		
		public function onStageHandler(e:Event){
        	init();
        	this.removeEventListener(Event.ADDED_TO_STAGE,onStageHandler);
        }
		
		public function init(){
			Mouse.show();
			back_bt.addEventListener(MouseEvent.CLICK,onBack);
			down_bt.addEventListener(MouseEvent.CLICK,onDown);
			
			
		}
		
		public function onBack(e:MouseEvent){
			main_class.show_intro();
			back_bt.removeEventListener(MouseEvent.CLICK,onBack);
			down_bt.removeEventListener(MouseEvent.CLICK,onDown);
			up_bt.removeEventListener(MouseEvent.CLICK,onUp);
			
		}
		
		public function onUp(e:MouseEvent){
			this.gotoAndStop(1);
			back_bt.addEventListener(MouseEvent.CLICK,onBack);
		}
		
		public function onDown(e:MouseEvent){
			this.gotoAndStop(2);
			up_bt.addEventListener(MouseEvent.CLICK,onUp);
		}
		
		
	}
	
}
