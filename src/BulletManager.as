package {
	import org.flixel.*;

	public class BulletManager extends FlxGroup {
		public function BulletManager() {
			super();
			
			for (var i:int = 0; i < 30; ++i) {
				add(new Bullet());
			}
		}
		
		public function fire(x:int, y:int, type:int):void {
			if (getFirstAvailable()) {
				Bullet(getFirstAvailable()).fire(x, y, type);
			}
		}
	}
}