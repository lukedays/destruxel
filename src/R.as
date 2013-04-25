package {
	import org.flixel.*;
	
	// Registry class, stores global variables
	public class R {
		public static var player:Player;
		public static var map:FlxTilemap;
		public static var darkness:FlxSprite;
		public static var light:FlxSprite;
		public static var bullets:BulletManager;
		public static var emitter:FlxEmitter;
		public static var size:int = 25;
	}
}