package {
	import org.flixel.*;
	
	// Registry class, stores global variables
	public class R {
		public static var player:Player;
		public static var map:FlxTilemap;
		public static var blocks:FlxGroup;
		public static var vertices:Array;
		
		public static var darkness:Darkness;
		public static var shadows:Shadows;
		public static var light:Light;
		
		public static var bullets:BulletManager;
		public static var emitter:FlxEmitter;
		public static var size:int = 40;
	}
}