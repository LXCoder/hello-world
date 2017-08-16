package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import fl.motion.ColorMatrix;
	import flash.filters.ColorMatrixFilter;
	
	
	
	public class the_game_itself extends MovieClip {
		public var main_class:main_control;
		private var isPlay:Boolean=true;//总体开关
		private var isBoss:Boolean=true;//Boss开关
		private var isZero:Boolean;//怪物是否为零
		private var levelScreen:Number;//关卡
		private var active_arr:Array;//存放每个关卡目标数
		private var bars:Array;//存放障碍物数组
		private var hero:Hero;//英雄
		private var enemy:MovieClip;//敌人
		private var blood:Blood;
		private var enemies_arr:Array;//存放敌人的数组
		private var _arrow:Arrow;//箭
		private var arrows_arr:Array;//存放➹的数组
		private var rock:Rock_man;//Boss
		private var boss_hp:Boss_blood;//Boss血条
		private var sound:Sound;//声音
		private var chl:SoundChannel;//声音控制
		private var pos:Number;//音乐进度
		
		
		
		public function the_game_itself(passed_class:main_control) {
			// constructor code
			main_class=passed_class;
			this.addEventListener(Event.ADDED_TO_STAGE,onStageHandler);
			
			
			
		}
		public function onStageHandler(e:Event){
        	init();
        	this.removeEventListener(Event.ADDED_TO_STAGE,onStageHandler);
        }
		
		private function init(){
			Mouse.hide();
			levelScreen=1;
			next_bt.alpha=0;
			next_bt.mouseEnabled =false;
			next_level_screen.alpha=0;
			BGM("3962.mp3");
			addBars();
			addHero();
			
			enemies_arr=new Array();
			arrows_arr=new Array();
			//active_arr = [25,50,75,200];
			active_arr = [5,10,15,1000];//测试专用
			showGameData();
			addEnemy();
			
			blood=new Blood();
			addChild(blood);
			blood.visible=false;
			
			
			stage.focus=this;
			stage.addEventListener(MouseEvent.MOUSE_DOWN,Shot);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,rott);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseFollow);
			next_bt.addEventListener(MouseEvent.CLICK,onNext);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			
		}
		
		public function onEnterFrame(e:Event){
			addOtherEnemy();
			EndGame();
			//checkHit();
			autoWalk();
			NextLevel();
			
		}
		
		
		//创建英雄
		public function addHero(){
			hero=new Hero();
			addChild(hero);
			hero.scaleX=0.7;//角色大小缩放
			hero.scaleY=0.7;
		}
		
		//创建敌人
		public function addEnemy(){
			
			for(var i:int=0;i<5;i++){
				enemy=new Enemy();
				enemy.x=Math.random()*FWConstants.STAGE_WIDTH;
				enemy.y=Math.random()*FWConstants.STAGE_HEIGHT;
				addChild(enemy);
				enemies_arr.push(enemy);
			}
			
		}
		
		//额外加敌人
		public function addOtherEnemy(){
			//舞台外随机坐标的生成
			var coordinate:Array=new Array();//存储坐标数组
			coordinate.push({x: Math.random()*FWConstants.STAGE_WIDTH,y: -Math.random()*100});
			coordinate.push({x: Math.random()*100+FWConstants.STAGE_WIDTH,y: Math.random()*FWConstants.STAGE_HEIGHT});
			coordinate.push({x: Math.random()*FWConstants.STAGE_WIDTH,y: Math.random()*100+FWConstants.STAGE_HEIGHT});
			coordinate.push({x: -Math.random()*100,y: Math.random()*FWConstants.STAGE_HEIGHT});
			//生成随机怪物
			if(enemies_arr.length<5*levelScreen && isBoss){
				var enemy_index:int=Math.random()*levelScreen+1;
				
				var spirder:MovieClip;
				if(enemy_index==1){
					spirder=new Enemy();
					
				}else if(enemy_index==2){
					spirder=new Spider();
					//随机大小
					var size:Number=Math.random();
					spirder.scaleX=size;
					spirder.scaleY=size;
					//更换颜色
					var tempColor:Number=Math.random()*255;
					var color:Number=Math.random()>0.5 ? -tempColor : tempColor;
					var Color_Matrix:ColorMatrix=new ColorMatrix();
					var Color_Filter:ColorMatrixFilter=new ColorMatrixFilter();
					Color_Matrix.SetHueMatrix(color);
					Color_Filter.matrix = Color_Matrix.GetFlatArray();
					spirder.filters=[Color_Filter];
				}else if(enemy_index==3){
					spirder = new Tree_man();
					spirder.scaleX=0.8;
					spirder.scaleY=0.8;
				}else{
					return;
				}
			
			var index:Number=Math.floor(Math.random()*4);
			spirder.x=coordinate[index].x;
			spirder.y=coordinate[index].y;
			addChild(spirder);
			enemies_arr.push(spirder);

			}
			
			


		}
		
		//添加障碍物
		public function addBars() {
			bars = new Array();
			var i:int = 1;
			while (true) {
				if(this.getChildByName("bar"+i)==null){
					break;
				}
				var bar = new Object();
				bar.mc = this.getChildByName("bar"+i);
				bar.leftside=bar.mc.x;
				bar.rightside=bar.mc.x+bar.mc+bar.mc.width;
				bar.topside=bar.mc.y;
				bar.bottomside=bar.mc.y+bar.mc.height;
				bars.push(bar);
				i++;
			}
		}
		
		//障碍物阻挡
		public function checkHit(){
			//trace(newX);
			for(var i:int=bars.length-1;i>=0;i--){
				if(hero.hitTestObject(bars[i].mc)){
					hero.movingDown=false;
					hero.movingLeft=false;
					hero.movingRight=false;
					hero.movingUp=false;
					break;
				}
				
				
			}
		}
		
		//发射
		public function Shot(e:MouseEvent){
			if(isPlay){
				_arrow=new Arrow(hero.x,hero.y);
				var dx:Number=mouseX-_arrow.x;
  				var dy:Number=mouseY-_arrow.y;
				var radians:Number=Math.atan2(dy,dx);
   				_arrow.rotation=radians*180/Math.PI;
				SoundPlay("3961.mp3");
				addChild(_arrow);
				arrows_arr.push(_arrow);
				addEventListener(Event.ENTER_FRAME,CheckHitOfEnemy);
			}else{
				return;
			}
			
		}
		
		//击中敌人
		public function CheckHitOfEnemy(e:Event){
			var tempEnemy:MovieClip;
			var tempArrow:MovieClip;
			for(var arrowNum:int=arrows_arr.length-1;arrowNum>=0;arrowNum--){
				tempArrow=arrows_arr[arrowNum];
				for(var enemyNum:int=enemies_arr.length-1;enemyNum>=0;enemyNum--){
					tempEnemy=enemies_arr[enemyNum];
					if(tempArrow.hitTestPoint(tempEnemy.x,tempEnemy.y)){
						if(tempEnemy.blood<=0){
							
							if(tempEnemy as Rock_man){
								isBoss=false;
							}
							
							tempEnemy.EnemyHit();
							hero.kills++;
							hero.score +=tempEnemy.SCORE;
							if(enemies_arr.length==0){
								isZero=true;
							}
							
						}else{
							tempEnemy.blood-=10;
							tempEnemy.gotoAndPlay("hit");
							
							
						}
						tempArrow.deleteArrow();
			
						showGameData();
						break;
					}
				}
			}
			
		}
		
		//与敌人碰撞
		public function CheckHitEnemy(e:Event){
			for(var enemyNum:int=enemies_arr.length-1;enemyNum>=0;enemyNum--){
				if(enemies_arr[enemyNum].hitTestPoint(hero.x,hero.y)){
					hero.Hit();
					blood.visible=true;
					showGameData();
				}else{
					blood.visible=false;
				}
			}
			
			
		}
		
		//清理
		public function removeEnemy(enemy:MovieClip){
			for(var i in enemies_arr){
				if(enemies_arr[i]==enemy){
					enemies_arr.splice(i,1);
					break;
				}
			}
		}
		
		public function removeArrow(_arrow:MovieClip){
			for(var i in arrows_arr){
				if(arrows_arr[i]==_arrow){
					arrows_arr.splice(i,1);
					break;
				}
			}
		}
		
		//显示数据
		public function showGameData(){
			
			score.text=String(hero.score);
			kills.text=String(hero.kills);
			level.text=String(levelScreen);
			HP.scaleX=hero.hp/100;
			var percent:Number=hero.kills/active_arr[levelScreen-1];
			active.scaleX=percent;
			

			
			
		}
		
		
		//自动跟随
		public function autoWalk(){
			if(isPlay){
				for(var i:int=enemies_arr.length-1;i>=0;i--){
					var dx:Number=hero.x-enemies_arr[i].x;
					var dy:Number=hero.y-enemies_arr[i].y;
					var distance:Number=Math.sqrt(dx*dx+dy*dy);
			
					if(distance<=enemies_arr[i].RANG){
						var moveX:Number=enemies_arr[i].TRUN_SPEED*dx/distance;
						var moveY:Number=enemies_arr[i].TRUN_SPEED*dy/distance;
					
						enemies_arr[i].vx +=moveX;
						enemies_arr[i].vy +=moveY;
				
						var moveDistance:Number=Math.sqrt(enemies_arr[i].vx*enemies_arr[i].vx+enemies_arr[i].vy*enemies_arr[i].vy);
				
						enemies_arr[i].vx=enemies_arr[i].SPEED*enemies_arr[i].vx/moveDistance;
						enemies_arr[i].vy=enemies_arr[i].SPEED*enemies_arr[i].vy/moveDistance;
					
						enemies_arr[i].rotation=180*Math.atan2(enemies_arr[i].vy,enemies_arr[i].vx)/Math.PI+15;
				
						enemies_arr[i].vx *= enemies_arr[i].FRICTION;
						enemies_arr[i].vy *= enemies_arr[i].FRICTION;
				
						enemies_arr[i].x += enemies_arr[i].vx;
						enemies_arr[i].y += enemies_arr[i].vy;
					}
					addEventListener(Event.ENTER_FRAME,CheckHitEnemy);
				}
			}
		}
		
		//鼠标跟随
		public function mouseFollow(e:MouseEvent){
			
			mouse.x=mouseX;
			mouse.y=mouseY;
			
		}
		
		//旋转
		public function rott(event:MouseEvent):void {
   			if(isPlay){
				var dx:Number=mouseX-hero.x;
  				var dy:Number=mouseY-hero.y;
   				var radians:Number=Math.atan2(dy,dx);
   				hero.rotation=radians*180/Math.PI;
			}
		}
		
		
		//射箭音
		public function SoundPlay(misic:String){
			var _sound:Sound=new Sound();
			var req:URLRequest=new URLRequest(misic);
			_sound.load(req);
			_sound.play();
		}
		
		//背景音
		public function BGM(misic:String){
			sound=new Sound();
			var req:URLRequest=new URLRequest(misic);
			sound.load(req);
			chl=sound.play(0,2);
		}
		
		public function soundPlay(e:MouseEvent){
			chl=sound.play(pos,3);
			sound_control.gotoAndStop(1);
		}
		
		public function soundStop(e:MouseEvent){
			pos=chl.position;
			chl.stop();
			sound_control.gotoAndStop(2);
		}
		
		
		//达成通关条件触发
		public function NextLevel(){
			if(hero.kills==active_arr[levelScreen-1] || isZero){
				hero.Pause();
				if(isBoss==false && isZero){
					hero.status="win";
					next_level_screen.intro_txt.text="你已完成全部关卡！"
					
				}
				next_bt.mouseEnabled =true;
				next_bt.alpha=1;
				next_level_screen.alpha=1;
				isPlay=false;
				
			}
			
			
		}
		
		//下一关按钮
		public function onNext(e:MouseEvent){
			if(hero.status=="win"){
				ClearListener();
				main_class.show_win(hero.score);
			}else{
				hero.Play();
				isPlay=true;
				levelScreen++;
			}
			
			next_bt.alpha=0;
			next_level_screen.alpha=0;
			next_bt.mouseEnabled =false;
			showGameData();
			
			//第四关，加BOSS
			if(levelScreen==4){
				addBoss();
			}
			
		}
		
		//实例化BOSS
		public function addBoss(){
			rock=new Rock_man();
			rock.x=200;
			rock.y=200;
			rock.scaleX=0.5;
			rock.scaleY=0.5;
			enemies_arr.push(rock);
			addChild(rock);
			boss_hp=new Boss_blood(rock);
			boss_hp.x=110;
			boss_hp.y=635;
			addChild(boss_hp);
		}
		
		//game over
		public function EndGame(){
			if(hero.status=="dead"){
				ClearListener();
				main_class.show_over(hero.score);
			}
		}
		
		//清除侦听
		public function ClearListener(){
			chl.stop();
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,Shot);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,rott);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseFollow);
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			removeEventListener(Event.ENTER_FRAME,CheckHitOfEnemy);
			removeEventListener(Event.ENTER_FRAME,CheckHitEnemy);
			next_bt.removeEventListener(MouseEvent.CLICK,onNext);
		}
		
	}
	
}
