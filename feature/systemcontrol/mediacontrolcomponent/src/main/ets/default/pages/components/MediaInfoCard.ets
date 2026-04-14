/*
 * Copyright (c) 2023-2025 Huawei Device Co., Ltd.
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

import Curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/plugin/PluginConstants';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import Constants, {
  AVCastPickerDeviceIconName,
  AVQueueInfo,
  ButtonIconName,
  DeviceSource,
  foldHeightCard,
  GeometryOptions,
  ImageCallback,
  LocalDeviceInfo,
  LyricDataArray,
  PlayStyleObj,
  SliderStyleEx,
  StyleObject,
  ImageStyle,
  SetVolumeType,
  InputVolumeAction,
  InputGestureType,
  ShowDevType,
} from '../../Util/Constants';
import AVSessionManager from '@ohos.multimedia.avsession';
import image from '@ohos.multimedia.image';
import systemDateTime from '@ohos.systemDateTime';
import AnimationIconLocal from './AnimationIconLocal';
import MediaInfoProvider from '../../Controller/MediaInfoProvider';
import { MediaInfoProviderDc } from '../../Controller/MediaInfoProviderDc';
import { DcMediaController } from '../../Controller/DcMediaController';
import CommunicationUtil from '../../Util/CommunicationUtil';
import CommonUtils from '../../Util/CommonUtils';
import display from '@ohos.display';
import { LocalEventCallback } from '../../Util/LocalEventCallBack';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { MediaControllerSlider } from '../../Util/MediaControllerSlider';
import MeasuringUtil from '../../Util/MeasuringUtil';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import ImageDownloaderUtils from '../../Util/ImageDownloaderUtils';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityUtil';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';
import { CardStackControl } from '../../Controller/CardStackControl';
import { MediaInfoListData } from '../../viewmodel/MediaInfoListData';
import { RecentlyPlayList } from './RecentlyPlayList';
import AnimationIconSimple from './AnimationIconSimple';
import uiEffect from '@ohos.graphics.uiEffect';
import JumpingNotes from './JumpingNotes';
import { PageLoad } from './PageLoad';

const TAG: string = 'MediaInfoCard_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const loopIcon: Resource[] = [
  $r(ButtonIconName.ORDER_PLAY_SYMBOL),
  $r(ButtonIconName.SINGLE_CYCLE_SYMBOL),
  $r(ButtonIconName.LIST_CYCLE_SYMBOL),
  $r(ButtonIconName.RANDOM_PLAY_SYMBOL),
];

const landscapeLargeAliases = [
  'mediaImgBgLandscapeLarge',
  'mediaImgLandscapeLarge',
  'defaultBgLandscapeLarge',
  'defaultImgLandscapeLarge',
  'publicIconLandscapeLarge',
  'mediaImgBgLandscapeSmall',
  'mediaImgLandscapeSmall',
  'defaultBgLandscapeSmall',
  'defaultImgLandscapeSmall',
  'publicIconLandscapeSmall'
];

const portraitAliases = [
  'textPlayBoxPortraitSmall',
  'songBoxPortraitSmall',
  'textPlayBoxPortraitLarge',
  'songBoxPortraitLarge'
];

@Component
export struct MediaInfoCard {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private isPC: boolean = DeviceHelper.isPC() && !ControlCenterPluginMgr.isPcMode;
  private isPad: boolean = DeviceHelper.isPad();
  private isPhone: boolean = DeviceHelper.isPhone();
  @Prop @Watch('sessionUpdate') index: number = 0;
  @Prop @Watch('sessionUpdate') sessionId: string = '';
  @Link isFirstDataLength: boolean;
  @Link firstDataLength: number;
  @Link isShowDev: boolean;
  @Link isSmallPic: boolean; // 小卡模式（通话场景）
  @Link isText: boolean;
  @Link isFriction: boolean;
  @Link albumInfoListIsData: boolean;
  @Link isFoldDevice: boolean; // 是否为折叠屏
  @Link alInfoTmpList: Array<AVQueueInfo>;
  @Link albInfo: AVQueueInfo;
  @Link isClickIndex: boolean;
  @Link isVideo: boolean;
  @State isCasting: AbstractProperty<boolean> = AppStorage.setAndRef('isCasting', false);
  @Link @Watch('outputDevChanged') curOutputDev: LocalDeviceInfo;
  @State showVolumeButton: boolean = false;
  @State @Watch('enableCommandUpdate') isInCast: boolean = this.curOutputDev.deviceSource === DeviceSource.CAST;
  public fun:() =>void = () => {};
  @Link exitApplication: boolean;
  @Link @Watch('sessionUpdate') curForceMedia: number;
  @Link @Watch('landscapeChanged') isLandscape: boolean;

  @Prop panelWidth: number = 0;
  @Prop panelHeight: number = 0;
  @Prop curSwitchIcon: string = '';
  @Prop isShowButtonIcon: boolean = true;
  @Prop cardStackController: CardStackControl | undefined = undefined;
  @Prop firstColumnTextConst: Resource | string = $r('app.string.LocalDevice');
  @Prop titleMaxFontScale: number = Constants.SMALL_FOLD_DEVICE_TITLE_MAX_FONT_SCALE;
  @Prop pointOpacityFirst: number = 0.1; // 播放动画透明度1
  @Prop pointOpacitySecond: number = 0.1; // 播放动画透明度2
  @Prop pointOpacityThird: number = 0.1; // 播放动画透明度3
  @Prop showDevType: ShowDevType = ShowDevType.MEDIA;
  @Prop callDeviceListHeight: number = 0;
  private clickCurSwitchIcon: () => void = () => {};
  @Link playbackCardHeight: number;
  @StorageLink('hasCall') hasCall: boolean = false;
  @StorageLink('showPlayLoading') showPlayLoading: boolean = false;
  private showPlayLoadingTimer: number | undefined = undefined;
  @StorageProp('canColdStart') canColdStart: boolean = false;

  @StorageLink('appIconMap') appIconMap: Map<string, image.PixelMap> = new Map();
  @StorageLink('MetaDataMap') @Watch('metaDataUpdate') metaDataMap: Map<string, AVSessionManager.AVMetadata> =
    new Map<string, AVSessionManager.AVMetadata>();
  @StorageLink('imageRatioMap') @Watch('imageRatioUpdate') imageRatioMap: Map<string, number> =
    new Map<string, number>();
  @StorageLink('PlayStateMap') @Watch('playStateUpdate') playStateMap: Map<string, AVSessionManager.AVPlaybackState> = new Map();
  @StorageLink('commandEnableMap') @Watch('enableCommandUpdate') commandEnableMap: Map<string, Array<AVSessionManager.AVControlCommandType>> =
    new Map<string, Array<AVSessionManager.AVControlCommandType>>();
  @StorageLink('appNameMap') @Watch('enableCommandUpdate') appNameMap: Map<string, string> = new Map<string, string>();
  @State private oldAssetId: AbstractProperty<string> = AppStorage.setAndRef('oldAssetId', '');
  @State private oldTitle: AbstractProperty<string> = AppStorage.setAndRef('oldTitle', '');
  @State private oldSubTitle: AbstractProperty<string> = AppStorage.setAndRef('oldSubTitle', '');

  private preOrNextOperateTimeStamp: number | null = null;

  @Provide dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  private mediaInfoProvider: MediaInfoProvider | MediaInfoProviderDc | undefined = this.enableDc ?
    MediaInfoProviderDc.getInstance() : MediaInfoProvider.getInstance();
  @State @Watch('checkSinkSession') private isSinkSession: boolean = false;
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  // 可用功能
  @State @Watch('enableCommandUpdate') private isCanPlay: boolean = false;
  @State private isShowFavor: boolean = false;
  @State private isShowPlay: boolean = true;
  @State private isShowPause: boolean = true;
  @State private isShowPlayNext: boolean = false;
  @State private isShowPlayPrevious: boolean = false;
  @State private isShowRewind: boolean = false;
  @State private isShowFastforward: boolean = false;
  @State private isShowSeek: boolean = true;
  @State private isShowLoopMode: boolean = false; //循环模式
  @State isOperateProgress: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  // 进度条
  @State @Watch('enableCommandUpdate') private duration: number = -6; // 0111
  @State private speed: number = 1;
  @State private progressTextColor: Resource = $r('app.color.media_control_text_secondary');
  @State private progressTextBrightness: boolean = true;
  private timerId: number | undefined = undefined;
  private operateMinInterval: number = 500; // 防抖时间
  @StorageLink('playbackPositionMap')
  private playbackPositionMap: Map<string, AVSessionManager.PlaybackPosition> = new Map(); // position from avsession
  @State @Watch('getMusicLyric') private movePosition: number = 0; // position to show
  @State @Watch('getMusicLyric') private movingPosition: number = 0; // position to get lyric
  @State @Watch('getProgressStart') private trueMovePosition: number = 0; // position truely show
  @State private moveFlag: number = 0;
  @State private moveStartCachePosition: Array<number> = [];
  @State private moveFlagStep: number = 2;
  @State private progressHeight: number = 4;
  @State private volumeHeight: number = 4;
  @State loopMode: number = AVSessionManager.LoopMode.LOOP_MODE_SEQUENCE;
  @State private isClickLoop: boolean = false;
  @State private isSliderChange: boolean = false;
  // 封面图
  @State isCanLoaded: boolean = true;
  private imageSize:ImageStyle | null = null;
  private isUpdateImageSize:boolean = false;
  private isUpdateNewImageSize:boolean = false;
  private isUpdateSmallImageSize:boolean = false;
  @State imagesWidth: number = this.getDefaultSize('portraitImagesWidth', Constants.PANEL_PORTRAIT_WIDTH - 48);
  @State imagesWidthNew: number = this.getDefaultSize('portraitImagesWidth', Constants.PANEL_PORTRAIT_WIDTH - 48);
  @State imagesHeight: number = this.getDefaultSize('portraitImagesHeight', Constants.PANEL_PORTRAIT_WIDTH - 48);
  @State imagesHeightNew: number = this.getDefaultSize('portraitImagesHeight', Constants.PANEL_PORTRAIT_WIDTH - 48);
  @State imagesX: number = this.getDefaultSize('portraitImagesX', Constants.PANEL_PORTRAIT_WIDTH - 48 - 32);
  @State imagesNewX: number = this.getDefaultSize('portraitImagesX', Constants.PANEL_PORTRAIT_WIDTH - 48 - 32);
  @State imagesY: number = this.getDefaultSize('portraitImagesY', Constants.PANEL_PORTRAIT_WIDTH - 48 - 32);
  @State imagesNewY: number = this.getDefaultSize('portraitImagesY', Constants.PANEL_PORTRAIT_WIDTH - 48 - 32);
  @StorageLink('iconSmallX') smallImagesX: number = 48 - 16;
  @StorageLink('iconSmallY') smallImagesY: number = 48 - 16;
  @State goldFlagX: number = 8;
  @State goldFlagNewX: number = 8;
  @State goldFlagY: number = Constants.PANEL_PORTRAIT_WIDTH - 48 - 16 - 8;
  @State goldFlagNewY: number = Constants.PANEL_PORTRAIT_WIDTH - 48 - 16 - 8;
  @StorageLink('imgSmallWidth') imagesSmallWidth: number = 48;
  @StorageLink('imgSmallHeight') imagesSmallHeight: number = 48;
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存，防止丢帧

  // 历史歌单
  @StorageLink('finishAnimate') @Watch('isFinishAnimation') finishAnimate: boolean = true;
  @State @Watch('isTextOpacityFunction') isClickToggle:boolean = false;
  @StorageLink('changeBigPicIconOpc') private bigPicIconOpacity:number = 1;
  @StorageLink('loadingProgressOpacity') private loadingProgressOpacity: number = 0;
  @StorageLink('maskBlur') private maskBlur: number = 0;
  @Link bigImageDataTemp: AVSessionManager.AVMetadata;

  @State @Watch('tempPicChange') tempPic: Resource | image.PixelMap | string = this.getDefaultTempPic();
  @State tempTitle: string = this.getDefaultTempTitle();
  @State tempSubTitle: string = this.getDefaultTempSubTitle();
  @State private opacityBigImage: number = 1.0; //监听透明度
  @State private scaleSizeX: number = 1.0; //改变大图尺寸X
  @State private scaleSizeY: number = 1.0; //改变大图尺寸Y
  @State private opacityBigImageNew: number = 0; //监听透明度
  @State private scaleSizeXNew: number = 0.5; //改变大图尺寸X
  @State private scaleSizeYNew: number = 0.5; //改变大图尺寸Y
  @State @Watch('tempPicChange') tempPicNew: Resource | image.PixelMap | string = this.getDefaultTempPic();
  private noPic: boolean = !this.tempPic && !this.tempPicNew; // 封面图是否为空，判断歌单冷启动淡入淡出
  private noTitle: boolean = !this.tempTitle; // 标题是否为空，判断歌单冷启动淡入淡出
  @State bigIconPic: string | image.PixelMap = ''
  @State bigIconPicNew: string | image.PixelMap = ''
  @StorageLink('clickItemAnimationStart') @Watch('clickItemAnimationStart') isItemAnimationStart: boolean = false;

  @StorageLink('clickAlbum') isClickAlbum: boolean = false; //是否点击歌单
  // 标题
  private songNameAreaWidthNoCast: number = 0;
  private songNameAreaWidthCast: number = 0;

  // 金标
  private goldFlagImage: Resource = $r('app.media.ic_audiovivid');
  @State private isShowGoldFlag: boolean = false;
  @State private animateShowGoldFlag: Boolean = false;
  @State private goldFlagLeft: number = -70;
  @State private goldFlagOpacity: number = 0;
  @State private goldFlagScale: number = 0.5;
  private songNameTextSize: Resource = $r('sys.float.ohos_id_text_size_body1');

  // 音量
  @StorageLink('Volume') outSetValue: number = 0;
  @Link isButtonHolding: boolean;

  // 歌词
  @StorageLink('isTextOpacity') @Watch('isTextOpacityFunction') isTextOpacity: boolean = false;
  @State dataArray: Array<LyricDataArray> = [];
  @State lyricList: Array<string> = [];
  // 淡入淡出相关变量
  @State newLyric: string = '';
  @State oldLyric: string = '';
  @State newLyricOpacity: number = 0;
  @State oldLyricOpacity: number = 1;
  @State newMusicAuthorTwo: string = '';
  @State oldMusicAuthorTwo: string = '';
  @State newGetText: string = '';
  @State oldGetText: string = '';
  @State newProgressStartTime: string = '';
  @State oldProgressStartTime: string = '';
  @State newProgressEndTime: string = '';
  @State oldProgressEndTime: string = '';

  // 动效与位置相关
  @StorageLink('isDisplay') @Watch('updateBigImageInfo') isDisplay: boolean = false;
  @StorageLink('isStartPlaying') @Watch('updateBigImageInfo') isStartPlaying:boolean = false;

  // 窗口
  @StorageLink('windowHeight') windowHeight: number = 0;
  @StorageLink('windowWidth') windowWidth: number = 0;

  private outputDeviceChangedCallback: LocalEventCallback | undefined = undefined;

  // 一镜到底动效是否完成
  @Link @Watch('mediaTransitionDoneChange') mediaTransitionDone: boolean;
  @StorageLink('mediaTransitionFlag') mediaTransitionFlag: number = 0;
  // 淡入淡出元素的透明度
  @Prop fadeOpacity: number = 0;

  // 进度条seek后快速返回原位置逻辑 回调计数
  @State private shortTimeUpdateCount: number = 0;
  // 进度条seek后快速返回原位置逻辑 操作计数
  @State private callSeekCount: number = 0;
  // 音量键按压时间
  @State touchCastVolumeTime: number | undefined = undefined;
  // 延迟标记，控制长按音量键的回调响应
  private monitorVolumeTimerId: number | undefined = undefined;
  @Consume('isQuiting') isQuiting: boolean;
  @Consume('isJumping') isJumping: boolean;

  private lyricCache: string = '';

  private lastPlayState: number = 0;

  @State @Watch('playStateChange') isPlaying: boolean = false;
  @State @Watch('favorStateChange') isFavorite: boolean = false;
  @State @Watch('loopModeStateChange') isLoopModeStateChange: number = 0;

  // 是否做动效标记，数值改变触发动效
  @State fastForwardTriggerValue: number = 0;
  @State fastRewindTriggerValue: number = 0;
  @State favorTriggerValue: number = 0;
  @State playPauseTriggerValue: number = 0;
  @State loopModeTriggerValue: number = 0;
  @Provide('maxTextFontScale') textMaxFontScale: number = Constants.TEXT_MAX_FONT_SCALE;
  @State progressMaxFontScale: number = Constants.PROGRESS_MAX_FONT_SCALE;

  @Builder systemSceneBg() {};
  @BuilderParam systemSceneBgBuilder: () => void = this.systemSceneBg; // 组件插槽，父组件自定义systemSceneBg

  @StorageLink('mediaInfoListData') @Watch('historyDataChange') mediaInfoListData: MediaInfoListData[] = [];
  @Link isShowPrefer: boolean;
  @State preferHeight: number = 628;
  @State @Watch('currentIndexChange') currentIndex: number = 0;
  @Link isShowDeviceAnim: boolean;
  @StorageLink('ControlMediaTitle') title : string | boolean = '';
  @StorageLink('MediaArtist') artist : string | boolean = '';
  private tabsController: TabsController = new TabsController();
  private swiperController: SwiperController = new SwiperController();
  @State isShowMore: Visibility = Visibility.None;
  @State isListItemClicked: boolean = false;
  @State playingLayoutScale: number = 1;
  @State landSmallImageBlankWidth: number = 0;
  @StorageLink('isExistAvQueueInfo') isExistAvQueueInfo: boolean = false;
  @State isShowPreferenceButton: boolean = false;
  private exitControlCenterCallback: LocalEventCallback | undefined = undefined;

  /**
   * 数据列表改变监听
   */
  public async listDataChanged() {

  }

  currentIndexChange() {
    this.uiContext.animateTo({
      curve: Curves.interpolatingSpring(0, 1, 228, 25),
      delay: this.isShowDev || (this.getMusicAuthorBoolean() && this.currentIndex === 0) ? 0 : 50
    }, () => {
      if (this.isShowDev || (this.getMusicAuthorBoolean() && this.currentIndex === 0)) {
        this.landSmallImageBlankWidth = Constants.COMMON_PICTURE_SIZE_LARGE + 8;
      } else {
        this.landSmallImageBlankWidth = 0;
      }
    });
  }

  /**
   * 获取共享元素的绑定key
   * 由于geometryTransition属性是单例，在修改参数时，需同时修改绑定id
   * @param name
   * @returns
   */
  getGeometryKey(name: string): string {
    return this.mediaTransitionFlag > 0 ? name : `${name}Flag`;
  }

  getSongInfoGeometryKey(name: string, alias: string): string {
    // 进出播控一镜到底动效的key
    if (this.mediaTransitionFlag > 0) {
      if (this.isLandscapeLayout() && (name === 'songBox' || name === 'textPlayBox')) {
        return `${name}Land`;
      }
      return name;
    }
    if (this.isLandscapeLayout() && landscapeLargeAliases.includes(alias)) {
      return alias;
    }
    // 大小图切换文本的key
    if (portraitAliases.includes(alias)) {
      return alias;
    }

    if (this.currentIndex !== 1) {
      return alias;
    }
    return `${name}Flag`;
  }

  /**
   * 获取淡入淡出共享元素的绑定id
   */
  getAnimGeometryId(isNew: boolean, name: string): string {
    return isNew ? `${name}New` : name;
  }

  /**
   * 获取淡入淡出共享元素的绑定key，控制中心进出播控的场景
   */
  getAnimGeometryKey(isNew: boolean, newLyricOpacity: number, oldLyricOpacity: number, name: string,
    scene: string): string {
    if ((isNew && newLyricOpacity === 1) || (!isNew && oldLyricOpacity === 1)) {
      return this.mediaTransitionFlag > 0 ? name : `${name}Flag`;
    } else {
      return `${name}Hide`;
    }
  }
  getProgressOpacity(isNew: boolean, newLyricOpacity: number, oldLyricOpacity: number): number {
    if (this.mediaTransitionDone) {
      return isNew ? this.newLyricOpacity : this.oldLyricOpacity;
    } else if ((isNew && newLyricOpacity === 1) || (!isNew && oldLyricOpacity === 1)) {
      return this.fadeOpacity;
    }
    return 0;
  }

  /**
   * 获取共享元素的绑定参数
   * @param name
   * @returns
   */
  getGeometryOptions(): GeometryOptions | undefined {
    return this.mediaTransitionFlag > 0 ? { hierarchyStrategy: TransitionHierarchyStrategy.NONE } : undefined;
  }

  /**
   * 初始化封面图
   * @returns
   */
  getDefaultTempPic(): image.PixelMap | string {
    let hasCache: boolean = AppStorage.has('tempMediaImage');
    log.showInfo(`getDefaultTempPic hasCache: ${hasCache}`)
    let result: PixelMap | string = hasCache ? AppStorage.get('tempMediaImage') as image.PixelMap : '';
    AppStorage.delete('tempMediaImage')
    return result;
  }

  /**
   * 初始化标题
   * @returns
   */
  getDefaultTempTitle(): string {
    const hasCache: boolean = AppStorage.has('tempMediaTitle');
    const result: string = hasCache ? AppStorage.get('tempMediaTitle') as string : '';
    AppStorage.delete('tempMediaTitle');
    return result;
  }

  /**
   * 初始化副标题
   * @returns
   */
  getDefaultTempSubTitle(): string {
    const hasCache: boolean = AppStorage.has('tempMediaSubTitle');
    const result: string = hasCache ? AppStorage.get('tempMediaSubTitle') as string : '';
    AppStorage.delete('tempMediaSubTitle');
    return result;
  }

  /**
   * 初始化小图尺寸
   * @param cacheKey
   * @param defaultValue
   * @returns
   */
  getDefaultSize(cacheKey: string, defaultValue: number) {
    let result = defaultValue;
    if (this.isPhone && !this.isFoldDevice && !this.isLandscape && AppStorage.get(cacheKey)) {
      result = Number(AppStorage.get(cacheKey)) || result;
    }
    AppStorage.delete(cacheKey);
    return result;
  }

  getOutputDeviceChangedCallback(): LocalEventCallback {
    if (!this.outputDeviceChangedCallback) {
      this.outputDeviceChangedCallback = new LocalEventCallback((eventData : Object) => {
        log.showInfo(`outputDeviceChanged event`);
        this.enableCommandUpdate();
      });
    }
    return this.outputDeviceChangedCallback;
  }

  tempPicChange() {
    this.noPic = !this.tempPic && !this.tempPicNew;
  }

  // 更新字体最大放大倍数
  updateMaxFontScale(): void {
    this.textMaxFontScale = Constants.TEXT_MAX_FONT_SCALE;
    this.progressMaxFontScale = Constants.PROGRESS_MAX_FONT_SCALE;
  }

  mediaTransitionDoneChange() {
    this.goldFlagState();
  }

  async aboutToAppear() {
    this.isVideo = !!this.mediaInfoProvider?.getIsVideo(this.sessionId);
    this.isSinkSession = !!this.mediaInfoProvider?.checkIsSinkSession(this.sessionId);
    // 投播设备监听
    CommunicationUtil.addLocalEventListener('outputDeviceChanged', this.getOutputDeviceChangedCallback());
    this.enableCommandUpdate();
    this.updateMaxFontScale();
    this.registerInputConsumer();
    this.mediaInfoProvider?.getHistoricalAndRecommendData();
    if(!this.isExistAvQueueInfo || this.getMusicAuthorBoolean()) {
      this.currentIndex = 1;
    }
    this.listDataChanged();
    this.imageSize = this.getImageSize(this.imageRatioMap[this.sessionId]);
    if (this.isLandscapeLayout()) {
      this.imageSizeUpdate(this.imageSize);
      this.newImageSizeUpdate(this.imageSize);
    }
    if (this.isShowDev || (this.getMusicAuthorBoolean() && this.currentIndex === 0)) {
      this.landSmallImageBlankWidth = Constants.COMMON_PICTURE_SIZE_LARGE + 8;
    } else {
      this.landSmallImageBlankWidth = 0;
    }
  }


  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.clearTimerAndProgressData(true);
    CommunicationUtil.removeLocalEventListener('outputDeviceChanged', this.getOutputDeviceChangedCallback());
    // 移除物理音量键监听
    this.mediaInfoProvider?.releaseInputMediaVolumeCallback();
    // 转移到ListDialog销毁
    this.mediaInfoProvider = undefined;
    this.preOrNextOperateTimeStamp = null;
    if (this.monitorVolumeTimerId) {
      clearTimeout(this.monitorVolumeTimerId);
      this.monitorVolumeTimerId = undefined;
    }
    this.showPlayLoading = false;
    this.clearLoadingTimer();
  }


  /**
   * 输出设备变化
   */
  outputDevChanged() {
    const isInCast = this.curOutputDev.deviceSource === DeviceSource.CAST;
    if (this.isInCast !== isInCast) {
      this.isInCast = isInCast;
    }
  }

  /**
   * 注册音量键
   */
  private registerInputConsumer(): void {
    if (this.mediaInfoProvider) {
      // 注册回调事件，父组件监听后调用该方法
      this.mediaInfoProvider.inputMediaVolumeCallback = this.callbackInputConsumer;
    }
  }

  /**
   * 物理音量键回调
   */
  callbackInputConsumer = (callback: inputConsumer.KeyOptions) => {
    log.showInfo(`callbackInputConsumer ${callback.finalKey}`)
    if (callback.finalKey !== KeyCode.KEYCODE_VOLUME_UP &&
      callback.finalKey !== KeyCode.KEYCODE_VOLUME_DOWN) {
      return;
    }
    AppStorage.setOrCreate('soundLongPress', true);
    if (this.enableDc) {
      this.dcController?.setAppStorage('soundLongPress', true);
    }
    const actionType = callback.finalKey === KeyCode.KEYCODE_VOLUME_UP ?
      InputVolumeAction.PLUS : InputVolumeAction.MINUS;

    this.mediaInfoProvider?.callVolumeInput(SetVolumeType.AUDIO, actionType, this.sessionId);
    this.setVolumeTimer();
  }

  /**
   * 设置音量计时器
   */
  setVolumeTimer() {
    this.monitorVolumeTimerId = setTimeout(() => {
      AppStorage.delete('soundLongPress');
      if (this.enableDc) {
        this.dcController?.setAppStorage('soundLongPress', undefined);
      }
      clearTimeout(this.monitorVolumeTimerId);
      this.monitorVolumeTimerId = undefined;
    }, 300)
  }

  /**
   * 接收到listDialog组件中最外层build完成渲染的通知触发监听获取大图的大小和定位，传到historicalListCard组件
   */
  updateBigImageInfo() {

  }

  clickItemAnimationStart() {
    if (this.noPic) {
      if (this.opacityBigImage === 0) {
        this.tempPic = ImageDownloaderUtils.mediaImage;
        this.bigIconPic = this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '';
        this.scaleSizeXNew = 0.5;
        this.scaleSizeYNew = 0.5;
        this.opacityBigImageNew = 0;
        this.scaleSizeX = 1.0;
        this.scaleSizeY = 1.0;
        this.opacityBigImage = 1.0;
      } else {
        this.tempPicNew = ImageDownloaderUtils.mediaImage;
        this.bigIconPicNew = this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '';
        this.scaleSizeXNew = 1.0;
        this.scaleSizeYNew = 1.0;
        this.opacityBigImageNew = 1.0;
        this.scaleSizeX = 0.5;
        this.scaleSizeY = 0.5;
        this.opacityBigImage = 0;
      }
      this.isItemAnimationStart = false;
      this.finishAnimate = true;
      AppStorage.setOrCreate('finishAnimate', this.finishAnimate);
      return;
    }

    if (this.isItemAnimationStart) {
      if (this.opacityBigImage === 0) {
        this.isUpdateImageSize = true;
        this.isUpdateSmallImageSize = true;
        this.tempPic = ImageDownloaderUtils.mediaImage
        this.bigIconPic = this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '';
        log.showInfo(`clickDataUpdate,opacityBigImage===0`)
      } else {
        this.isUpdateNewImageSize = true;
        this.isUpdateSmallImageSize = true;
        this.tempPicNew = ImageDownloaderUtils.mediaImage
        this.bigIconPicNew = this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '';
        log.showInfo(`clickDataUpdate,opacityBigImage===1`)
      }
      if (this.opacityBigImage === 0) {
        this.uiContext.animateTo({
          curve: Curves.interpolatingSpring(0, 1, 228, 25),
        }, () => {
          this.scaleSizeXNew = 0.5;
          this.scaleSizeYNew = 0.5;
        });
        this.uiContext.animateTo({
          curve: Curve.Sharp,
          duration: 150
        }, () => {
          this.opacityBigImageNew = 0;
        });
        this.uiContext.animateTo({
          curve: Curves.interpolatingSpring(0, 1, 228, 25),
          delay: 50,
          onFinish: () => {
            this.isItemAnimationStart = false;
            this.finishAnimate = true;
            AppStorage.setOrCreate('finishAnimate', this.finishAnimate);
            log.showInfo(`clickItemAnimationStart ,end`);
          }
        }, () => {
          this.scaleSizeX = 1.0;
          this.scaleSizeY = 1.0;
        });

        this.uiContext.animateTo({
          curve: Curve.Sharp,
          duration: 150,
          delay: 50,
        }, () => {
          this.opacityBigImage = 1.0;
        });

      } else {
        this.uiContext.animateTo({
          curve: Curves.interpolatingSpring(0, 1, 228, 25),
        }, () => {
          this.scaleSizeX = 0.5;
          this.scaleSizeY = 0.5;
        });

        this.uiContext.animateTo({
          curve: Curve.Sharp,
          duration: 150
        }, () => {
          this.opacityBigImage = 0;
        });

        this.uiContext.animateTo({
          curve: Curves.interpolatingSpring(0, 1, 228, 25),
          delay: 50,
          onFinish: () => {
            this.isItemAnimationStart = false;
            this.finishAnimate = true;
            AppStorage.setOrCreate('finishAnimate', this.finishAnimate);
            log.showInfo(`clickItemAnimationStart ,end`);
          }
        }, () => {
          this.scaleSizeXNew = 1.0;
          this.scaleSizeYNew = 1.0;
        });

        this.uiContext.animateTo({
          curve: Curve.Sharp,
          duration: 150,
          delay: 50,
        }, () => {
          this.opacityBigImageNew = 1.0;
        });
      }
    }
  }

  /**
   * 歌词/副标题文字淡入淡出
   */
  isTextOpacityFunction() {
    // 执行动画逻辑处理
    // 通过透明度交替替换新旧值
    log.showInfo(`isTextOpacityFunction isClickToggle: ${this.isClickToggle} isTextOpacity: ${this.isTextOpacity}`);
    if (this.isTextOpacity) {
      this.getTextTry()
      this.getMusicAuthorTry()
      this.ProgressStartTimeChange()
      this.uiContext.animateTo({
        duration: this.noTitle ? 0 : 150,
        curve: Curve.Sharp,
        onFinish: () => {
          // 动画完成之后，所有值初始化
          this.newGetText = this.getText()
          this.oldGetText = this.getText()
          this.newLyric = this.getMusicAuthorTwo()
          this.oldLyric = this.getMusicAuthorTwo()
          this.newMusicAuthorTwo = this.getMusicAuthorTwo()
          this.oldMusicAuthorTwo = this.getMusicAuthorTwo()
          this.oldProgressStartTime = this.getProgressStart() || '--:--';
          this.oldProgressEndTime = this.getProgressEnd() || '--:--';
          this.newProgressStartTime = this.getProgressStart() || '--:--';
          this.newProgressEndTime = this.getProgressEnd() || '--:--';
          AppStorage.setOrCreate('isTextOpacity', false);
          AppStorage.setOrCreate('clickAlbum', false);
          this.noTitle = false;
        }
      }, () => {
        if (this.newLyricOpacity == 0) {
          this.newLyricOpacity = 1
          this.oldLyricOpacity = 0
        } else {
          this.newLyricOpacity = 0
          this.oldLyricOpacity = 1
        }
      })
    }

    //不执行动画时逻辑处理
    if (this.isClickToggle) {
      // 此方法只调用一次
      this.isClickToggle = false;
      //获取专辑和副标题名称
      this.getTextTry()
      this.getMusicAuthorTry()
      this.ProgressStartTimeChange()
      setTimeout(() => {
        // 因avsession前两条数据返回的是老数据，获取到新数据的时间不等，所以做延迟获取数据处理
        const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
        this.newGetText = this.getText();
        this.oldGetText = this.getText();
        if (metadata?.lyric) {
          let curLyric = this.getEachLyric();
          this.newLyric = curLyric;
          this.oldLyric = curLyric;
          return;
        }
        this.newLyric = this.getMusicAuthorTwo();
        this.oldLyric = this.getMusicAuthorTwo();
        this.newMusicAuthorTwo = this.getMusicAuthorTwo();
        this.oldMusicAuthorTwo = this.getMusicAuthorTwo();
        this.oldProgressStartTime = this.getProgressStart() || '--:--';
        this.oldProgressEndTime = this.getProgressEnd() || '--:--';
        this.newProgressStartTime = this.getProgressStart() || '--:--';
        this.newProgressEndTime = this.getProgressEnd() || '--:--';
        this.noTitle = false;
      }, 100);
    }
  }

  /**
   * 是否折叠屏
   */
  isFoldable() {
    return this.isFoldDevice;
  }

  /**
   * 获取可折叠设备的当前折叠状态
   */
  getFoldStatus(): boolean {
    try {
      const foldStatus = display.getFoldStatus();
      return foldStatus == 2;
    } catch (error) {
      return false
    }
  }

  /**
   * 适配折叠屏状态判断，true为横屏，false为竖屏，默认false
   * @returns
   */
  isLandscapeLayout(): boolean {
    // 折叠状态的折叠屏
    if (this.isFoldable()) {
      return this.getFoldStatus() && this.isLandscape;
    } else if (this.isPhone) {
      return this.isLandscape;
    }
    return false;
  }

  // Tips 计算逻辑中windowWidth 临时改为 Constants.PANEL_LANDSCAPE_WIDTH
  /**
   * 折叠屏样式
   * @returns
   */
  getFoldStyle() {
    let foldHeight: foldHeightCard = {width: 0, height : 0}
    foldHeight.textAlign = TextAlign.Center;
    foldHeight.align = Alignment.Center;
    foldHeight.horizontalWidth = 0;
    foldHeight.marginTop = 0;
    foldHeight.justifyContent = FlexAlign.Center;
    if (!this.getFoldStatus()) {
      foldHeight.width = (this.duration >= 3600 * 1000 ? 52 : 36);
      foldHeight.height = this.isLandscape ?
        Constants.PANEL_LANDSCAPE_WIDTH - Constants.EXPAND_HORIZONTAL_POSITION -
        Constants.PLAYBACK_BTNS_HEIGHT - Constants.PLAYBACK_BTNS_HEIGHT :
        Constants.PANEL_LANDSCAPE_WIDTH - Constants.EXPAND_VERTICAL_POSITION - 30 - Constants.PLAYBACK_BTNS_HEIGHT;
      foldHeight.textAlign = (!this.isShowDev) ? TextAlign.Center : TextAlign.Start;
      foldHeight.align = (!this.isShowDev) ? Alignment.Center : Alignment.Start;
      foldHeight.justifyContent = (!this.isShowDev) ? FlexAlign.Center : FlexAlign.Start;
    } else {
      if (this.isLandscapeLayout()) {
        //78-78-191-12-24-24
        foldHeight.horizontalWidth = Constants.PANEL_LANDSCAPE_WIDTH -
          (Constants.EXPAND_HORIZONTAL_PADDINGLEFTRIGHT * 2) -
          Constants.EXPAND_HORIZONTAL_IMAGESIZE - (Constants.CARD_EDGE_HALF_PADDING * 5);
        foldHeight.marginTop = 12;
      }
      foldHeight.width = this.duration >= 3600 * 1000 ? 52 : 36;
      foldHeight.height = Constants.PANEL_LANDSCAPE_WIDTH - 96;
      foldHeight.textAlign = !this.isShowDev && !this.isLandscapeLayout() ? TextAlign.Center : TextAlign.Start;
      foldHeight.align = !this.isShowDev && !this.isLandscapeLayout() ? Alignment.Center : Alignment.Start;
      foldHeight.justifyContent = !this.isShowDev && !this.isLandscapeLayout() ? FlexAlign.Center : FlexAlign.Start;
    }
    return foldHeight;
  }

  /**
   * 是否为sink的session
   */
  checkSinkSession() {
    log.showInfo(`checkSinkSession `);
    if (this.isSinkSession) {
      log.showInfo(`sink cast session, show default enableCommands`);
      this.isShowPlay = true;
      this.isShowPause = true;
      this.isShowPlayPrevious = true;
      this.isShowPlayNext = true;
      return;
    }
  }

  /**
   * 是否为横屏
   */
  landscapeChanged() {
    log.showInfo(`landscapeChanged in this.isPlaying=${this.isPlaying}`);
    AppStorage.setOrCreate('isRefreshData', true);
  }

  /**
   * session更新回调
   */
  sessionUpdate() {
    this.imageSize = this.getImageSize(this.imageRatioMap[this.sessionId]);
    log.showInfo(`sessionUpdate in: ${this.index}, ${this.curForceMedia}, ${this.sessionId?.length < 10 ? '' :
      (this.sessionId?.substr(0, 5) + '**' + this.sessionId?.substr(this.sessionId?.length - 5))}`)
    if (this.mediaInfoProvider && this.index === this.curForceMedia && (this.sessionId || this.isPC)) {
      this.mediaInfoProvider.refreshVolume(this.sessionId);
    }
    this.isSinkSession = !!this.mediaInfoProvider?.checkIsSinkSession(this.sessionId);
  }

  /**
   * 是否有歌词
   * @returns
   */
  isLyric() {
    return !!(this.metaDataMap[this.sessionId]?.lyric);
  }

  playStateChange() {
    this.playPauseTriggerValue++;
  }

  favorStateChange() {
    this.favorTriggerValue++;
  }

  loopModeStateChange() {
    this.loopModeTriggerValue++;
  }

  /**
   * 标题与宽度设置
   */
  getTextTry(): void {
    if (this.oldGetText.length == 0 && this.newGetText.length == 0) {
      this.oldGetText = this.getText();
    } else if (this.oldGetText.length != 0 && this.newGetText.length == 0) {
      this.newGetText = this.getText();
    } else if (this.oldGetText.length != 0 && this.newGetText.length != 0) {
      if (this.oldLyricOpacity == 0) {
        this.oldGetText = this.getText();
      } else {
        this.newGetText = this.getText();
      }
    }
  }

  /**
   * 标题
   * @returns
   */
  getText(): string {
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    return metadata?.title || '';
  }

  /**
   * 标题
   */
  getTitleText(isNew?: boolean): string {
    if (this.tempTitle && !this.mediaTransitionDone) {
      return this.tempTitle;
    } else if (this.isLandscapeLayout()) {
      return this.getText();
    } else if (this.isClickAlbum) {
      return isNew ? this.newGetText : this.oldGetText;
    } else if (isNew) {
      return this.getText() || this.newGetText;
    } else {
      return this.getText() || this.oldGetText;
    }
  }

  /**
   * 副标题
   */
  getSubtitleText(isNew?: boolean): string {
    if (this.tempSubTitle && !this.mediaTransitionDone) {
      return this.tempSubTitle;
    } else if (this.isLandscapeLayout()) {
      return (this.isLyric() && this.newLyric) ? this.newLyric : this.getMusicAuthorTwo();
    } else if (this.isClickAlbum) {
      return isNew ? (this.newMusicAuthorTwo || this.newLyric) : (this.oldMusicAuthorTwo || this.oldLyric);
    } else if (this.isLyric()) {
      return this.oldLyric || this.getMusicAuthorTwo();
    } else {
      return (isNew ? this.newMusicAuthorTwo : this.oldMusicAuthorTwo) || this.getMusicAuthorTwo();
    }
  }

  /**
   * 获取副标题
   * @returns
   */
  getMusicAuthor(): Resource | string {
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    if (metadata && metadata.title && metadata.artist && !this.isVideo) {
      return metadata.artist as string;
    } else if (metadata && metadata.title && this.isVideo) {
      return (metadata.subtitle ? metadata.subtitle : metadata.artist) as string;
    } else if (this.appNameMap && this.appNameMap[this.sessionId]) {
      return this.appNameMap[this.sessionId] as string;
    } else {
      return $r('app.string.no_media_title');
    }
  }

  /**
   * 第一次进来时判断下次的歌手名是否为空，为空则获取当前的且本次的不进行获取
   */
  getMusicAuthorTry() {
    if (this.oldMusicAuthorTwo.length == 0 && this.newMusicAuthorTwo.length == 0) {
      this.oldMusicAuthorTwo = this.getMusicAuthorTwo()
    } else if (this.oldMusicAuthorTwo.length != 0 && this.newMusicAuthorTwo.length == 0) {
      this.newMusicAuthorTwo = this.getMusicAuthorTwo()
    } else if (this.oldMusicAuthorTwo.length != 0 && this.newMusicAuthorTwo.length != 0) {
      if (this.oldLyricOpacity == 0) {
        this.oldMusicAuthorTwo = this.getMusicAuthorTwo()
      } else {
        this.newMusicAuthorTwo = this.getMusicAuthorTwo()
      }
    }
  }

  /**
   * 歌手名，副标题
   * @returns
   */
  getMusicAuthorTwo(): string {
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    log.showInfo(`getMusicAuthorTwo with param : ${metadata?.artist}, ${metadata?.subtitle}, ${this.isVideo}`);
    this.isCanPlay = !!(metadata?.title || metadata?.artist || metadata?.mediaImage);
    let musicAuthor: string = this.isVideo ? (metadata?.subtitle || metadata?.artist || '') :
      (metadata?.artist || metadata?.subtitle || '');
    if (!musicAuthor && this.appNameMap && this.appNameMap[this.sessionId]) {
      musicAuthor = this.appNameMap[this.sessionId] as string
    }
    return musicAuthor;
  }

  /**
   * 是否显示副标题
   * @returns
   */
  getMusicAuthorBoolean(): boolean {
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    return !!metadata?.title || !!this.tempTitle;
  }

  /**
   * 无障碍朗读循环模式
   * @returns
   */
  accessLoopMode(): string {
    switch (this.loopMode) {
      case AVSessionManager.LoopMode.LOOP_MODE_SINGLE:
        // 1-单曲
        return ResUtils.getInnerString($r('app.string.access_cyclic_mode_loop'))
      case AVSessionManager.LoopMode.LOOP_MODE_LIST:
        // 2-列表
        return ResUtils.getInnerString($r('app.string.access_cyclic_mode_list'))
      case AVSessionManager.LoopMode.LOOP_MODE_SHUFFLE:
        // 3-随机
        return ResUtils.getInnerString($r('app.string.access_cyclic_mode_shuffle'))
      default:
      // 0-顺序
        return ResUtils.getInnerString($r('app.string.access_cyclic_mode_sequential'))
    }
  }
  /**
   * 金标显示动画
   */
  goldFlagState() {
    if (this.goldFlagOpacity == 0) {
      this.goldFlagLeft = -70;
      this.goldFlagScale = 0.5;
      this.goldFlagOpacity = 0;
      // 金标动画
      this.uiContext.animateTo({ delay: 200, curve: Curves.springCurve(16, 1, 100, 20) }, () => {
        this.animateShowGoldFlag = this.isShowGoldFlag
        this.goldFlagScale = 1;
      });
      this.uiContext.animateTo({ duration: 250, delay: 200, curve: Curve.EaseIn }, () => {
        this.goldFlagOpacity = 1;
      });
      this.uiContext.animateTo({ duration: 1000, delay: 550, curve: Curve.Ease }, () => {
        this.goldFlagLeft = 70;
      });
    }

  }

  /**
   * 可用操作变更
   */
  async enableCommandUpdate() {
    log.debug(`enableCommandUpdate in`);
    if (this.commandEnableMap == undefined) {
      log.showInfo(`enableCommandUpdate: commandEnableMap undefined return`);
      return;
    }
    let commandEnableArray: Array<AVSessionManager.AVControlCommandType> | undefined =
      this.commandEnableMap[this.sessionId];
    let commandEnableMap: Map<string, boolean> = new Map();
    log.showInfo(`meta data update commandEnableMap: + ${JSON.stringify(commandEnableArray)} | ${this.isCanPlay}`);
    // 置灰
    if (commandEnableArray !== undefined) {
      commandEnableArray.forEach(command => {
        commandEnableMap[command] = true
      });
      if (this.isCanPlay) {
        this.isShowFavor = !!(commandEnableMap['toggleFavorite']);
        this.isShowPlay = !!(commandEnableMap['play']);
        this.isShowPause = !!(commandEnableMap['pause']);
        this.isShowPlayNext = !!(commandEnableMap['playNext']);
        this.isShowPlayPrevious = !!(commandEnableMap['playPrevious']);
        this.isShowRewind = !!(commandEnableMap['rewind']) && (this.duration > 0 || !this.isInCast);
        this.isShowFastforward = !!(commandEnableMap['fastForward']) && (this.duration > 0 || !this.isInCast);
        this.isShowSeek = !!(commandEnableMap['seek']);
        this.isShowLoopMode = !!(commandEnableMap['setLoopMode']);
        this.getLoopMode();
      } else {
        // 三方
        log.showInfo(`isCanPlay nothing: 三方`)
        this.isShowPlay = false;
        this.isShowPause = false;
      }
    } else {
      this.initCommandEnable();
    }
  }

  initCommandEnable() {
    this.isPlaying = false;
    this.isShowPlay = this.canColdStart;
    this.isShowPause = this.canColdStart;
    this.loopMode = AVSessionManager.LoopMode.LOOP_MODE_SEQUENCE;
    this.isShowFavor = false;
    this.isShowPlayNext = false;
    this.isShowPlayPrevious = false;
    this.isShowRewind = false;
    this.isShowFastforward = false;
    this.isShowSeek = true;
    this.isShowLoopMode = false; //循环模式
  }

  initMetaData() {
    this.tempPic = '';
    this.tempPicNew = '';
    this.duration = 0;
    this.tempTitle = '';
    this.bigIconPic = this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '';
    this.bigIconPicNew = this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '';
  }

  /**
   * 媒体信息变更
   */
  async metaDataUpdate() {
    let metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    this.isCanPlay = !!(metadata?.title || metadata?.artist || metadata?.mediaImage);
    log.showInfo(`meta data update : ${JSON.stringify(metadata)}, ${this.sessionId?.length < 10 ? '' :
      (this.sessionId?.substr(0, 5) + '**' + this.sessionId?.substr(this.sessionId?.length - 5))}`);
    if (!metadata) {
      this.initMetaData();
    }
    if (metadata != undefined && metadata?.duration != undefined && metadata?.duration >= 0) {
      // 音频总时长，当总时长大于24:00:00，显示24:00:00
      let duration = Math.floor(metadata?.duration);
      if (duration > 24 * 60 * 60 * 1000) {
        duration = 24 * 60 * 60 * 1000;
      }
      this.duration = duration;
      this.setProgreeUpDateTime(this.duration);
    } else {
      this.initSliderChange();
    }
    log.debug(`meta data update checkduration: ${this.duration}`);
    this.isSinkSession = !!this.mediaInfoProvider?.checkIsSinkSession(this.sessionId);
    this.isShowGoldFlag = !!metadata && !!metadata?.displayTags && metadata?.displayTags != 0;
    this.animateShowGoldFlag = this.isShowGoldFlag;
    this.loadMusicLyricList()
    if (this.isLyric()) {
      let curLyric = this.getEachLyric();
      if (this.oldLyric.length == 0) {
        this.oldLyric = curLyric;
      }
      this.newLyric = curLyric;
    }
    let musicAuthor: string = this.isVideo ? (metadata?.subtitle || metadata?.artist || '') :
      (metadata?.artist || metadata?.subtitle || '');
    if (!!metadata && !!metadata?.assetId) {
      if (this.oldAssetId.get() === metadata?.assetId && this.oldTitle.get() === metadata?.title && 
        this.oldSubTitle.get() === musicAuthor) {
        this.animateShowGoldFlag = this.isShowGoldFlag
        this.goldFlagScale = 1;
        this.goldFlagOpacity = 1;
      } else {
        // 历史歌单被点击时isFirstDataLength是false不会进入下面判断，会进入专辑和歌手名淡入淡出的动画逻辑判断
        if (this.isFirstDataLength) {
          this.isClickToggle = true;
        }
        log.debug(`metaDataUpdate isClickToggle:${this.isClickToggle}`);
        this.oldAssetId.set(metadata?.assetId);
        this.oldTitle.set(metadata?.title);
        this.oldSubTitle.set(musicAuthor);
        this.goldFlagOpacity = 0;
        this.goldFlagScale = 0.5;
        this.goldFlagState();
      }
    }
    if (!!metadata?.title && !this.isClickAlbum) {
      if (this.newGetText === '') {
        this.newGetText = metadata?.title;
      }
      if (this.oldGetText === '') {
        this.oldGetText = metadata?.title;
      }
    }
    if (!this.isClickAlbum && (metadata?.subtitle || metadata?.artist)) {
      let musicAuthor: string = this.isVideo ? (metadata?.subtitle || metadata?.artist || '') :
        (metadata?.artist || metadata?.subtitle || '');
      if (!musicAuthor && this.appNameMap && this.appNameMap[this.sessionId]) {
        musicAuthor = this.appNameMap[this.sessionId] as string
      }
      if (this.newMusicAuthorTwo === '') {
        this.newMusicAuthorTwo = musicAuthor;
      }
      if (this.oldMusicAuthorTwo === '') {
        this.oldMusicAuthorTwo = musicAuthor;
      }
    }
    this.isCanLoaded = true; //图片是否能加载
    log.showInfo(`metaDataUpdate isRefreshData: ${JSON.stringify(AppStorage.get<boolean>('isRefreshData'))}`);
    if (this.isRefreshMediaImage(metadata?.mediaImage)) {
      this.isUpdateImageSize = true;
      this.isUpdateNewImageSize = true;
      this.isUpdateSmallImageSize = true;
      this.tempPic = this.metaDataMap[this.sessionId]?.mediaImage;
      this.tempPicNew = this.metaDataMap[this.sessionId]?.mediaImage;
      this.bigIconPic = this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '';
      this.bigIconPicNew = this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '';
      log.showInfo(`metaDataUpdate isRefreshData done`);
    } else {
      log.showInfo(`metaDataUpdate isRefreshData: other`);
    }
  }

  isRefreshMediaImage(mediaImage: image.PixelMap | string | undefined) {
    return mediaImage !== undefined && (this.isLandscapeLayout() || AppStorage.get<boolean>('isRefreshData'));
  }

  /**
   * 重置进度条相关变量
   */
  initSliderChange() {
    this.progressHeight = 4;
    this.isSliderChange = false;
    this.progressTextColor = $r('app.color.media_control_text_secondary');
    this.progressTextBrightness = true;
    this.isOperateProgress = false;
  }

  /**
   * 设置进度条定时器更新时间
   * 绘制进度条更新时间，分30分钟以上，30分钟内，1分钟以内 300 100 50
   * 1209 为了进度条平滑刷新间隔改这么小，是否不太合理，日志刷屏问题也应该尝试解决
   * @param duration
   */
  setProgreeUpDateTime(duration: number) {
    let supProtocols: number | undefined = AppStorage.get<LocalDeviceInfo>('CurDeviceSelect')?.supportedProtocols;
    if (duration <= 1000 * 1800) {
      if (duration <= 1000 * 60) {
        this.operateMinInterval = 50;
      } else {
        this.operateMinInterval = 100;
      }
    } else {
      this.operateMinInterval = 300;
      }
    if (!this.isClickAlbum) {
      if (this.isProgressTimeNull(this.oldProgressStartTime)) {
        this.oldProgressStartTime = this.getProgressStart();
      }
      if (this.isProgressTimeNull(this.newProgressStartTime)) {
        this.newProgressStartTime = this.getProgressStart();
      }
      if (this.isProgressTimeNull(this.oldProgressEndTime)) {
        this.oldProgressEndTime = this.getProgressEnd();
      }
      if (this.isProgressTimeNull(this.newProgressEndTime)) {
        this.newProgressEndTime = this.getProgressEnd();
      }
    }
  }
  isProgressTimeNull(time: string): boolean {
    if (time === '' || time === '--:--' || time === '00:00') {
      return true;
    } else {
      return false;
    }
  }

  /**
   * 播放状态变更
   */
  playStateUpdate() {
    log.showInfo(`play State update: ${this.isPlaying}, ${this.isFavorite}, ${this.loopMode}`);
    let playbackStateTemp: AVSessionManager.AVPlaybackState = this.playStateMap[this.sessionId];
    if (playbackStateTemp == undefined) {
      log.showInfo(`no playbackstate return`);
      return;
    }
    log.debug(`playbackStateTemp when update: ${JSON.stringify(playbackStateTemp)}`);
    if ((playbackStateTemp.loopMode || playbackStateTemp.loopMode === 0) && this.loopMode !=
      playbackStateTemp.loopMode) {
      this.loopMode = playbackStateTemp.loopMode;
      this.isLoopModeStateChange = this.loopMode;
      this.getLoopMode();
    }
    if (playbackStateTemp && playbackStateTemp.extras && playbackStateTemp.extras.duration !== undefined ) {
      if (playbackStateTemp.extras.duration > 0) {
        this.duration = playbackStateTemp.extras.duration as number
        log.debug(`playbackStateTemp when update this.duration :  ${this.duration}`);
      }
    }
    this.speed = playbackStateTemp.speed || 1;
    if (this.isLyric()) {
      let curLyric = this.getEachLyric();
      this.newLyric = curLyric;
      this.oldLyric = curLyric;
    }
    if (playbackStateTemp?.state !== undefined &&
      playbackStateTemp?.state !== AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
      this.lastPlayState = playbackStateTemp?.state;
    }
    if (playbackStateTemp?.state !== undefined) {
      let isPlaying = !!CommonUtils.isPlaying(playbackStateTemp?.state, this.lastPlayState,
        this.curOutputDev.deviceSource === DeviceSource.CAST);
      if (this.isPlaying !== isPlaying) {
        this.isPlaying = isPlaying;
        this.showPlayLoading = false;
        this.clearLoadingTimer();
      }
    }
    if (playbackStateTemp?.isFavorite !== undefined) {
      let isFavor = !!playbackStateTemp?.isFavorite;
      if (this.isFavorite !== isFavor) {
        this.isFavorite = isFavor;
      }
    }
    if (!this.isOperateProgress) {
      let position: AVSessionManager.PlaybackPosition | undefined = playbackStateTemp.position;
      log.showInfo(`play State update position ${position?.elapsedTime}, ${this.duration}`);
      if (position !== undefined) {
        this.setPosition(position, playbackStateTemp);
      } else if (playbackStateTemp?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY &&
        this.curOutputDev.deviceSource !== DeviceSource.CAST) {
        log.showInfo(`playing AND no position: ${this.movePosition}`);
        this.startInterval();
      } else if (playbackStateTemp?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
        log.showInfo(`buffer AND no position: ${this.movePosition}`);
        this.clearTimerAndProgressData(false);
      } else {
        log.showInfo(`play State update get no position `);
      }
    }
  }

  setPosition(position: AVSessionManager.PlaybackPosition, playbackStateTemp?: AVSessionManager.AVPlaybackState) {
    //处理初始化异常，投播等
    if (position?.updateTime < 1) {
      position.updateTime = new Date().getTime();
    }
    this.playbackPositionMap[this.sessionId] = position;
    const hasPosition: boolean = this.timerId == undefined ||
      (this.moveFlag > 0 && this.moveFlag < this.moveFlagStep * this.speed);
    if (!hasPosition) {
      return;
    }
    this.shortTimeUpdateCount++;
    log.debug(`MediaControllerSlider on shortTimeUpdateCount add: ${this.shortTimeUpdateCount}`);
    if (this.isPlaying) {
      const canSetPosition: boolean = (this.playbackPositionMap[this.sessionId]?.elapsedTime ||
        this.playbackPositionMap[this.sessionId]?.elapsedTime === 0) && this.timerId == undefined;
      if (!canSetPosition) {
        return;
      }
      if (playbackStateTemp?.state === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
        // buffer状态更新position且不走进度条
        this.clearTimerAndProgressData(false);
        log.showInfo(`buffer AND update position: ${this.playbackPositionMap[this.sessionId]?.elapsedTime}`);
        this.movePosition = this.playbackPositionMap[this.sessionId]?.elapsedTime;
        if (position?.elapsedTime >= this.duration) {
          this.movePosition = this.duration;
        }
      } else {
        log.showInfo(`play AND update position: ${this.playbackPositionMap[this.sessionId]?.elapsedTime}`);
        this.startInterval();
      }
    } else {
      log.showInfo(`Resolve issues beyond the audition scope. ${this.playbackPositionMap[this.sessionId]?.elapsedTime}`);
      this.movePosition = position?.elapsedTime;
      if (position?.elapsedTime >= this.duration) {
        this.movePosition = this.duration;
      }
      this.clearTimerAndProgressData(false);
    }
  }

  /**
   * 进度条计时器
   */
  startInterval(): void {
    log.debug('startInterval in');
    if (this.timerId != undefined) {
      log.showInfo('start clearInterval')
      clearInterval(this.timerId);
      this.timerId = undefined;
    }
    if (!this.sessionId) {
      log.showInfo('no session no intervals');
      return;
    }
    this.getMovePosition();
    log.showInfo(`startInterval setInterval : ${this.timerId}`);
    this.timerId = setInterval(() => {
      this.getMovePosition();
    }, this.operateMinInterval / (this.speed ? this.speed : 1));
    log.showInfo(`startInterval setInterval out: ${this.timerId}, ${this.operateMinInterval}, ${this.speed}`);
  }

  /**
   * 进度条左侧时间计算
   */
  getMovePosition() {
    log.showDebug(`get in interval : ${this.movePosition},${this.moveFlag}`);
    if (this.playStateMap[this.sessionId] == undefined) {
      log.showInfo(`setInterval with no state`);
      return;
    }
    let currentTime = new Date().getTime();
    if (!this.playbackPositionMap[this.sessionId]) {
      this.playbackPositionMap[this.sessionId] = {elapsedTime: 0, updateTime: 0};
    }
    if (!this.isPlaying || (this.playbackPositionMap[this.sessionId].updateTime == 0)) {
      currentTime = this.playbackPositionMap[this.sessionId].updateTime;
    } else {
      log.showInfo(`timed refresh this movePosition to: ${this.movePosition}`);
    }
    let newPosition : number = (currentTime - this.playbackPositionMap[this.sessionId].updateTime) * this.speed +
    this.playbackPositionMap[this.sessionId].elapsedTime
    if (newPosition >= this.duration && this.duration > 0) {
      this.movePosition = this.duration;
    } else if (newPosition >= this.duration) {
      this.movePosition = 0;
    } else {
      if (this.moveStartCachePosition.length > 0) {
        log.showInfo(`clear moveStartCachePosition for timeout ${newPosition}`);
        this.moveStartCachePosition = [];
      }
      this.movePosition = newPosition;
      log.showDebug(`this movePosition check to : ${this.movePosition}`);
    }
  }

  /**
   * 进度条左侧时间显示
   */
  getProgressStart(): string {
    if (!this.duration || this.duration < 0 ) {
      return '--:--';
    }
    log.showInfo(`refresh move position in change getProgressStart position: ${this.movePosition}`);
    let overOneTime = 3600000;
    if (this.duration >= overOneTime && this.movePosition <= 0) {
      this.oldProgressStartTime = '00:00:00';
      this.newProgressStartTime = '00:00:00';
      return '00:00:00';
    } else if (this.movePosition <= 0) {
      this.oldProgressStartTime = '00:00';
      this.newProgressStartTime = '00:00';
      return '00:00';
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
    if (result !== '00:00') { //淡入淡出变量更新
      this.oldProgressStartTime = result;
      this.newProgressStartTime = result;
      if (this.isProgressTimeNull(this.oldProgressEndTime)) {
        this.oldProgressEndTime = this.getProgressEnd();
        log.debug(`oldProgressEndTime: ${this.oldProgressEndTime}`);
      }
      if (this.isProgressTimeNull(this.newProgressEndTime)) {
        this.newProgressEndTime = this.getProgressEnd();
        log.debug(`newProgressEndTime: ${this.newProgressEndTime}`);
      }
    }
    return result;
  }

  /**
   * 进度条右侧时间显示
   */
  getProgressEnd(): string {
    if (!this.duration || this.duration < 0) {
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

  /**
   * 歌词部分
   */
  loadMusicLyricList() {
    let metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    if (!metadata || !metadata.lyric || !metadata.lyric.startsWith('[')) {
      log.showInfo(`lyric error: ${metadata?.lyric}`);
      this.lyricCache = '';
      this.dataArray = [];
      return
    } else if (this.lyricCache === metadata?.lyric) {
      log.showInfo(`lyric same`);
      return;
    }
    this.lyricCache = metadata?.lyric || '';
    this.dataArray = [];
    let newReg: RegExp = new RegExp('[\r\n]+')
    this.lyricList = metadata?.lyric?.split(newReg) //得到字符串分割的数组
    this.dataArray = CommonUtils.analyzeLyric(this.lyricList);
  }

  /**
   * 获取歌词
   * @returns
   */
  getMusicLyric() {
    let metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    try {
      let curLyric = this.getEachLyric();
      if (this.newLyric != curLyric) {
        this.newLyric = curLyric;
        this.oldLyric = curLyric;
      }
    } catch {
      log.showInfo(`metadata?.duration =${metadata?.duration} | this.movePosition =${this.movePosition}`);
    }
    return this.newLyric
  }

  /**
   * 获取每一句歌词
   * @returns
   */
  getEachLyric() {
    // 循环比对歌词，比对不成功就跳出循环，显示最后比对成功的值，最后一句比对下标，如果比对成功一直显示最后一句
    let oldLyric: string = '';
    if (!this.dataArray || this.dataArray.length === 0) {
      return oldLyric;
    }
    if (this.dataArray && this.dataArray.length > 0 && this.dataArray[this.dataArray.length - 1]?.time <=
      (this.isSliderChange ? this.movingPosition : this.movePosition)) {
      oldLyric = this.dataArray[this.dataArray.length - 1]?.lyric?.trim();
      return oldLyric;
    }
    for (let i = 0; i <= this.dataArray.length; i++) {
      // 当前位置计算公式：(当前时间 - 最后更新时间) x 播放速度+ 最后的位置
      // 时间比对条件当前时间大于等于歌词所在时间赋值
      if (!this.dataArray[i] || !this.dataArray[i]?.lyric || !this.dataArray[i]?.originalTime) {
        log.showError('lyric format error, no time lyric originalTime');
        continue;
      }
      if (this.dataArray[i]?.time <= (this.isSliderChange ? this.movingPosition : this.movePosition)) {
        if (!!this.dataArray[i]?.lyric) {
          oldLyric = this.dataArray[i].lyric.trim();
        }
      } else {
        // 如果是最后一句，就一直显示最后一句
        if (i >= this.dataArray.length && !!this.dataArray[i]?.lyric) {
          oldLyric = this.dataArray[i].lyric.trim();
        }
        // 比对不成功跳出循环
        break
      }
    }
    return oldLyric
  }

  /**
   * 获取循环模式
   */
  getLoopMode() {
    log.debug(`getLoopMode, this.isShowLoopMode: ${this.isShowLoopMode}`);
    let playState: AVSessionManager.AVPlaybackState | undefined = this.playStateMap[this.sessionId];
    log.showInfo(`getLoopMode, playState: ${playState} | loopMode =${playState?.loopMode}`);
    if (playState && playState.loopMode !== undefined) {
      this.loopMode = playState.loopMode;
    }
  }

  /**
   * 清除定时器和当前进度条绘制值currentProgress
   * @param isClearData
   */
  clearTimerAndProgressData(isClearData: boolean) {
    log.showInfo('clearTimerAn dProgressData');
    if (this.timerId !== undefined) {
      clearInterval(this.timerId);
      this.timerId = undefined;
    }
    // 是否需要清除 进度条播放位置
    if (isClearData) {
      this.movePosition = 0;
    }
  }

  /**
   * 防止频繁同一操作 防抖
   * @returns
   */
  debounce(): boolean {
    log.showInfo('newDate set 3')
    let currentTimeStamp: number = new Date().getTime();
    if (this.preOrNextOperateTimeStamp && currentTimeStamp > this.preOrNextOperateTimeStamp &&
      currentTimeStamp - this.preOrNextOperateTimeStamp < 500) {
      log.warn(' next operate too frequency');
      return false;
    }
    this.preOrNextOperateTimeStamp = currentTimeStamp;
    return true;
  }

  /**
   * 获取步长图标
   */
  getSkipIntervalsIcon(isFastForward: boolean): string {
    let metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    if (metadata?.skipIntervals === 10) {
      return isFastForward ? ButtonIconName.FAST_FORWARD_10 : ButtonIconName.FAST_REWIND_10;
    } else if (metadata?.skipIntervals === 30) {
      return isFastForward ? ButtonIconName.FAST_FORWARD_30 : ButtonIconName.FAST_REWIND_30;
    } else {
      return isFastForward ? ButtonIconName.FAST_FORWARD_15 : ButtonIconName.FAST_REWIND_15;
    }
  }

  /**
   * 计算标题长度
   * @param text
   * @param fontSize
   * @returns
   */
  getSongNameTextLength(text: string, fontSize: Resource): number {
    let textLength: number = this.getUIContext().getMeasureUtils().measureText({
      textContent: text,
      fontSize: fontSize
    })
    let songNameAreaWidth = this.isFoldable() && !this.getFoldStatus() ?
      (this.isShowDev ? this.songNameAreaWidthCast : this.songNameAreaWidthNoCast) :
      (this.isLandscapeLayout() || this.isShowDev ? this.songNameAreaWidthCast : this.songNameAreaWidthNoCast);
    let audioVividFlagWidth = Constants.AUDIO_VIVID_FLAG_WIDTH + Constants.GOLD_FLAG_MARGIN;
    let maxValidLength = this.isShowGoldFlag ? songNameAreaWidth - audioVividFlagWidth : songNameAreaWidth;
    let length: number = (this.uiContext.px2vp(textLength) + 5) > maxValidLength ? maxValidLength :
      (this.uiContext.px2vp(textLength) + 5);
    log.showInfo(`textLength: ${(this.uiContext.px2vp(textLength) + 5)} maxValidLength: ${maxValidLength} result: ${length}`);
    return length;
  }

  /**
   * 获取进度条长度
   * @returns
   */
  getSliderWidth() {
    let sliderStyle: SliderStyleEx = {
      sliderWidth: 0,
      volumeWidth: 0
    }
    let cardEdgePadding: number = Constants.CARD_EDGE_PADDING;
    let progressTextHourWidth: number = MeasuringUtil.getHeight(10, Constants.PROGRESS_TEXT_HOUR_WIDTH,
      this.progressMaxFontScale, this.getFontSizeScale(), true, true);
    const hourFactor: number = 3600 * 1000;
    if (this.isPC) {
      sliderStyle.volumeWidth = this.windowWidth - (cardEdgePadding + cardEdgePadding +
      Constants.GOLD_FLAG_MARGIN) * 2;
      if (this.duration >= hourFactor) {
        sliderStyle.sliderWidth = this.windowWidth - (cardEdgePadding + cardEdgePadding +
          progressTextHourWidth) * 2;
      } else {
        sliderStyle.sliderWidth = sliderStyle.volumeWidth;
      }
    } else if (this.isLandscapeLayout()) { //横屏
      let cardWidth: number = (Constants.PANEL_LANDSCAPE_WIDTH - Constants.LANDSCAPE_CARD_MARGIN) / 2;
      sliderStyle.volumeWidth = cardWidth - (cardEdgePadding +
        Constants.COMMON_PICTURE_SIZE + Constants.CARD_ICON_PADDING - Constants.SLIDER_INNER_PADDING) * 2;
      if (this.duration >= hourFactor) {
        sliderStyle.sliderWidth = cardWidth - (cardEdgePadding +
          progressTextHourWidth + Constants.GOLD_FLAG_MARGIN - Constants.SLIDER_INNER_PADDING) * 2;
      } else {
        sliderStyle.sliderWidth = sliderStyle.volumeWidth - (MeasuringUtil.getHeight(10, 30, this.progressMaxFontScale,
          this.getFontSizeScale(), true) - 30) * 2;
      }
    } else { //竖屏
      // 音量条宽度 = 卡片宽度-(卡片边距+图标宽度+图标与音量条间距-音量条组件内边距)x2
      sliderStyle.volumeWidth = Constants.PANEL_PORTRAIT_WIDTH - (cardEdgePadding +
      Constants.COMMON_PICTURE_SIZE + Constants.CARD_ICON_PADDING - Constants.SLIDER_INNER_PADDING) * 2;
      if (this.duration >= hourFactor) {
        // 进度条宽度 = 卡片宽度-(卡片边距+文本宽度+文本与进度条间距-音量条组件内边距)x2
        sliderStyle.sliderWidth = Constants.PANEL_PORTRAIT_WIDTH - (cardEdgePadding +
          progressTextHourWidth + Constants.GOLD_FLAG_MARGIN - Constants.SLIDER_INNER_PADDING) * 2;
      } else {
        sliderStyle.sliderWidth = sliderStyle.volumeWidth - (MeasuringUtil.getHeight(10, 30, this.progressMaxFontScale,
          this.getFontSizeScale(), true) - 30) * 2;
      }
    }
    return sliderStyle
  }

  getIconColor(isActive: boolean): ResourceColor[] {
    return isActive ? [$r('app.color.media_control_icon_primary')] : [$r('app.color.media_control_icon_disable')];
  }

  /**
   * 背景色
   * @returns
   */
  getBackground(): string | Resource {
    if ((this.isHasMediaImage() && this.isCanLoaded)) {
      return Constants.TRANSLUCENT_COLOR
    } else {
      return this.isPC ? $r('sys.color.comp_background_tertiary') :
        $r('app.color.media_control_default_img_bgc');
    }
  }

  /**
   * 是否有图片
   * @returns
   */
  isHasMediaImage() {
    return !!(this.metaDataMap[this.sessionId] && this.metaDataMap[this.sessionId].mediaImage &&
      this.metaDataMap[this.sessionId].mediaImage != 'unknown' &&
      !this.metaDataMap[this.sessionId].mediaImage.toString()?.includes('http'))
  }

  /**
   * 歌单完成动画--大图动效
   */
  isFinishAnimation() {
    log.showInfo(`isFinishAnimation: ` + this.finishAnimate);
    if (this.finishAnimate) {
      if ((this.firstDataLength != this.alInfoTmpList.length) && this.firstDataLength == 1) {
        setTimeout(() => {
          this.albumInfoListIsData = false;
        }, 100);
      }
      this.isFirstDataLength = true;
    }
  }

  clickRewindButton() {
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    if (metadata && (metadata.title || metadata.artist || metadata.subtitle) && this.isShowRewind &&
    this.debounce()) {
      this.mediaInfoProvider?.callRewind(this.sessionId, this.movePosition);
    } else {
      log.error('error click rewind')
    }
  }

  clickFastForwardButton() {
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    if (metadata && (metadata.title || metadata.artist || metadata.subtitle) && this.isShowFastforward &&
    this.debounce()) {
      this.mediaInfoProvider?.callForward(this.sessionId, this.movePosition);
    } else {
      log.error('error click fastForward')
    }
  }

  clickFavorButton() {
    this.isClickLoop = false;
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    if (metadata && (metadata.title || metadata.artist || metadata.subtitle) && this.isShowFavor &&
    this.debounce()) {
      this.mediaInfoProvider?.callFavorites(this.sessionId, this.isFavorite);
    } else {
      log.error('error click favor');
    }
  }

  clickPrevious() {
    this.isClickLoop = false;
    if (!this.debounce()) {
      return;
    }
    this.isFirstDataLength = true;
    AppStorage.setOrCreate('isRefreshData', true);
    systemDateTime.getCurrentTime();
    if (this.isShowPlayPrevious) {
      this.mediaInfoProvider?.callPrevious(this.sessionId);
      // 切歌时清定时器
      this.clearTimerAndProgressData(false);
    } else {
      log.error('call preview with no show');
    }
  }

  showLoading() {
    this.clearLoadingTimer();
    if (!this.canColdStart) {
      return;
    }
    this.showPlayLoading = true;
    this.showPlayLoadingTimer = setTimeout(() => {
      this.showPlayLoading = false;
      this.clearLoadingTimer();
    }, Constants.LOADING_PLAY_DELAY);
  }

  clearLoadingTimer() {
    if (this.showPlayLoadingTimer) {
      clearTimeout(this.showPlayLoadingTimer);
      this.showPlayLoadingTimer = undefined;
    }
  }

  clickPlayButton() {
    if (!this.isShowPlay && !this.isShowPause) {
      return;
    }
    if (!this.debounce()) {
      return;
    }
    if (!this.isPlaying && this.currentIndex !== 1) {
      this.tabsController.changeIndex(1);
      this.swiperController.changeIndex(1);
    }
    this.isClickLoop = false;
    log.showInfo(`click play/pause`);
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.sessionId];
    if (!(metadata?.title || metadata?.artist || metadata?.subtitle)) {
      this.showLoading();
      this.mediaInfoProvider?.startDefaultAppNow(this.sessionId, false, true);
      AppStorage.setOrCreate('isLoadData', true);
    } else if (this.isPlaying) {
      // 暂停时停止进度条
      this.clearTimerAndProgressData(false);
      this.mediaInfoProvider?.callPause(this.sessionId);
    } else {
      this.mediaInfoProvider?.callPlay(this.sessionId, false);
    }
  }

  clickNext() {
    this.isClickLoop = false;
    if (!this.debounce()) {
      return;
    }
    this.isFirstDataLength = true;
    AppStorage.setOrCreate('isRefreshData', true);
    if (this.isShowPlayNext) {
      this.mediaInfoProvider?.callNext(this.sessionId);
      // 切歌时清定时器
      this.clearTimerAndProgressData(false);
    } else {
      log.error('callnext with no show');
    }
  }

  imageRatioUpdate() {
    let imageRatio: number = this.imageRatioMap[this.sessionId];
    this.imageSize = this.getImageSize(imageRatio);
    log.showInfo(`imageRatioUpdate done`);
  }

  getImageSize(imageRatio: number): ImageStyle {
    let smallImageMaxSize = 48;
    let bigImageMaxSize = Constants.PANEL_PORTRAIT_WIDTH - 48;
    let smallIconWidth = 16;
    let bigIconWidth = 32;
    if (this.isLandscapeLayout()) {
      bigImageMaxSize = Constants.LANDSCAPE_LARGE_IMAGE_WIDTH_HEIGHT;
    }

    if (!imageRatio) {
      imageRatio = 1;
    } else if (imageRatio < Constants.MIN_PORTRAIT_RATIO) {
      imageRatio = Constants.MIN_PORTRAIT_RATIO;
    } else if (imageRatio > Constants.MAX_PORTRAIT_RATIO) {
      imageRatio = Constants.MAX_PORTRAIT_RATIO;
    }
    let imagesSmallWidth = Math.min(smallImageMaxSize, smallImageMaxSize * imageRatio);
    let imagesSmallHeight = Math.min(smallImageMaxSize, smallImageMaxSize / imageRatio);
    let imagesWidth = Math.min(bigImageMaxSize, bigImageMaxSize * imageRatio);
    let imagesHeight = Math.min(bigImageMaxSize, bigImageMaxSize / imageRatio);
    let imageSize: ImageStyle = {
      imagesSmallWidth,
      imagesSmallHeight,
      smallImagesX: (smallImageMaxSize - imagesSmallWidth) / 2 + imagesSmallWidth - smallIconWidth,
      smallImagesY: (smallImageMaxSize - imagesSmallHeight) / 2 + imagesSmallHeight - smallIconWidth,
      imagesWidth,
      imagesHeight,
      imagesX: (bigImageMaxSize - imagesWidth) / 2 + imagesWidth - bigIconWidth,
      imagesY: (bigImageMaxSize - imagesHeight) / 2 + imagesHeight - bigIconWidth,
      goldFlagX: (bigImageMaxSize - imagesWidth) / 2 + Constants.GOLD_FLAG_MARGIN,
      goldFlagY: (bigImageMaxSize - imagesHeight) / 2 + imagesHeight - Constants.GOLD_FLAG_HEIGHT -
        Constants.GOLD_FLAG_MARGIN,
    };
    log.debug(`getImageSize done imageRatio: ${imageRatio} imageSize: ${JSON.stringify(imageSize)}`);
    return imageSize;
  }

  imageSizeUpdate(imageSize:ImageStyle) {
    this.imagesWidth = imageSize.imagesWidth;
    this.imagesHeight = imageSize.imagesHeight;
    this.imagesX = imageSize.imagesX;
    this.imagesY = imageSize.imagesY;
    this.goldFlagX = imageSize.goldFlagX;
    this.goldFlagY = imageSize.goldFlagY;
  }

  newImageSizeUpdate(imageSize:ImageStyle) {
    this.imagesWidthNew = imageSize.imagesWidth;
    this.imagesHeightNew = imageSize.imagesHeight;
    this.imagesNewX = imageSize.imagesX;
    this.imagesNewY = imageSize.imagesY;
    this.goldFlagNewX = imageSize.goldFlagX;
    this.goldFlagNewY = imageSize.goldFlagY;
  }

  smallImageSizeUpdate(imageSize:ImageStyle) {
    this.imagesSmallWidth = imageSize.imagesSmallWidth;
    this.imagesSmallHeight = imageSize.imagesSmallHeight;
    this.smallImagesX = imageSize.smallImagesX;
    this.smallImagesY = imageSize.smallImagesY;
  }

  getLanguage() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.language || 'zh';
    } else {
      return ResourceVm.instance.language;
    }
  }

  getFontSizeScale() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.fontSizeScale || 1;
    } else {
      return ResourceVm.instance.fontScale;
    }
  }

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  getNotPlayingHeight(): number {
      if (this.getMusicAuthorBoolean()) {
        let height = MeasuringUtil.getHeight(16, MeasuringUtil.getHeight(14, 43, this.textMaxFontScale,
          this.getFontSizeScale()), this.textMaxFontScale, this.getFontSizeScale());
        height = Constants.COMMON_PICTURE_SIZE_LARGE > height ? Constants.COMMON_PICTURE_SIZE_LARGE : height;
        return height;
      }
      return Constants.COMMON_PICTURE_SIZE_LARGE;
  }

  getMediaTextInfoHeight(): number {
    let height = MeasuringUtil.getHeight(16, MeasuringUtil.getHeight(14, 43, this.textMaxFontScale,
      this.getFontSizeScale()), this.textMaxFontScale, this.getFontSizeScale());
    height = Constants.COMMON_PICTURE_SIZE_LARGE > height ? Constants.COMMON_PICTURE_SIZE_LARGE : height;
    return height;
  }

  @Builder
  topBigImageBuilder(scene: string, isNew: boolean = false) {
    Stack() {
      this.ExtraLongImageChamfer(scene, isNew);
      // 左下角金标
      this.goldFlagBuilder(isNew, scene);
      // 右下角小图标
      this.BigPicIcon(isNew, scene);
    }
    .alignContent(Alignment.Center)
    .backgroundColor(Constants.TRANSLUCENT_COLOR)
    .opacity(isNew ? this.opacityBigImageNew : this.opacityBigImage)
    .scale({ x: isNew ? this.scaleSizeXNew : this.scaleSizeX, y: isNew ? this.scaleSizeYNew : this.scaleSizeY })
    .width(this.isLandscapeLayout() ? Constants.LANDSCAPE_LARGE_IMAGE_WIDTH_HEIGHT :
      Constants.PANEL_PORTRAIT_WIDTH - 48)
    .height(this.isLandscapeLayout() ? Constants.LANDSCAPE_LARGE_IMAGE_WIDTH_HEIGHT :
      Constants.PANEL_PORTRAIT_WIDTH - 48)
  }

  /**
   * 最近播放数据改变监听
   */
  historyDataChange() {

  }

  jumpToApp(sessionId: string) {
    if (!this.isButtonHolding && !this.mediaTransitionFlag) {
      log.showInfo(`jumpToApp: ${sessionId?.length < 10 ? '' : (sessionId?.substr(0, 5) + '**' +
      sessionId?.substr(sessionId?.length - 5))}`);
      if (sessionId && sessionId !== 'default') {
        if (ControlCenterPluginMgr.isPcMode) {
          windowMgr.hideWindowWithAnim(PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL);
        } else {
          this.isJumping = true;
        }
      }
      this.mediaInfoProvider?.startAimApp(sessionId);
      log.showInfo(`jumpToApp`);
    }
  }

  @Builder
  recentlyPlayListGroupHead() {
    Row() {
      Text($r('app.string.RecentlyPlay'))
        .maxFontScale(this.textMaxFontScale)
        .fontSize(12)
        .fontColor($r('sys.color.font_secondary'))
        .fontWeight($r('sys.string.ohos_id_text_font_family_regular'))
    }
    .padding({ top: !this.isLandscapeLayout() ? 6 : 0, bottom: 12 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 列表顶部正在播放的音乐信息
  @Builder
  playingLayout() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Stack() {
          if (this.tempPicNew || this.tempPic || this.metaDataMap[this.sessionId]?.mediaImage) {
            Image(this.getSmallImage())
              .width(40)
              .height(40)
              .borderRadius(8)
              .draggable(false)
          } else {
            Column()
              .width(40)
              .height(40)
              .borderRadius(8)
              .backgroundColor($r('app.color.media_control_default_img_bgc'))
            Image($r('app.media.ic_nomusic_img'))
              .fillColor($r('app.color.media_control_icon_disable'))
              .width(40)
              .height(40)
              .borderRadius(8)
              .draggable(false)
          }
        }

        Image(this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '')
          .width(12)
          .height(12)
          .draggable(false)
      }
      .flexGrow(0)
      .flexShrink(0)
      .flexBasis('auto')
      .onClick(() => {
        this.jumpToApp(this.sessionId);
      })
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityText($r('app.string.access_cover_image'))

      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Text(typeof this.title === 'string' ? this.title : '')
            .fontSize(14)
            .fontColor(this.isPlaying ? $r('sys.color.icon_emphasize') : $r('sys.color.font_primary'))
            .fontWeight($r('sys.string.ohos_id_text_font_family_medium'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .flexBasis('auto')
            .constraintSize({ maxWidth: Constants.RECENTLY_PLAY_TEXT_MAX_LENGTH })
            .maxFontScale(this.textMaxFontScale)

          if (this.isPlaying) {
            JumpingNotes({
              lottieFileName: 'jumping_notes.json',
              isPlaying: this.isPlaying
            })
              .margin({ left: this.isRTL() ? 0 : 4, right: this.isRTL() ? 4 : 0 })
              .width(16)
              .height(12)
          }
        }

        Text(typeof this.artist === 'string' ? this.artist : '')
          .width('100%')
          .fontSize(12)
          .fontColor(this.isPlaying ? $r('sys.color.icon_emphasize') : $r('sys.color.font_secondary'))
          .fontWeight($r('sys.string.ohos_id_text_font_family_regular'))
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 2 })
          .maxFontScale(this.textMaxFontScale)
          .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
      }
      .justifyContent(FlexAlign.Start)
      .padding({ left: this.isRTL() ?  0 : 12, right: this.isRTL() ? 12 : 0})
      .onClick(() => {
        if (!this.isPlaying) {
          this.mediaInfoProvider?.callPlay(this.sessionId, false);
        }
        this.tabsController.changeIndex(1);
        this.swiperController.changeIndex(1)
      })
    }
    .height(this.getMediaTextInfoHeight())
    .scale({ x: this.playingLayoutScale, y: this.playingLayoutScale, centerX: '50%', centerY: '50%' })
    .onTouch((event: TouchEvent) => {
      if (TouchType.Up === event.type) {
        this.uiContext.animateTo({
          curve: Curves.interpolatingSpring(1, 1, 410, 38),
        }, () => {
          this.playingLayoutScale = 1;
        });
      }
      if (TouchType.Down === event.type) {
        this.uiContext.animateTo({
          curve: Curves.interpolatingSpring(1, 1, 410, 38),
        }, () => {
          this.playingLayoutScale = 0.95;
        });
      }
    })
  }

  getTabsHeight(): number {
    return this.isLandscapeLayout() ? Constants.LANDSCAPE_CONTROLLER_HEIGHT :
      this.getMusicAuthorBoolean() ?
        Constants.PORTRAIT_RECENTLY_CARD_HEIGHT + this.getMediaTextInfoHeight() + Constants.TEXT_INFO_MARGIN_TOP :
      Constants.PORTRAIT_RECENTLY_CARD_HEIGHT;
  }

  getResourceString(data: Resource) {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return ResUtils.getInnerString(data);
    } else {
      return ResourceVm.instance.getString(data);
    }
  }

  @Builder
  recentlyPlayAndBigImageBuilder(scene: string) {
    Tabs({ barPosition: BarPosition.Start, controller: this.tabsController, index: this.currentIndex }) {
      TabContent() {
        Column() {
          if (!this.isLandscapeLayout() && this.getMusicAuthorBoolean()) {
            this.playingLayout();
          }
          List() {
            if (this.mediaInfoListData && this.mediaInfoListData.length > 0) {
              ListItemGroup({ header: this.recentlyPlayListGroupHead(), space: 12 }) {
                RecentlyPlayList({
                  clickAvQueueItem: (bundleName: string, avQueueId: string, sessionId: string) => {
                    this.mediaInfoProvider?.playAvQueue(bundleName, avQueueId);
                  },
                  startAimApp: (sessionId: string) => {
                    this.jumpToApp(sessionId);
                  },
                  startDefaultAppNow: (sessionId: string, isFromSessionCreate: boolean, callPlay: boolean) => {
                    this.mediaInfoProvider?.startDefaultAppNow(sessionId, isFromSessionCreate, callPlay);
                    this.tabsController.changeIndex(1);
                    this.swiperController.changeIndex(1);
                  },
                  clickActiveApp: (sessionId: string, isPlaying: boolean) => {
                    this.mediaInfoProvider?.callPlay(sessionId, false, isPlaying);
                    this.tabsController.changeIndex(1);
                    this.swiperController.changeIndex(1);
                  },
                  listItemClicked: (click: boolean) => {
                    this.isListItemClicked = click;
                  }
                }
                );
              }
              .width('100%')
            }

          }
          .height(Constants.PORTRAIT_RECENTLY_CARD_HEIGHT)
          .scrollBar(BarState.Off)
        }
        .clip(this.mediaTransitionDone)
      }
      .clip(this.mediaTransitionDone)
      .padding({ left: 24, right: 24})
      .align(Alignment.TopStart)
      .id(this.getAnimGeometryId(false, 'recentlyPlayEnd'))
      .height(this.getTabsHeight())
      .geometryTransition(this.getAnimGeometryKey(false, this.opacityBigImageNew, this.opacityBigImage,
        'recentlyPlay', scene), this.getGeometryOptions())

      TabContent() {
        Column() {
          Stack({ alignContent: this.isLandscapeLayout() ? Alignment.Top : Alignment.Center }) {
            this.topBigImageBuilder(scene, true);
            this.topBigImageBuilder(scene, false);
          }
          .clip(this.mediaTransitionDone)
          .height(Constants.PORTRAIT_RECENTLY_CARD_HEIGHT)

          if (!this.isLandscapeLayout() && this.getMusicAuthorBoolean()) {
            Column() {
              this.SongName(scene)
              // 副标题或者歌手或者歌词
              this.SubtitlesAndLyrics(scene)
            }
            .onAreaChange((oldArea, newValue) => {
              this.songNameAreaWidthCast = newValue.width as number;
            })
            .height(this.getMediaTextInfoHeight())
            .width(`calc(100% - ${Constants.COMMON_PICTURE_SIZE_LARGE}vp)`)
            .transition(this.getPortraitLargeTextInfoTransition())
            .margin({ top: 8 })
          }
        }
        .clip(this.mediaTransitionDone)
        .accessibilityText(this.isLandscapeLayout() ? this.getResourceString($r('app.string.access_cover_image')) : '')
        .onClick(() => {
          this.jumpToApp(this.sessionId);
        })
      }
      .height(this.getTabsHeight())
      .clip(this.mediaTransitionDone)
    }
    .clip(this.mediaTransitionDone)
    .onSelected((index: number) => {
      this.currentIndex = index;
      this.swiperController.changeIndex(index, true);
    })
    .animationDuration(500)
    .animationMode(AnimationMode.CONTENT_FIRST_WITH_JUMP)
    .barHeight(0)
    .edgeEffect(EdgeEffect.Spring)
    .scrollable(this.isExistAvQueueInfo && this.getMusicAuthorBoolean())
    .width(this.isLandscapeLayout() ? Constants.LANDSCAPE_CONTROLLER_WIDTH : Constants.PORTRAIT_MEDIA_CARD_WIDTH)
    .height(this.getTabsHeight())
    .padding({
      right: this.isRTL() ? 0 : this.isLandscapeLayout() ? 12 : 0,
      left: this.isRTL() ? this.isLandscapeLayout() ? 12 : 0 : 0
    })
  }

  getRecentlyPlayTransitionEffect(): TransitionEffect {
    // 横竖屏列表一镜到底
    if (this.mediaTransitionFlag > 0 && this.currentIndex === 0) {
      return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 150, delay: 50 })
        .combine(TransitionEffect.scale({ x: 0.4, y: 0.4, centerX: 0, centerY: 0 })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })),
        TransitionEffect.opacity(0)
          .animation({ curve: Curve.Sharp, duration: 150 })
          .combine(TransitionEffect.scale({ x: 0.4, y: 0.4, centerX: 0, centerY: 0 })
            .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })))
    }

    // 横竖屏大图一镜到底
    if (this.mediaTransitionFlag > 0 && this.currentIndex === 1) {
      return TransitionEffect.opacity(0)
    }

    // 投音按钮切换时横屏动效
    if (this.isLandscapeLayout()) {
      return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 50, delay: 100 })
        .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25), delay: 50 })),
        TransitionEffect.opacity(0)
          .animation({ curve: Curve.Sharp, duration: 50, delay: 0 })
          .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
            .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })))
    } else {
      // 竖屏投音按钮切换大图一镜到底
      if (this.currentIndex === 1) {
        return TransitionEffect.opacity(0);
      } else {
        log.showInfo(`get recently effect: ${this.isShowDeviceAnim}`)
        return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
          .animation({ curve: Curve.Sharp, duration: 100, delay: 100 })
          .combine(TransitionEffect.scale({ x: 0.5, y: 0.3, z: 0.5})
            .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })),
          TransitionEffect.opacity(0)
            .animation({ curve: Curve.Sharp, duration: 100 })
            .combine(TransitionEffect.scale({ x: 0.5, y: 0.3, z: 0.5})
              .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
        )
      }
    }
  }

  getPortraitLargeTextInfoTransition(): TransitionEffect {
    if (this.mediaTransitionFlag > 0) {
      return TransitionEffect.opacity(0);
    }
    return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
      .animation({ curve: Curve.Sharp, duration: 33, delay: 200 }),
      TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 50 }))
  }

  getSmallImageTransitionEffect(): TransitionEffect {
    if (this.hasCall) {
      return TransitionEffect.IDENTITY;
    }
    if (this.mediaTransitionFlag > 0 || this.currentIndex === 1) {
      return TransitionEffect.opacity(0);
    }
    return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
      .animation({ curve: Curve.Sharp, duration: 100, delay: 100 }),
      TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 100}))
  }

  getSmallSongInfoTransitionEffect(): TransitionEffect {
    if (this.isSmallPic || this.hasCall) {
      return TransitionEffect.IDENTITY;
    }
    if (this.mediaTransitionFlag > 0) {
      return TransitionEffect.opacity(0);
    }
    if (this.currentIndex === 1) {
      return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
        .animation({ duration: 100, curve: Curve.Sharp, delay: 150 })
        .combine(TransitionEffect.translate({
          x: 200,
          y: (Constants.PANEL_PORTRAIT_WIDTH - 48 - this.getNotPlayingHeight()) / 2
        })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })),
        TransitionEffect.opacity(0)
          .animation({ duration: 100, curve: Curve.Sharp })
          .combine(TransitionEffect.translate({
            x: 200,
            y: (Constants.PANEL_PORTRAIT_WIDTH - 48 - this.getNotPlayingHeight()) / 2
          })
            .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })))
    }
    return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
      .animation({ curve: Curve.Sharp, duration: 100, delay: 100 }),
      TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 100 }))
  }

  getLandSmallImageTransitionEffect(): TransitionEffect {
    if (this.isSmallPic) {
      return TransitionEffect.IDENTITY;
    }
    if (this.mediaTransitionFlag > 0) {
      return TransitionEffect.opacity(0);
    }
    return TransitionEffect.asymmetric(
      TransitionEffect.opacity(0).animation({ curve: Curve.Sharp, duration: 100, delay: 150 }),
      TransitionEffect.opacity(0).animation({ curve: Curve.Sharp, duration: 100 }))
  }

  @Builder
  goldFlagBuilder(isNew: boolean, scene: string) {
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
    .opacity(!this.animateShowGoldFlag ? 0 : this.goldFlagOpacity)
    .padding({
      left: 8,
      right: 8,
      top: 4,
      bottom: 4
    })
    .height(16)
    .width(79)
    .backgroundColor('#66000000')
    .position({
      x: this.isRTL() ?
        isNew ? this.goldFlagNewX : this.goldFlagX + (isNew ? this.imagesWidthNew : this.imagesWidth) - 79 - 16 :
        isNew ? this.goldFlagNewX : this.goldFlagX,
      y: isNew ? this.goldFlagNewY : this.goldFlagY
    })
    .id('goldFlagEnd')
    .geometryTransition(this.getGeometryKey('goldFlag'), this.getGeometryOptions())
  }

  getBigImage(isNew?: boolean): string | Resource | PixelMap {
    let bigImage: string | Resource | PixelMap = '';
    if (isNew) {
      bigImage = this.tempPicNew || this.metaDataMap[this.sessionId]?.mediaImage || $r('app.media.ic_nomusic_img');
    } else {
      bigImage = this.tempPic || this.metaDataMap[this.sessionId]?.mediaImage || $r('app.media.ic_nomusic_img');
    }
    if (this.isUpdateNewImageSize && this.imageSize && isNew) {
      this.isUpdateNewImageSize = false;
      this.newImageSizeUpdate(this.imageSize);
    } else if (this.isUpdateImageSize && this.imageSize && !isNew) {
      this.isUpdateImageSize = false;
      this.imageSizeUpdate(this.imageSize);
    }
    log.showInfo(`getBigImage done`);
    return bigImage;
  }

  checkMediaImage(isNew: boolean = false): boolean {
    let mediaImage: image.PixelMap | string | undefined = this.metaDataMap[this.sessionId]?.mediaImage;
    // 冷启动时，图片返回PixelMap之前，显示默认音符
    if (this.noPic && typeof mediaImage === 'string' && mediaImage.startsWith('http')) {
      return false;
    }
    return !!((isNew ? this.tempPicNew : this.tempPic) || mediaImage);
  }

  /**
   * 适配超长图和超宽图，以及应用图标对齐
   * @param _width
   */
  @Builder
  ExtraLongImageChamfer(scene: string, isNew: boolean = false) {
    Stack({ alignContent: Alignment.Center }) {
      if (this.checkMediaImage(isNew)) {
        Column()
          .width(isNew ? this.imagesWidthNew : this.imagesWidth)
          .height(isNew ? this.imagesHeightNew : this.imagesHeight)
          .id(this.getAnimGeometryId(isNew, 'mediaLargeImgBg'))
          .geometryTransition(this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage,
            'mediaImgBg', scene), this.getGeometryOptions())
          .zIndex(0)
        Image(this.getBigImage(isNew))
          .alt($r('app.media.ic_nomusic_img'))
          .fillColor(this.isPC ? '#19000000' : $r('app.color.media_control_icon_disable'))
          .backgroundColor(this.getBackground())
          .width(isNew ? this.imagesWidthNew : this.imagesWidth)
          .height(isNew ? this.imagesHeightNew : this.imagesHeight)
          .draggable(false)
          .align(Alignment.Center)
          .objectFit(ImageFit.Cover)
          .interpolation(ImageInterpolation.High)
          .onComplete((newValue: ImageCallback) => {
            log.showInfo(`mediaImage show onComplete for this.sessionId: ${this.sessionId?.length < 10 ? '' :
              (this.sessionId?.substr(0, 5) + '**' +
              this.sessionId?.substr(this.sessionId?.length - 5))},isNew:${isNew}`);
            this.isCanLoaded = true;
          })
          .onError((event) => {
            log.error(`mediaImage show err for this.sessionId : ${this.sessionId},errorMessage:${JSON.stringify(event.message)},image:${isNew ?
            this.tempPicNew : this.tempPic}`);
            let currentImage: string | Resource | PixelMap = this.getBigImage(isNew);
            if (currentImage && typeof (currentImage) !== undefined && typeof (currentImage) !== 'string') {
              log.warn('mediaImage show err :already is PixelMap')
              return;
            }
            this.isCanLoaded = false;
            if (this.metaDataMap && this.metaDataMap[this.sessionId]) {
              this.metaDataMap[this.sessionId].mediaImage = undefined;
              this.tempPic = '';
            }
          })
          .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
          .syncLoad(true)
          .id(this.getAnimGeometryId(isNew, 'mediaLargeImg'))
          .geometryTransition(this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage,
            'mediaImg', scene), this.getGeometryOptions())
          .onAppear(() => {
            log.showInfo(`onAppear
              ${this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage, 'mediaImg', scene)}`);
          })
          .onDisAppear(() => {
            log.showInfo(`onDisAppear
              ${this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage, 'mediaImg', scene)}`);
          })
          .zIndex(1)
          .autoResize(false)
          .clip(true)
      } else {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius(Constants.MUSIC_ICON_RADIUS_SIZE_BIG)
          .backgroundColor(this.getBackground())
          .zIndex(0)
          .id(this.getAnimGeometryId(isNew, 'defaultLargeBg'))
          .geometryTransition(this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage,
            'defaultBg', scene), this.getGeometryOptions())
        Image($r('app.media.ic_nomusic_img_big'))
          .fillColor(this.isPC ? '#19000000' : $r('app.color.media_control_icon_disable'))
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .width(64)
          .height(64)
          .draggable(false)
          .renderFit(RenderFit.RESIZE_COVER)
          .id(this.getAnimGeometryId(isNew, 'defaultLargeImage'))
          .geometryTransition(this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage,
            'defaultImg', scene), this.getGeometryOptions())
          .onAppear(() => {
            log.showInfo(`onAppear
              ${this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage, 'defaultImg', scene)}`);
          })
          .onDisAppear(() => {
            log.showInfo(`onDisAppear
              ${this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage, 'defaultImg', scene)}`);
          })
          .zIndex(1)
          .onComplete((newValue: ImageCallback) => {
            log.showInfo('mediaImage show onComplete for default : ');
            this.isCanLoaded = true;
          })
      }
    }
    .width(isNew ? this.imagesWidthNew : this.imagesWidth)
    .height(isNew ? this.imagesHeightNew : this.imagesHeight)
    .key('media_pic_No.' + this.index)
  }

  getBigAppIcon(isNew: boolean): string | image.PixelMap {
    if (isNew) {
      return this.bigIconPicNew || this.appIconMap[this.sessionId] || '';
    } else {
      return this.bigIconPic || this.appIconMap[this.sessionId] || '';
    }
  }

  /**
   * 应用大图标
   */
  @Builder
  BigPicIcon(isNew: boolean, scene: string) {
    if (this.isCanLoaded) {
      Column() {
        Image(this.getBigAppIcon(isNew))
          .size({ width: '100%', height: '100%' })
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false);
      }
      .clip(true)
      .width(this.isPC ? 38 : Constants.COMMON_PICTURE_SIZE_BIG)
      .height(this.isPC ? 38 : Constants.COMMON_PICTURE_SIZE_BIG)
      .backgroundColor(Constants.TRANSLUCENT_COLOR)
      .borderRadius($r('sys.float.ohos_id_corner_radius_icon'))
      .position(this.isRTL() ?
        {
          right: isNew ? this.imagesNewX : this.imagesX,
          top: isNew ? this.imagesNewY : this.imagesY
        } :
        {
          left: isNew ? this.imagesNewX : this.imagesX,
          top: isNew ? this.imagesNewY : this.imagesY
        })
      .align(Alignment.BottomEnd)
      .zIndex(1)
      .key('media_icon_No.' + this.index)
      .id(this.getAnimGeometryId(isNew, 'mediaPublicIcon'))
      .geometryTransition(this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage,
        'publicIcon', scene), this.getGeometryOptions())
      .onAppear(() => {
        log.showInfo(`onAppear
          ${this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage, 'publicIcon', scene)}`);
      })
      .onDisAppear(() => {
        log.showInfo(`onDisAppear
          ${this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage, 'publicIcon', scene)}`);
      })
      .opacity(this.bigPicIconOpacity)
    } else {
      Column() {
        Image(this.getBigAppIcon(isNew))
          .size({ width: '100%', height: '100%' })
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false);
      }
      .clip(true)
      .width(this.isPC ? 38 : Constants.COMMON_PICTURE_SIZE_BIG)
      .height(this.isPC ? 38 : Constants.COMMON_PICTURE_SIZE_BIG)
      .backgroundColor(Constants.TRANSLUCENT_COLOR)
      .borderRadius($r('sys.float.ohos_id_corner_radius_icon'))
      .position(this.isRTL() ? { right: this.imagesX, top: this.imagesY } :
        { left: this.imagesX, top: this.imagesY })
      .align(Alignment.Center)
      .zIndex(1)
      .key('media_icon_No.' + this.index)
      .id(this.getAnimGeometryId(isNew, 'mediaPublicIcon'))
      .geometryTransition(this.getAnimGeometryKey(isNew, this.opacityBigImageNew, this.opacityBigImage,
        'publicIcon', scene), this.getGeometryOptions())
      .onAppear(() => {
        log.showInfo(`no image, onAppear ${this.getAnimGeometryKey(isNew, this.opacityBigImageNew,
          this.opacityBigImage, 'publicIcon', scene)}`);
      })
      .onDisAppear(() => {
        log.showInfo(`no image, onDisAppear ${this.getAnimGeometryKey(isNew, this.opacityBigImageNew,
          this.opacityBigImage, 'publicIcon', scene)}`);
      })
    }
  }

  getSmallImage(): Resource | PixelMap | string {
    let smallImage: Resource | PixelMap | string = '';
    if (this.isCasting) {
      smallImage = this.metaDataMap[this.sessionId]?.mediaImage || $r('app.media.ic_nomusic_img');
    } else {
      if (this.opacityBigImage === 1) {
        smallImage = this.tempPic || this.metaDataMap[this.sessionId]?.mediaImage || $r('app.media.ic_nomusic_img');
      } else {
        smallImage = this.tempPicNew || this.metaDataMap[this.sessionId]?.mediaImage || $r('app.media.ic_nomusic_img');
      }
    }
    if (this.isUpdateSmallImageSize && this.imageSize) {
      this.isUpdateSmallImageSize = false;
      this.smallImageSizeUpdate(this.imageSize);
    }
    log.showInfo(`getSmallImage done`);
    return smallImage;
  }

  /**
   * 模糊封面小图
   */
  @Builder MediaImg(scene: string) {
    Stack({ alignContent: Alignment.Center }) {
      if (this.tempPicNew || this.tempPic || this.metaDataMap[this.sessionId]?.mediaImage) {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
          .clip(false)
          .backgroundColor(Color.Transparent)
          .id('mediaSmallImgBg')
          .geometryTransition(this.getSongInfoGeometryKey('mediaImgBg', `mediaImgBg${scene}`),
            this.getGeometryOptions())
          .transition(this.getSmallImageTransitionEffect())
          .zIndex(0)
        Image(this.getSmallImage())
          .alt($r('app.media.ic_nomusic_img'))
          .fillColor(this.isPC ? '#19000000' : $r('app.color.media_control_icon_disable'))
          .backgroundColor(this.getBackground())
          .borderRadius(this.imagesSmallWidth === this.imagesSmallHeight ?
            $r('sys.float.ohos_id_corner_radius_default_m') : 4)
          .draggable(false)
          .align(Alignment.Center)
          .objectFit(ImageFit.Cover)
          .onComplete((newValue: ImageCallback) => {
            log.error(`mediaSmallImage show`);
            this.isCanLoaded = true;
          })
          .onError((event) => {
            log.error(`mediaSmallImage show err for this.sessionId : ${this.sessionId}`);
            let currentImage: string | Resource | image.PixelMap = this.getSmallImage();
            if (currentImage && typeof currentImage !== 'string') {
              log.showWarn('mediaSmallImage show err: already pixelMap');
              return;
            }
            this.isCanLoaded = false;
            if (this.metaDataMap && this.metaDataMap[this.sessionId]) {
              this.metaDataMap[this.sessionId].mediaImage = undefined;
              this.tempPic = '';
            }
          })
          .id('mediaSmallImg')
          .geometryTransition(this.getSongInfoGeometryKey('mediaImg', `mediaImg${scene}`), this.getGeometryOptions())
          .transition(this.getSmallImageTransitionEffect())
          .zIndex(1)
          .autoResize(false)
          .interpolation(ImageInterpolation.Medium)
          .clip(true)
          .width(this.imagesSmallWidth)
          .height(this.imagesSmallHeight)
      } else {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius(12)
          .backgroundColor(this.getBackground())
          .id('defaultSmallBg')
          .geometryTransition(this.getSongInfoGeometryKey('defaultBg', `defaultBg${scene}`), this.getGeometryOptions())
          .transition(this.getSmallImageTransitionEffect())
          .zIndex(0)
        Image($r('app.media.ic_nomusic_img_big'))
          .fillColor(this.isPC ? '#19000000' : $r('app.color.media_control_icon_disable'))
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .width(18)
          .height(18)
          .draggable(false)
          .renderFit(RenderFit.RESIZE_COVER)
          .id('defaultSmallImage')
          .geometryTransition(this.getSongInfoGeometryKey('defaultImg', `defaultImg${scene}`),
            this.getGeometryOptions())
          .transition(this.getSmallImageTransitionEffect())
          .zIndex(1)
          .onComplete((newValue: ImageCallback) => {
            this.isCanLoaded = true;
            this.imagesWidth = this.getDefaultSize('portraitImagesWidth', Constants.PANEL_PORTRAIT_WIDTH - 48);
            this.imagesWidthNew = this.getDefaultSize('portraitImagesWidth', Constants.PANEL_PORTRAIT_WIDTH - 48);
            this.imagesHeight = this.getDefaultSize('portraitImagesHeight', Constants.PANEL_PORTRAIT_WIDTH - 48);
            this.imagesHeightNew = this.getDefaultSize('portraitImagesHeight', Constants.PANEL_PORTRAIT_WIDTH - 48);
          })
      }
      if (this.isClickIndex && this.mediaTransitionDone) {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius(this.imagesSmallWidth === this.imagesSmallHeight ?
            $r('sys.float.ohos_id_corner_radius_default_m') : 4)
          .backgroundColor(this.isPC ? $r('sys.color.comp_background_tertiary') : this.getBackground())
          .blur(50)
          .zIndex(2)
        LoadingProgress()
          .width(24)
          .height(24)
          .color(this.isPC ? $r('sys.color.icon_secondary') : $r('app.color.media_control_icon_disable'))
          .zIndex(3)
      }
    }
    .width(this.imagesSmallWidth)
    .height(this.imagesSmallHeight)
    .key('media_pic_No.' + this.index)
  }

  /**
   * 应用小图标
   */
  @Builder SmallPicIcon(scene: string) {
    Column() {
      Image(this.appIconMap[this.sessionId] ? this.appIconMap[this.sessionId] : '')
        .size({ width: '100%', height: '100%' })
        .backgroundColor(Constants.TRANSLUCENT_COLOR)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false);
    }
    .clip(true)
    .size({
      width: Constants.COMMON_PICTURE_SIZE_SMALL,
      height: Constants.COMMON_PICTURE_SIZE_SMALL
    })
    .position(this.isRTL() ? { right: this.smallImagesX, top: this.smallImagesY } :
      { left: this.smallImagesX, top: this.smallImagesY })
    .backgroundColor(Constants.TRANSLUCENT_COLOR)
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
    .align(Alignment.BottomEnd)
    .key('media_icon_No.' + this.index)
    .id('mediaPublicIconSm')
    .geometryTransition(this.getSongInfoGeometryKey('publicIcon', `publicIcon${scene}`), this.getGeometryOptions())
    .transition(this.getSmallImageTransitionEffect())
  }

  /**
   * 未在播放
   */
  @Builder NotPlaying(scene: string) {
    Row() {
      Text(this.getMusicAuthor())
        .fontColor($r('app.color.media_control_text_secondary'))
        .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossSubOption)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .maxFontScale(this.textMaxFontScale)
        .fontWeight(FontWeight.Regular)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Start)
        .key('media_music_subtitle_No.' + this.index)
        .height(40)
        .accessibilityGroup(true)
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height('100%')
    .id('notPlaying')
    .geometryTransition(this.getSongInfoGeometryKey('textPlayBox', `textPlayBox${scene}`), this.getGeometryOptions())
    .onAppear(() => {
      log.showInfo(`onAppear ${this.getSongInfoGeometryKey('textPlayBox', `textPlayBox${scene}`)}`);
    })
    .onDisAppear(() => {
      log.showInfo(`onDisAppear ${this.getSongInfoGeometryKey('textPlayBox', `textPlayBox${scene}`)}`);
    })
  }

  /**
   * 歌曲名称
   */
  @Builder SongName(scene: string) {
    Stack({ alignContent: Alignment.Center }) {
      this.SongNameRow(false)
      this.SongNameRow(true)
    }
    .accessibilityLevel('yes')
    .id('songBoxEnd')
    .geometryTransition(this.getSongInfoGeometryKey('songBox', `songBox${scene}`), this.getGeometryOptions())
    .clip(true)
  }

  /**
   * 歌曲名称
   * @param isNew 新旧名称行数据切换，淡入淡出
   */
  @Builder SongNameRow(isNew: boolean = false) {
    Flex({
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start
    }) {
      Row() {
        if (this.isPlaying) {
          Marquee({
            start: true,
            step: 6,
            loop: -1,
            fromStart: !this.isRTL() ? true : false,
            src: this.getTitleText(isNew)
          })
            .fontColor($r('sys.color.font_primary'))
            .fontSize(MeasuringUtil.getFontSize(this.songNameTextSize, this.textMaxFontScale,
              this.getFontSizeScale()))
            .fontWeight(600)
            .align(!this.isRTL() ? Alignment.Start : Alignment.End)
            .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
            .key('media_music_title_No.' + this.index)
        } else {
          Text(this.getTitleText(isNew))
            .fontColor($r('sys.color.font_primary'))
            .fontSize(this.songNameTextSize)
            .maxFontScale(this.textMaxFontScale)
            .fontWeight(600)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .key('media_music_title_No.' + this.index)
        }
      }
    }
    .accessibilityLevel(isNew ? 'yes' : 'no-hide-descendants')
    .padding({ bottom: 0 })
    .width('100%')
    .opacity(this.isLandscapeLayout() ? (isNew ? 0 : 1) : (isNew ? this.newLyricOpacity : this.oldLyricOpacity))
    .height(MeasuringUtil.getHeight(16, 24, this.textMaxFontScale, this.getFontSizeScale()))
  }

  /**
   * 副标题和歌词
   */
  @Builder SubtitlesAndLyrics(scene: string) {
    Stack({ alignContent: Alignment.Center }) {
      this.SubtitlesAndLyricsRow(false)
      this.SubtitlesAndLyricsRow(true)
    }
    .clip(true)
    .accessibilityLevel('yes')
    .id('textPlayBoxEnd')
    .geometryTransition(this.getSongInfoGeometryKey('textPlayBox', `textPlayBox${scene}`), this.getGeometryOptions())
  }

  /**
   * 副标题和歌词
   * @param isNew 新旧副标题行数据切换，淡入淡出
   */
  @Builder SubtitlesAndLyricsRow(isNew: boolean = false) {
    Row() {
      if (this.isPlaying) {
        Marquee({
          start: true,
          step: 6,
          loop: -1,
          fromStart: !this.isRTL() ? true : false,
          src: this.getSubtitleText(isNew)
        })
          .fontColor($r('sys.color.font_secondary'))
          .fontSize(MeasuringUtil.getFontSize($r('sys.float.ohos_id_text_size_body2'),
            this.textMaxFontScale, this.getFontSizeScale()))
          .fontWeight(FontWeight.Regular)
          .align(!this.isRTL() ? Alignment.Start : Alignment.End)
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
          .key('media_music_lyrics_No.' + this.index)
      } else {
        Text(this.getSubtitleText(isNew))
          .fontColor($r('sys.color.font_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(this.textMaxFontScale)
          .fontWeight(FontWeight.Regular)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)
          .key('media_music_subtitle_No.' + this.index)
      }
    }
    .accessibilityLevel(isNew ? 'yes' : 'no-hide-descendants')
    .opacity(this.isLandscapeLayout() ? (isNew ? 0 : 1) : (isNew ? this.newLyricOpacity : this.oldLyricOpacity))
    .width('100%')
    .height(MeasuringUtil.getHeight(14, 20, this.textMaxFontScale, this.getFontSizeScale()))
  }

  @Builder progressStack(scene: string) {
    Stack({ alignContent: Alignment.Center }) {
      this.progressBuilder({
        left: 24,
        right: 24,
        top: 0
      }, false, scene);
      this.progressBuilder({
        left: 24,
        right: 24,
        top: 0
      }, true, scene);
    }
    .id('progressStack')
  }

  getProgressStartTime(isNew: boolean) {
    if (this.isClickAlbum) {
      return isNew ? this.newProgressStartTime : this.oldProgressStartTime;
    }
    return this.getProgressStart() || '--:--';
  }

  getProgressEndTime(isNew: boolean) {
    if (this.isClickAlbum) {
      return isNew ? this.newProgressEndTime : this.oldProgressEndTime;
    }
    return this.getProgressEnd() || '--:--';
  }

  ProgressStartTimeChange() {
    if (this.oldProgressStartTime.length == 0 && this.newProgressStartTime.length == 0) {
        this.oldProgressStartTime = this.getProgressStart() || '--:--';
        this.oldProgressEndTime = this.getProgressEnd() || '--:--';
      } else if (this.oldProgressStartTime.length != 0 && this.newProgressStartTime.length == 0) {
        this.newProgressStartTime = this.getProgressStart() || '--:--';
        this.newProgressEndTime = this.getProgressEnd() || '--:--';
      } else if (this.oldProgressStartTime.length != 0 && this.newProgressStartTime.length != 0) {
        if (this.oldLyricOpacity == 0) {
          this.oldProgressStartTime = this.getProgressStart() || '--:--';
          this.oldProgressEndTime = this.getProgressEnd() || '--:--';
        } else {
          this.newProgressStartTime = this.getProgressStart() || '--:--';
          this.newProgressEndTime = this.getProgressEnd() || '--:--';
        }
    }
  }

  /**
   * 进度条
   * @param styleObject
   */
  @Builder progressBuilder(styleObject: StyleObject, isNew: boolean, scene: string) {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      Text(this.getProgressStartTime(isNew) || '--:--')
        .fontSize(10)
        .maxFontScale(this.progressMaxFontScale)
        .fontWeight(FontWeight.Regular)
        .fontColor(this.progressTextColor)
        .foregroundBrightness(this.progressTextBrightness ? this.colorModeViewData.foregroundTertiaryGlossSubOption :
          this.colorModeViewData.foregroundPrimaryOption)
        .maxLines(1)
        .width(this.duration >= 3600 * 1000 ?
          MeasuringUtil.getHeight(10, 46, this.progressMaxFontScale, this.getFontSizeScale(), true, true) :
          MeasuringUtil.getHeight(10, 30, this.progressMaxFontScale, this.getFontSizeScale(), true))
        .flexShrink(0)
        .textAlign(TextAlign.Start)
        .key('media_progress_start_No.' + this.index)
        .textOverflow({overflow: TextOverflow.Clip})
        .id(this.getAnimGeometryId(isNew, 'mediaProcessNowEnd'))
        .geometryTransition(this.getAnimGeometryKey(isNew, this.newLyricOpacity, this.oldLyricOpacity,
          'mediaProcessNow', scene), this.getGeometryOptions())
        .transition(TransitionEffect.OPACITY)
        .height(40)
        .accessibilityLevel('no')

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        if (!this.duration || this.duration < 0) {
          Slider({
            value: 0,
            min: 0,
            max: 0,
            step: 1,
            style: SliderStyle.InSet,
            direction: Axis.Horizontal
          })
            .padding({
              left: this.isPC ? 5 : 0,
              right: this.isPC ? 5 : 0
            })
            .trackColor(this.isPC ? $r('sys.color.comp_background_secondary') :
              $r('app.color.media_control_component_normal'))
            .trackThickness(4)
            .blockColor('#00ffffff')
            .showSteps(false)
            .showTips(false)
            .enabled(false)
            .accessibilityLevel('no')
        } else {
          MediaControllerSlider({
            movePositionPreferSet: this.movePosition,
            movePositionTrueSet: this.trueMovePosition,
            callSeekCount: this.callSeekCount,
            shortTimeUpdateCount: this.shortTimeUpdateCount,
            sliderMax: this.duration,
            sliderMin: 0,
            sliderStep: 0.1,
            sliderStyle: SliderStyle.InSet,
            sliderDirection: Axis.Horizontal,
            sliderPadding:
              {
                left: this.isPC ? 5 : 0,
                right: this.isPC ? 5 : 0
              },
            sliderTrackThickness: this.progressHeight,
            sliderIsActive: this.isShowSeek,
            sliderSelectedColor: (this.isShowSeek ?
              (this.isPC ? $r('sys.color.icon_emphasize') : $r('app.color.media_control_slider_primary')) :
              (this.isPC ? '#999999' : $r('app.color.media_control_component_normal'))),
            sliderTrackColor: (this.isPC ?
              $r('sys.color.comp_background_secondary') : $r('app.color.media_control_component_normal')),
            sliderBlockColor: (this.isPC ?
              $r('sys.color.icon_emphasize') : Color.Transparent),
            sliderWidth: '100%',
            sliderFlexShrink: 1,
            sliderShowSteps: false,
            sliderShowTips: false,
            sliderShowTipsContent: '',
            sliderBlockBorderWidth: 0,
            sliderEnabled: true,
            sliderBlockStyle:
              {
                type: SliderBlockType.SHAPE,
                shape: new Path({ commands: 'M60 60 M30 30 L15 56 L45 56 Z' })
              },

            sliderChangeCallback:
              (value: number, mode: SliderChangeMode) => {
                this.movingPosition = value;
                this.isOperateProgress = true;
                log.showInfo(`slider onChange: ${value}, mode=${mode}, this.movePosition=${this.movePosition}`);
                if (value === 0 && this.movePosition < 0) {
                  this.isOperateProgress = false;
                  log.error('slider position abnormal, return');
                  return;
                }
                this.moveFlag = this.moveFlagStep * this.speed;
                this.moveStartCachePosition.push(this.movePosition);
                switch (mode) {
                  case SliderChangeMode.Begin:
                    this.isClickLoop = false; //拖动点击等进度条防止循环按钮变动
                    this.isSliderChange = true;
                    log.showInfo(`slider onChange end to seek, begin value : ${value}  ${this.movePosition}`);
                    this.progressTextColor = $r('app.color.media_control_text_primary');
                    this.progressTextBrightness = false;
                    this.uiContext.animateTo({
                      duration: 300
                    }, () => {
                      this.progressHeight *= 2.5;
                    })
                    // 防止长按事件
                    this.clearTimerAndProgressData(false);
                    break;
                  case SliderChangeMode.Click:
                    this.isFirstDataLength = true;
                    AppStorage.setOrCreate('isRefreshData', true);
                    this.isClickLoop = false; //拖动点击等进度条防止循环按钮变动
                    log.showInfo(`slider onChange end to seek, click value :
                  ${TAG}: ${JSON.stringify(this.moveStartCachePosition)}, ${value}, ${this.movePosition}`);
                    break;
                  case SliderChangeMode.Moving:
                    this.isClickLoop = false; //拖动点击等时间防止循环按钮变动
                    break;
                  case SliderChangeMode.End:
                    if (!this.isSliderChange) {
                      return;
                    }
                    this.isFirstDataLength = true;
                    AppStorage.setOrCreate('isRefreshData', true);
                    this.isOperateProgress = false;
                    this.isClickLoop = false; //拖动点击等进度条防止循环按钮变动
                    this.isSliderChange = false;
                    this.progressTextColor = $r('app.color.media_control_text_secondary');
                    this.progressTextBrightness = true;
                    log.showInfo(`slider onChange end to seek, value : ${value}`);
                    if (value <= this.duration) {
                      this.callSeekCount++;
                      log.showInfo(`MediaControllerSlider on callSeekCount add ${this.callSeekCount}`)
                      this.mediaInfoProvider?.callSeek(this.sessionId, value);
                    }
                    if (value <= 0) {
                      this.progressHeight = 4;
                    } else {
                      this.uiContext.animateTo({
                        duration: 300
                      }, () => {
                        this.progressHeight = 4;
                      });
                    }
                    break;
                  default:
                    break;
                }
              },
            sliderKey: 'media_progress_No.' + this.index,
          })
        }
      }
      .width(this.getSliderWidth().sliderWidth)
      .margin({ left: 8, right: 8 })
      .height(40)
      .backgroundColor(Constants.TRANSLUCENT_COLOR)
      .clip(true)
      .id(this.getAnimGeometryId(isNew, 'mediaProcessEnd'))
      .geometryTransition(this.getAnimGeometryKey(isNew, this.newLyricOpacity, this.oldLyricOpacity, 'mediaProcess',
        scene), this.getGeometryOptions())
      .transition(TransitionEffect.OPACITY)

      Text(this.getProgressEndTime(isNew) || '--:--')
        .fontSize(10)
        .maxFontScale(this.progressMaxFontScale)
        .fontWeight('sys.string.ohos_id_text_font_family_regular')
        .fontColor(this.progressTextColor)
        .foregroundBrightness(this.progressTextBrightness ? this.colorModeViewData.foregroundTertiaryGlossSubOption :
          this.colorModeViewData.foregroundPrimaryOption)
        .textAlign(TextAlign.End)
        .maxLines(1)
        .width(this.duration >= 3600 * 1000 ?
          MeasuringUtil.getHeight(10, 46, this.progressMaxFontScale, this.getFontSizeScale(), true, true) :
          MeasuringUtil.getHeight(10, 30, this.progressMaxFontScale, this.getFontSizeScale(), true))
        .flexShrink(0)
        .key('media_progress_end_No.' + this.index)
        .textOverflow({overflow: TextOverflow.Clip})
        .id(this.getAnimGeometryId(isNew, 'mediaProcessTotalEnd'))
        .geometryTransition(this.getAnimGeometryKey(isNew, this.newLyricOpacity, this.oldLyricOpacity,
          'mediaProcessTotal', scene), this.getGeometryOptions())
        .transition(TransitionEffect.OPACITY)
        .height(40)
        .accessibilityLevel('no')
    }
    .accessibilityLevel(!this.isShowSeek ? 'no-hide-descendants' :
      this.getProgressOpacity(isNew, this.newLyricOpacity, this.oldLyricOpacity) === 1 ? 'yes' : 'no-hide-descendants')
    .opacity(this.getProgressOpacity(isNew, this.newLyricOpacity, this.oldLyricOpacity))
    .height(40)
    .padding(styleObject)
    .margin({ top: this.isLandscapeLayout() ? (this.isSmallPic ? 4 : 17.5) : (0) })
  }

  /**
   * 操作按钮
   * @param playStyle
   */
  @Builder playbackControlBuilder(playStyle: PlayStyleObj) {
    // 播控按钮
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      // 快退和循环模式
      if (this.isVideo) {
        Button({ stateEffect: this.isShowRewind }) {
          SymbolGlyph($r(this.getSkipIntervalsIcon(false)))
            .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
            .fontColor(this.getIconColor(this.isShowRewind))
            .backgroundColor(Color.Transparent)
            .opacity(this.isPC ? (this.isShowRewind ? 1 : 0.2) : 1)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.DOWN),
              this.isShowRewind ? this.fastRewindTriggerValue : -1)
        }
        .onClick(() => {
          log.showInfo('Add this attribute to ensure that barrier-free reading is normal.');
          this.fastRewindTriggerValue++;
          this.clickRewindButton();
        })
        .type(ButtonType.Circle)
        .accessibilityLevel('yes')
        .accessibilityGroup(true)
        .accessibilityDescription(this.isShowRewind ? '' : ResUtils.getInnerString($r('app.string.access_unavailable')))
        .accessibilityText(ResUtils.getInnerString($r('app.string.access_rewind')))
        .size({
          width: Constants.COMMON_PICTURE_SIZE_LARGE,
          height: Constants.COMMON_PICTURE_SIZE_LARGE
        })
        .backgroundColor(Color.Transparent)
        .offset(playStyle.offsetLeft)
        .key('media_rewind_No.' + this.index)
        .geometryTransition(this.getGeometryKey('buttonRewind'), this.getGeometryOptions())
        .id('media_rewind_No.' + this.index)

      } else {
        Button({ stateEffect: this.isShowLoopMode }) {
          SymbolGlyph(loopIcon[this.loopMode])
            .fontSize(this.isPC ? Constants.COMMON_PICTURE_SIZE_BIG_PLUS : `${Constants.COMMON_PICTURE_SIZE}vp`)
            .fontColor(this.getIconColor(this.isShowLoopMode))
            .rotate({ angle: this.loopMode === 3 ? this.isRTL() ? 180 : 0 : 0 })
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .opacity(this.isPC ? (this.isShowLoopMode ? 1 : 0.3) : 1)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE),
              this.isShowLoopMode ? this.loopModeTriggerValue : -1)
        }
        .onClick(() => {
          log.showInfo(`getLoopMode: ${this.loopMode}, ${this.isSliderChange}`);
          if (this.isSliderChange || !this.isCanPlay || !this.isShowLoopMode || !this.debounce()) {
            return;
          }
          this.mediaInfoProvider?.callLoop(this.sessionId, this.loopMode);
          setTimeout(() => {
            AccessibilityUtil.requestFocusAccessibility('buttonLoopModeEnd');
          }, 100)
        })
        .type(ButtonType.Circle)
        .rotate({ angle: this.loopMode === 3 ? this.isRTL() ? 180 : 0 : 0 })
        .accessibilityLevel('yes')
        .accessibilityGroup(true)
        .accessibilityDescription(this.isShowLoopMode ? '' : ResUtils.getInnerString($r('app.string.access_unavailable')))
        .accessibilityText(this.accessLoopMode())
        .size({ width: Constants.COMMON_PICTURE_SIZE_LARGE, height: Constants.COMMON_PICTURE_SIZE_LARGE })
        .backgroundColor(Color.Transparent)
        .offset(playStyle.offsetRight)
        .key('media_loop_No.' + this.index)
        .id('buttonLoopModeEnd')
        .geometryTransition(this.getGeometryKey('buttonLoopMode'), this.getGeometryOptions())
      }
      this.playbackControl()

      // 快进和收藏
      if (this.isVideo) {
        Button({ stateEffect: this.isShowFastforward }) {
          SymbolGlyph($r(this.getSkipIntervalsIcon(true)))
            .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
            .fontColor(this.getIconColor(this.isShowFastforward))
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .opacity(this.isPC ? (this.isShowFastforward ? 1 : 0.3) : 1)
            .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.DOWN),
              this.isShowFastforward ? this.fastForwardTriggerValue : -1)
        }
        .onClick(() => {
          log.showInfo('Add this attribute to ensure that barrier-free reading is normal.');
          this.fastForwardTriggerValue++;
          this.clickFastForwardButton();
        })
        .type(ButtonType.Circle)
        .accessibilityLevel('yes')
        .accessibilityGroup(true)
        .accessibilityDescription(this.isShowFastforward ? '' : ResUtils.getInnerString($r('app.string.access_unavailable')))
        .accessibilityText(ResUtils.getInnerString($r('app.string.access_fast_forward')))
        .size({ width: Constants.COMMON_PICTURE_SIZE_LARGE, height: Constants.COMMON_PICTURE_SIZE_LARGE })
        .backgroundColor(Color.Transparent)
        .offset(playStyle.offsetRight)
        .key('media_fastforward_No.' + this.index)
        .geometryTransition(this.getGeometryKey('buttonForward'), this.getGeometryOptions())
        .id('media_fastforward_No.' + this.index)
      } else {
        Button({ stateEffect: this.isShowFavor }) {
          SymbolGlyph(this.isFavorite ? $r(ButtonIconName.FAVOR_FILL_SYMBOL) : $r(ButtonIconName.FAVOR_SYMBOL))
            .fontColor(this.getIconColor(this.isShowFavor))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .backgroundColor(Color.Transparent)
            .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.isShowFavor ? this.favorTriggerValue : -1)
        }
        .onClick(() => {
          log.showInfo('Add this attribute to ensure that barrier-free reading is normal.');
          this.clickFavorButton();
          setTimeout(() => {
            AccessibilityUtil.requestFocusAccessibility('buttonFavorEnd');
          }, 100)
        })
        .type(ButtonType.Circle)
        .accessibilityLevel('yes')
        .accessibilityGroup(true)
        .accessibilityDescription(this.isShowFavor ? '' : ResUtils.getInnerString($r('app.string.access_unavailable')))
        .accessibilityText(this.isFavorite ? ResUtils.getInnerString($r('app.string.access_Favorited')) :
          ResUtils.getInnerString($r('app.string.access_favorites')))
        .size({
          width: Constants.COMMON_PICTURE_SIZE_LARGE,
          height: Constants.COMMON_PICTURE_SIZE_LARGE
        })
        .backgroundColor(Color.Transparent)
        .offset(playStyle.offsetLeft)
        .key('media_favorite_No.' + this.index)
        .id('buttonFavorEnd')
        .geometryTransition(this.getGeometryKey('buttonFavor'), this.getGeometryOptions())
      }
    }
    .height(Constants.COMMON_PICTURE_SIZE_LARGE)
    .width('100%')
    .padding(playStyle.padding)
    .margin({top: this.isLandscapeLayout() && !this.isSmallPic ? 6 : 0})
  }

  /**
   * 上下一首和播放暂停
   */
  @Builder playbackControl() {
    // 上一首
    Button({ stateEffect: this.isShowPlayPrevious }) {
      AnimationIconLocal({ active: this.isShowPlayPrevious, scaleValue: 1.6 })
        .width(Constants.COMMON_PICTURE_SIZE_LARGE)
        .height(Constants.COMMON_PICTURE_SIZE_LARGE)
        .rotate({ centerX: '50%', centerY: '50%', angle: 180 })
    }
    .onClick(() => {
      log.showInfo('Add this attribute to ensure that barrier-free reading is normal.');
      this.clickPrevious();
    })
    .type(ButtonType.Circle)
    .accessibilityLevel('yes')
    .accessibilityGroup(true)
    .accessibilityDescription(this.isShowPlayPrevious ? '' : ResUtils.getInnerString($r('app.string.access_unavailable')))
    .accessibilityText(ResUtils.getInnerString($r('app.string.access_previous')))
    .size({
      width: Constants.COMMON_PICTURE_SIZE_LARGE,
      height: Constants.COMMON_PICTURE_SIZE_LARGE
    })
    .backgroundColor(Color.Transparent)
    .offset({ x: this.isLandscapeLayout() ? -6 : 0 })
    .key('media_previous_No.' + this.index)
    .geometryTransition(this.getGeometryKey('buttonPrevious'), this.getGeometryOptions())
    .id('media_previous_No.' + this.index)

    // 播放
    Button({ stateEffect: (this.isPlaying && this.isShowPause) || (!this.isPlaying && this.isShowPlay) }) {
      if (this.showPlayLoading && !this.isPC) {
        LoadingProgress()
          .size({ width: Constants.PLAY_BUTTON_SIZE, height: Constants.PLAY_BUTTON_SIZE })
          .color($r('app.color.media_control_icon_primary'))
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
      } else {
        SymbolGlyph(this.isPlaying ? $r(ButtonIconName.PAUSE_SYMBOL) : $r(ButtonIconName.PLAY_SYMBOL))
          .fontSize(Constants.PLAY_BUTTON_SIZE)
          .fontColor(this.getIconColor(this.isShowPause && this.isShowPlay))
          .rotate({ angle: this.isRTL() ? 180 : 0 })
          .backgroundColor(Color.Transparent)
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .opacity(this.isPC ? (this.isShowPlay ? 1 : 0.3) : 1)
          .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.isCanPlay ? this.playPauseTriggerValue : -1)
      }
    }
    .onClick(() => {
      log.showInfo('Add this attribute to ensure that barrier-free reading is normal.');
      this.clickPlayButton();
    })
    .type(ButtonType.Circle)
    .accessibilityLevel('yes')
    .accessibilityGroup(true)
    .accessibilityDescription(this.isShowPlay ? '' : ResUtils.getInnerString($r('app.string.access_unavailable')))
    .accessibilityText(this.isPlaying ? ResUtils.getInnerString($r('app.string.access_pause')) :
    ResUtils.getInnerString($r('app.string.access_play')))
    .size({
      width: Constants.COMMON_PICTURE_SIZE_LARGE,
      height: Constants.COMMON_PICTURE_SIZE_LARGE
    })
    .backgroundColor(Color.Transparent)
    .key('media_play_pause_No.' + this.index)
    .geometryTransition(this.getGeometryKey('buttonPlay'), this.getGeometryOptions())
    .id('media_play_pause_No.' + this.index)

    // 下一首
    Button({ stateEffect: this.isShowPlayNext }) {
      AnimationIconLocal({ active: this.isShowPlayNext, scaleValue: 1.6 })
        .width(Constants.COMMON_PICTURE_SIZE_LARGE)
        .height(Constants.COMMON_PICTURE_SIZE_LARGE)
    }
    .onClick(() => {
      log.showInfo('Add this attribute to ensure that barrier-free reading is normal.');
      this.clickNext();
    })
    .type(ButtonType.Circle)
    .accessibilityLevel('yes')
    .accessibilityGroup(true)
    .accessibilityDescription(this.isShowPlayNext ? '' : ResUtils.getInnerString($r('app.string.access_unavailable')))
    .accessibilityText(ResUtils.getInnerString($r('app.string.access_next')))
    .backgroundColor(Color.Transparent)
    .size({
      width: Constants.COMMON_PICTURE_SIZE_LARGE,
      height: Constants.COMMON_PICTURE_SIZE_LARGE
    })
    .offset({ x: this.isLandscapeLayout() ? 6 : 0 })
    .key('media_next_No.' + this.index)
    .geometryTransition(this.getGeometryKey('buttonNext'), this.getGeometryOptions())
    .id('media_next_No.' + this.index)
  }

  /**
   * 音量条
   */
  @Builder volumeControlBuilder(paddingStyle: StyleObject) {
    // 音量控制
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      Row() {
        SymbolGlyph($r(ButtonIconName.VOLUME_REDUCE_SYMBOL))
          .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
          .fontColor([$r('app.color.media_control_icon_disable')])
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .draggable(false)
      }
      .width(24)
      .justifyContent(FlexAlign.Start)
      .padding({ left: Constants.COMMON_MARGIN_SMALL })
      .id('mediaVolumeReduceEnd')
      .geometryTransition(this.getGeometryKey('mediaVolumeReduce'), this.getGeometryOptions())
      .transition(TransitionEffect.OPACITY)

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Slider({
          value: this.outSetValue,
          min: 0,
          max: Constants.VOLUME_SLIDER_MAX,
          step: 1,
          style: SliderStyle.InSet,
          direction: Axis.Horizontal
        })
          .trackColor(this.isPC ? $r('sys.color.comp_background_secondary') :
          $r('app.color.media_control_component_normal'))
          .blockColor(Color.Transparent)
          .selectedColor(this.isPC ? $r('sys.color.icon_emphasize') :
            $r('app.color.media_control_slider_primary'))
          .showSteps(false)
          .showTips(false)
          .blockStyle({
            type: SliderBlockType.SHAPE,
            shape: new Path({ commands: 'M60 60 M30 30 L15 56 L45 56 Z' })
          })
          .accessibilityText(Math.round(this.outSetValue * 2 / 3) + '%' + ' ' + ResUtils.getInnerString($r('app.string.access_media_volume_bar')))
          .trackThickness(this.volumeHeight)
          .onChange((value: number, mode: SliderChangeMode) => {
            log.showInfo(`slider onChange: ${value}, mode=${mode}`);
            switch (mode) {
              case SliderChangeMode.Begin:
                this.uiContext.animateTo({
                  duration: 300
                }, () => {
                  this.volumeHeight *= 2.5;
                });
                break;
              case SliderChangeMode.Moving:
                this.isButtonHolding = true;
                break;
              case SliderChangeMode.End:
                if (value <= 0) {
                  this.volumeHeight = 4;
                } else {
                  this.uiContext.animateTo({
                    duration: 300
                  }, () => {
                    this.volumeHeight = 4;
                  });
                }
                this.isButtonHolding = false;
                break;
              default:
                this.isButtonHolding = false;
                break;
            }
            this.outSetValue = value;
            this.mediaInfoProvider?.callVolumeChange(value, mode, this.sessionId);
          })
          .key('media_volume_slider_No.' + this.index)
      }
      .height(40)
      .width(this.getSliderWidth().volumeWidth)
      .margin({ left: 8, right: 8 })
      .backgroundColor(Constants.TRANSLUCENT_COLOR)
      .clip(true)
      .id('mediaVolumeEnd')
      .geometryTransition(this.getGeometryKey('mediaVolume'), this.getGeometryOptions())
      .transition(TransitionEffect.OPACITY)

      Row() {
        SymbolGlyph($r(ButtonIconName.VOLUME_ADD_SYMBOL))
          .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
          .fontColor([$r('app.color.media_control_icon_disable')])
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .draggable(false)
      }
      .width(24)
      .justifyContent(FlexAlign.End)
      .id('mediaVolumeAddEnd')
      .geometryTransition(this.getGeometryKey('mediaVolumeAdd'), this.getGeometryOptions())
      .transition(TransitionEffect.OPACITY)
    }
    .width('100%')
    .height(40)
    .padding(paddingStyle)
    .margin({ top: this.isLandscapeLayout() && !this.isSmallPic ? 6 : 0 })
    .opacity(this.fadeOpacity)
  }

  /**
   * 设置投播音量
   * @param gestureType
   * @param actionType
   */
  setCastVolume(gestureType: InputGestureType, actionType: InputVolumeAction) {
    if (this.isQuiting) {
      return;
    }
    let curTime = new Date().getTime();
    const timeOut = gestureType === InputGestureType.TOUCH ? Constants.SOUND_LONG_PRESS_SPLIT : 500;
    if (this.touchCastVolumeTime && curTime - this.touchCastVolumeTime < timeOut) {
      return;
    }
    if (gestureType === InputGestureType.TOUCH) { // 点击事件
      log.showInfo(`touch callCastVolumeChange`);
      this.touchCastVolumeTime = curTime;
    } else { // 长按事件
      log.showInfo(`longPress callCastVolumeChange`);
      this.touchCastVolumeTime = undefined;
    }
    this.mediaInfoProvider?.callCastVolumeChange(this.sessionId, actionType);
  }

  /**
   * 音量按钮
   * @param icon
   * @param type
   * @param geometryId
   */
  @Builder volumeCastButton(type: InputVolumeAction, geometryId: string, icon: Resource) {
    Button({ type: ButtonType.Capsule, stateEffect: true}) {
      SymbolGlyph(icon)
        .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
        .backgroundColor(Constants.TRANSLUCENT_COLOR)
        .fontColor([$r('app.color.media_control_icon_primary')])
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .draggable(false)
    }
    .height(40)
    .width(120)
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .id(geometryId + 'End')
    .geometryTransition(this.getGeometryKey(geometryId), this.getGeometryOptions())
    .accessibilityLevel('yes')
    .accessibilityGroup(true)
    .accessibilityText(ResUtils.getInnerString(type === InputVolumeAction.PLUS ? $r('app.string.access_av_cast_volume_increase') :
      $r('app.string.access_av_cast_volume_reduce')))
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        TapGesture()
          .onAction(() => {
            this.setCastVolume(InputGestureType.TOUCH, type);
          }),
        LongPressGesture({ repeat: true, duration: Constants.SOUND_LONG_PRESS_SPLIT })
          .onAction((event?: GestureEvent) => {
            // 长按标记,延迟更新音量
            AppStorage.setOrCreate('soundLongPress', true);
            if (this.enableDc) {
              this.dcController?.setAppStorage('soundLongPress', true);
            }
            this.setCastVolume(InputGestureType.LONG_PRESS, type);
          })
          .onActionEnd(() => {
            // 延迟删除长按标志
            this.setVolumeTimer();
          })
          .onActionCancel(() => {
            // 延迟删除长按标志
            this.setVolumeTimer();
          })
      )
    )
  }

  /**
   * 投播音量控制
   * @param paddingStyle
   */
  @Builder volumeCastBuilder(paddingStyle: StyleObject) {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      this.volumeCastButton(InputVolumeAction.MINUS, 'mediaVolumeReduce',
        $r(AVCastPickerDeviceIconName.SOUND_MINUS_SYMBOL))
      this.volumeCastButton(InputVolumeAction.PLUS, 'mediaVolumeAdd',
        $r(AVCastPickerDeviceIconName.SOUND_PLUS_SYMBOL))
    }
    .width('100%')
    .height( 40)
    .padding(paddingStyle)
    .opacity(this.fadeOpacity)
  }

  @Builder backgroundBuilder() {
    Column()
      .backgroundColor(this.isPC ? Constants.TABLET_WINDOW_BACKGROUND_COLOR : $r('app.color.media_control_card_bgc'))
      .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
      .saturate(this.isPC ? 1.7 : 1)
      .shadow(this.isPC ? {
        radius: Constants.TABLET_WINDOW_SHADOW_RADIUS,
        color: Constants.TABLET_WINDOW_SHADOW_COLOR,
        offsetX: Constants.TABLET_WINDOW_SHADOW_OFFSET_X,
        offsetY: Constants.TABLET_WINDOW_SHADOW_OFFSET_Y,
      } : { radius : 0})
      .width(this.panelWidth)
      .height(this.panelHeight)
      .borderRadius(ControlCenterPluginMgr.isPcMode ?
        Constants.MEDIA_CARD_BORDER_RADIUS_PC_MODE : Constants.MEDIA_CARD_BORDER_RADIUS)
      .border({
        width: this.isPC ? 1 : 0,
        color: this.isPC ? '#33FFFFFF' : '#00000000',
      })
      .backdropBlur(this.isPC ? 60 : 0)
      .opacity(this.cardStackController?.mediaBoxOpacity)
      .id('mediaPanelEnd')
      .geometryTransition('mediaPanel', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
  }

  private getRenderingStrategy(iconName: string): SymbolRenderingStrategy {
    if (iconName === AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL ||
      iconName === AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL) {
      return SymbolRenderingStrategy.SINGLE;
    }
    return SymbolRenderingStrategy.MULTIPLE_OPACITY;
  }

  @Builder headerBuilder() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center}) {
      Row() {
        Text(this.firstColumnTextConst)
          .fontColor($r('app.color.media_control_text_primary'))
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .fontWeight(this.isPC && !this.isShowDev ? FontWeight.Bold : FontWeight.Medium)
          .fontSize(this.isPC ? (!this.isShowDev ? 24 : 16) : $r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(this.titleMaxFontScale)
          .transition(TransitionEffect.OPACITY.animation({
            duration: 333,
            curve: Curve.Friction
          }))
          .padding({ right: this.isRTL() ? 24 : 0 })
          .accessibilityLevel('yes')
          .accessibilityGroup(true)
          .id('media_card_first_Column_Text')
        if (this.isShowButtonIcon) {
          Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.SpaceBetween,
            alignItems: ItemAlign.Center
          }) {
            Image($r('app.media.device_switch_point'))
              .draggable(false)
              .size({ width: 4, height: 4 })
              .fillColor(this.isPC ? $r('app.color.black') : $r('app.color.media_control_ponit'))
              .opacity(this.pointOpacityFirst)
            Image($r('app.media.device_switch_point'))
              .draggable(false)
              .size({ width: 4, height: 4 })
              .fillColor(this.isPC ? $r('app.color.black') : $r('app.color.media_control_ponit'))
              .opacity(this.pointOpacitySecond)
            Image($r('app.media.device_switch_point'))
              .draggable(false)
              .size({ width: 4, height: 4 })
              .fillColor(this.isPC ? $r('app.color.black') : $r('app.color.media_control_ponit'))
              .opacity(this.pointOpacityThird)
          }
          .width(18)
          .margin({ left: 6, right: 6 })
          Text(this.curOutputDev.deviceName)
            .fontColor($r('app.color.media_control_text_primary'))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(this.titleMaxFontScale)
            .maxLines(1)
            .wordBreak(WordBreak.BREAK_ALL)
            .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .accessibilityLevel('yes')
            .accessibilityGroup(true)
        }
      }
      .height('100%')
      .alignItems(VerticalAlign.Center)
      .layoutWeight(1)
      .flexGrow(1)
      .key('media_card_title')
      .id('mediaCardTitleEnd')
      .geometryTransition('mediaCardTitle', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
      .opacity(this.fadeOpacity)

      Button({ stateEffect: false }) {
        Column() {
          SymbolGlyph($r(this.curSwitchIcon))
            .fontSize(Constants.COMMON_CAST_SMALL_SIZE)
            .backgroundColor(Constants.TRANSLUCENT_COLOR)
            .fontColor(this.isShowButtonIcon ?
              [$r('app.color.media_control_switch_active_full')] : [$r('app.color.media_control_switch_full')])
            .foregroundBrightness(this.colorModeViewData.getPrimaryFgOption(this.isShowButtonIcon))
            .draggable(false)
            .renderingStrategy(this.getRenderingStrategy(this.curSwitchIcon))
        }
        .width(Constants.COMMON_SWITCH_SIZE)
        .height(Constants.COMMON_SWITCH_SIZE)
        .borderRadius(120)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.isShowButtonIcon ?
          $r('app.color.media_control_switch_active_bgc') : (this.colorModeViewData.isBrightnessActive ?
            $r('app.color.media_control_color_brightness') : $r('app.color.media_control_component_normal')))
        .backgroundBrightnessInternal(this.colorModeViewData.getTopOption(this.isShowButtonIcon))
        .id('switchIconEnd')
        .geometryTransition('switchIcon', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
        .key('showing_switch_for_media')
      }
      .backgroundColor(Color.Transparent)
      .accessibilityGroup(true)
      .onClick(() => {
        this.clickCurSwitchIcon();
        this.currentIndexChange();
      })
      .accessibilityLevel('yes')
      .accessibilityText(ResUtils.getInnerString($r('app.string.access_audio_control')))
      .height('100%')
      .width(Constants.COMMON_SWITCH_SIZE + 24)
      .margin({left: this.isRTL() ? -12 : 0, right: this.isRTL() ? 0 : 12})
      .id('mediaSwitchIcon')
    }
    .width('100%')
    .height(Constants.COMMON_PICTURE_SIZE + 24)
    .padding({ left: 24 })
    .margin({})
    .zIndex(2)
  }

  @Builder
  tabsSwiper() {
    Swiper(this.swiperController) {
      Text()
        .width('100%')
        .height(24)

      Text()
        .width('100%')
        .height(24)
    }
    .indicatorInteractive(false)
    .disableSwipe(false)
    .autoPlay(false)
    .loop(false)
    .indicator(
      new DotIndicator()
        .itemWidth(6)
        .itemHeight(6)
        .selectedItemWidth(12)
        .selectedItemHeight(6)
        .color($r('app.color.dot_color'))
        .selectedColor($r('app.color.dot_selected_color'))
        .top(18)
    )
    .width('100%')
    .height(24)
    .onVisibleAreaChange([0, 1.0], (isVisible, currentRatio) => {
      if (isVisible && currentRatio >= 1.0) {
        log.showInfo(`currentIndex ${this.currentIndex}`)
        this.swiperController.changeIndex(this.currentIndex)
      }
    })
    .id('swiperEnd')
    .geometryTransition(this.getGeometryKey('swiper'), this.getGeometryOptions())
    .visibility(this.isShowDev || this.isSmallPic ? Visibility.Hidden : Visibility.Visible)
    .zIndex(1)
    .transition(this.getSwiperTransitionEffect())
  }

  getSwiperTransitionEffect(): TransitionEffect {
    if (this.mediaTransitionFlag > 0 ) {
      return TransitionEffect.OPACITY;
    }
    return TransitionEffect.opacity(0).animation({ curve: Curve.Sharp, duration: 100 });
  }

  // 横屏布局
  @Builder
  landscapeLargeMediaInfoCardBuilder() {
    Column() {
      if (this.isExistAvQueueInfo && (this.getMusicAuthorBoolean() || this.isListItemClicked)) {
        this.tabsSwiper();
      } else {
        Column().width('100%').height(24)
      }

      Row() {
        Stack() {
          Column() {
            Column().width('50%').height(24).geometryTransition('songBox', this.getGeometryOptions())
            Column().width('50%').height(16).geometryTransition('textPlayBox', this.getGeometryOptions())
          }
          .margin({ top: this.getMusicAuthorBoolean() ? 150 : 0 })
          .zIndex(-1)

          if (!this.checkShowDev()) {
            Stack() {
              if (this.currentIndex === 0 && !this.getMusicAuthorBoolean()) {
                Stack({ alignContent: Alignment.BottomEnd }) {
                  Column().width('100%').height('100%')
                    .geometryTransition('mediaImgBg', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                  Column().width('100%').height('100%')
                    .geometryTransition('mediaImg', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                  Column().width('100%').height('100%')
                    .geometryTransition('defaultBg', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                  Column().width('100%').height('100%')
                    .geometryTransition('defaultImg', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                  Column().width(Constants.COMMON_PICTURE_SIZE_BIG).height(Constants.COMMON_PICTURE_SIZE_BIG)
                    .geometryTransition('publicIcon', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                }
                .width(Constants.LANDSCAPE_CONTROLLER_WIDTH)
                .height(this.getTabsHeight())
                .zIndex(-1)
              }
              this.recentlyPlayAndBigImageBuilder('LandscapeLarge');
            }
            .transition(this.getRecentlyPlayTransitionEffect())
          }
          Column() {

          }
          .width(this.isShowDev ? 0 : Constants.LANDSCAPE_CONTROLLER_WIDTH)
          .height(Constants.LANDSCAPE_CONTROLLER_HEIGHT)
          .zIndex(-1)
        }
        .width(this.isShowDev ? 0 : Constants.LANDSCAPE_CONTROLLER_WIDTH)
        .visibility(this.isSmallPic ? Visibility.None : Visibility.Visible)

        Column() {
          Column() {
            this.headerBuilder();
          }
          .margin({ top: -12 })

          Stack({ alignContent : Alignment.Start }) {
            if (this.isShowDev || (this.getMusicAuthorBoolean() && this.currentIndex === 0)) {
              Stack() {
                this.MediaImg('LandscapeSmall')
                // 右下角小图标
                this.SmallPicIcon('LandscapeSmall');
              }
              .backgroundColor(Constants.TRANSLUCENT_COLOR)
              .width(Constants.COMMON_PICTURE_SIZE_LARGE)
              .height(Constants.COMMON_PICTURE_SIZE_LARGE)
              .transition(this.getLandSmallImageTransitionEffect())
            }
            Row() {
              Column()
                .height(Constants.COMMON_PICTURE_SIZE_LARGE)
                .width(this.landSmallImageBlankWidth)
                .transition(this.getLandSmallImageTransitionEffect())

              Column() {
                if (this.getMusicAuthorBoolean()) {
                  this.SongName('LandscapeLarge')
                  // 副标题或者歌手或者歌词
                  this.SubtitlesAndLyrics('LandscapeLarge')
                } else if (!this.isPC) {
                  this.NotPlaying('LandscapeLarge')
                }
              }
              .width(`calc(100% - ${Constants.COMMON_PICTURE_SIZE_LARGE + 8}vp)`)
            }
            .alignItems(VerticalAlign.Top)
            .height(this.getNotPlayingHeight())
            .width('100%')
            .key('media_music_info_No.' + this.index)
          }
          .padding({ left: 24, right: 24 })
          .onClick((event: ClickEvent) => {
            this.jumpToApp(this.sessionId);
          })

          Stack() {
            Column() {
              Column().width('100%').height(24).geometryTransition('songBox', this.getGeometryOptions())
              Column().width('100%').height(16).geometryTransition('textPlayBox', this.getGeometryOptions())
            }
            .zIndex(-1)
            Column() {
              this.progressStack('LandscapeLarge')
              this.playbackControlBuilder({ padding: { left: 12, right: 12 }, offsetLeft: { x: 0 },
                offsetRight: { x: 0 } })
              if (this.showVolumeButton) {
                this.volumeCastBuilder({ left: 24, right: 24 })
              } else {
                this.volumeControlBuilder({
                  left: 24, right: 24,
                  bottom: 0,
                })
              }
            }
          }
        }
        .width(Constants.LANDSCAPE_CONTROLLER_WIDTH)
        .height(Constants.LANDSCAPE_CONTROLLER_HEIGHT)
        .margin({
          left: this.isShowDev ? 0 : this.isRTL() ? 0 : -24,
          right: this.isShowDev ? 0 : this.isRTL() ? -24 : 0
        })
      }
    }
  }

  /**
   * 竖屏小图模式
   */
  @Builder portraitSmallImageBuilder() {
    Stack() {
      Row() {
        Stack() {
          this.MediaImg('PortraitSmall')
          // 右下角小图标
          this.SmallPicIcon('PortraitSmall');

          Row().width(1).height(0)
            .id('goldFlagSmall')
            .geometryTransition(this.getGeometryKey('goldFlag'), this.getGeometryOptions())
        }
        .alignContent(Alignment.Center)
        .backgroundColor(Constants.TRANSLUCENT_COLOR)
        .width(Constants.COMMON_PICTURE_SIZE_LARGE)
        .height(Constants.COMMON_PICTURE_SIZE_LARGE)

        Column() {
          if (this.getMusicAuthorBoolean()) {
            this.SongName('PortraitSmall')
            // 副标题或者歌手或者歌词
            this.SubtitlesAndLyrics('PortraitSmall')
          } else {
            this.NotPlaying('PortraitSmall')
          }
        }
        .onAreaChange((oldArea, newValue) => {
          this.songNameAreaWidthCast = newValue.width as number;
        })
        .height(this.getNotPlayingHeight())
        .width(`calc(100% - ${Constants.COMMON_PICTURE_SIZE_LARGE}vp)`)
        .padding({ left: this.isRTL() ? 0 : 12,
          right: this.isRTL() ? 12 : 0})
        .transition(this.getSmallSongInfoTransitionEffect())
      }
      .alignItems(VerticalAlign.Top)
      .padding({ left: 24, right: 24 })
      .height(this.getNotPlayingHeight())
      .width('100%')
      .onClick((event: ClickEvent) => {
        this.jumpToApp(this.sessionId);
      })
      .key('media_music_info_No.' + this.index)

      Column() {
        if (this.getMusicAuthorBoolean()) {
          Column()
            .width('100%')
            .height(MeasuringUtil.getHeight(16, 24, this.textMaxFontScale, this.getFontSizeScale()))
            .geometryTransition('songBoxPortraitLarge', this.getGeometryOptions())
          Column()
            .width('100%')
            .height(MeasuringUtil.getHeight(14, 20, this.textMaxFontScale, this.getFontSizeScale()))
            .geometryTransition('textPlayBoxPortraitLarge', this.getGeometryOptions())
        } else {
          Column()
            .width('100%')
            .height(MeasuringUtil.getHeight(14, 20, this.textMaxFontScale, this.getFontSizeScale()))
            .geometryTransition('textPlayBoxPortraitLarge', this.getGeometryOptions())
        }
      }
      .width(`calc(100% - ${Constants.COMMON_PICTURE_SIZE_LARGE}vp)`)
      .zIndex(-1)
    }
    .width('100%')
  }

  @Builder bodyBuilder() {
    Flex({direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center}) {
      if (this.isLandscapeLayout() && !this.isSmallPic) { // 横屏（排除通话场景小图）
        this.landscapeLargeMediaInfoCardBuilder();
      } else {
        Stack({ alignContent: Alignment.Top }) {
          Column() {
            if (!this.isLandscapeLayout() || this.isSmallPic) {
              Stack({ alignContent: Alignment.Top  }) { // 解决层叠关系投音按钮点不到问题
                this.headerBuilder()
                if (this.isExistAvQueueInfo && (this.getMusicAuthorBoolean() || this.isListItemClicked)) {
                  Column() {
                    Column().width('100%').height(this.isShowDev || this.hasCall ? 24 : 32)
                    this.tabsSwiper();
                  }
                  .clip(false)
                }
              }
              .height(this.isShowDev || this.hasCall ? 48 : 56)
            }
            if ((this.currentIndex === 1 ? this.isShowDev : this.checkShowDev()) || this.isSmallPic) {
              // 竖屏小图（包含通话场景小图）
              Column() {
                this.portraitSmallImageBuilder();
              }
              .height(this.isShowDev || this.isSmallPic ? this.getNotPlayingHeight() : 0)
              .transition(this.getSmallImageTransitionEffect())
            } else {
              // 竖屏大图
              Stack() {
                if (this.currentIndex === 0) {
                  Stack({ alignContent: Alignment.BottomEnd }) {
                    Column().width('100%').height('100%')
                      .geometryTransition('mediaImgBg', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                    Column().width('100%').height('100%')
                      .geometryTransition('mediaImg', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                    Column().width('100%').height('100%')
                      .geometryTransition('defaultBg', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                    Column().width('100%').height('100%')
                      .geometryTransition('defaultImg', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                    Column().width(Constants.COMMON_PICTURE_SIZE_BIG).height(Constants.COMMON_PICTURE_SIZE_BIG)
                      .geometryTransition('publicIcon', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                    if (this.getMusicAuthorBoolean()) {
                      Column().width('100%').height(this.getNotPlayingHeight())
                        .geometryTransition('textPlayBox', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                      Column().width('100%').height(this.getNotPlayingHeight())
                        .geometryTransition('songBox', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
                    }
                  }
                  .height(this.isShowDeviceAnim ? 0 : this.getMusicAuthorBoolean() ?
                    Constants.PORTRAIT_RECENTLY_CARD_HEIGHT + this.getMediaTextInfoHeight() :
                  Constants.PORTRAIT_RECENTLY_CARD_HEIGHT)
                  .zIndex(-1)
                }

                Column() {
                  this.recentlyPlayAndBigImageBuilder('PortraitLarge');
                }
                .width('100%')
                .margin({} )
                .height(this.isShowDev ? 0 : this.getMusicAuthorBoolean() ?
                Constants.PORTRAIT_RECENTLY_CARD_HEIGHT + this.getMediaTextInfoHeight() :
                Constants.PORTRAIT_RECENTLY_CARD_HEIGHT)
              }
              .height(this.isShowDev ? 0 : this.getMusicAuthorBoolean() ?
                Constants.PORTRAIT_RECENTLY_CARD_HEIGHT + this.getMediaTextInfoHeight() :
              Constants.PORTRAIT_RECENTLY_CARD_HEIGHT)
              .transition(this.getRecentlyPlayTransitionEffect())
            }

            if (!this.getMusicAuthorBoolean() && !this.checkShowDev() && !this.isSmallPic) {
              Column() {
                this.NotPlaying('PortraitLarge')
              }
              .onAreaChange((oldArea, newValue) => {
                this.songNameAreaWidthNoCast = newValue.width as number;
              })
              .width('100%')
              .height(this.getMediaTextInfoHeight())
              .padding({ left: 24, right: 24 })
              .margin({ top: 8 })
              .transition(this.getPortraitLargeTextInfoTransition())
            }
          }

          Column() {

          }
          .width(this.panelWidth)
          .height(this.isShowDev || this.isSmallPic ? this.getMediaTextInfoHeight() + Constants.TITLE_LAYOUT_HEIGHT :
              Constants.PORTRAIT_RECENTLY_CARD_HEIGHT + this.getMediaTextInfoHeight() + Constants.TITLE_LAYOUT_HEIGHT +
              Constants.TEXT_INFO_MARGIN_TOP
          )
          .zIndex(-1)
        }
        
        this.progressStack(this.isShowDev || this.isSmallPic ? 'PortraitSmall' : 'PortraitLarge')
        this.playbackControlBuilder({ padding: { left: 12, right: 12 }, offsetLeft: { x: 0 }, offsetRight: { x: 0 } })
        if (this.showVolumeButton) {
          this.volumeCastBuilder({ left: 24, right: 24 })
        } else {
          this.volumeControlBuilder({ left: 24, right: 24, bottom:  0 })
        }
      }
    }
    .key('media_item_No.0')
    .onTouch((event: TouchEvent) => {
      if (this.isButtonHolding || event?.type !== TouchType.Up) {
        return;
      }
    })
  }

  getMediaCardTransition(): TransitionEffect {
    if (!this.isSmallPic) {
      return TransitionEffect.IDENTITY;
    }
    if (this.mediaTransitionFlag > 0 || this.isQuiting) {
      const transOptions: TranslateOptions = this.isLandscapeLayout() ?
        { x: (2 * Constants.PANEL_LANDSCAPE_WIDTH - this.panelWidth) / -4 - Constants.PANEL_LANDSCAPE_GEOM_OFFSET_X ,
          y: this.panelHeight / -4 } :
        { x: this.isPad ? this.panelWidth / -4 + Constants.PANEL_PAD_GEOM_OFFSET_X : this.panelWidth / -4,
          y: this.isPad ? this.panelHeight / -2.5 : this.panelHeight / -1.5 };
      const scaleOptions: ScaleOptions = this.isLandscapeLayout() ?
        { x: 0.5, y: 0.5, z: 0.5 } : { x: 0.46, y: 0.46, z: 0.46 };
      const opacityAnimation: AnimateParam = this.isQuiting ?
        { duration: 100, curve: Curve.Sharp } :
        { duration: 100, curve: Curve.Sharp, delay: 50 };
      return TransitionEffect.translate(transOptions)
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
        .combine(TransitionEffect.opacity(0).animation(opacityAnimation))
        .combine(TransitionEffect.scale(scaleOptions)
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
    }
    const translateY: number = this.isLandscapeLayout() ? this.panelHeight / -4:
      this.callDeviceListHeight * Constants.CALL_CARD_HEIGHT_ANIM_RATIO;
    return TransitionEffect.translate({y: translateY})
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0)
        .animation({ duration: 150, curve: Curve.Sharp }))
      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
  }

  checkShowDev() {
    return this.isSmallPic ? this.isShowDev : this.isShowDeviceAnim;
  }

  build() {
    if (!this.checkShowDev() || this.showDevType === ShowDevType.MEDIA) {
      Stack({ alignContent: Alignment.Top }) {
        this.systemSceneBgBuilder();
        this.backgroundBuilder();
        Column() {
          this.bodyBuilder()
        }
        .width(this.panelWidth)
        .height(this.panelHeight)
      }
      .width(this.panelWidth)
      .height(this.panelHeight) // Stack对齐方式Alignment.Top需要设置高度，避免动效闪烁
      .clip(false)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        let cardHeight = Number(newValue.height);
        if (cardHeight === 0 || cardHeight === this.playbackCardHeight) {
          return;
        }
        this.playbackCardHeight = cardHeight;
        log.showInfo(`playbackCardHeight change: ${cardHeight}`);
      })
      .opacity(this.cardStackController?.mediaBoxOpacity)
      .key('media_card')
      .onTouch((event?: TouchEvent) => {
        event?.stopPropagation();
      })
      .transition(this.getMediaCardTransition())
    } else {
      Column().width(this.panelWidth)
    }
  }
}