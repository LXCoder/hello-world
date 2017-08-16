package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.net.SharedObject;
	
	
	public class the_game_over extends MovieClip {
		public var main_class:main_control;
		private var GameTopList:Array;
		private var topNum:int;
		private var score:Number;
		
		public function the_game_over(passed_class:main_control,passed_score:Number) {
			// constructor code
			main_class=passed_class;
			score=passed_score;
			
			this.addEventListener(Event.ADDED_TO_STAGE,onStageHandler);
			
		}
		
		
		public function onStageHandler(e:Event){
        	init();
        	this.removeEventListener(Event.ADDED_TO_STAGE,onStageHandler);
        }
		
		public function init(){
			Mouse.show();
			
			GameTopList=new Array();
			topNum=5;
			yes_bt.addEventListener(MouseEvent.CLICK,onYesBt);
			no_bt.addEventListener(MouseEvent.CLICK,onNoBt);
			ok_bt.addEventListener(MouseEvent.CLICK,submitScore);
			main_bt.addEventListener(MouseEvent.CLICK,onMainBt);
		}
		
		//提交成绩
		public function submitScore(evt:MouseEvent) {
			if (name_text.text!="") {
				readScore();
				var newRecord:Object={player:name_text.text,score:this.score};
				GameTopList.push(newRecord);
				GameTopList.sortOn("score",Array.NUMERIC|Array.DESCENDING);//对数组排序
				saveScore();
				this.gotoAndStop(3);
				displayScore();
			}
		}
		
		//保存排行榜
		public function saveScore() {
			var so:SharedObject = SharedObject.getLocal("heroList");
			var str:String="";
			var count:int=0;
			while (GameTopList.length!=0&&count<topNum) {
				var temp:Object=GameTopList.shift();
				str+=temp.player+":"+temp.score;
				count++;
				if (GameTopList.length!=0&&count<topNum) {
					str+=",";
				}
			}
			so.data.topList=str;
			so.flush();
		}
		
		//显示排行榜
		public function displayScore() {
			readScore();
			heroList.text="";
			var order:int=1;
			while (GameTopList.length!=0) {
				var temp:Object=GameTopList.shift();
				heroList.appendText(order+". "+ temp.player+"   成绩：" + temp.score + "\n"+" ");
				order++;
			}
		}
		
		//读取排行榜
		public function readScore() {
			GameTopList=new Array();
			var so:SharedObject=SharedObject.getLocal("heroList");
			var str:String;
			if (so.data.topList!=null) {
				str=String(so.data.topList);
			}
			//trace(str);
			var topScore:Array;
			if (str!=null) {
				topScore=str.split(",");
				for (var i:int =0; i<topScore.length; i++) {
					var singleRecord:Array;
					singleRecord=String(topScore[i]).split(":");
					var newRecord:Object={player:String(singleRecord[0]),score:Number(singleRecord[1])};
					GameTopList.push(newRecord);
				}
			}
		}
		
		public function onYesBt(e:MouseEvent){
			main_class.show_game();
		}
		
		public function onNoBt(e:MouseEvent){
			toTwo();
		}
		
		public function toTwo(){
			this.gotoAndStop(2);
			sorce_text.text=String(this.score);
		}
		
		public function onMainBt(e:MouseEvent){
			main_class.show_intro();
		}
	}
	
}
