package code.game {
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.display.MovieClip;
	
	public class Player {
		const GRAVITY:Number = 0.034;		
		const WALK_MAX_SPEED:Number = 0.500;
		const WALK_ACCELERATION:Number = 0.05;
		const RUN_MAX_SPEED:Number = 2.000;
		const RUN_ACCELERATION:Number = 0.025;
		
		var movieClip:MovieClip;
		var speed:Number;
		var dx:Number;
		var dxMax:Number;
		var acceleration:Number;
		var dy:Number;
		var dyMax:Number;
		var jumpBoost:Number;
		var alive:Boolean;
		
		var up:Boolean;
		var down:Boolean;
		var left:Boolean;
		var right:Boolean;
		var run:Boolean;
		var fast:Boolean;
		var slowing:Boolean;
		var reverse:Boolean;
		var push:Boolean;
		var pushObjectInRange:Boolean;
		var interaction:Boolean;
		
		var inGround:Boolean;
		var isFalling:Boolean;
		var hitWall:String;
		
		var animationState:String;
		
		private var screenWidth:int;
		private var screenHeight:int;
		
		public function Player(screenWidth:int, screenHeight:int) {
			//movieClip = new Player_mc();
			
			this.screenWidth = screenWidth;
			this.screenHeight = screenHeight;
		}
		
		public function initialize(player_mc:MovieClip):void{
			movieClip = player_mc;
			speed = 0;
			dx = 0;
			dxMax = WALK_MAX_SPEED;
			acceleration = WALK_ACCELERATION;
			//dy = dyMax = -17,2;
			dy = 0;
			dyMax = -0.54;
			alive = true;
			
			inGround = false;
			animationState = "stand";
			resume();
		}
		
		public function resume():void{
			up = down = left = right = run = false;
			movieClip.play();
		}
		
		public function pause():void{
			movieClip.stop();
		}
		
		public function enterFrameHandler(event:Event):void{
			if(alive){
				if(up && dy < 0){
					if(inGround){
						if(dx > RUN_MAX_SPEED*0.5){
							fast = true;
						}else{
							fast = false;
						}
						reverse = false;
					}
					if(dy == dyMax || !inGround){
						if(fast){
							if(animationState != "start_jump" && animationState != "jumping" && animationState != "landing"){
								movieClip.gotoAndPlay("inicio_pulo");
								animationState = "start_jump";
							}else if(animationState == "start_jump"){
								if(movieClip.currentLabel != "inicio_pulo"){
									animationState = "jumping";
								}
							}else if(animationState == "jumping"){
								if(movieClip.currentLabel != "loop_pulo"){
									movieClip.gotoAndPlay("loop_pulo");
								}
							}
						}else{
							if(animationState != "start_jump2" && animationState != "jumping2" && animationState != "landing2"){
								movieClip.gotoAndPlay("inicio_pulo2");
								animationState = "start_jump2";
							}else if(animationState == "start_jump2"){
								if(movieClip.currentLabel != "inicio_pulo2"){
									animationState = "jumping2";
								}
							}else if(animationState == "jumping2"){
								if(movieClip.currentLabel != "loop_pulo2"){
									movieClip.gotoAndPlay("loop_pulo2");
								}
							}
						}						
						
						dy += GRAVITY;
						movieClip.y += dy * GRAVITY*1000;
					}
				}else if(!inGround){
					if(!isFalling && 
					   animationState != "start_jump" && animationState != "start_jump2" && 
					   animationState != "jumping" && animationState != "jumping2"){
						if(dx > RUN_MAX_SPEED*0.5){
							fast = true;
						}else{
							fast = false;
						}
					}
					
					if(fast){
						if(animationState != "landing"){
							movieClip.gotoAndPlay("inicio_pulo_aterrissagem");
							animationState = "landing";
						}else{
							if(movieClip.currentLabel != "inicio_pulo_aterrissagem"){
								movieClip.stop();
							}
						}
					}else{
						if(animationState != "landing2"){
							movieClip.gotoAndPlay("inicio_queda_de_pulo2");
							animationState = "landing2";
						}else if(animationState == "landing2"){
							if(movieClip.currentLabel != "loop_queda_de_pulo2"){
								movieClip.gotoAndPlay("loop_queda_de_pulo2");
							}
						}
					}
					
					isFalling = true;
				}
				
				if(down && ((!up && inGround) || (up && dy > 0 && inGround))){
					if(dx >= RUN_MAX_SPEED*0.8){
						if(animationState != "stop"){
							movieClip.gotoAndPlay("parando");
							animationState = "stop";
						}
						slowing = true;
					}else if(dx > 0){
						if(animationState != "desacceleration" && animationState != "stop"){							
							animationState = "desacceleration";
						}else if(animationState == "desacceleration"){
							movieClip.prevFrame();
						}
						slowing = true;
					}else if(dx == 0){
						if(animationState != "start_crouch" && animationState != "crouching"){
							dx = 0;
							reverse = false;
							animationState = "start_crouch";
							movieClip.gotoAndPlay("inicio_abaixando");
						}else if(animationState == "start_crouch"){
							if(movieClip.currentLabel != "inicio_abaixando"){
								animationState = "crouching";
							}
						}else if(animationState == "crouching"){
							if(movieClip.currentLabel != "loop_abaixando"){
								movieClip.gotoAndPlay("loop_abaixando");
							}
						}
					}
				}else if(animationState == "start_crouch"){
					reverse = true;
					animationState = "back_from_down";
				}else if(animationState == "crouching"){
					reverse = true;
					movieClip.gotoAndStop("loop_abaixando");
					animationState = "back_from_down";
				}else if(animationState == "back_from_down"){
					movieClip.prevFrame();
					if(movieClip.currentLabel != "inicio_abaixando"){
						reverse = false;
					}
				}
				
				if(run && inGround && !slowing){
					dxMax = RUN_MAX_SPEED;
					acceleration = RUN_ACCELERATION;
				}else if(inGround){
					dxMax = WALK_MAX_SPEED;
					acceleration = WALK_ACCELERATION;
				}
				
				if(left && !right && hitWall != "left" && !slowing && ((inGround && !down) || !inGround)){
					if(left && dx > 0 && movieClip.scaleX > 0){
						slowing = true;
					}else{
						movieClip.scaleX = -1;
						if(inGround){
							if(dx + acceleration <= dxMax){
								dx += acceleration;
							}else if(dx - acceleration*2.0 >= dxMax){
								dx -= acceleration*2.0;
							}else{
								dx = dxMax;
							}
						}else if(dx < dxMax/1.5){
							if(dx + acceleration <= dxMax/1.5){
								dx += acceleration;
							}else if(dx - acceleration*2.0 >= dxMax/1.5){
								dx -= acceleration*2.0;
							}else{
								dx = dxMax/1.5;
							}
						}
						speed = dx * 10;
						//trace("dx: "+dx+", speed: "+speed);
						movieClip.x -= speed;
						reverse = false;
						
						if(inGround){
							if(run){
								if(animationState != "start_run" && animationState != "running" && animationState != "landing"){
									animationState = "start_run";
									movieClip.gotoAndPlay("inicio_correndo");
								}else if(animationState == "start_run"){
									if(movieClip.currentLabel != "inicio_correndo"){
										animationState = "running";
									}
								}else if(animationState == "running" || animationState == "landing"){
									if(movieClip.currentLabel != "loop_correndo"){
										movieClip.gotoAndPlay("loop_correndo");
										animationState = "running";
									}
								}
							}else{
								if(movieClip.currentLabel != "andando" || animationState != "walk"){
									animationState = "walk";
									movieClip.gotoAndPlay("andando");
								}
							}
						}
					}
				}
				
				//trace("animationstate: "+animationState+", right: "+right+", left: "+left+", down: "+down+", run: "+run+", slowing: "+slowing);
				if(right && !left && hitWall != "right" && !slowing && (dx == 0 || movieClip.scaleX > 0) && ((inGround && !down) || !inGround)){
					movieClip.scaleX = 1;
					if(inGround){
						if(dx + acceleration <= dxMax){
							dx += acceleration;
						}else if(dx - acceleration*2.0 >= dxMax){
							dx -= acceleration*2.0;
						}else{
							dx = dxMax;
						}
					}else if(dx < dxMax/1.5){
						if(dx + acceleration <= dxMax/1.5){
							dx += acceleration;
						}else if(dx - acceleration*2.0 >= dxMax/1.5){
							dx -= acceleration*2.0;
						}else{
							dx = dxMax/1.5;
						}
					}
					speed = dx * 10;
					//trace("dx: "+dx+", speed: "+speed);
					movieClip.x += speed;
					reverse = false;
					
					if(inGround){
						if(run){
							if(animationState != "start_run" && animationState != "running" && animationState != "landing"){
								animationState = "start_run";
								movieClip.gotoAndPlay("inicio_correndo");
							}else if(animationState == "start_run"){
								if(movieClip.currentLabel != "inicio_correndo"){
									animationState = "running";
								}
							}else if(animationState == "running" || animationState == "landing"){
								if(movieClip.currentLabel != "loop_correndo"){
									movieClip.gotoAndPlay("loop_correndo");
									animationState = "running";
								}
							}
						}else{
							if(movieClip.currentLabel != "andando" || animationState != "walk"){
								animationState = "walk";
								movieClip.gotoAndPlay("andando");
							}
						}
					}
				}
				
				if(hitWall == "right" || hitWall == "left"){
					if(animationState != "start_push" && animationState != "pushing"){
						dx = 0;
					}if(!pushObjectInRange && !up && !down && (right && hitWall == "right" || left && hitWall == "left")){
						if(movieClip.currentLabel != "loop_parado"){
							animationState = "stand";
							movieClip.gotoAndPlay("loop_parado");
						}
					}
				}if(run && pushObjectInRange && inGround && !down && (right && hitWall == "right" || left && hitWall == "left")){
					if(animationState != "start_push" && animationState != "pushing"){
						animationState = "start_push";
						movieClip.gotoAndPlay("inicio_empurrando");
					}else if(animationState == "start_push"){
						if(movieClip.currentLabel != "inicio_empurrando"){
							animationState = "pushing";
						}
					}else if(animationState == "pushing"){
						push = true;
						if(movieClip.currentLabel != "loop_empurrando"){
							movieClip.gotoAndPlay("loop_empurrando");
							animationState = "pushing";
						}
					}					
				}else if(animationState == "pushing"){
					dx = 0;
					push = false
					reverse = true;
					movieClip.gotoAndStop("loop_empurrando");
					animationState = "back_from_push";
				}else if(animationState == "start_push"){
					dx = 0;
					push = false
					reverse = true;
					animationState = "back_from_push";
				}else if(animationState == "back_from_push"){
					movieClip.prevFrame();
					if(movieClip.currentLabel != "inicio_empurrando"){
						reverse = false;
					}
				}
				
				if((!left && !right) || (left && right) || slowing ||
				   left && dx > 0 && movieClip.scaleX > 0 || right && dx > 0 && movieClip.scaleX < 0){
					if(dx > 0){
						if(movieClip.scaleX > 0 && (left || down)){
							if(dx - acceleration*2.5 >= 0){
								dx -= acceleration*2.5;
							}else{
								dx = 0;
							}
						}else if(movieClip.scaleX < 0 && (right || down)){
							if(dx - acceleration*2.5 >= 0){
								dx -= acceleration*2.5;
							}else{
								dx = 0;
							}
						}else{
							if(dx - acceleration*1.2 >= 0){
								dx -= acceleration*1.2;
							}else{
								dx = 0;
							}
						}						
						speed = dx * 10;
						movieClip.x += speed*movieClip.scaleX;
						slowing = true;
					}else{
						slowing = false;
					}
				}
				
				if((inGround && !down && !reverse && (!left && !right || left && right || slowing ||
				   left && dx > 0 && movieClip.scaleX > 0 || right && dx > 0 && movieClip.scaleX < 0)) ||
				   (inGround && !down && !reverse && (!run || !pushObjectInRange) && (right && hitWall == "right" || left && hitWall == "left"))){
					//trace(animationState);
					if(dx >= RUN_MAX_SPEED*0.8){
						if(animationState != "stop"){
							movieClip.gotoAndPlay("parando");
							animationState = "stop";
						}
					}else if(dx > 0){
						if(animationState != "desacceleration" && animationState != "stop"){														
							if(animationState == "start_run" || animationState == "running" || animationState == "landing"){
								movieClip.gotoAndStop("loop_correndo");
							}else{
								movieClip.gotoAndStop("inicio_correndo");
							}
							animationState = "desacceleration";
							
						}else if(animationState == "desacceleration"){
							movieClip.prevFrame();
						}else if(animationState == "stop"){
							if(movieClip.currentLabel != "parando"){
								movieClip.prevFrame();
							}
						}
					}else if(dx == 0){
						if(movieClip.currentLabel != "loop_parado"){
							dx = 0;
							animationState = "stand";
							movieClip.gotoAndPlay("loop_parado");
							//trace("-=-=-=-=-=-=-=-=: "+dx);
						}
					}
				}
			}
		}
		
		public function onColision(event:Event):void{
			if(inGround){
				isFalling = false;
				if(!up){
					dy = dyMax;
				}
			}else if(isFalling){
				/*
				para o valor da descida ser igual o da subida 
				o valor de dy inicial deve ser divisivel 
				pelo acrescimo de dy...
				*/
				
				if(dy < 0){
					dy = 0;
				}
				//dy += 1.156;
				//movieClip.y += dy;
				
				dy += GRAVITY;
				movieClip.y += dy * GRAVITY*1000;
				//trace("dy: "+dy);
				//trace("final: "+dy*34);
			}
		}
		
		public function collide(target:DisplayObject, considerParent:Boolean = false):Boolean{
			var targetBox:Rectangle;
			var playerBox:Rectangle;
			
			if(considerParent){
				targetBox = new Rectangle(target.parent.x + target.x, target.parent.y + target.y, target.width, target.height);
				//trace("parent: "+target.parent+", "+targetBox.x+" x "+targetBox.y);
			}else{
				targetBox = new Rectangle(target.x, target.y, target.width, target.height);
			}if(dy + GRAVITY > 0){				
				playerBox = new Rectangle(0, 0, 34, 70 + (dy + GRAVITY) * GRAVITY*1000);
				playerBox.x = movieClip.x - playerBox.width/2;
				playerBox.y = movieClip.y - 70;
			}else{				
				playerBox = new Rectangle(0, 0, 34, 70 + 1);
				playerBox.x = movieClip.x - playerBox.width/2;
				playerBox.y = movieClip.y - 70;
			}
			
			if(playerBox.intersects(targetBox)){
				if(movieClip.y <= target.y){
					//trace("|HIT| dy: " + dy + ", player.bottom: " + (movieClip.y) + ", p.box.bottom: " + (playerBox.y + playerBox.height) + ", target.top: " + (targetBox.y));
					movieClip.y = target.y;
					
					return true;
				}else{
					//trace("dy: " + dy + ", player.bottom: " + (movieClip.y) + ", p.box.bottom: " + (playerBox.y + playerBox.height) + ", target.top: " + (targetBox.y));
					
					return false;
				}				
			}else{
				if(target.name == "teste"){
					//trace("|MISS| dy: " + dy + ", player.bottom: " + (movieClip.y) + ", p.box.bottom: " + (playerBox.y + playerBox.height) + ", target.top: " + (targetBox.y));
				}
				return false;
			}
		}
		
		public function collideSide(target:DisplayObject, direction:int):Boolean{
			var targetBox:Rectangle = new Rectangle(target.x, target.y, target.width, target.height);
			var playerBox:Rectangle;
			
			if(dx > 0){
				//(speed * direction)
				//((dx + acceleration)*10 * direction)
				playerBox = new Rectangle(0, 0, 34, 70);
				//playerBox.x = movieClip.x - playerBox.width/2 + ((dx + acceleration)*10 * direction);
				playerBox.x = movieClip.x - playerBox.width/2 + ((dx + acceleration)*10 * direction);
				playerBox.y = movieClip.y - 70;				
			}else{
				playerBox = new Rectangle(0, 0, 34, 70);
				playerBox.x = movieClip.x - playerBox.width/2 + (1 * direction);
				playerBox.y = movieClip.y - 70;
			}
			//trace("player.left: "+(movieClip.x-movieClip.width/2)+" player.right: "+(movieClip.x+movieClip.width-movieClip.width/2));
			//trace("playerBox.left: "+(playerBox.x)+" playerBox.right: "+(playerBox.x+playerBox.width));
			//trace("target.left: "+(target.x)+" target.right: "+(target.x+target.width));
			//trace("targetBox.left: "+(targetBox.x)+" targetBox.right: "+(targetBox.x+targetBox.width));
			//trace(" ");
			
			if(playerBox.intersects(targetBox)){				
				if(direction > 0){
					//trace("player.right: "+(movieClip.x+movieClip.width)+" target.left: "+(target.x));
					//trace("playerBox.right: "+(playerBox.x+playerBox.width)+" targetBox.left: "+(targetBox.x));
					//trace("final.x:"+(targetBox.x - 17));
					//trace(playerBox.x+", "+movieClip.x+"/"+(movieClip.x+movieClip.bb_mc.x));
					if(movieClip.x + playerBox.width/2 <= targetBox.x){
						speed = targetBox.x - (movieClip.x + playerBox.width/2);
						movieClip.x += speed;
						
						return true;
					}else{
						return false;
					}
				}else{
					//trace("player.left: "+(movieClip.x)+" target.right: "+(target.x+target.width));
					//trace("playerBox.left: "+(playerBox.x)+" targetBox.right: "+(targetBox.x+targetBox.width));
					//trace("final.x:"+(targetBox.x + targetBox.width));
					if(movieClip.x - playerBox.width/2 >= targetBox.x + targetBox.width){
						speed = (targetBox.x + targetBox.width) - (movieClip.x - playerBox.width/2);
						movieClip.x += speed;
						
						return true;
					}else{
						return false;
					}					
				}
				
				return true;
			}else{
				return false;
			}
		}
		
		public function keyDownHandler(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.SPACE:
					up = true;
					break;
				case Keyboard.Z:
					up = true;
					break;
				case Keyboard.DOWN:
					down = true;
					break;
				case Keyboard.LEFT:
					left = true;
					break;
				case Keyboard.RIGHT:
					right = true;
					break;
				case Keyboard.CONTROL:
					run = true;
					break;
				case Keyboard.X:
					run = true;
					break;
				case Keyboard.UP:
					interaction = true;
					break;
			}
		}
		
		public function keyUpHandler(event:KeyboardEvent):void{
			switch(event.keyCode){
				case Keyboard.SPACE:
					up = false;
					break;
				case Keyboard.Z:
					up = false;
					break;
				case Keyboard.DOWN:
					down = false;
					break;
				case Keyboard.LEFT:
					left = false;
					break;
				case Keyboard.RIGHT:
					right = false;
					break;
				case Keyboard.CONTROL:
					run = false;
					break;
				case Keyboard.X:
					run = false;
					break;
				case Keyboard.UP:
					interaction = false;
					break;
			}
		}
	}
}