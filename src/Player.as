package {
	import org.flixel.*;
	
	public class Player extends FlxSprite {
		[Embed(source = "assets/player.png")] protected var Img:Class;
		
		protected var _jumpVel:Number = 500;
		protected var _runVel:Number = 250;

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
			
			if (FlxG.keys.LEFT) {
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if (FlxG.keys.RIGHT) {
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			
			if (FlxG.keys.justPressed("X") && !velocity.y) velocity.y = -_jumpVel;
			
			play("run");
		}
	}
}