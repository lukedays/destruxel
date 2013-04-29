package {
	import org.flixel.*;
	import com.adobe.serialization.json.JSON;
	
	public class Player extends FlxSprite {
		[Embed(source = "assets/player.png")] protected var Img:Class;
		
		public var inactive:Boolean = false;
		protected var _networkTimer:Number = 0;
		protected var _jumpVel:int = 650;
		protected var _runVel:int = 350;
		protected var _isJumping:Boolean;

		public function Player(x:Number, y:Number) {
			super(x, y);
			loadGraphic(Img, true, true, 40, 40);
			
			maxVelocity.x = _runVel;
			maxVelocity.y = _jumpVel;
			drag.x = _runVel * 10;
			
			addAnimation("run", [0]);
		}
		
		override public function update():void {
			acceleration.y = 0;
			
			if (!inactive) {
				acceleration.x = 0;
				acceleration.y = 1000;
				
				if (FlxG.keys.pressed("A")) {
					facing = LEFT;
					acceleration.x -= drag.x;
					sendData();
				}
				else if (FlxG.keys.pressed("D")) {
					facing = RIGHT;
					acceleration.x += drag.x;
					sendData();
				}
				
				if (!_isJumping && FlxG.keys.pressed("W") && !velocity.y) {
					_isJumping = true;
					velocity.y = -_jumpVel;
					sendData();
				}
				
				if (touching == FlxObject.DOWN) _isJumping = false;
				
				if (FlxG.mouse.justPressed()) {
					var type:int;
					if (FlxG.keys.SHIFT) type = 1;
					else type = 0;
					R.bullets.fire(FlxG.mouse.x, FlxG.mouse.y, type);
				}
				
				play("run");
			}
			
			if (R.playerNumber == 1) {
				R.player2.color = 0xFF0000;
			}
			
			if (R.playerNumber == 2) {
				R.player1.color = 0xFF0000;
			}
			
			if (_networkTimer < 1) _networkTimer += FlxG.elapsed;
		}
		
		public function sendData():void {
			if (_networkTimer >= 1) {
				_networkTimer = 0;
				var mess:Object = new Object();
				mess.player = R.playerNumber;
				mess.x = R.player1.x;
				mess.y = R.player1.y;
				R.socket.write(JSON.encode(mess));
				R.socket.flush();
			}
		}
	}
}