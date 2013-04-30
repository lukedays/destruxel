package {
	import org.flixel.*;
	import com.adobe.serialization.json.JSON;
	
	public class Player extends FlxSprite {
		[Embed(source = "assets/player.png")] protected var Img:Class;
		[Embed(source = "assets/p1_jump.mp3")] private var P1Jump:Class;
		[Embed(source = "assets/p2_jump.mp3")] private var P2Jump:Class;
		[Embed(source = "assets/p1_shoot.mp3")] private var P1Shoot:Class;
		[Embed(source = "assets/p2_shoot.mp3")] private var P2Shoot:Class;
		
		public var inactive:Boolean = false;
		protected var _startx:Number;
		protected var _starty:Number;
		protected var _jumpVel:int = 650;
		protected var _runVel:int = 350;
		protected var _isJumping:Boolean;
		protected var _fireTimer:Number = 0;
		protected var _isFiring:Boolean;
		protected var _firingPeriod:Number = 0.2;

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
			// Inactive players will be controlled via network
			acceleration.y = 0;
			if (!inactive) {
				sendPosition();
				
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
					
					if (R.playerNumber == 1) FlxG.play(P1Jump, 0.1, false);
					else FlxG.play(P2Jump, 0.1, false);
				}
				
				if (touching == FlxObject.DOWN) _isJumping = false;

				if (FlxG.mouse.pressed()) {
					_isFiring = true;
				}
				else {
					_isFiring = false;
					_fireTimer = _firingPeriod;
				}

				if (_isFiring && _fireTimer >= _firingPeriod) {
					_fireTimer = 0;
					var type:int;
					if (FlxG.keys.SHIFT) type = 1;
					else type = 0;
					sendBullet(FlxG.mouse.x, FlxG.mouse.y, type);
					R.bullets.fire(FlxG.mouse.x, FlxG.mouse.y, type, 1);
					
					if (R.playerNumber == 1) FlxG.play(P1Shoot, 0.1, false);
					else FlxG.play(P2Shoot, 0.1, false);
				}
				
				if (_fireTimer < _firingPeriod) _fireTimer += FlxG.elapsed;
				play("run");
			}
			
			// Score
			if (y > R.map.height + 20) {
				flicker();
				x = _startx;
				y = _starty;
				
				if ((R.playerNumber == 1 && inactive) || (R.playerNumber == 2 && !inactive)) {
					R.player1Score++;
					R.textPlayer1Score.text = "Player 1 score: " + R.player1Score;
				}
				else if ((R.playerNumber == 2 && inactive) || (R.playerNumber == 1 && !inactive)) {
					R.player2Score++;
					R.textPlayer2Score.text = "Player 2 score: " + R.player2Score;
				}
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
		
		public function sendPosition():void {
			var mess:Object = new Object();
			mess.x = R.player1.x;
			mess.y = R.player1.y;
			R.socket1.write(JSON.encode(mess));
			R.socket1.flush();
		}
		
		public function sendBullet(x:int, y:int, type:int):void {
			var mess:Object = new Object();
			mess.bullet = true;
			mess.x = x;
			mess.y = y;
			mess.type = type;
			R.socket2.write(JSON.encode(mess));
			R.socket2.flush();
		}
	}
}