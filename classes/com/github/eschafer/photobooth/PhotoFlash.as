package com.github.eschafer.photobooth {
	import flash.display.MovieClip;

	/**
	 * @author eschafer
	 */
	public class PhotoFlash extends MovieClip {
		public function PhotoFlash() {
			this.stop();
		}

		public function flash():void {
			this.gotoAndPlay(1);
		}
	}
}
