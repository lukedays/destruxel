package {
	import org.flixel.*;
	import flash.display.*;
	import flash.utils.*;
	import com.adobe.serialization.json.JSON;
	
	public class PlayState extends FlxState {
		[Embed(source = "assets/tileset2.png")] protected var Tileset:Class;
		[Embed(source = "assets/map.csv", mimeType = "application/octet-stream")] protected var Map:Class;
		
		override public function create():void {
			addEnvironment();
			spawnPlayer();
			addBasicUI();
			
			FlxG.flash(0xff000000);
			FlxG.camera.setBounds(0, 0, R.map.width, R.map.height, true);
			FlxG.camera.follow(R.player1, FlxCamera.STYLE_PLATFORMER);
			FlxG.mouse.show();
		}
		
		override public function update():void {
			FlxG.collide(R.player1, R.blocks);
			FlxG.collide(R.player2, R.blocks);
			super.update();
		}
		
		public function addBasicUI():void {
			R.textPlayer1Score = new FlxText(0, 2, FlxG.width, "Player 1 score: " + R.player1Score);
			R.textPlayer1Score.setFormat(null, 16, 0x0000AA, "left");
			R.textPlayer1Score.scrollFactor.x = R.textPlayer1Score.scrollFactor.y = 0;
			add(R.textPlayer1Score);
			
			R.textPlayer2Score = new FlxText(0, 20, FlxG.width, "Player 2 score: " + R.player2Score);
			R.textPlayer2Score.setFormat(null, 16, 0xAA0000, "left");
			R.textPlayer2Score.scrollFactor.x = R.textPlayer2Score.scrollFactor.y = 0;
			add(R.textPlayer2Score);
		}
		
		protected function addEnvironment():void {
			// Background
			add(new Background(0, 0, 0));
			
			// Map
			R.map = new FlxTilemap();
			R.map.loadMap(new Map, Tileset, R.size, R.size);
			
			// Boundaries
			var left:FlxTileblock = new FlxTileblock(0, 0, 1, R.map.height);
			var right:FlxTileblock = new FlxTileblock(R.map.width - 1, 0, 1, R.map.height);
			var top:FlxTileblock = new FlxTileblock(0, 0, R.map.width, 1);
			var bottom:FlxTileblock = new FlxTileblock(0, R.map.height - 1, R.map.width, 1);
			
			// Lighting
			R.light = new Light(FlxG.width / 2, 0);
			R.darkness = new Darkness();
			R.shadows = new Shadows();
			R.shadows.updateVertices();
			
			// Particles
			R.bullets = new BulletManager();
			R.emitter = new FlxEmitter(0, 0, 20);
			R.emitter.bounce = 0.5;
			R.emitter.gravity = 800;
			
			for (var i:int = 0; i < 20; i++) {
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(4, 4, 0xff72651e);
				particle.exists = false;
				R.emitter.add(particle);
			}
			
			// Add to collision group
			R.blocks = new FlxGroup();
			R.blocks.add(left);
			R.blocks.add(right);
			R.blocks.add(top);
			//R.blocks.add(bottom);
			R.blocks.add(R.map);
			
			add(R.shadows);
			add(R.blocks);
			add(R.light);
			add(R.darkness);
			add(R.bullets);
			add(R.emitter);
		}
		
		protected function spawnPlayer():void {
			R.player1 = new Player(FlxG.width / 2, FlxG.height / 3);
			add(R.player1);
			
			R.player2 = new Player(FlxG.width / 2, FlxG.height / 3);
			R.player2.inactive = true;
			add(R.player2);
		}
	}
}