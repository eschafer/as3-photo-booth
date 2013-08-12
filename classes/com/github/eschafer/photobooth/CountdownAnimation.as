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
		public var cameraIcon:MovieClip;
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
			intervalId = setInterval(camera1, 1000);

			threeIcon.alpha = .5;
			twoIcon.alpha = .5;
			oneIcon.alpha = 1;
			cameraIcon.alpha = .5;

			sound.play();
		}

		protected function camera1():void {
			clearInterval(intervalId);
			intervalId = setInterval(camera2, 1000);

			cameraIcon.gotoAndStop(2);

			threeIcon.alpha = .5;
			twoIcon.alpha = .5;
			oneIcon.alpha = .5;
			cameraIcon.alpha = 1;

			dispatchEvent(new Event("COMPLETE"));
		}

		protected function camera2():void {
			clearInterval(intervalId);
			intervalId = setInterval(camera3, 1000);

			cameraIcon.gotoAndStop(3);

			threeIcon.alpha = .5;
			twoIcon.alpha = .5;
			oneIcon.alpha = .5;
			cameraIcon.alpha = 1;
		}

		protected function camera3():void {
			clearInterval(intervalId);
			intervalId = setInterval(camera4, 1000);

			cameraIcon.gotoAndStop(4);

			threeIcon.alpha = .5;
			twoIcon.alpha = .5;
			oneIcon.alpha = .5;
			cameraIcon.alpha = 1;
		}

		protected function camera4():void {
			clearInterval(intervalId);

			cameraIcon.gotoAndStop(5);

			threeIcon.alpha = .5;
			twoIcon.alpha = .5;
			oneIcon.alpha = .5;
			cameraIcon.alpha = 1;
		}
	}
}
