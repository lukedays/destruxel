package {
	import org.flixel.*;
	
	// Registry class, stores global variables
	public class R {
		public static var socket1:CustomSocket;
		public static var socket2:CustomSocket;
		
		public static var player1:Player;
		public static var player2:Player;
		
		public static var playerNumber:int;
		public static var textPlayer1Number:FlxText;
		public static var textPlayer2Number:FlxText;
		
		public static var player1Score:int = 0;
		public static var player2Score:int = 0;
		public static var textPlayer1Score:FlxText;
		public static var textPlayer2Score:FlxText;
		
		public static var map:FlxTilemap;
		public static var blocks:FlxGroup;
		
		public static var darkness:Darkness;
		public static var light:Light;
		
		public static var shadows:Shadows;
		public static var vertices:Array;
		
		public static var bullets:BulletManager;
		public static var emitter:FlxEmitter;
		public static var size:int = 40;
	}
}