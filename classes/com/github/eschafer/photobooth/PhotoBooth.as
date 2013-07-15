package com.github.eschafer.photobooth {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Matrix;
	import flash.events.MouseEvent;
	import flash.display.StageDisplayState;

	public class PhotoBooth extends Sprite {
		protected var camera:Camera;
		protected var video:Video;
		protected var photoScreen:PhotoScreen;

		public function PhotoBooth() {
			initVideo();
			photoScreen = new PhotoScreen(video);
			addChild(photoScreen);
			var banner:Banner = new Banner();
			banner.x = -36.5;
			banner.y = -23.5;
			addChild(banner);
			photoScreen.init();
		}

		protected function initVideo():void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, resizeHandler);

			camera = Camera.getCamera();
			camera.setQuality(0, 100);
			camera.setMode(1280, 960, 30, false);

			if (camera != null) {
				video = new Video(camera.width, camera.height);
				video.attachCamera(camera);
				video.scaleX = -.625;
				video.scaleY = .625;
				video.x = 80 + video.width;
				video.y = 30;
				addChild(video);
			} else {
				trace("You need a camera.");
			}
		}

		protected function resizeHandler(e:Event):void {
			var newX:Number = (stage.stageWidth - 960) / 2;
			if (newX < 0) {
				newX = 0;
			}
			this.x = newX;

			var newY:Number = (stage.stageHeight - 720) / 2;
			if (newY < 0) {
				newY = 0;
			}
			this.y = newY;
		}
	}
}
