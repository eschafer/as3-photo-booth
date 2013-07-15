package com.github.eschafer.photobooth {
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.media.Sound;

	/**
	 * @author eschafer
	 */
	public class CountdownAnimation extends Sprite {

		public var oneIcon:Sprite;
		public var twoIcon:Sprite;
		public var threeIcon:Sprite;
		public var cameraIcon:Sprite;
		protected var intervalId:int;
		protected var sound:Sound;

		public function CountdownAnimation() {
			threeIcon.alpha = .5;
			twoIcon.alpha = .5;
			oneIcon.alpha = .5;
			cameraIcon.alpha = .5;

			var urlRequest:URLRequest = new URLRequest("audio/ding.mp3");
			sound = new Sound(urlRequest);
		}

		public function play():void {
			three();
		}

		protected function three():void {
			clearInterval(intervalId);
			intervalId = setInterval(two, 1000);

			threeIcon.alpha = 1;
			twoIcon.alpha = .5;
			oneIcon.alpha = .5;
			cameraIcon.alpha = .5;

			sound.play();
		}

		protected function two():void {
			clearInterval(intervalId);
			intervalId = setInterval(one, 1000);

			threeIcon.alpha = .5;
			twoIcon.alpha = 1;
			oneIcon.alpha = .5;
			cameraIcon.alpha = .5;

			sound.play();
		}

		protected function one():void {
			clearInterval(intervalId);
			intervalId = setInterval(camera, 1000);

			threeIcon.alpha = .5;
			twoIcon.alpha = .5;
			oneIcon.alpha = 1;
			cameraIcon.alpha = .5;

			sound.play();
		}

		protected function camera():void {
			clearInterval(intervalId);

			threeIcon.alpha = .5;
			twoIcon.alpha = .5;
			oneIcon.alpha = .5;
			cameraIcon.alpha = 1;

			dispatchEvent(new Event("COMPLETE"));
		}
	}
}
