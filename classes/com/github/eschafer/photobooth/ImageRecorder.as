package com.github.eschafer.photobooth {
	import com.adobe.images.PNGEncoder;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.*;
	import flash.geom.Matrix;
	import flash.media.Video;
	import flash.utils.*;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundTransform;

	public class ImageRecorder extends Sprite {
		protected var video:Video;
		protected var imageRecorder:ImageRecorder;
		protected var bitmapData1:BitmapData;
		protected var bitmapData2:BitmapData;
		protected var bitmapData3:BitmapData;
		protected var bitmapData4:BitmapData;
		protected var intervalId:Number;
		protected var sound:Sound;

		public function ImageRecorder(vid:Video) {
			video = vid;

			var urlRequest:URLRequest = new URLRequest("audio/camera_shutter.mp3");
			sound = new Sound(urlRequest);
		}

		public function recordImages():void {
			bitmapData1 = null;
			bitmapData2 = null;
			bitmapData3 = null;
			bitmapData4 = null;
			takePhoto();
		}

		protected function takePhoto():void {
			clearInterval(intervalId);
			dispatchEvent(new Event("TAKE_PHOTO"));

			sound.play(0, 0, new SoundTransform(0.6));

			var matrix:Matrix = new Matrix();
			matrix.scale(-1,1);
			matrix.translate(video.width,0);
			var bitmapData:BitmapData = new BitmapData(video.width*1.6, video.height*1.6);
			bitmapData.draw(video);
			var startTime:Number;
			if (bitmapData1 == null) {
				bitmapData1 = bitmapData;
				intervalId = setInterval(takePhoto, 1000);
			} else if (bitmapData2 == null) {
				bitmapData2 = bitmapData;
				intervalId = setInterval(takePhoto, 1000);
			} else if (bitmapData3 == null) {
				bitmapData3 = bitmapData;
				intervalId = setInterval(takePhoto, 1000);
			} else {
				bitmapData4 = bitmapData;
				intervalId = setInterval(imagesCaptured, 1000);
			}
		}

		protected function imagesCaptured():void {
			clearInterval(intervalId);
			var params:Object = new Object();
			params.bitmapData1 = bitmapData1;
			params.bitmapData2 = bitmapData2;
			params.bitmapData3 = bitmapData3;
			params.bitmapData4 = bitmapData4;
			dispatchEvent(new EventWithParameters("IMAGES_CAPTURED", params));
		}
	}
}
