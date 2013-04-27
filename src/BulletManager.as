package {
	import org.flixel.*;

	public class BulletManager extends FlxGroup {
		public function BulletManager() {
			super();
			
			for (var i:int = 0; i < 60; ++i) {
				add(new Bullet());
			}
		}
		
		public function fire(x:Number, y:Number, type:int):void {
			if (getFirstAvailable()) {
				Bullet(getFirstAvailable()).fire(x, y, type);
			}
		}
	}
}