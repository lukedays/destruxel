package {
	import org.flixel.*;
	import com.adobe.serialization.json.JSON;
	
	public class Bullet extends FlxSprite {
		[Embed(source = "assets/bullet.png")] protected var Img:Class;
		[Embed(source = "assets/create.mp3")] private var Create:Class;
		[Embed(source = "assets/destroy.mp3")] private var Destroy:Class;
		
        protected var _speed:int = 800;
		protected var _type:int;
        
        public function Bullet() {
            super(0, 0);
			loadGraphic(Img, true, true, 10, 10);
            exists = false;
        }
 
        public function fire(bx:Number, by:Number, type:int, origin:int):void {
			if (origin == 1) {
				x = R.player1.x + R.player1.width / 2;
				y = R.player1.y + 5;
			}
			else {
				x = R.player2.x + R.player2.width / 2;
				y = R.player2.y + 5;
			}
			_type = type;
			
			var mag:Number = Math.sqrt(Math.pow((bx - x), 2) + Math.pow((by - y), 2));
            velocity.x = _speed * (bx - x) / mag;
			velocity.y = _speed * (by - y) / mag;
			
            exists = true;
        }

		override public function update():void {
			var xpos:Number = Math.round(x / R.size);
			var ypos:Number = Math.round(y / R.size);
			
			// If collided with a tile or a boundary except bottom
			if (R.map.getTile(xpos, ypos) > 0 || x < 0 || x > R.map.width || y < 0) {
				if (_type == 1) { // Create
					var xoff:int;
					var yoff:int;
					if (velocity.x > 0 && Math.abs(velocity.x) >= 2 * Math.abs(velocity.y)) {
						xoff = -1;
						yoff = 0;
					}
					if (velocity.x < 0 && Math.abs(velocity.x) >= 2 * Math.abs(velocity.y)) {
						xoff = 1;
						yoff = 0;
					}
					if (velocity.y > 0 && Math.abs(velocity.y) >= 2 * Math.abs(velocity.x)) {
						xoff = 0;
						yoff = -1;
					}
					if (velocity.y < 0 && Math.abs(velocity.y) >= 2 * Math.abs(velocity.x)) {
						xoff = 0;
						yoff = 1;
					}
					/*
					trace(touching);
					trace(x / R.size);
					trace(xpos);
					if (x / R.size - xpos > 0 && x / R.size - xpos < 2) {
						xoff = -1;
						yoff = 0;
					}
					if (xpos - x / R.size + R.size > 0 && xpos - x / R.size + R.size < 2) {
						xoff = 1;
						yoff = 0;
					}
					if (y / R.size - ypos > 0 && y / R.size - ypos < 2) {
						xoff = 0;
						yoff = -1;
					}
					if (ypos - y / R.size + R.size > 0 && ypos - y / R.size + R.size < 2) {
						xoff = 0;
						yoff = 1;
					}*/
					
					R.map.setTile(xpos + xoff, ypos + yoff, 1);
					
					FlxG.play(Create, 0.1, false);
				}
				else { // Destroy
					R.map.setTile(xpos, ypos, 0);
					
					// Emit debris
					R.emitter.x = xpos * R.size;
					R.emitter.y = ypos * R.size;
					R.emitter.start(true, 1, 0, 4);
					
					FlxG.play(Destroy, 0.1, false);
				}
				
				exists = false;
				R.shadows.updateVertices();
			}
			// If collided with the bottom boundary
			else if (y > R.map.height) {
				exists = false;
			}
		}
	}
}