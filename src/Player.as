package {
	import org.flixel.*;
	import com.adobe.serialization.json.JSON;
	
	public class Player extends FlxSprite {
		[Embed(source = "assets/player.png")] protected var Img:Class;
		
		public var inactive:Boolean = false;
		protected var _startx:Number;
		protected var _starty:Number;
		protected var _jumpVel:int = 650;
		protected var _runVel:int = 350;
		protected var _isJumping:Boolean;

		public function Player(x:Number, y:Number) {
			_startx = x;
			_starty = y;
			super(_startx, _starty);
			loadGraphic(Img, true, true, 40, 40);
			
			maxVelocity.x = _runVel;
			maxVelocity.y = _jumpVel;
			drag.x = _runVel * 10;
			
			addAnimation("run", [0]);
		}
		
		override public function update():void {
			acceleration.y = 0;
			
			if (y > R.map.height) {
				flicker();
				x = _startx;
				y = _starty;
				
				if (R.playerNumber == 1) {
					R.player2Score++;
					R.textPlayer2Score.text = "Player 2 score: " + R.player2Score;
				}
				else {
					R.player1Score++;
					R.textPlayer1Score.text = "Player 1 score: " + R.player1Score;
				}
			}
			
			// Inactive players will be controlled via network
			if (!inactive) {
				acceleration.x = 0;
				acceleration.y = 1000;
				
				if (FlxG.keys.pressed("A")) {
					facing = LEFT;
					acceleration.x -= drag.x;
				}
				else if (FlxG.keys.pressed("D")) {
					facing = RIGHT;
					acceleration.x += drag.x;
				}
				
				if (!_isJumping && FlxG.keys.pressed("W") && !velocity.y) {
					_isJumping = true;
					velocity.y = -_jumpVel;
				}
				
				if (touching == FlxObject.DOWN) _isJumping = false;
				
				if (FlxG.mouse.justPressed()) {
					var type:int;
					if (FlxG.keys.SHIFT) type = 1;
					else type = 0;
					R.bullets.fire(FlxG.mouse.x, FlxG.mouse.y, type);
				}
				
				play("run");
				sendData();
			}
			
			if (R.playerNumber == 1) {
				R.player1.color = 0x0000BB;
				R.player2.color = 0xBB0000;
			}
			
			if (R.playerNumber == 2) {
				R.player1.color = 0xBB0000;
				R.player2.color = 0x0000BB;
			}
		}
		
		public function sendData():void {
			var mess:Object = new Object();
			mess.position = true;
			mess.x = R.player1.x;
			mess.y = R.player1.y;
			R.socket1.write(JSON.encode(mess));
			R.socket1.flush();
		}
	}
}