/**
 * ...
 * Author: SiuzukZan <minoscc@gmail.com>
 * Date: 14/12/8 17:53
 */
package cc.minos.codec.mp4.boxs {
    import cc.minos.codec.mp4.MP4Constants;
    import cc.minos.codec.mp4.Sample;

    import flash.utils.ByteArray;

    /**
     * container
     */
    public class TrakBox extends Box {

        //mdia -> hdlr
        private var _hdlrBox:HdlrBox;
        private var _mdhdBox:MdhdBox;
        //mdia -> minf -> stbl
        private var _stblBox:StblBox;
        //tkhd box
        private var _tkhdBox:TkhdBox;

        public function TrakBox()
        {
            super( MP4Constants.BOX_TYPE_TRAK );
        }

        override protected function init():void
        {
            //type
            _hdlrBox = getBox(MP4Constants.BOX_TYPE_HDLR).shift() as HdlrBox;
            _mdhdBox = getBox(MP4Constants.BOX_TYPE_MDHD).shift() as MdhdBox;
            _tkhdBox = getBox(MP4Constants.BOX_TYPE_TKHD).shift() as TkhdBox;
            _stblBox = getBox(MP4Constants.BOX_TYPE_STBL).shift() as StblBox;

            for each(var sample:Sample in _stblBox.samples )
            {
                sample.timestamp = sample.index * sampleDelta;
            }
        }

        public function get trakType():uint
        {
            return _hdlrBox.hdType;
        }

        public function get id():uint
        {
            return _tkhdBox.id;
        }

        public function get duration():uint
        {
            return _tkhdBox.duration;
        }

        public function get volume():uint
        {
            return _tkhdBox.volume;
        }

        public function get width():uint
        {
            return _tkhdBox.width;
        }

        public function get height():uint
        {
            return _tkhdBox.height;
        }

        public function get samples():Vector.<Sample>
        {
            return _stblBox.samples;
        }

        public function get sampleDelta():Number
        {
            return ( _stblBox.sttsBox.delta / _mdhdBox.timeScale ) * 1000;
        }

        public function get framerate():Number
        {
            return ( _stblBox.sttsBox.count / ( _mdhdBox.duration / _mdhdBox.timeScale ) );
        }

        public function get stsdBox():StsdBox
        {
            return _stblBox.stsdBox;
        }

        public function get keyframes():Vector.<uint>
        {
            if( _stblBox.stssBox != null )
                return _stblBox.stssBox.keyframes;
            return null;
        }

    }
}
