package  {
	
	import flash.display.MovieClip;
	
	
	public class main_control extends MovieClip {
		public var intro:intro_screen;
		public var help:how_to_play;
		public var game:the_game_itself;
		public var over:the_game_over;
		
		public function main_control() {
			// constructor code
			show_intro();
			//show_over(1020);
			//show_game();
		}
		
		public function show_intro(){
			intro=new intro_screen(this);
			if(help){
				removeChild(help);
				help=null;
			}
			if(over){
				removeChild(over);
				over=null;
			}
			addChild(intro);
		}
		
		public function show_help(){
			help=new how_to_play(this);
			if(intro){
				removeChild(intro);
				intro=null;
			}
			addChild(help);
		}
		
		public function show_game(){
			game=new the_game_itself(this);
			if(intro){
				removeChild(intro);
				intro=null;
			}
			if(over){
				removeChild(over);
				over=null;
			}
			addChild(game);
		}
		
		public function show_over(passed_score:int){
			over=new the_game_over(this,passed_score);
			if(game){
				removeChild(game);
				game=null;
			}
			addChild(over);
		}
		
		public function show_win(passed_score:int){
			over=new the_game_over(this,passed_score);
			if(intro){
				removeChild(intro);
				intro=null;
			}
			addChild(over);
			over.toTwo();
			
		}
		
		public function show_rank(level:int){
			over=new the_game_over(this,0);
			if(intro){
				removeChild(intro);
				intro=null;
			}
			addChild(over);
			over.gotoAndStop(level);
			over.displayScore();
		}
	}
	
}
