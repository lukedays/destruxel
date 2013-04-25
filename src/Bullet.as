package {
	import org.flixel.*;
	
	public class Bullet extends FlxSprite {
		[Embed(source = "assets/light.png")] protected var Img:Class;
		
        protected var _speed:int = 700;
		protected var _type:int;
        
        public function Bullet() {
            super(0, 0);
			loadGraphic(Img, true, true, R.size, R.size);
            exists = false;
        }
 
        public function fire(bx:int, by:int, type:int):void {
            x = R.player.x;
            y = R.player.y;
			_type = type;
			
			var mag:Number = Math.sqrt(Math.pow((bx - x), 2) + Math.pow((by - y), 2));
            velocity.x = _speed * (bx - x) / mag;
			velocity.y = _speed * (by - y) / mag;
			
            exists = true;
        }
        
        override public function update():void {
			var xpos:Number = Math.round(x / R.size);
			var ypos:Number = Math.round(y / R.size);
			
			changeTile(xpos, ypos);
        }
		
		protected function changeTile(xpos:int, ypos:int):void {
			if (R.map.getTile(xpos, ypos) > 0) {
				exists = false;
				
				if (_type == 0) {
					R.map.setTile(xpos, ypos, 0);
					
					// Emit debris
					R.emitter.x = xpos * R.size;
					R.emitter.y = ypos * R.size;
					R.emitter.start(true, 1, 0, 4);
				}
				else {
					R.map.setTile(xpos, ypos - 1, 1);
				}
			}
		}
	}
}