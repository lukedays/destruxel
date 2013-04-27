package {
	import org.flixel.*;
	
	public class Player extends FlxSprite {
		[Embed(source = "assets/player.png")] protected var Img:Class;
		
		protected var _jumpVel:int = 500;
		protected var _runVel:int = 250;
		protected var _isJumping:Boolean;

		public function Player(x:Number, y:Number) {
			super(x, y);
			loadGraphic(Img, true, true, 25, 25);
			
			maxVelocity.x = _runVel;
			maxVelocity.y = _jumpVel;
			drag.x = _runVel * 10;
			acceleration.y = 800;
			
			addAnimation("run", [0]);
		}
		
		override public function update():void {
			acceleration.x = 0;
			
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
		}
	}
}