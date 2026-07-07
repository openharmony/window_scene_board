/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { SlMainStateType, SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import Curves from '@ohos.curves';
import audio from '@ohos.multimedia.audio';
import AVSessionManager from '@ohos.multimedia.avsession';
import { CardMediaController, ShowingMesTS } from '../../Controller/CardMediaController';
import ControlButtonGroup from './ControlButtonGroup';
import DeviceSwitchButton from './DeviceSwitchButton';
import CommonUtils from '../../Util/CommonUtils';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { slWallpaperMgr } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { SLWallpaperType } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperState';
import { ImmInvertColorMgr } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/manager/ImmInvertColorMgr';
import { LocalEventCallback } from '../../Util/LocalEventCallBack';
import {
  AodStyleType,
  ImmersiveAodStyle,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import {
  immersiveKgMgr,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { globalStorage } from '../../Util/GlobalStorage';
import { ImmersiveCardStyle } from '../../Util/ImmersiveCardStyle';
import { MediaImmersiveConstants } from '../../Util/MediaImmersiveConstants';
import { MediaControllerSlider } from '../../Util/MediaControllerSlider';
import curves from '@ohos.curves';
import { AnimationState } from '../../viewmodel/AnimationState';
import { AnimationController } from '../../Controller/AnimationController';
import MeasuringUtil from '../../Util/MeasuringUtil';
import Constants, { ImageCallback, LyricDataArray } from '../../Util/Constants';
import { ImmersiveSmallMediaCard } from './ImmersiveSmallMediaCard';
import BrightnessUtils from '../../Util/BrightnessUtils';
import display from '@ohos.display';
import { throttle } from '../../Util/Tool';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';
import { PixelMapUtil } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'ImmersiveMediaCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

interface CurOutputDev {
  deviceType: audio.DeviceType;
  deviceId: number;
}
const imageZIndex: number = 100;

@Component
export struct ImmersiveMediaCard {
  // notify property
  @Prop notifyId: string;
  // meta data
  @StorageLink('MediaTitle') title: string = '';
  @StorageLink('ControlMediaTitle') songName : string = '';
  @StorageLink('MediaArtist') artist: string = '';
  @StorageLink('MediaValidCommands') validCommands: Array<string> = [];
  @StorageLink('appName') curAppName: string | boolean = '';
  @StorageLink('MediaImgShow') mediaImgShow: boolean = false;
  @StorageLink('MediaPlayState') playState: number = 0;
  @StorageLink('MediaImg') @Watch('onImageChanged') image: string | PixelMap = '';
  @StorageLink('isChangeSong') isChangeSong: boolean = false;
  @StorageLink('isChangeApp') isChangeApp: boolean = false;
  @StorageLink('systemLanguage') systemLanguage: string = Constants.DEFAULT_LANGUAGE;
  @StorageProp('currColorMode') @Watch('currColorModeChanged') currColorMode: number = 0;
  @StorageProp('MediaLoopMode') loopMode: number | undefined = undefined;
  @StorageProp('MediaIsFavor') isFavor: boolean = false;
  @State isDarkMode: boolean = false;
  @State assetId: string | number = '';
  @State hasMedia: boolean = true;
  @State skipIntervals: number = 15;
  @State isShowPlayButton: boolean = false;
  @State isShowPlayPause: boolean = false;
  @State isClickSlider: boolean = false;
  @State private imgBoxWidth: number = 314;
  @State private imgBoxHeight: number = 314;
  @State private imgWidthSize: number = 314;
  @State private imgHeightSize: number = 314;
  @State imagesX: number = 8;
  @State imagesY: number = 8;
  // app info
  @State appIcon: string = '';
  @State appIconShow: boolean = false;
  @State mediaType: AVSessionManager.AVSessionType = 'audio';
  // app storage
  @StorageLink('CurDevSelect')
    curOutputDev: CurOutputDev = { deviceType: audio.DeviceType.SPEAKER, deviceId: -1 };
  @StorageLink('CurRemoteDevSelect') curRemoteOutputDev: number = -1;
  @State isShowSeek: boolean = false;
  // class variable
  private controller: CardMediaController = CardMediaController.getInstance();
  private exitTimer: number = 0;
  //进度条变量
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
  private OPERATE_MIN_INTERVAL: number = 500; // 防抖时间
  @State private moveFlagStep: number = 2;
  @State private progressHeight: number = 4;
  private lastPlayState: number = 0;
  //歌词
  @State lyric: string = '';
  @State dataArray: Array<LyricDataArray> = [];
  @State lyricList: Array<string> = []
  @State minute: number = 0
  @State second: number = 0
  @State millisecond: number = 0
  @State newLyric: string = '';
  @State @Watch('onLyricIndexChanged') lyricIndex: number = 0;
  @State @Watch('onIsMarqueeStart') isMarqueeStart: boolean | null = true;
  // 金标
  private songNameAreaWidth: number = 0;
  private songNameTextSize: number = 18;
  private goldFlagImage: Resource = $r('app.media.ic_audiovivid');
  private avControllerCallback:LocalEventCallback | undefined = undefined;
  @State tagsType: boolean = true;
  @State isChangeMetaDate: boolean = false;
  @State AUDIO_VIVID_FLAG_WIDTH: number = 79;
  @State GOLD_FLAG_MARGIN: number = 16;
  @State private titleWidth: number = 0;
  @State private isShowGoldFlag: boolean = false;
  @State private animateShowGoldFlag: Boolean = false;
  @State private goldFlagLeft: number = -70;
  @State private goldFlagOpacity: number = 0;
  @State private goldFlagScale: number = 0.5;
  @State goldFlagloop: boolean = false;
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State imageReady: boolean = false;
  @State private moveStartCachePosition: number = -1;
  @State isPhoneOrPad: boolean = DeviceHelper.isPhoneOrPad();

  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);
  // 锁屏UI状态
  @State slBindSt?: ISlState = slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE);
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Prop isFoldFullDisplay: boolean;
  @Prop cardStyle: ImmersiveCardStyle;

  private notifyIdWithScreenLockSuffix: string = '';
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存，防止丢帧
  private isAnimComponent: boolean = false;

  // 进度条seek后快速返回原位置逻辑 回调计数
  @State private shortTimeUpdateCount: number = 0;
  // 进度条seek后快速返回原位置逻辑 操作计数
  @State private callSeekCount: number = 0;
  @Prop previewAlpha: number;
  // 锁屏一镜到底动效状态
  @State mediaAnimState: AnimationState = AnimationController.getAnimationState();
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;

  private scroller: ListScroller = new ListScroller();
  // 点击快进快退，更新position,用于打点
  @State @Watch('refreshPosition') isClickFastForward: boolean = false;
  @State @Watch('refreshPosition') isClickRewind: boolean = false;
  // 是否有歌词
  @StorageLink('hasLyric') hasLyric: boolean = false;
  private lyricIndexInit: boolean = false;
  private lyricCache: string = '';
  @State lyricTimerId: number | undefined = undefined;
  @State lyricLoadingTimerId: number | undefined = undefined;
  @State showLyric: boolean = false;
  @State isOrGoExpandLayout: boolean = this.isExpandLayout();
  @Prop isSmallFoldOuterScreen: boolean;
  private isDoubleExpand: boolean = false; //true：双列控制中心展开态
  private isThreeFoldProduct: boolean = DeviceHelper.isThreeFoldProduct();
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData =
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData;
  @State isLyricLoading: boolean = false;
  // 歌词超过1秒没有传来就不再显示
  private hideLyric: boolean = false;

  async aboutToAppear() {
    if (this.isThreeFoldProduct) {
      this.registerFoldStatusChangeCallback();
    }
    this.showLyric = this.hasLyric;
    let screenLockSuffix: string = '_screenLockImmersive';
    this.notifyIdWithScreenLockSuffix = this.notifyId + screenLockSuffix;
    log.showInfo('aboutToAppear notifyId: ' + this.notifyId + ' ,notifyIdWithScreenLockSuffix: ' +
    this.notifyIdWithScreenLockSuffix + ' isAnimeComponent ' + this.isAnimComponent);
    this.goldFlagState();
    this.controller.doSubscribeNotify();
    // 修复清除卡片后点击播放异常闪烁
    this.controller.startShowing(TAG, true);
    this.setMediaDataListener();
    this.isDarkMode = CommonUtils.isDarkMode(this.currColorMode);
    this.eventMgr.on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
      this.onScreenOnOffEvent(event)
    });
    if (!this.isAnimComponent) {
      if (!!this.image && typeof this.image === 'object') {
        PixelMapUtil.addName(this.image, 'Media_Control_Immersive');
      }
      slWallpaperMgr.setSlWallpaperImg(SLWallpaperType.TYPE_IMMERSIVE_STYLE, this.image as PixelMap);
    }
  }

  aboutToDisappear() {
    if (this.isThreeFoldProduct) {
      this.unRegisterFoldStatusChangeCallback();
    }
    this.clearTimerAndProgressData(true)
    this.unsetMediaDataListener();
    log.showInfo('aboutToDisappear notifyId: ' + this.notifyId + ' ,notifyIdWithScreenLockSuffix: ' +
    this.notifyIdWithScreenLockSuffix + ' isAnimeComponent ' + this.isAnimComponent);
    this.eventMgr.offAll();
    if (!this.isAnimComponent) {
      if (!!this.image && typeof this.image === 'object') {
        PixelMapUtil.addName(this.image, 'Media_Control_Immersive');
      }
      slWallpaperMgr.setSlWallpaperImg(SLWallpaperType.TYPE_IMMERSIVE_STYLE, undefined);
    }
    if (this.timerId) {
      clearInterval(this.timerId);
    }
    this.clearLyricTimer();
  }

  private registerFoldStatusChangeCallback(): void {
    try {
      display.on('foldStatusChange', this.mFoldStatusChangeCallback);
    } catch (error) {
      log.showError(`registerFoldStatusChangeCallback showError failed: ${error?.code}!`);
    }
  };
 
  private mFoldStatusChangeCallback: (newFoldStatus: display.FoldStatus) => void =
    (newFoldStatus: display.FoldStatus) => {
      this.isOrGoExpandLayout = (newFoldStatus !== display.FoldStatus.FOLD_STATUS_FOLDED);
    };
 
  private unRegisterFoldStatusChangeCallback(): void {
    try {
      display.off('foldStatusChange', this.mFoldStatusChangeCallback);
    } catch (error) {
      log.showError(`unRegisterFoldStatusChangeCallback showError failed: ${error?.code}!`);
    }
  };

  clearLyricTimer() {
    if (this.lyricTimerId) {
      clearTimeout(this.lyricTimerId);
      this.lyricTimerId = undefined;
    }
    if (this.lyricLoadingTimerId) {
      clearTimeout(this.lyricLoadingTimerId);
      this.lyricLoadingTimerId = undefined;
    }
  }

  onImageComplete(newValue: ImageCallback, _width: number, _height: number) { // _width容器的宽度  newValue-图片的宽高
    log.showInfo(`onImageComplete: --${newValue.width}--${newValue.height}--${this.imgBoxWidth}--${this.imgBoxHeight}`);
    const minPortraitRatio: number = 13 / 18;
    const maxLandscapeRatio: number = 16 / 9;
    const realRatio: number = newValue.width / newValue.height;
    const realImgBoxRatio = this.imgBoxWidth / this.imgBoxHeight;
    let calRatio: number = 1;
    if ((realRatio >= minPortraitRatio && realRatio <= maxLandscapeRatio)) {
      calRatio = realRatio;
    } else if (realRatio > maxLandscapeRatio) {
      calRatio = maxLandscapeRatio;
    } else { // w/h < 13/18
      calRatio = minPortraitRatio;
    }
    if (this.isExpandLayout()) {
      this.imgWidthSize = Math.min(_width, _width * calRatio);
      this.imgHeightSize = Math.min(_height, _height / calRatio);
    } else {
      if (realImgBoxRatio < calRatio) {
        this.imgWidthSize = this.imgBoxWidth;
        this.imgHeightSize = this.imgBoxWidth / calRatio;
      } else {
        this.imgHeightSize = this.imgBoxHeight;
        this.imgWidthSize = this.imgBoxHeight * calRatio;
      }
    }
    this.imagesX = Math.ceil((_width - this.imgWidthSize) / 2 + 8);
    this.imagesY = Math.ceil((_height - this.imgHeightSize) / 2 + 8 );
  }

  isHasMediaImage() {
    return !!this.image && this.image != 'unknown' && !this.image?.toString()?.includes('http')
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
    this.isShowSeek = this.validCommands.includes('seek')
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

  onLyricIndexChanged() {
    log.showInfo(`onLyricIndexChanged ${this.lyricIndex}`);
    this.scroller.scrollToIndex(this.lyricIndex, this.lyricIndexInit, ScrollAlign.CENTER);
    this.lyricIndexInit = true;
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

  isRTL() {
    return this.sysConfigData.isRTL;
  }
  
  @Builder normalImageContentBuilder() {
    Image((this.mediaImgShow && this.image) ? this.image : $r('app.media.ic_nomusic_img'))
      .alt($r('app.media.ic_nomusic_img'))
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .fillColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.IMMERSIVE_MUSIC_COLOR) : $r('sys.color.icon_fourth'))
      .interpolation(ImageInterpolation.High)
      .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.IMMERSIVE_CARD_PREVIEW_ALPHA) : 1)
      .onError(() => {
        log.showInfo('mediaImg show err ' + this.image)
        if (this.image && typeof this.image === 'object') {
          return;
        }
        this.image = '';
        this.imageReady = false
      })
      .onComplete(newValue => {
        log.showInfo('mediaImg show success: ' + this.image);
        if (newValue) {
          this.onImageComplete(newValue, this.imgBoxWidth, this.imgBoxHeight);
          if (!this.mediaImgShow || !this.image) {
            this.imageReady = false
          }
        }
      })
      .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
      .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      .geometryTransition(!this.isAnimComponent && this.mediaAnimState.isCardGeo ? 'mediaControllerImage' : '',
        {hierarchyStrategy: TransitionHierarchyStrategy.ADAPTIVE})
      .transition(TransitionEffect.IDENTITY)
      .visibility(this.isAnimComponent ? Visibility.Hidden : Visibility.Visible)
      .zIndex(this.mediaAnimState.isListGeo ? imageZIndex : undefined)
      .backgroundColor(this.mediaImgShow && this.image && this.isHasMediaImage() ? undefined :
        (this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.MEDIA_BACKGROUND_COLOR) :
        $r('sys.color.comp_background_secondary')))
  }

  @Builder normalImageBuilder() { //直板机形态
    RelativeContainer() {
      Stack() {
        if (this.mediaAnimState.isCardShow) {
          this.normalImageContentBuilder()
        }
        if (this.isShowGoldFlag) {
          Column() {
            this.goldFlagBuilder()
          }
          .zIndex(this.mediaAnimState.isListGeo ? imageZIndex + 1 : 1)
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .position(this.isRTL() ? { right: this.imagesX, bottom: this.imagesY } :
            { left: this.imagesX, bottom: this.imagesY })
        }
      }
      .constraintSize({ maxWidth: '100%', maxHeight: '100%' })
      .height('100%')
      .width('100%')
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .onAreaChange((oldArea: Area, newValue: Area) => {
        log.showInfo(`onAreaChange---${newValue.width}--${newValue.height}`)
        this.imgBoxWidth = newValue.width as number;
        this.imgBoxHeight = newValue.height as number;
      })
      .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    }
    .clip(false)
    .borderRadius(16)
    .width('100%')
    .flexGrow(0)
    .padding({ left: 24, right: 24 })
  }

  // 展开布局, 当前为折叠屏展开态和Pad场景
  @Builder expandImageBuilder() {
    Column() {
      Flex( { direction: FlexDirection.Row, justifyContent: ((this.showLyric || this.isLyricLoading) ?
        FlexAlign.Start : FlexAlign.Center)} ) {
        RelativeContainer() {
          Stack() {
            if (this.mediaAnimState.isCardShow) {
              this.normalImageContentBuilder()
            }
            if (this.isShowGoldFlag) {
              Column() {
                this.goldFlagBuilder()
              }
              .zIndex(this.mediaAnimState.isListGeo ? imageZIndex + 1 : 1)
              .alignRules({
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                left: { anchor: '__container__', align: HorizontalAlign.Start }
              })
              .position(this.isRTL() ? { right: this.imagesX, bottom: this.imagesY } :
                { left: this.imagesX, bottom: this.imagesY })
            }
          }
          .height('100%')
          .aspectRatio(1)
          .onAreaChange((oldArea: Area, newValue: Area) => {
            this.imgBoxWidth = newValue.height as number;
          })
          .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))

          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })

        }
        .aspectRatio(1)
        .height('100%')
        .flexShrink(0)

        if (this.isLyricLoading) {
          Column() {
            LoadingProgress()
              .color($r('sys.color.icon_secondary'))
              .width('50vp')
              .height('50vp')
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .width('100%')
          .height('100%')
        }
        if (this.showLyric) {
          this.lyricBuilder()
        }
      }
      .width('100%')
      .height('100%')
    }
    .clip(true)
    .width('100%')
    .layoutWeight(1)
    .padding({ left: 24, right: 24 })
  }

  @Builder lyricBuilder() {
    Column() {
      List( {scroller: this.scroller, space: 12} ) {
        ForEach(this.dataArray, (item: LyricDataArray) => {
          ListItem() {
            Text(item.lyric)
              .fontSize(item.index === this.lyricIndex ? MediaImmersiveConstants.LYRIC_FONT_MAIN :
              MediaImmersiveConstants.LYRIC_FONT_OTHER)
              .fontColor(this.getLyricColor(item.index))
              .lineHeight(21)
              .fontFamily('HarmonyHeiTi')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
              .width('100%')
              .maxFontScale(1.75)
          }
        })
      }
      .scrollBar(BarState.Off)
      .onAppear(() => {
        log.showInfo(`lyricBuilder onAppear ${this.lyricIndex}`);
        if (this.lyricIndex <= 0) {
          return;
        }
        this.scroller.scrollToIndex(this.lyricIndex, false, ScrollAlign.CENTER);
        this.lyricIndexInit = true;
      })
    }
    .width('100%')
    .height('100%')
    .margin({ left: 24 })
  }

  @Builder goldFlagBuilder() {
    Row() {
      Image(this.goldFlagImage)
        .height(8)
        .width(63)
        .fillColor('#ffffff')
        .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      Row()
        .width('100%')
        .height(16)
        .position({ x: this.goldFlagLeft, y: -4 })
        .backgroundImage($r('app.media.light'))
        .backgroundImageSize({
          width: '100%',
          height: '100%'
        })
        .opacity(1)
    }
    .scale({ x: this.goldFlagScale, y: this.goldFlagScale })
    .borderRadius(4)
    .clip(true)
    .opacity(this.goldFlagOpacity)
    .padding({
      left: 8,
      right: 8,
      top: 4,
      bottom: 4
    })
    .height(16)
    .width(79)
    .backgroundColor('#66000000')
  }

  @Builder deviceSwitchBuilder() {
    Column() {
      DeviceSwitchButton({
        buttonSize: Constants.COMMON_SWITCH_SIZE,
        isDarkMode: this.isDarkMode
      })
    }
    .justifyContent(FlexAlign.Center)
    .width(40)
    .height(40)
    .position(this.isRTL() ? { top: -10, left: -8 } : { top: -10, right: -8 })
    .zIndex(1)
  }

  build() {
    if (this.isSmallFoldOuterScreen) {
      this.buildSmallFoldOuterCard()
    } else {
      this.buildBigMediaCard()
    }
  }

  // small external screen
  @Builder buildSmallFoldOuterCard() {
    Column() {
      ImmersiveSmallMediaCard({
        notifyId: this.notifyId,
        isAnimComponent: true,
        cardStyle: {
          height: this.cardStyle.height,
          opacity: this.getContentAlpha(),
          enabled: false,
          visibility: this.cardStyle.visibility
        },
        cardHeight: 108,
        isFoldFullDisplay: this.isFoldExpand(),
        previewAlpha: this.getPreviewAlpha(),
        isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
      })
    }
    .height(this.cardStyle.height)
    .width(this.cardStyle.width)
    .opacity(this.getContentAlpha())
    .enabled(this.cardStyle.enabled)
    .visibility(this.cardStyle.visibility)
  }

  @Builder buildImage() {
    Row() {
      Image((this.mediaImgShow && this.image) ? this.image : $r('app.media.ic_nomusic_img'))
        .alt($r('app.media.ic_nomusic_img'))
        .objectFit(ImageFit.Cover)
        .fillColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.IMMERSIVE_MUSIC_COLOR) : $r('sys.color.icon_fourth'))
        .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.IMMERSIVE_CARD_PREVIEW_ALPHA) : 1)
    }
    .height(this.cardStyle.height)
    .width(this.cardStyle.width)
  }

  getTitle():string {
    if (this.isExpandLayout() && this.showLyric) {
      return this.songName;
    } else {
      const defaultTitle: string | Resource = ((this.isPlaying() && this.isMarqueeStart) ? '' : ResUtils.getInnerString($r('app.string.no_media_title')) );
      return this.title || (this.curAppName ? this.curAppName.toString() : defaultTitle);
    }
  }

  @Builder buildBigMediaCard() {
    Flex({direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween}) {
      // album image
      if (this.isThreeFoldProduct ? this.isOrGoExpandLayout : this.isExpandLayout()) {
        this.expandImageBuilder()
      } else {
        this.normalImageBuilder()
      }

      // title
      Column() {
        Column() {
          Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
            Row() {
              if (this.isPlaying() && this.isMarqueeStart) {
                Marquee({
                  start: this.isMarqueeStart,
                  step: 6,
                  loop: -1,
                  fromStart: !this.isRTL() ? true : false,
                  src: this.getTitle()
                })
                  .fontSize(MeasuringUtil.getFontSize(16, 1.75, this.fontSizeScale))
                  .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.WEIGHT_FONT_COLOR) :
                    this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_primary'))
                  .foregroundBrightness(this.aodStyle?.isAod ? undefined :
                    BrightnessUtils.getInstance().getItemTextBrightnessOption(true, 'immersive', this.isDarkMode))
                  .fontWeight(ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_weight')))
                  .width('100%')
                  .align(!this.isRTL() ? Alignment.Start : Alignment.End)
                  .accessibilityLevel('no')
                  .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
              } else {
                Text(this.getTitle())
                  .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
                  .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.WEIGHT_FONT_COLOR) :
                    this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_primary'))
                  .foregroundBrightness(this.aodStyle?.isAod ? undefined :
                    BrightnessUtils.getInstance().getItemTextBrightnessOption(true, 'immersive', this.isDarkMode))
                  .fontSize('16fp')
                  .maxFontScale(1.75)
                  .fontWeight(ResUtils.getConvertNumber($r('app.float.Control_center_long_button_font_weight')))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('100%')
              }
            }
            .height(MeasuringUtil.getHeight(16, 24, 1.75, this.fontSizeScale))
          }
          .width('100%')
          .padding(!this.isRTL() ? { right: 32 } : { left: 32 })
          .onAreaChange((oldArea: Area, newValue: Area) => {
            this.songNameAreaWidth = newValue.width as
            number;
            this.titleWidth = this.getSongNameTextLength(this.title, this.songNameTextSize);
            log.showInfo(`parse media data: title = ${this.titleWidth}${this.goldFlagImage}`);
          })

          // artist
          Flex({ wrap: FlexWrap.NoWrap }) {
            Marquee({
              start: this.isMarqueeStart,
              step: 6,
              loop: -1,
              fromStart: !this.isRTL() ? true : false,
              src: (this.lyric && !this.isExpandLayout() && this.newLyric) ? this.newLyric : this.artist
            })
              .fontSize(MeasuringUtil.getFontSize(14, 1.75, this.fontSizeScale))
              .fontWeight(FontWeight.Regular)
              .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
                this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
              .foregroundBrightness(this.aodStyle?.isAod ? undefined :
                BrightnessUtils.getInstance().getItemTextBrightnessOption(false, 'immersive', this.isDarkMode))
              .width('100%')
              .align(!this.isRTL() ? Alignment.Start : Alignment.End)
              .visibility(this.isPlaying() && this.isMarqueeStart ? Visibility.Visible : Visibility.None)
              .accessibilityLevel('no')
              .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
            Text((this.lyric && !this.isExpandLayout() && this.newLyric) ? this.newLyric : this.artist)
              .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize(14)
              .maxFontScale(1.75)
              .fontWeight(FontWeight.Regular)
              .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
                this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
              .foregroundBrightness(this.aodStyle?.isAod ? undefined :
                BrightnessUtils.getInstance().getItemTextBrightnessOption(false, 'immersive', this.isDarkMode))
              .width('100%')
              .visibility(this.isPlaying() && this.isMarqueeStart ? Visibility.None : Visibility.Visible)
          }
          .width('100%')
          .height(MeasuringUtil.getHeight(14, 19, 1.75, this.fontSizeScale))
          .margin({ top: $r('sys.float.ohos_id_text_margin_vertical') })
        }
        .accessibilityGroup(true)
        .accessibilityLevel('yes')
        // 投音按钮
        this.deviceSwitchBuilder()
      }
      .margin({ top: 8 })
      .backgroundColor(Color.Transparent)
      .padding({ left: 24, right: 24 })
      .flexShrink(0)


      // process bar
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text(this.getProgressStart())
          .fontSize(10)
          .maxFontScale(1.45)
          .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
            this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
          .foregroundBrightness(this.aodStyle?.isAod ? undefined :
            BrightnessUtils.getInstance().getItemTextBrightnessOption(this.isClickSlider, 'immersive', this.isDarkMode))
          .flexShrink(0)
          .textAlign(TextAlign.Start)
          .padding(this.aodStyle?.isAod ? { right: 3 } : undefined)
          .accessibilityLevel('no')
          .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧

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
            sliderSelectedColor: (this.aodStyle?.isAod ? '#26FFFFFF' :
              (this.isPhoneOrPad ? (this.isShowSeek ? $r('app.color.media_item_slider_primary') : $r('app.color.media_item_slider_normal')) :
              (this.isShowSeek ? $r('sys.color.icon_emphasize') : $r('sys.color.icon_fourth')))),
            sliderTrackColor: (this.aodStyle?.isAod ? '#0DFFFFFF' : (this.isPhoneOrPad ?
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
          .fontSize(10)
          .maxFontScale(1.45)
          .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
            this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
          .foregroundBrightness(this.aodStyle?.isAod ? undefined :
            BrightnessUtils.getInstance().getItemTextBrightnessOption(this.isClickSlider, 'immersive', this.isDarkMode))
          .flexShrink(0)
          .textAlign(TextAlign.End)
          .padding(this.aodStyle?.isAod ? { right: 3 } : undefined)
          .accessibilityLevel('no')
          .renderGroup(this.aodStyle?.isOneMirror ? false : this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      }
      .width('100%')
      .height(40)
      .padding({ left: 24, right: 24 })
      .flexShrink(0)

      // 四元组按钮
      ControlButtonGroup({
        sceneType: 'immersive',
        sessionType: this.mediaType,
        iconSize: 28,
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
        isDoubleExpand: this.isDoubleExpand,
        duration: this.duration,
        fun: () => {
          if (this.loopMode !== AVSessionManager.LoopMode.LOOP_MODE_SINGLE && this.isShowGoldFlag) {
            this.goldFlagEnd()
          }
        }
      })
        .width('100%')
        .backgroundColor(Color.Transparent)
        .height(48)
        .constraintSize({ minHeight: 48 })
        .flexShrink(0)
        .clip(true)
        .padding({ left: 12, right: 12 })
        .flexShrink(0)
    }
    .width(this.cardStyle.width)
    .height(this.cardStyle.height)
    .borderRadius(32)
    .clip(false)
    .brightness(1)
    .saturate(1)
    .padding({ top: 24, bottom: 11})
    .opacity(this.getContentAlpha())
    .enabled(this.cardStyle.enabled)
    .visibility(this.cardStyle.visibility)
  }

  private getContentAlpha(): number | undefined {
    // 内容透明度，AOD时0.9
    if (this.aodStyle?.isAod) {
      return this.aodStyle.getStyleValue(AodStyleType.LIST_CARD_BG_ALPHA);
    }
    return this.cardStyle?.opacity;
  }

  private getPreviewAlpha(): number | undefined {
    // 预览图透明度，AOD时内屏0.4，小外屏0
    if (this.aodStyle?.isAod) {
      return this.isSmallFoldOuterScreen ? 0 : 0.4;
    }
    return undefined;
  }

  private isFoldExpand(): boolean {
    return (this.slBindSt?.getSlState(SlBindStateType.SL_FOLD_EXPAND_STATE) as boolean) ?? false;
  }

  updateBasicInfo(mediaInfo: ShowingMesTS) {
    if (mediaInfo.playState != undefined) {
      log.debug(`parse media data: playState = ${mediaInfo.playState}`);
      const playState: number = mediaInfo.playState as number;
      if (playState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
        this.lastPlayState = playState;
      }
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
        this.appIconShow = false;
      } else {
        this.appIcon = mediaInfo.mediaPlayerIcon as string;
        this.appIconShow = true;
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
    if (mediaInfo.validCommands !== undefined) {
      log.debug(`parse media data: validCommands = ${mediaInfo.validCommands}`)
      this.isShowPlayPause = !!mediaInfo.validCommands?.includes('play') &&
        !!mediaInfo.validCommands?.includes('pause')
    }
    this.isShowPlayButton = (!!this.image || !!this.title || !!this.artist || !this.curAppName) && !!this.mediaType &&
      this.isShowPlayPause;
    this.titleWidth = this.getSongNameTextLength(this.title, this.songNameTextSize);
  }

  updateGoldFlag(mediaInfo: ShowingMesTS) {
    log.showInfo(`updateGoldFlag displayTags: ${mediaInfo.displayTags} 、${this.isShowGoldFlag}`);
    if (!mediaInfo.displayTags) {
      return;
    }
    if (this.isChangeSong || this.tagsType) {
      this.tagsType = false;
      setTimeout(() => {
        this.tagsType = true;
      }, 1000)
      log.showInfo(`updateGoldFlag update`);
      this.isShowGoldFlag = !!mediaInfo.displayTags;
      if (this.isShowGoldFlag) {
        if (this.loopMode !== AVSessionManager.LoopMode.LOOP_MODE_SINGLE) {
          this.goldFlagOpacity = 0;
          this.goldFlagState();
        } else {
          this.animateShowGoldFlag = this.isShowGoldFlag;
          this.goldFlagScale = 1;
          this.goldFlagOpacity = 1;
        }
      } else {
        this.animateShowGoldFlag = false
      }
    }
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
      if (duration > 24 * 60 * 60 * 1000) {
        duration = 24 * 60 * 60 * 1000;
      }
      if (this.duration !== duration && mediaInfo.position === undefined) {
        this.handleDurationUpdate(duration, this.duration);
      }
      this.duration = duration;
      if (!this.duration || this.duration < 0) {
        this.initSliderChange();
      }
    }

    if (mediaInfo.speed != undefined) {
      this.speed = mediaInfo.speed;
    } else {
      this.speed = 1;
    }

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

  /**
   * 重置进度条相关变量
   */
  initSliderChange() {
    this.progressHeight = 4;
    this.isClickSlider = false;
  }

  updateLyric(mediaInfo: ShowingMesTS) {
    if (mediaInfo.lyric === undefined) {
      if (this.curRemoteOutputDev > 0) {
        this.lyric = '';
        this.newLyric = '';
      }
      return;
    }
    this.clearLyricTimer();
    if (this.lyric && !mediaInfo.lyric) {
      this.lyricLoadingTimerId = setTimeout(() => {
        this.uiContext.animateTo({
          curve: curves.interpolatingSpring(0, 1, 228, 25)
        }, () => {
          this.showLyric = false;
          this.isLyricLoading = true;
        })
      }, 500)
      // 延时动效
      this.lyricTimerId = setTimeout(() => {
        this.hideLyric = true;
        this.tryLyricDisappear();
        this.clearLyricTimer();
      }, 1000)
    } else if (!this.hideLyric) {
      this.tryLyricAppear(mediaInfo);
    }
  }

  tryLyricAppear(mediaInfo: ShowingMesTS) {
    if ((!this.showLyric || this.isLyricLoading) && mediaInfo.lyric) {
      this.uiContext.animateTo({
        curve: curves.interpolatingSpring(0, 1, 228, 25)
      }, () => {
        this.showLyric = true;
        this.isLyricLoading = false;
      })
    }
    this.lyric = mediaInfo.lyric as string;
    this.loadMusicLyricList();
    this.updateLyricByPosition();
  }

  tryLyricDisappear() {
    this.uiContext.animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 25)
    }, () => {
      this.showLyric = false;
      this.isLyricLoading = false;
    })
    this.lyric = '';
    this.newLyric = '';
    this.loadMusicLyricList();
    this.updateLyricByPosition();
  }

  mediaDataUpdate(mediaInfo: ShowingMesTS) {
    if (this.isChangeSong && !mediaInfo.displayTags) {
      this.isShowGoldFlag = false;
    }
    if (this.isChangeSong || this.isChangeApp) {
      this.hideLyric = false;
    }
    if ((this.aodStyle?.isAod || this.isMarqueeStart === null) && !this.isChangeSong &&
      (!mediaInfo?.musicAssetId || this.assetId === mediaInfo?.musicAssetId)) {
      return;
    }
    this.updateBasicInfo(mediaInfo);
    this.updateGoldFlag(mediaInfo);
    this.updateProgress(mediaInfo);
    this.updateLyric(mediaInfo);
  }

  getSongNameTextLength(text: string, fontSize: number): number {
    let textLength: number = this.uiContext.getMeasureUtils().measureText({
      textContent: text,
      fontSize: fontSize
    })
    let audioVividFlagWidth = this.AUDIO_VIVID_FLAG_WIDTH + this.GOLD_FLAG_MARGIN;
    let maxValidLength = this.songNameAreaWidth - audioVividFlagWidth;
    let length = (this.uiContext.px2vp(textLength) + 5) > maxValidLength ? maxValidLength :
      (this.uiContext.px2vp(textLength) + 5);
    log.showInfo('textLength:' + (this.uiContext.px2vp(textLength) + 5) + ' maxValidLength:' + maxValidLength + ' result:' + length);
    return length - 28;
  }

  goldFlagState() { //金标显示动画
    setTimeout(() => {
      if (this.goldFlagOpacity == 0) {
        this.goldFlagLeft = -70;
        this.goldFlagScale = 0.5;
        this.goldFlagOpacity = 0;
        // 金标动画
        this.uiContext.animateTo({ duration: 16, curve: Curves.interpolatingSpring(16, 1, 100, 20) }, () => {
          this.animateShowGoldFlag = this.isShowGoldFlag
          this.goldFlagScale = 1;
        });
        this.uiContext.animateTo({ duration: 250, curve: Curve.EaseIn }, () => {
          this.goldFlagOpacity = 1;
        });
        this.uiContext.animateTo({ duration: 1000, delay: 250, curve: Curve.Ease }, () => {
          this.goldFlagLeft = 70;
        });
      } else {
        this.goldFlagLeft = 70;
        this.goldFlagOpacity = 1;
        this.goldFlagScale = 1;
      }
    }, 200)
  }

  goldFlagEnd() { //金标消失动画
    if (this.isMarqueeStart) {
      if (this.goldFlagOpacity != 0) {
        this.goldFlagScale = 1;
        this.goldFlagOpacity = 1;
        // 金标动画
        this.uiContext.animateTo({ duration: 16, curve: Curves.interpolatingSpring(16, 1, 188, 20) }, () => {
          this.goldFlagScale = 0.8;
        });
        this.uiContext.animateTo({ duration: 166, curve: Curve.EaseIn }, () => {
          this.goldFlagOpacity = 0;
        });
      }
    } else {
      this.goldFlagScale = 0.8;
      this.goldFlagOpacity = 0;
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
      this.checkPowerActive();
      if (this.aodStyle?.isAod || !this.isMarqueeStart) {
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
    }, this.OPERATE_MIN_INTERVAL / (this.speed ? this.speed : 1))
  }

  checkPowerActive = throttle(() => {
    if (!this.controller.isPowerActive()) {
      log.showInfo(`checkPowerActive to clear interval`)
      this.isMarqueeStart = false;
      this.clearTimerAndProgressData(false);
    }
  }, 1000);

  getProgressStart(): string {
    log.showInfo(` getProgressStart result: ${this.duration}`);
    if (!this.duration || this.duration <= 0 || this.aodStyle?.isAod) {
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
    if (!this.duration || this.duration <= 0 || this.aodStyle?.isAod) {
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

  onImageChanged() {
    if (!this.isAnimComponent) {
      if (!!this.image && typeof this.image === 'object') {
        PixelMapUtil.addName(this.image, 'Media_Control_Immersive');
      }
      slWallpaperMgr.setSlWallpaperImg(SLWallpaperType.TYPE_IMMERSIVE_STYLE, this.image as PixelMap);
      // 播控壁纸就绪后刷新壁纸反色
      ImmInvertColorMgr.getInstance().cacheInvertColor(this.notifyId, this.image as PixelMap);
    }
    if (this.imageReady) {
      setTimeout(() => {
        if (this.image?.toString()?.includes('http')) {
          this.imageReady = false;
        } else {
          this.imageReady = true;
        }
      }, 500)
    } else if (this.image?.toString()?.includes('http')) {
      this.imageReady = false;
      setTimeout(() => {
        if (this.image?.toString()?.includes('http')) {
          this.imageReady = false;
        } else {
          this.imageReady = true;
        }
      }, 500)
    } else if (this.hasMedia && this.image) {
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
    let lyricIndex: number = 0;
    if (!this.dataArray || this.dataArray.length === 0) {
      this.newLyric = oldLyric;
      this.lyricIndex = lyricIndex;
      return;
    }
    if (this.dataArray && this.dataArray.length > 0 && this.dataArray[this.dataArray.length - 1]?.time <=
      (this.isClickSlider ? this.movingPosition : this.movePosition)) {
      this.newLyric = this.dataArray[this.dataArray.length - 1]?.lyric?.trim();
      this.lyricIndex = this.dataArray[this.dataArray.length - 1]?.index;
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
          lyricIndex = this.dataArray[i].index;
        }
      } else {
        // 如果是最后一句，就一直显示最后一句
        if (i >= this.dataArray.length && !!this.dataArray[i]?.lyric) {
          oldLyric = this.dataArray[i].lyric.trim();
          lyricIndex = this.dataArray[i].index;
        }
        // 比对不成功跳出循环
        break;
      }
    }
    this.newLyric = oldLyric;
    this.lyricIndex = lyricIndex;
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

  getCurSwitchIcon() {
    return CommonUtils.getCurSwitchIcon(this.curOutputDev?.deviceType, this.curRemoteOutputDev);
  }

  // 是否使用展开布局，当前为折叠屏展开态和pad场景
  isExpandLayout(): boolean {
    return (this.isFoldExpand()) || DeviceHelper.isPad() ||
      CommonUtils.isThreeFoldProductInGState();
  }

  getLyricColor(index: number): ResourceColor {
    if (index === this.lyricIndex) {
      return this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.WEIGHT_FONT_COLOR) as ResourceColor :
      $r('sys.color.font_primary');
    } else {
      return this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) as ResourceColor :
      $r('sys.color.font_tertiary');
    }
  }
}