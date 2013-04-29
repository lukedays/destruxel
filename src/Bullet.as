package {
	import org.flixel.*;
	import com.adobe.serialization.json.JSON;
	
	public class Bullet extends FlxSprite {
		[Embed(source = "assets/bullet.png")] protected var Img:Class;
		
        protected var _speed:int = 900;
		protected var _type:int;
        
        public function Bullet() {
            super(0, 0);
			loadGraphic(Img, true, true, 10, 10);
            exists = false;
        }
 
        public function fire(bx:Number, by:Number, type:int):void {
            x = R.player1.x + R.player1.width / 2;
            y = R.player1.y + R.player1.height / 2;
			_type = type;
			
			var mag:Number = Math.sqrt(Math.pow((bx - x), 2) + Math.pow((by - y), 2));
            velocity.x = _speed * (bx - x) / mag;
			velocity.y = _speed * (by - y) / mag;
			
            exists = true;
        }
        
        override public function update():void {
			if (x < 0 || x > R.map.width || y < 0 || y > R.map.height) {
				exists = false;
			}
			else {
				// Check if it collided with any tile
				var xpos:Number = Math.round(x / R.size);
				var ypos:Number = Math.round(y / R.size);
				
				updateTile(xpos, ypos);
			}
        }
		
		protected function updateTile(xpos:int, ypos:int):void {
			if (R.map.getTile(xpos, ypos) > 0) {
				if (_type == 0) { // Destroy
					R.map.setTile(xpos, ypos, 0);
					sendData(xpos, ypos, 0);
					
					// Emit debris
					R.emitter.x = xpos * R.size;
					R.emitter.y = ypos * R.size;
					R.emitter.start(true, 1, 0, 4);
				}
				else { // Create
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
					
					R.map.setTile(xpos + xoff, ypos + yoff, 1);
					sendData(xpos + xoff, ypos + yoff, 1);
					
					// Make player do a little jump
					if (R.map.overlaps(R.player1)) {
						R.player1.velocity.y = -250;
					}
				}
				
				exists = false;
				R.shadows.updateVertices();
			}
		}
		
		public function sendData(x:int, y:int, tile:int):void {
			var mess:Object = new Object();
			mess.block = true;
			mess.x = x;
			mess.y = y;
			mess.tile = tile;
			R.socket2.write(JSON.encode(mess));
			R.socket2.flush();
		}
	}
}