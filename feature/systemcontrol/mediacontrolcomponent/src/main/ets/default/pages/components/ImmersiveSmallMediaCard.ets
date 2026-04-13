/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Constants, { LyricDataArray } from '../../Util/Constants';
import { CardMediaController, ShowingMesTS } from '../../Controller/CardMediaController';
import AVSessionManager from '@ohos.multimedia.avsession';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/constants/SlStateConst';
import { SlWidgetId } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import CommonUtils from '../../Util/CommonUtils';
import { AnimValue } from '@ohos/systemuicommon/src/main/ets/base/anim/AnimConstants';
import {
  immersiveKgMgr,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import DeviceSwitchButton from './DeviceSwitchButton';
import { MediaControllerSlider } from '../../Util/MediaControllerSlider';
import { globalStorage } from '../../Util/GlobalStorage';
import ControlButtonGroup from './ControlButtonGroup';
import { LocalEventCallback } from '../../Util/LocalEventCallBack';
import { ImmersiveCardStyle } from '../../Util/ImmersiveCardStyle';
import MeasuringUtil from '../../Util/MeasuringUtil';
import { SlIdHelper } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/helper/SlIdHelper';
import { WidgetAnimState } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/bean/WidgetAnimState';
import { AnimationController } from '../../Controller/AnimationController';
import BrightnessUtils from '../../Util/BrightnessUtils';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG = 'ImmersiveSmallMediaCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const sceneType: string = 'immersive';

@Component
export struct ImmersiveSmallMediaCard {
  // notify property
  @Prop notifyId: string;
  // meta data
  @StorageLink('MediaTitle') title: string = '';
  @StorageLink('MediaArtist') artist: string = '';
  @StorageLink('MediaValidCommands') validCommands: Array<string> = [];
  @StorageLink('appName') curAppName: string | boolean = '';
  @StorageLink('MediaPlayState') playState: number = 0;
  @StorageLink('MediaImg') @Watch('onImageChanged') image: string | PixelMap = '';
  @StorageLink('MediaImgShow') mediaImgShow: boolean = false;
  @StorageProp('currColorMode') @Watch('currColorModeChanged') currColorMode: number = 0;
  @State isDarkMode: boolean = false;
  @StorageLink('systemLanguage') systemLanguage: string = Constants.DEFAULT_LANGUAGE;
  @State assetId: string | number = '';
  @State isFavor: boolean = false;
  @State loopMode: number | undefined = undefined;
  @State hasMedia: boolean = true;
  @State skipIntervals: number = 15;
  @State isShowPlayButton: boolean = false;
  @State isClickSlider: boolean = false;
  @State isChangeMetaDate: boolean = false;
  @State imageReady: boolean = false;
  // app info
  @State appIcon: string = '';
  @State mediaType: AVSessionManager.AVSessionType = 'audio';
  // app storage
  @StorageLink('CurRemoteDevSelect') curRemoteOutputDev: number = -1;
  @State isShowSeek: boolean = false;
  // class variable
  private controller: CardMediaController = CardMediaController.getInstance();
  // 进度条变量
  @State private duration: number = 0;
  @State @Watch('updateLyricByPosition') private movePosition: number = 0; // position to show
  @State @Watch('updateLyricByPosition') private movingPosition: number = 0; // position to get lyric
  @State private trueMovePosition: number = 0; // position truely show
  @StorageLink('playbackPosition') private playbackPosition: AVSessionManager.PlaybackPosition = {
    elapsedTime: 0,
    updateTime: 0
  }; // position from avsession
  private timerId: number | undefined = undefined;
  @State private moveFlag: number = 0;
  @State private speed: number = 0;
  @State private moveFlagStep: number = 2;
  @State private progressHeight: number = 4;
  private lastPlayState: number = 0;
  @State private moveStartCachePosition: number = -1;
  // 进度条seek后快速返回原位置逻辑 回调计数
  @State private shortTimeUpdateCount: number = 0;
  // 进度条seek后快速返回原位置逻辑 操作计数
  @State private callSeekCount: number = 0;
  // 点击快进快退，更新position,用于打点
  @State @Watch('refreshPosition') isClickFastForward: boolean = false;
  @State @Watch('refreshPosition') isClickRewind: boolean = false;
  // 歌词
  @State lyric: string = '';
  @State dataArray: Array<LyricDataArray> = [];
  @State lyricList: Array<string> = []
  @State minute: number = 0
  @State second: number = 0
  @State millisecond: number = 0
  @State newLyric: string = '';
  @State @Watch('onIsMarqueeStart') isMarqueeStart: boolean | null = true;
  private lyricCache: string = '';
  @State lyricTimerId: number | undefined = undefined;
  private avControllerCallback: LocalEventCallback | undefined = undefined;
  @State isPhoneOrPad: boolean = DeviceHelper.isPhoneOrPad();
  @Prop isSmallFoldOuterScreen: boolean;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Prop isFoldFullDisplay: boolean;
  @Prop cardStyle: ImmersiveCardStyle;
  private notifyIdWithScreenLockSuffix: string = '';
  private isAnimComponent: boolean = false;
  @Prop previewAlpha: number;

  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  private eventMgr: EventManager = EvtBus.createEventManager();
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存，防止丢帧
  @Prop cardHeight: number;
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;
  @State cardContentAnimState?: WidgetAnimState = AnimationController.getImmLiveCardAnim();
  private isDoubleExpand: boolean = false; //true：双列控制中心展开态
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData =
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData;

  async aboutToAppear() {
    let screenLockSuffix: string = '_screenLockImmersive';
    this.notifyIdWithScreenLockSuffix = this.notifyId + screenLockSuffix;
    log.showInfo('aboutToAppear notifyId: ' + this.notifyId + ' ,notifyIdWithScreenLockSuffix: ' +
    this.notifyIdWithScreenLockSuffix + ' isAnimeComponent ' + this.isAnimComponent);
    this.controller.doSubscribeNotify();
    // 修复清除卡片后点击播放异常闪烁
    this.controller.startShowing(TAG, true);
    this.setMediaDataListener();
    this.isDarkMode = CommonUtils.isDarkMode(this.currColorMode);
    this.eventMgr.on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
      this.onScreenOnOffEvent(event)
    });
  }

  aboutToDisappear() {
    this.clearTimerAndProgressData(true)
    this.unsetMediaDataListener();
    log.showInfo('aboutToDisappear notifyId: ' + this.notifyId + ' ,notifyIdWithScreenLockSuffix: ' +
    this.notifyIdWithScreenLockSuffix + ' isAnimeComponent ' + this.isAnimComponent);
    this.eventMgr.offAll();
    if (this.timerId) {
      clearInterval(this.timerId);
    }
    this.clearLyricTimer();
  }

  clearLyricTimer() {
    if (this.lyricTimerId) {
      clearTimeout(this.lyricTimerId);
      this.lyricTimerId = undefined;
    }
  }

  refreshPosition(value: string) {
    if (!this.isClickRewind && !this.isClickFastForward) {
      return;
    }
    if (value === 'isClickRewind') {
      this.isClickRewind = false;
      log.showInfo(`refeashMovePosition--if--${value}`);
    } else {
      this.isClickFastForward = false;
      log.showInfo(`refeashMovePosition--else--${value}`);
    }
    globalStorage.setNumberByKey('curPosition', this.movePosition);
  }

  isPlaying() {
    return CommonUtils.isPlaying(this.playState, this.lastPlayState, this.curRemoteOutputDev >= 0);
  }

  setMediaDataListener() {
    this.isShowSeek = this.validCommands.includes('seek');
    this.avControllerCallback = new LocalEventCallback((mediaInfo: ShowingMesTS) => {
      log.showInfo(` media data update: ${JSON.stringify(mediaInfo)} ` + this.notifyId);
      setTimeout(() => {
        this.mediaDataUpdate(mediaInfo);
      }, 0);
    });
    log.showInfo(` setMediaDataListener for notification id: ` + this.notifyIdWithScreenLockSuffix);
    CardMediaController.on('mediaUpdate', this.avControllerCallback, this.notifyIdWithScreenLockSuffix);
  }

  unsetMediaDataListener() {
    log.showInfo(`unsetMediaDataListener off for notification id: ${this.notifyIdWithScreenLockSuffix}`);
    if (!this.avControllerCallback) {
      return;
    }
    CardMediaController.off('mediaUpdate', this.avControllerCallback, this.notifyIdWithScreenLockSuffix);
  }

  onIsMarqueeStart() {
    log.showInfo(`isMarqueeStartChange: ${this.isMarqueeStart}`);
  }

  onScreenOnOffEvent(event: ScreenOnOffEvent) {
    if (event.event == 'usual.event.SCREEN_OFF') {
      this.isMarqueeStart = null;
      this.clearTimerAndProgressData(false);
      return;
    }
    if (event.event == 'usual.event.SCREEN_ON') {
      this.isMarqueeStart = true;
      this.startInterval();
    }
  }

  updateBasicInfo(mediaInfo: ShowingMesTS) {
    if (mediaInfo.isFavor != undefined) {
      log.debug(`parse media data: isFavor = ${mediaInfo.isFavor}`);
      this.isFavor = mediaInfo.isFavor as boolean;
    }
    if (mediaInfo.playState != undefined) {
      log.debug(`parse media data: playState = ${mediaInfo.playState}`);
      const playState: number = mediaInfo.playState as number;
      if (playState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
        this.lastPlayState = playState;
      }
    }
    if (mediaInfo.loopMode != undefined && typeof mediaInfo.loopMode === 'number') {
      log.debug(`parse media data: loopMode = ${mediaInfo.loopMode}`);
      this.loopMode = mediaInfo.loopMode as number;
    }
    if (mediaInfo.validCommands !== undefined) {
      this.isShowSeek = mediaInfo.validCommands.includes('seek');
    }
    if (mediaInfo.musicAssetId != undefined) {
      log.debug(`parse media data: assetId = ${CommonUtils.getMaskStr(mediaInfo.musicAssetId as string || '')}`);
      this.assetId = mediaInfo.musicAssetId as string || '';
    }
    if (mediaInfo.hasMedia != undefined) {
      log.debug(`parse media data: hasMedia = ${mediaInfo.hasMedia}`);
      this.hasMedia = mediaInfo.hasMedia;
    }
    if (mediaInfo.mediaPlayerIcon != undefined) {
      log.debug(`parse media data: mediaPlayerIcon = ${JSON.stringify(mediaInfo.mediaPlayerIcon)}`);
      if (!mediaInfo.mediaPlayerIcon) {
        this.appIcon = '';
      } else {
        this.appIcon = mediaInfo.mediaPlayerIcon as string;
      }
    }
    if (mediaInfo.skipIntervals != undefined) {
      log.debug(`parse media data: skipIntervals = ${mediaInfo.skipIntervals}`);
      this.skipIntervals = mediaInfo.skipIntervals;
    }
    if (mediaInfo.mediaType != undefined) {
      log.debug(`parse media data: mediaType = ${mediaInfo.mediaType}`);
      this.mediaType = mediaInfo.mediaType;
    }
    this.isShowPlayButton = (!!this.image || !!this.title || !!this.artist || !this.curAppName) && !!this.mediaType;
  }

  calcNewPosition(): number {
    const currentTime: number = this.isPlaying() ? new Date().getTime() : this.playbackPosition.updateTime;
    let newPosition = (currentTime - this.playbackPosition.updateTime) * this.speed +
    this.playbackPosition.elapsedTime;
    if (newPosition >= this.duration) {
      newPosition = this.duration;
    }
    if (newPosition < 0) {
      newPosition = 0;
    }
    return newPosition;
  }

  updateProgress(mediaInfo: ShowingMesTS) {
    if (mediaInfo.duration != undefined) {
      // 音频总时长，当总时长大于24:00:00，显示24:00:00
      let duration = Math.floor(mediaInfo.duration);
      duration = duration > Constants.MAX_DURATION ? Constants.MAX_DURATION : duration;
      if (this.duration !== duration && mediaInfo.position === undefined) {
        this.handleDurationUpdate(duration, this.duration);
      }
      this.duration = duration;
      if (!this.duration || this.duration < 0) {
        this.initSliderChange();
      }
    }
    this.speed = ((mediaInfo.speed != undefined) ? mediaInfo.speed : 1);
    if (mediaInfo.position != undefined) {
      this.playbackPosition = mediaInfo.position;
    } else if (this.playState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY) {
      this.clearTimerAndProgressData(false);
    }
    if (!mediaInfo.position && this.curRemoteOutputDev >= 0 &&
      this.playState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY) {
      return;
    }
    this.getSliderData();
  }

  /**
   * 根据当前播放进度占上一个媒体时长的比例计算新的播放进度。
   * 在切歌时，新的媒体信息播放时长与上一个不一样，duration变化后movePosition并没有及时更新，导致进度条长度可能突然变长或变短。
   */
  handleDurationUpdate(newDuration: number, oldDuration: number) {
    if (!this.movePosition || !newDuration || !oldDuration) {
      return;
    }
    if (this.movePosition >= oldDuration) {
      this.movePosition = 0;
    } else {
      this.movePosition = Math.floor(this.movePosition / oldDuration * newDuration);
    }
    this.playbackPosition = {
      elapsedTime: this.movePosition,
      updateTime: new Date().getTime(),
    };
    log.showInfo(`update movePosition when duration change, ${JSON.stringify(this.movePosition)}`)
  }

  private getCardContentScale(): ScaleOptions {
    if (this.cardContentAnimState?.isSceneAnimating()) {
      return {
        x: this.cardContentAnimState.getScaleX(),
        y: this.cardContentAnimState.getScaleY()
      }
    }
    return {
      x: AnimValue.VALUE_MAX,
      y: AnimValue.VALUE_MAX
    }
  }

  private getCardContentTranslate(): TranslateOptions {
    if (this.cardContentAnimState?.isSceneAnimating()) {
      return {
        x: this.cardContentAnimState.getTranX(),
        y: this.cardContentAnimState.getTranY(),
      }
    }
    return {
      x: AnimValue.VALUE_MIN,
      y: AnimValue.VALUE_MIN
    }
  }


  isRTL() {
    return this.sysConfigData.isRTL;
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      this.buildImage()
      Column() {
        this.buildMediaCard()
      }
      .clip(true)
      .backgroundBlurStyle(BlurStyle.Regular)
      .backgroundColor(undefined)
      .margin({
        bottom: Constants.SMALL_SCREEN_CARD_PADDING,
        left: Constants.SMALL_SCREEN_CARD_PADDING,
        right: Constants.SMALL_SCREEN_CARD_PADDING
      })
      .id(SlIdHelper.getViewId(SlStateMgr.MGR_OUTER_SCREEN, SlWidgetId.IMMERSIVE_lIVE_CARD))
      .borderRadius(this.cardContentAnimState?.getBorderRadiusTL() ?? 20)
      .translate(this.getCardContentTranslate())
      .scale(this.getCardContentScale())
    }
  }

  @Builder buildImage() {
    Stack() {
      Row().width('100%').height('100%').backgroundColor('#33FFFFFF').blur(50)
        .visibility((this.mediaImgShow && this.image) ? Visibility.None : Visibility.Visible)
      Image((this.mediaImgShow && this.image) ? this.image : '')
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%')
        .syncLoad(true)
        .draggable(false)
      Column()
        .backgroundEffect({
          radius: 242,
        })
        .width('100%')
        .height('100%')

      Image((this.mediaImgShow && this.image) ? this.image : $r('app.media.small_device_nomusic_img'))
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.High)
        .syncLoad(true)
        .fillColor($r('app.color.ohos_id_color_fourth'))
        .draggable(false)
    }
    .opacity(this.previewAlpha)
    .height(this.cardStyle.height)
    .width(this.cardStyle.width)
  }

  /**
   * 重置进度条相关变量
   */
  initSliderChange() {
    this.progressHeight = 4;
    this.isClickSlider = false;
  }

  updateLyric(mediaInfo: ShowingMesTS) {
    if (mediaInfo.lyric === undefined) {
      return;
    }
    this.clearLyricTimer();
    if (this.lyric && !mediaInfo.lyric) {
      // 延时动效
      this.lyricTimerId = setTimeout(() => {
        this.tryLyricDisappear();
        this.clearLyricTimer();
      }, 500)
    } else {
      this.tryLyricAppear(mediaInfo);
    }
  }

  getSliderData() {
    log.showInfo(` this.playbackPosition result and shortTime add: ${JSON.stringify(this.playbackPosition)}`);
    this.shortTimeUpdateCount++;
    if (this.playbackPosition.updateTime < 1) {
      this.playbackPosition.updateTime = new Date().getTime();
    }
    if (!this.timerId || this.moveFlag > 0) {
      this.moveFlag = 0;
      if (this.playState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY && this.isMarqueeStart) {
        this.startInterval();
      }
      if (this.isMarqueeStart) {
        this.movePosition = this.calcNewPosition();
      }
      log.showInfo(` this.movePosition result: ${this.movePosition}`);
    }
  }

  startInterval(): void {
    if (this.timerId != undefined) {
      clearInterval(this.timerId);
    }
    this.timerId = setInterval(() => {
      if (!this.isMarqueeStart) {
        log.showError('do not start timer while screen off');
        return;
      }
      const newPosition = this.calcNewPosition();
      if (newPosition >= this.duration && this.duration > 0) {
        this.movePosition = this.duration;
      } else if (newPosition >= this.duration) {
        this.movePosition = 0;
      } else {
        if (this.moveFlag > 0) {
          this.moveFlag -= this.speed;
          return;
        }
        this.movePosition = newPosition;
      }
    }, Constants.OPERATE_MIN_INTERVAL / (this.speed ? this.speed : 1))
  }

  tryLyricAppear(mediaInfo: ShowingMesTS) {
    this.lyric = mediaInfo?.lyric as string;
    this.loadMusicLyricList();
    this.updateLyricByPosition();
  }

  tryLyricDisappear() {
    this.lyric = '';
    this.newLyric = '';
    this.loadMusicLyricList();
    this.updateLyricByPosition();
  }

  mediaDataUpdate(mediaInfo: ShowingMesTS) {
    if (mediaInfo?.musicAssetId && (this.assetId !== mediaInfo?.musicAssetId)) {
      log.showInfo(`mediaDataUpdate isChangeMetaDate`);
      this.isChangeMetaDate = true;
    } else {
      this.isChangeMetaDate = false;
    }
    this.updateBasicInfo(mediaInfo);
    this.updateProgress(mediaInfo);
    this.updateLyric(mediaInfo);
  }

  onImageChanged() {
    if (this.image?.toString()?.includes('http') && this.imageReady) {
      this.imageReady = true;
      setTimeout(() => {
        if (this.image?.toString()?.includes('http')) {
          this.imageReady = false;
        }
      }, 500)
    } else {
      this.imageReady = true;
    }
  }

  currColorModeChanged() {
    this.isDarkMode = CommonUtils.isDarkMode(this.currColorMode);
  }

  loadMusicLyricList() {
    if (!this.lyric || !this.lyric.startsWith('[')) {
      log.showInfo(`lyric error: ${this.lyric}`);
      this.lyric = '';
      this.lyricCache = '';
      this.dataArray = [];
      return;
    } else if (this.lyricCache === this.lyric) {
      log.showInfo(`lyric same`);
      return;
    }
    this.dataArray = [];
    this.lyricCache = this.lyric || '';
    let newRegex: RegExp = new RegExp('[\r\n]+');
    this.lyricList = this.lyric.split(newRegex) //得到字符串分割的数组
    this.dataArray = CommonUtils.analyzeLyric(this.lyricList);
  }

  updateLyricByPosition() {
    if (!this.lyric) {
      return;
    }
    // 循环比对歌词，比对不成功就跳出循环，显示最后比对成功的值，最后一句比对下标，如果比对成功一直显示最后一句
    let oldLyric: string = '';
    if (!this.dataArray || this.dataArray.length === 0) {
      this.newLyric = oldLyric;
      return;
    }
    if (this.dataArray && this.dataArray.length > 0 && this.dataArray[this.dataArray.length - 1]?.time <=
      (this.isClickSlider ? this.movingPosition : this.movePosition)) {
      this.newLyric = this.dataArray[this.dataArray.length - 1]?.lyric?.trim();
      return;
    }
    for (let i = 0; i <= this.dataArray.length; i++) {
      // 当前位置计算公式：(当前时间 - 最后更新时间) x 播放速度+ 最后的位置
      // 时间比对条件当前时间大于等于歌词所在时间赋值
      if (!this.dataArray[i] || !this.dataArray[i]?.lyric || !this.dataArray[i]?.originalTime) {
        log.showError('lyric format error, no time lyric originalTime');
        continue;
      }
      if (this.dataArray[i]?.time <= (this.isClickSlider ? this.movingPosition : this.movePosition)) {
        if (!!this.dataArray[i]?.lyric) {
          oldLyric = this.dataArray[i].lyric.trim();
        }
      } else {
        // 如果是最后一句，就一直显示最后一句
        if (i >= this.dataArray.length && !!this.dataArray[i]?.lyric) {
          oldLyric = this.dataArray[i].lyric.trim();
        }
        // 比对不成功跳出循环
        break;
      }
    }
    this.newLyric = oldLyric;
  }

  // 清除定时器和当前进度条绘制值currentProgress
  clearTimerAndProgressData(isClearData: boolean) {
    if (this.timerId !== undefined) {
      clearInterval(this.timerId);
      this.timerId = undefined;
    }
    // 是否需要清除 进度条播放位置
    if (isClearData) {
      this.movePosition = 0;
    }
  }

  @Builder buildMediaCard() {
    Flex( { direction: FlexDirection.Column, justifyContent: FlexAlign.Start} ) {
      Flex( { direction: FlexDirection.Row, justifyContent: FlexAlign.Start } ) {
        // app icon
        Column() {
          Image(this.appIcon ? this.appIcon : $r('app.media.ic_nomusic_img'))
            .borderRadius(8)
            .border({ width: 0.5, color: '#D1D1D6' })
            .visibility(this.appIcon ? Visibility.Visible : Visibility.None)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .draggable(false)
            .opacity(1)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
        .borderRadius(8)
        .margin({ top: 12 })
        .flexShrink(0)
        .width(Constants.SMALL_SCREEN_CARD_APP_ICON)
        .height(Constants.SMALL_SCREEN_CARD_APP_ICON)

        Column() {}
        .width(8)
        .backgroundColor(Color.Transparent)
        .margin({ top: 12 })
        // title
        this.titleBuilder()

        // cast button
        this.deviceSwitchBuilder()
      }
      .flexShrink(0)
      .margin({ left: Constants.SMALL_SCREEN_CARD_LEFTRIGHTPADDING,
        right: Constants.SMALL_SCREEN_CARD_LEFTRIGHTPADDING })
      .width('calc(100% - 32vp)')
      .height(44)

      // process bar
      this.progressBarBuilder()

      // control button
      this.controlButtonGroupBuilder()
    }
    .height(this.cardHeight)
    .width('100%')
  }

  @Builder titleBuilder() {
    // title
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.End }) {
        if (this.isPlaying()) {
          Marquee({
            start: this.isMarqueeStart,
            step: 6,
            loop: -1,
            fromStart: !this.isRTL(),
            src: this.title || (this.curAppName ? this.curAppName.toString() : '')
          })
            .fontSize(MeasuringUtil.getFontSize(14, 1, this.fontSizeScale))
            .fontWeight(ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_weight')))
            .fontColor(this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_primary'))
            .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(true, sceneType, this.isDarkMode))
            .width('100%')
            .align(!this.isRTL() ? Alignment.Start : Alignment.End)
        } else {
          Text(this.title || (this.curAppName ? this.curAppName.toString() : $r('app.string.no_media_title')))
            .fontSize('14fp')
            .fontWeight(ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_weight')))
            .fontColor(this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_primary'))
            .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(true, sceneType, this.isDarkMode))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(!this.isRTL() ? TextAlign.Start : TextAlign.End)
            .width('100%')
            .maxFontScale(1)
            .maxLines(1)
        }
      }
      .width('100%')
      .height(19)

      // artist
      Flex({ wrap: FlexWrap.NoWrap }) {
        if (this.isPlaying()) {
          Marquee({
            start: this.isMarqueeStart,
            step: 6,
            loop: -1,
            fromStart: !this.isRTL(),
            src: (this.lyric && this.newLyric) ? this.newLyric : this.artist
          })
            .fontSize(MeasuringUtil.getFontSize(12, 1, this.fontSizeScale))
            .fontWeight(FontWeight.Regular)
            .fontColor(this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
            .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(false, sceneType, this.isDarkMode))
            .width('100%')
            .align(!this.isRTL() ? Alignment.Start : Alignment.End)
        } else {
          Text((this.lyric && this.newLyric) ? this.newLyric : this.artist)
            .fontSize('12fp')
            .fontWeight(FontWeight.Regular)
            .fontColor(this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
            .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(false, sceneType, this.isDarkMode))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(!this.isRTL() ? TextAlign.Start : TextAlign.End)
            .width('100%')
            .maxFontScale(1)
            .maxLines(1)
        }
      }
      .width('100%')
      .height(16)
    }
    .backgroundColor(Color.Transparent)
    .margin({ top: 9 })
    .width(176)
    .accessibilityLevel('no')
  }

  @Builder deviceSwitchBuilder() {
    Column() {
      DeviceSwitchButton({
        buttonSize: Constants.SMALL_SCREEN_CARD_SWITCH_SIZE,
        isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
        isDarkMode: this.isDarkMode
      })
    }
    .justifyContent(FlexAlign.Center)
    .zIndex(1)
    .position(this.isRTL() ? { top: 12, left: 0} : { top: 12, right: 0})
    .width(24)
    .height(24)
  }

  @Builder progressBarBuilder() {
    // process bar
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Text(this.getProgressStart())
        .fontSize('10fp')
        .maxFontScale(1)
        .fontColor(this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
        .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(false, sceneType, this.isDarkMode))
        .flexShrink(0)
        .textAlign(TextAlign.Start)
        .accessibilityLevel('no')
        .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      if (!this.duration || this.duration === 0 || this.duration < 0) {
        Slider({
          value: 0,
          min: 0,
          max: 0,
          step: 1,
          style: SliderStyle.InSet,
          direction: Axis.Horizontal
        })
          .trackThickness(4)
          .blockColor('#00ffffff')
          .showSteps(false)
          .showTips(false)
          .enabled(false)
      } else {
        MediaControllerSlider({
          movePositionPreferSet: this.movePosition,
          movePositionTrueSet: this.trueMovePosition,
          callSeekCount: this.callSeekCount,
          shortTimeUpdateCount: this.shortTimeUpdateCount,
          sliderMax: this.duration,
          sliderMin: 0,
          sliderStep: 1,
          sliderStyle: SliderStyle.InSet,
          sliderDirection: Axis.Horizontal,
          sliderIsActive: this.isShowSeek,
          sliderPadding:
          {
            left: 0,
            right: 0
          },
          sliderTrackThickness: this.progressHeight,
          sliderSelectedColor: ((this.isPhoneOrPad ? (this.isShowSeek ? $r('app.color.media_item_slider_primary') : $r('app.color.media_item_slider_normal')) :
              (this.isShowSeek ? $r('sys.color.icon_emphasize') : $r('sys.color.icon_fourth')))),
          sliderTrackColor: ((this.isPhoneOrPad ?
          $r('app.color.media_item_slider_normal') : undefined)),
          sliderBlockColor: ('#00ffffff'),
          sliderWidth: '100%',
          sliderFlexShrink: 1,
          sliderShowSteps: false,
          sliderShowTips: false,
          sliderShowTipsContent: '',
          sliderBlockBorderWidth: 40,
          sliderEnabled: true,
          sliderBlockStyle:
          {
            type: SliderBlockType.SHAPE,
            shape: new Path({ commands: 'M60 60 M30 30 L15 56 L45 56 Z' })
          },
          sliderChangeCallback:
          (value: number, mode: SliderChangeMode) => {
            log.showInfo(TAG, `slider onChange: ${value}, mode=${mode}, this.movePosition=${this.movePosition}`);
            this.movingPosition = value;
            if (value === 0 && this.movePosition < 0) {
              log.error(TAG, 'slider position abnormal, return');
              return;
            }
            log.showInfo(`imm slider mode: ${mode}`)
            switch (mode) {
              case SliderChangeMode.Begin:
                log.showInfo(`immSliderChangeMode begin`)
                this.isClickSlider = true
                this.moveFlag = this.moveFlagStep * this.speed;
                this.moveStartCachePosition = this.moveStartCachePosition > 0 ?
                this.moveStartCachePosition : this.movePosition;
                this.uiContext.animateTo({
                  duration: 300
                }, () => {
                  this.progressHeight *= 2.5;
                })
                this.clearTimerAndProgressData(false)
                break;
              case SliderChangeMode.Moving:
                this.moveFlag = this.moveFlagStep * this.speed;
                break;
              case SliderChangeMode.Click:
                this.moveStartCachePosition = this.moveStartCachePosition > 0 ?
                this.moveStartCachePosition : this.movePosition;
                break;
              case SliderChangeMode.End:
                log.showInfo(`immSliderChangeMode end: ${value}、${this.isClickSlider}`);
                if (!this.isClickSlider) {
                  this.isClickSlider = false;
                  return;
                }
                this.isClickSlider = false;
                this.moveFlag = this.moveFlagStep * this.speed;
                if (value <= this.duration) {
                  globalStorage.setStringByKey('scenesType', 'immersive');
                  this.callSeekCount++;
                  log.showInfo(`MediaControllerSlider on callSeekCount add : ${this.callSeekCount}`);
                  this.controller.callSeek(value);
                }
                if (value <= 0) {
                  this.progressHeight = 4;
                } else {
                  this.uiContext.animateTo({
                    duration: 300
                  }, () => {
                    this.progressHeight = 4;
                  })
                }
                break;
              default:
                break;
            }
          },
          sliderKey: 'immersive_media_progress',
        })
      }
      Text(this.getProgressEnd())
        .fontSize('10fp')
        .maxFontScale(1)
        .fontColor(this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
        .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(false, sceneType, this.isDarkMode))
        .flexShrink(0)
        .textAlign(TextAlign.End)
        .accessibilityLevel('no')
        .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
    }
    .width('100%')
    .height(28)
    .flexShrink(0)
    .padding({ left: Constants.SMALL_SCREEN_CARD_LEFTRIGHTPADDING,
      right: Constants.SMALL_SCREEN_CARD_LEFTRIGHTPADDING })
  }

  @Builder controlButtonGroupBuilder() {
    // 四元组按钮
    ControlButtonGroup({
      sceneType: 'immersive',
      sessionType: this.mediaType,
      iconSize: 20,
      validCommands: this.validCommands,
      isPlaying: this.isPlaying(),
      isHasMedia: this.hasMedia,
      isForceDark: this.isPhoneOrPad,
      skipIntervals: this.skipIntervals,
      assetId: this.assetId,
      isFavor: this.isFavor,
      loopMode: this.loopMode,
      isShowPlayButton: this.isShowPlayButton,
      isClickSlider: this.isClickSlider,
      isClickRewind: $isClickRewind,
      isClickFastForward: $isClickFastForward,
      isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
      isDoubleExpand: this.isDoubleExpand,
      duration: this.duration
    })
      .width('100%')
      .backgroundColor(Color.Transparent)
      .height(32)
      .flexShrink(0)
      .clip(true)
      .padding({ left: 10, right: 10 })
  }

  getProgressStart(): string {
    log.showInfo(` getProgressStart result: ${this.duration}`);
    if (!this.duration || this.duration <= 0) {
      return '--:--';
    }
    let curtime = Math.floor(this.trueMovePosition / 1000);
    let durationHours = Math.floor(this.duration / 1000 / 3600);
    let hours = Math.floor(curtime / 3600);
    let minutes = Math.floor((curtime / 60) % 60);
    let seconds = (curtime % 60);
    let result = `${minutes.toString().padStart(2, '0')}:${seconds.toFixed(0).padStart(2, '0')}`;
    if (durationHours > 0) {
      result = `${hours.toString().padStart(2, '0')}:${result}`;
    }
    log.showInfo(` getProgressStart result: ${result}`);
    return result;
  }

  getProgressEnd(): string {
    if (!this.duration || this.duration <= 0) {
      return '--:--';
    }
    let hours = Math.floor(this.duration / 1000 / 3600)
    let minutes = Math.floor((this.duration / 1000 / 60) % 60)
    let seconds = Math.floor((this.duration / 1000) % 60)
    let result = `${minutes.toString().padStart(2, '0')}:${seconds.toFixed(0).padStart(2, '0')}`
    if (hours > 0) {
      result = `${hours.toString().padStart(2, '0')}:${result}`;
    }
    return result;
  }
}