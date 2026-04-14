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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { PluginSlot } from '@ohos/frameworkwrapper/src/main/ets/plugin/PluginConstants';
import { ViewType, viewMgrPolicy } from '@ohos/frameworkwrapper/src/main/ets/manager/view/ViewManagerPolicy';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { PluginPosition } from '@ohos/frameworkwrapper/src/main/ets/plugin/PluginConstants';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import Constants, {
  LocalDeviceInfo,
  DeviceSource,
  AVQueueInfo,
  IconStyleTS,
  DeviceState,
  StyleObj,
  StyleObjForCall,
  FoldHeight,
  AVCastPickerDeviceIconName,
  ButtonIconName,
  CastingSessionInfo,
  CallSessionInfo,
  ShowDevType,
  AVQueueShowState,
  AVQueueOperatingMode,
  RecommendMoreInfo,
} from '../../Util/Constants';
import display from '@ohos.display';
import audio from '@ohos.multimedia.audio';
import image from '@ohos.multimedia.image';
import screen from '@ohos.screen';
import AVSessionManager from '@ohos.multimedia.avsession';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { DcMediaController } from '../../Controller/DcMediaController';
import { CastDeviceControl } from '../../Controller/CastDeviceControl';
import { CastDeviceControlDc } from '../../Controller/CastDeviceControlDc';
import { DeviceListCard } from './DeviceListCard';
import { MediaInfoCard } from './MediaInfoCard';
import { CallInfoCard } from './CallInfoCard';
import MediaInfoProvider from '../../Controller/MediaInfoProvider';
import { MediaInfoProviderDc } from '../../Controller/MediaInfoProviderDc';
import CommunicationUtil from '../../Util/CommunicationUtil';
import { globalStorage } from '../../Util/GlobalStorage';
import { CardStackControl } from '../../Controller/CardStackControl';
import Curves from '@ohos.curves';
import MeasuringUtil from '../../Util/MeasuringUtil';
import window from '@ohos.window';
import { CardMediaController } from '../../Controller/CardMediaController';
import { LocalEventCallback } from '../../Util/LocalEventCallBack';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';
import mediaquery from '@ohos.mediaquery';
import CommonUtils from '../../Util/CommonUtils';
import ImageDownloaderUtils from '../../Util/ImageDownloaderUtils';
import { DefaultPanelZIndex } from '@ohos/systemuicommon/src/main/ets/base/common/info/DefaultPanelZIndex';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { SystemUIColorVm } from '@ohos/systemuicommon/src/main/ets/vm/SystemUIColorVm';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/plugin/info/StatusBarType';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG: string = 'ListDialog_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
// 系统弹框的是1902,为保证指纹验证功能正常，需要将播控中心层级临时调整1901，完成之后还原
const DROP_CONTROL_LEVEL: number = 1901;
const DISABLE_TOAST: string = 'DISABLE_TOAST';
const SHOW_TOAST: string = 'SHOW_TOAST';

interface pageParameters {
  message?: string;
}

@Component
export struct ListDialog {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private isPC: boolean = DeviceHelper.isPC() && !ControlCenterPluginMgr.isPcMode;
  private isPad: boolean = DeviceHelper.isPad();
  private isPhone: boolean = DeviceHelper.isPhone();
  @Link @Watch('showDevChange') isShowDev: boolean;
  @Link isShowDeviceAnim: boolean;
  @State showDevStartTime: number = 0;
  @Link showAnimateDone: boolean; // 初始化动效是否执行完毕
  public disappear:() =>void = () => {};
  private mediaInfoProvider: MediaInfoProvider | MediaInfoProviderDc = this.enableDc ?
    MediaInfoProviderDc.getInstance() : MediaInfoProvider.getInstance(); // 开启worker时，使用DC子线程provider
  private dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  @StorageLink('PlayStateMap') @Watch('playStateUpdate') playStateMap:
    Map<string, AVSessionManager.AVPlaybackState> = new Map();
  // 设备列表
  @StorageLink('MergedDeviceList') @Watch('onDevicesUpdated') mergedDeviceList: Array<LocalDeviceInfo> = [];
  @StorageLink('CurDeviceSelect') @Watch('playStateUpdate') curOutputDevice: LocalDeviceInfo = {
    deviceType: audio.DeviceType.SPEAKER,
    deviceId: 0,
    deviceName: 'xxx',
    deviceSource: DeviceSource.LOCAL,
    networkId: 'LocalDevice',
  };
  @StorageLink('callDeviceList') @Watch('onDevicesUpdated') callDeviceList: Array<LocalDeviceInfo> = [];
  @StorageLink('curCallDevice') @Watch('callStateUpdate') curCallDevice: LocalDeviceInfo = {
    deviceType: audio.DeviceType.SPEAKER,
    deviceId: 0,
    deviceName: 'xxx',
    deviceSource: DeviceSource.LOCAL,
    networkId: 'LocalDevice',
  };
  @StorageLink('CurRemoteDevSelect') curRemoteOutputDev : number = -1;

  @StorageLink('StartDone') isStartDone: boolean = false;
  @StorageLink('sessionList') @Watch('onSessionListUpdated') sessionList: Array<string> = [];
  @StorageLink('firstColumnTextConst') firstColumnTextConst: Resource | string = $r('app.string.LocalDevice');
  @StorageLink('CurSessionId') @Watch('sessionIdChanged') private curSessionId: string = this.sessionList[0] || '';
  @State sessionListBIG: Array<string> = [];
  @State curForceMedia: number = 0;
  @StorageLink('isLandscape') @Watch('landscapeChanged') isLandscape: boolean = false;
  private listener: mediaquery.MediaQueryListener =
    this.getUIContext().getMediaQuery().matchMediaSync('(orientation: landscape)');
  @State private playCardTopMargin: number = 0; // 卡片初始位置

  @State screenHeight: number = 0; // 屏幕高度
  @State panelWidth: number = 0;
  @State panelHeight: number = 0;
  @StorageLink('isFriction') private isFriction: boolean = false; // 弹簧动画开关
  @StorageLink('isDisplay') private isDisplay:boolean = false;
  @StorageLink('isStartPlaying') private isStartPlaying:boolean = false;
  private avQueueColdId: string = '';
  private preOrNextOperateTimeStamp: number | null = null;
  @State isVideo: boolean = false;
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  // 播放动画
  @State timerId: number | undefined = undefined; //动画的定时器
  @State pointMediaOpacityFirst: number = 0.1; // 播放动画透明度1
  @State pointMediaOpacitySecond: number = 0.1; // 播放动画透明度2
  @State pointMediaOpacityThird: number = 0.1; // 播放动画透明度3

  // 通话卡片动画
  @State callTimerId: number | undefined = undefined;
  @State pointCallOpacityFirst: number = 0.1;
  @State pointCallOpacitySecond: number = 0.1;
  @State pointCallOpacityThird: number = 0.1;

  // 原栅格布局拿数据
  @StorageLink('commandEnableMap') commandEnableMap: Map<string, Array<AVSessionManager.AVControlCommandType>> =
    new Map<string, Array<AVSessionManager.AVControlCommandType>>();
  @StorageLink('MetaDataMap') @Watch('metaDataUpdate') metaDataMap: Map<string, AVSessionManager.AVMetadata> =
    new Map<string, AVSessionManager.AVMetadata>();
  @StorageLink('appNameMap') @Watch('appNameChange') appNameMap: Map<string, string> = new Map<string, string>();

  // 设备列表
  @State private castDeviceControl: CastDeviceControl | CastDeviceControlDc | undefined = undefined;
  private scroller: Scroller = new Scroller()
  @State @Watch('updateTopMarginByState') playbackCardHeight: number = 241;
  @State @Watch('updateTopMarginByState') isHasTitle: boolean = AppStorage.has('tempMediaTitle');
  @State @Watch('updateTopMarginByState') deviceListHeight: number = Constants.DEVICE_ITEM_HEIGHT +
    Constants.DEVICE_LIST_BOTH_PADDING; // 本机默认高度 + 上下padding
  @State @Watch('updateTopMarginByState') callDeviceListHeight: number = Constants.DEVICE_ITEM_HEIGHT +
    Constants.DEVICE_LIST_BOTH_PADDING; // 本机默认高度 + 上下padding
  @State @Watch('onIsExpand') isExpand: boolean = false; // 控制是否展开
  @State hideDeviceScroll: boolean = false; // 是否隐藏设备列表滚动条
  private expandAnimation: boolean = false; // 控制中心弹簧动效
  @State private displayDeviceList: Array<LocalDeviceInfo> = []; // 可信设备列表
  @State private maxDeviceListHeight: number = 0;
  @State isArrowActive: boolean = true;
  // 通话卡片
  @State @Watch('updateTopMarginByState') callCardHeight: number = Constants.CALL_CARD_HEIGHT;
  // 偏好设置页是否展示：立即体验|选择偏好
  @StorageLink('isPreferenceShow') isShowPrefer: boolean = false;

  // 折叠屏变量
  @State isFoldDevice: boolean = false; // 是否为折叠屏
  @State foldTotalHeight: number = 0;
  @State isCenter: boolean = true;
  // 历史歌单
  private timeoutID: number | null = null;
  @State albumInfoListIsData: boolean = false; // 根据数组大小判断卡片是否显示
  @State isClick: boolean = false; // 点击历史歌单 显示/隐藏 加载loading
  @State hasStart: boolean = false;
  @State hasFinished: boolean = true;
  @State @Watch('listDataChanged') albumInfoListNew: Array<AVQueueInfo> = [];
  @State bigImageDataTemp: AVSessionManager.AVMetadata = { assetId: '' };
  @State isDeviceStack: boolean = false;
  @State indexTmp: number = -1;
  private metaDataTemp: AVSessionManager.AVMetadata = { assetId: '' };
  private metaDataTempHis: AVSessionManager.AVMetadata = { assetId: '' };
  @State loadingProgressOpacity: number = 0;
  @State maskBlur:number = 0;
  @StorageLink('clickAVQueueTime') clickAVQueueTime: number = 0;
  @State secondDataLength: number = 0;
  @StorageLink('castingSessionInfo') @Watch('castSessionChange') castSession: CastingSessionInfo | undefined = undefined;
  private castSessionChangeCallback: LocalEventCallback | undefined = undefined;
  @StorageLink('appIconMap') appIconMap: Map<string, image.PixelMap> = new Map();
  @Consume('isQuiting') isQuiting: boolean;
  @Consume('isJumping') isJumping: boolean;

  // 009历史歌单动效参数
  @State canStartAnimate: boolean = false;
  @State startSlideAnimate: boolean = false; //歌单位移动画开始

  @State cardStackController: CardStackControl | undefined = new CardStackControl(); // 卡片

  // 通话卡片
  @StorageLink('hasCall') @Watch('hasCallUpdated') hasCall: boolean = false;
  @StorageLink('callSessionInfo') callSession: CallSessionInfo | undefined = undefined;
  @State showDevType: ShowDevType = this.hasCall ? ShowDevType.CALL : ShowDevType.MEDIA;
  @StorageLink('callTextConst') callTextConst: string = 'Call';
  @State curModeIsStack: boolean = false; // 当前模式  curModeIsStack : true  堆叠  ; false  平铺

  @State isFirstDataLength: boolean = true;
  @State firstDataLength: number = 0;

  //数据源
  @StorageLink('AlbumInfoList') @Watch('albumInfoListUpdate') albumInfoLisData: Array<AVQueueInfo> = [];
  //修改数据源
  @State albumInfoList: Array<AVQueueInfo> = [];
  //父子双向同步  监听歌单点击
  @State @Watch('albInfoUpdate') albInfo: AVQueueInfo = {};

  // 跟手滑动动效参数
  @State startPosition: number = 0; //起始坐标
  @State distance: number = 0; //列表移动距离
  @State endPosition: number = 0; //最终坐标
  @State delayTime: boolean = false;
  @State deviceReady: boolean = false;
  @State isText: boolean = true;
  @State private isButtonHolding: boolean = false;
  @State isSmallPic: boolean = this.hasCall;
  @State deviceDisable: boolean = false;
  @State exitApplication: boolean = false; // 清定时器
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State textMaxFontScale: number = Constants.TEXT_MAX_FONT_SCALE;
  @State titleMaxFontScale: number = Constants.SMALL_FOLD_DEVICE_TITLE_MAX_FONT_SCALE;

  // 物理按键监听
  private volumeUpKeyOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_VOLUME_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  private volumeDownKeyOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_VOLUME_DOWN,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };
  // 是否已监听物理音量按键
  private monitorVolumeKey: boolean = false;

  // 窗口
  private windowWidth: number = 0;
  private windowHeight: number = 0;
  private windowWidthLink: AbstractProperty<number> = AppStorage.setAndRef('windowWidth', 0);
  private windowHeightLink: AbstractProperty<number> = AppStorage.setAndRef('windowHeight', 0);
  private densityPixels: number = 3.25;
  private isDisableToast: boolean = true;

  // 动效
  @State castBannerEffect: TransitionEffect = this.getCastBannerTransition(false);

  // AVSession缺失设备类型，标识PC
  private readonly LOST_DEVICE_TYPE_PC = 8;
  // AVSession缺失设备类型，标识PAD
  private readonly LOST_DEVICE_TYPE_PAD = 6;
  // AVSession缺失设备类型，标识phone
  private readonly LOST_DEVICE_TYPE_PHONE = 7;

  private coldStartDoneCallback: LocalEventCallback | undefined = undefined;

  // 一镜到底动效是否完成
  @StorageLink('mediaTransitionDone') @Watch('transitionChange') mediaTransitionDone: boolean = false;
  // 延迟动画
  private albumDelayFlag: boolean = false;
  // 淡入淡出元素的透明度
  @State private fadeOpacity: number = 0;
  // 非可信设备的PIM码弹窗是否显示
  @StorageLink('showDmModal') @Watch('dmModalChanged') showDmModal: boolean = false;
  // 页面是否可见
  @State pageVisibility: Visibility = Visibility.Visible;
  // 设备列表透明度
  @State deviceListOpacity: number = 0;
  @State isInitCastBanner: boolean = false;
  @StorageLink('mediaTransitionFlag') mediaTransitionFlag: number = 0;
  @State isRecommendEightSupportTemp: boolean = false;
  @State isShowMore: Visibility = Visibility.Hidden;
  @State hasClickIndex: number = -1;
  @State titleResource: ResourceStr = '';
  @StorageLink('titleResource') @Watch('titleResourceChange') titleResourceLink: Resource =
    $r('app.string.RecentlyPlay');
  private albumPicMap: Map<string, string> = new Map<string, string>();
  @StorageLink('isStartAVPlaybackSuccess') @Watch('isStartSuccess') isStartAVPlaybackSuccess: boolean = false;

  /**
   * 数据列表改变监听
   */
  public async listDataChanged() {
    this.refreshPLayIndex();
  }

  titleResourceChange(): void {
    this.titleResource = this.titleResourceLink;
    log.showInfo(`titleResourceChange,titleResource:${this.titleResource}`)
  }

  isStartSuccess() {
    if (this.isStartAVPlaybackSuccess) {
      return;
    } else {
      //如果切歌失败，跳动符号回到正在播放的那一首
      this.refreshPLayIndex();
    }
  }

  private refreshPLayIndex() {
    if (!this.albumInfoListNew) {
      log.showInfo(`refreshPLayIndex,albumInfoListNew is empty`);
      return;
    }
    this.metaDataTemp = this.metaDataMap[this.curSessionId];
    let avQueueIdTemp = this.metaDataTemp?.avQueueId;
    if (avQueueIdTemp && !this.isVideo) {
      this.hasClickIndex = this.albumInfoListNew.findIndex((v => {
        return v.avQueueId == avQueueIdTemp;
      }));
    }
    log.showInfo(`refreshPLayIndex,avQueueId:${this.metaDataTemp?.avQueueId},playIndex:${this.hasClickIndex}`);
  }

  /**
   * 设备列表展示和最近播放展示切换回调
   */
  public showDevChange() {
    log.showInfo(`showDevChange,:${this.isShowDev}`);
    if (!this.isShowDev) {
      this.listDataChanged();
    }
  }

  mediaTransitionUpdate() {
    this.uiContext.animateTo({
      curve: Curve.Sharp,
      duration: 100,
      delay: this.fadeOpacity === 0 ? 100 : 0
    }, () => {
      this.fadeOpacity = this.fadeOpacity === 0 ? 1 : 0;
    })
  }

  transitionChange() {
    if (this.isQuiting) {
      return;
    }
    if (!this.mediaTransitionDone) {
      if (!this.isLandscapeLayout()) {
        this.isQuiting = true;
      }
      this.mediaTransitionUpdate();
      return;
    }
    this.castBannerInit();
    this.castSessionChange();
    // 刷新设备列表
    this.castDeviceControl = this.enableDc ? CastDeviceControlDc.getInstance() : CastDeviceControl.getInstance();
    this.castDeviceControl?.startControl(this.curSessionId);
    CommunicationUtil.addLocalEventListener('coldStartDone', this.getColdStartDoneCallback());
    CommunicationUtil.addLocalEventListener('castSessionDeviceChange', this.getCastSessionCallback());
    this.initDeviceList();
    if (this.isPad || this.isFoldable()) {
      this.listener.on('change', this.padOrFoldLandscapeChanged);
    }
    if (this.albumDelayFlag) {
      this.albumInfoListUpdate();
      this.albumDelayFlag = false;
    }
  }

  castBannerInit() {
      setTimeout(() => {
        this.isInitCastBanner = true;
        this.updateTopMargin();
      }, 150);
  }

  castSessionChange() {
    const hasCast: boolean = !!(this.castSession?.sessionId && this.sessionList.length > 0 &&
      this.castSession?.sessionId !== this.sessionList[0]);
    this.mediaInfoProvider.setCastSessionListener(hasCast, this.castSession?.sessionId);
  }

  getCastSessionCallback() {
    if (!this.castSessionChangeCallback) {
      this.castSessionChangeCallback = new LocalEventCallback((connectState: number) => {
        log.showInfo(`castSessionChangeCallback connectState = ${connectState}`)
        if (connectState === AVSessionManager.ConnectionState.STATE_DISCONNECTED) {
          this.castSession = undefined;
          if (this.enableDc) {
            this.dcController?.setAppStorage('castingSessionInfo', undefined);
          }
          this.updateTopMargin();
        }
      });
    }
    return this.castSessionChangeCallback;
  }

  dmModalChanged() {
    this.uiContext.animateTo({
      duration: 333,
      curve: Curve.Friction,
    }, () =>{
      this.pageVisibility = this.showDmModal ? Visibility.Hidden : Visibility.Visible;
    });
  }

  onIsExpand() {
    this.expandAnimation = true;
  }

  initDeviceList() {
    if (this.isShowDev) {
      this.uiContext.animateTo({
        duration: 333,
        curve: Curve.Friction
      }, () => {
        this.deviceListOpacity = 1;
      })
    } else {
      this.deviceListOpacity = 1;
    }
  }

  getColdStartDoneCallback(): LocalEventCallback {
    if (!this.coldStartDoneCallback) {
      this.coldStartDoneCallback = new LocalEventCallback(() => {
        log.showInfo(`start discovery on cold start done: ${this.curSessionId?.length < 10 ? '' :
          (this.curSessionId?.substr(0, 5) + '**' + this.curSessionId?.substr(this.curSessionId?.length - 5))}`);
        if (this.curSessionId) {
          this.castDeviceControl?.startControl(this.curSessionId);
        }
      });
    }
    return this.coldStartDoneCallback;
  }

  // 更新字体最大放大倍数
  updateMaxFontScale(): void {
    this.textMaxFontScale = Constants.TEXT_MAX_FONT_SCALE;
    this.titleMaxFontScale = Constants.TITLE_MAX_FONT_SCALE;
  }

  isShowToast() {
    try {
      commonEventManager.publish(this.isDisableToast ? DISABLE_TOAST : SHOW_TOAST, (err: BusinessError) => {
        if (err) {
          log.error(`disable toast error: code: ${err.code} message: ${err.message}`);
        } else {
          log.showWarn('disable toast success');
        }
      });
    } catch (err) {
      log.error(`Faild to close device menu. message: ${err?.message}`);
    }
  }

  async aboutToAppear() {
    log.showInfo(`aboutToAppear, this.curSessionId = ${this.curSessionId?.length < 10 ? '' :
      (this.curSessionId?.substr(0, 5) + '**' + this.curSessionId?.substr(this.curSessionId?.length - 5))}`);
    this.setDisplayInfo()
    this.getIsFoldable(); // 是否为折叠屏
    this.updateMaxFontScale();
    this.deviceListHeight = MeasuringUtil.getHeight(16, this.deviceListHeight, this.textMaxFontScale,
      this.getFontSizeScale());
    this.callDeviceListHeight = MeasuringUtil.getHeight(16, this.callDeviceListHeight, this.textMaxFontScale,
      this.getFontSizeScale());
    this.getCardHeightAndStyle(); // 设置宽高
    this.updateTopMargin(); // 计算边距
    this.init();
    this.mediaTransitionUpdate();
    this.clickAVQueueTime = 0;
    this.mediaInfoProvider.getMetadataFromAVSession();
    AppStorage.setOrCreate('clickAlbum', false);
    this.isDisableToast = true;
    this.isShowToast();
    this.registerInputConsumer();
  }

  /**
   * 初始化
   */
  async init() {
    // 弹簧动效变量
    this.isFriction = this.isShowDev;
    // 区分冷启动和热启动标识
    this.exitApplication = false;
    this.isFirstDataLength = true;
    AppStorage.setOrCreate('isRefreshData', true);
    if (this.sessionList.length > 0) {
      // 媒体卡片初始化
      this.curSessionId = this.sessionList[0];
      if (this.enableDc) {
        this.dcController?.setAppStorage('CurSessionId', this.sessionList[0]);
      }
      let tempSessionListBig: string[] = [];
      tempSessionListBig.push(this.sessionList[0]);
      this.sessionListBIG = tempSessionListBig;

      this.isVideo = !!this.mediaInfoProvider.getIsVideo(this.sessionList[this.curForceMedia]);
    }
    this.isCenter = this.getScreenState();
    // listen screen change
    screen.on('change', this.getMediaCardLayoutCallBack);
  }

  aboutToDisappear(): void {
    log.showInfo('listDialog aboutToDisappear begin');
    this.exitApplication = true;
    this.castDeviceControl?.release();
    this.mediaInfoProvider.clearCastSessionListener();
    clearTimeout(this.timeoutID);
    this.timeoutID = null;
    this.isDisplay = false;
    AppStorage.setOrCreate('isDisplay', this.isDisplay);
    this.isStartPlaying = false;
    AppStorage.setOrCreate('isStartPlaying', this.isStartPlaying);
    // 清除isClickLink，下次进入时，历史歌单重新读取
    AppStorage.delete('isClickLink');
    GlobalContext.getInstance().setObject('isMediaCenterShow', false);
    if (this.enableDc) {
      this.dcController?.callGlobalContext({name: 'isMediaCenterShow', value: false});
      this.dcController?.setAppStorage('isClickLink', undefined);
    }
    // 清空引用，释放内存
    this.cardStackController = undefined;
    this.castDeviceControl = undefined;
    this.preOrNextOperateTimeStamp = null;
    log.debug('listDialog aboutToDisappear done and clearInterval for point');
    this.clearTimer();
    if (this.isPad || this.isFoldable()) {
      this.listener.off('change', this.padOrFoldLandscapeChanged);
    }
    screen.off('change', this.getMediaCardLayoutCallBack);
    CommunicationUtil.removeLocalEventListener('coldStartDone', this.getColdStartDoneCallback());
    CommunicationUtil.removeLocalEventListener('castSessionDeviceChange', this.getCastSessionCallback());
    this.albumPicMap.clear();
    this.mediaInfoProvider.deleteAlbumInfoListLink();
    this.isDisableToast = false;
    this.isShowToast();
    AVSessionManager.setDiscoverable(false);
    this.removeInputConsumer();
  }

  clearTimer() {
    if (this.timerId !== undefined) {
      clearInterval(this.timerId);
      this.timerId = undefined;
    }
    if (this.callTimerId !== undefined) {
      clearInterval(this.callTimerId);
      this.callTimerId = undefined;
    }
  }

  /**
   * 注册音量键
   */
  private registerInputConsumer(): void {
    if (this.monitorVolumeKey || ControlCenterPluginMgr.isPcMode) {
      return;
    }
    try {
      inputConsumer.on('key', this.volumeUpKeyOptions, this.callbackInputConsumer);
      inputConsumer.on('key', this.volumeDownKeyOptions, this.callbackInputConsumer);
      this.monitorVolumeKey = true;
    } catch (err) {
      log.error('registerInputConsumer failed, err: ', err)
    }
  }

  /**
   * 解注册音量键
   */
  private removeInputConsumer(): void {
    if (!this.monitorVolumeKey || ControlCenterPluginMgr.isPcMode) {
      return;
    }
    try {
      inputConsumer.off('key', this.volumeUpKeyOptions, this.callbackInputConsumer);
      inputConsumer.off('key', this.volumeDownKeyOptions, this.callbackInputConsumer);
      this.monitorVolumeKey = false;
    } catch (err) {
      log.error('removeInputConsumer failed, err: ', err)
    }
  }

  /**
   * 物理音量键回调
   */
  callbackInputConsumer = (callback: inputConsumer.KeyOptions) => {
    log.showInfo(`input consumer ${this.hasCall}, ${this.isShowDev}, ${this.showDevType}`);
    if (this.hasCall && (!this.isShowDev || this.showDevType !== ShowDevType.MEDIA)) {
      this.mediaInfoProvider?.inputCallVolumeCallback(callback);
    }
    if (!this.isShowDev || this.showDevType !== ShowDevType.CALL) {
      this.mediaInfoProvider?.inputMediaVolumeCallback(callback);
    }
  }

  private getMediaCardLayoutCallBack = (data: number) => {
    this.isCenter = this.getScreenState();
    return;
  }

  /**
   * 大图loading和蒙层的淡隐淡出动画
   * @param isClick
   */
  loadingProgressAnimation( isClick: boolean ) {
    // loading加载淡入淡出
    this.uiContext.animateTo(
      {
        duration: isClick ? 100 : 100,
        curve: Curves.cubicBezierCurve(0.33, 0.00, 0.67, 1.00)
      },
      () => {
        this.loadingProgressOpacity = isClick ? 1 : 0;
        AppStorage.setOrCreate('loadingProgressOpacity', this.loadingProgressOpacity);
        this.maskBlur = isClick ? 50 : 0;
        AppStorage.setOrCreate('maskBlur', this.maskBlur);
      }
    )
  }

  /**
   * 播放状态变化
   */
  playStateUpdate() {
    if (this.isLocalSpeaker()) {
      // 避免重复刷帧
      if (this.timerId !== undefined) {
        clearInterval(this.timerId);
        this.timerId = undefined;
      }
      this.pointMediaOpacityFirst = 0.1;
      this.pointMediaOpacitySecond = 0.1;
      this.pointMediaOpacityThird = 0.1;
      return;
    }
    let playbackStateTemp: AVSessionManager.AVPlaybackState = this.playStateMap[this.curSessionId];
    if (playbackStateTemp?.state === 2) {
      if (this.timerId === undefined) {
        this.timerId = setInterval(() => {
          this.pointOpacityFirstAnim(ShowDevType.MEDIA);
          this.pointOpacitySecondAnim(ShowDevType.MEDIA);
          this.pointOpacityThirdAnim(ShowDevType.MEDIA);
        }, Constants.POINT_ANIMATION_INTERVAL);
      }
    } else {
      if (this.timerId !== undefined) {
        clearInterval(this.timerId);
        this.timerId = undefined;
      }
      // 暂停
      this.pointMediaOpacityFirst = 0.1;
      this.pointMediaOpacitySecond = 0.1;
      this.pointMediaOpacityThird = 0.1;
    }
  }

  callStateUpdate() {
    if (this.curCallDevice.deviceType === audio.DeviceType.SPEAKER ||
      this.curCallDevice.deviceType === audio.DeviceType.EARPIECE) {
      if (this.callTimerId !== undefined) {
        clearInterval(this.callTimerId);
        this.callTimerId = undefined;
      }
      this.pointCallOpacityFirst = 0.1;
      this.pointCallOpacitySecond = 0.1;
      this.pointCallOpacityThird = 0.1;
      return;
    }
    if (this.callTimerId === undefined) {
      this.callTimerId = setInterval(() => {
        this.pointOpacityFirstAnim(ShowDevType.CALL);
        this.pointOpacitySecondAnim(ShowDevType.CALL);
        this.pointOpacityThirdAnim(ShowDevType.CALL);
      }, Constants.POINT_ANIMATION_INTERVAL);
    }
  }

  /**
   * 判断是否为折叠屏
   */
  getIsFoldable() {
    try {
      const isFoldDevice: boolean = display.isFoldable();
      this.isFoldDevice = isFoldDevice;
    } catch (error) {
      this.isFoldDevice = false;
    }
  }

  /**
   * 是否折叠屏
   */
  isFoldable() {
    return this.isFoldDevice;
  }

  /**
   * 获取可折叠设备的当前折叠状态，ture为折叠态，false为展开态
   */
  getFoldStatus() {
    try {
      const foldStatus = display.getFoldStatus();
      log.showInfo(`foldStatus: ${foldStatus}`)
      return foldStatus == 2;
    } catch (error) {
      return false
    }
  }

  // Tips 折叠屏适配数据移除
  /**
   * 折叠屏样式
   * @returns
   */
  getFoldStyle() {
    let foldStyle: FoldHeight = {};
    return foldStyle
  }

  /**
   * 播放时，标题行动画-1
   */
  pointOpacityFirstAnim(type: ShowDevType) {
    this.uiContext.animateTo({
      duration: 250, // 动画时长
      curve: Curve.Linear, // 动画曲线
      delay: 0, // 动画延迟
      playMode: PlayMode.Normal // 动画模式
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacityFirst = 0.4;
      } else {
        this.pointMediaOpacityFirst = 0.4;
      }
    })
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 250,
      playMode: PlayMode.Normal
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacityFirst = 0.2;
      } else {
        this.pointMediaOpacityFirst = 0.2;
      }
    })
    this.uiContext.animateTo({
      duration: 600,
      curve: Curve.Linear,
      delay: 700,
      playMode: PlayMode.Normal
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacityFirst = 0.1;
      } else {
        this.pointMediaOpacityFirst = 0.1;
      }
    })
  }

  /**
   * 播放时，标题行动画-2
   */
  pointOpacitySecondAnim(type: ShowDevType) {
    this.uiContext.animateTo({
      duration: 350,
      curve: Curve.Linear,
      delay: 100,
      playMode: PlayMode.Normal
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacitySecond = 0.4;
      } else {
        this.pointMediaOpacitySecond = 0.4;
      }
    })
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 450,
      playMode: PlayMode.Normal
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacitySecond = 0.2;
      } else {
        this.pointMediaOpacitySecond = 0.2;
      }
    })
    this.uiContext.animateTo({
      duration: 400,
      curve: Curve.Linear,
      delay: 900,
      playMode: PlayMode.Normal
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacitySecond = 0.1;
      } else {
        this.pointMediaOpacitySecond = 0.1;
      }
    })
  }

  /**
   * 播放时，标题行动画-3
   */
  pointOpacityThirdAnim(type: ShowDevType) {
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 250,
      playMode: PlayMode.Normal
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacityThird = 0.4;
      } else {
        this.pointMediaOpacityThird = 0.4;
      }
    })
    this.uiContext.animateTo({
      duration: 350,
      curve: Curve.Linear,
      delay: 750,
      playMode: PlayMode.Normal
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacityThird = 0.2;
      } else {
        this.pointMediaOpacityThird = 0.2;
      }
    })
    this.uiContext.animateTo({
      duration: 250,
      curve: Curve.Linear,
      delay: 1050,
      playMode: PlayMode.Normal
    }, () => {
      if (type === ShowDevType.CALL) {
        this.pointCallOpacityThird = 0.1;
      } else {
        this.pointMediaOpacityThird = 0.1;
      }
    })
  }

  /**
   * pad或折叠屏展开状态，横竖屏切换监听回调
   */
  padOrFoldLandscapeChanged = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    if (this.isPad || (this.isFoldable() && !this.getFoldStatus())) {
      this.landscapeChanged()
    }
  }

  /**
   * 横竖屏切换
   */
  landscapeChanged() {
    log.showInfo(`isLandscape: ${this.isLandscape}`)
    this.setDisplayInfo(); // 设置屏幕尺寸
    this.updateTopMargin(); // 计算边距

    try {
      const displayClass = display.getDefaultDisplaySync();
      log.showInfo(`landscapeChanged displayClass: ${JSON.stringify(displayClass)}`)
      this.windowWidth = this.isPC ? (globalStorage.getNumberByKey('TABLET_WINDOW_DEF_WIDTH') /
        (Constants.TABLET_WINDOW_ANIMATE_RATE * displayClass.densityPixels)) : this.uiContext.px2vp(displayClass.width);
      this.windowHeight = this.isPC ? (globalStorage.getNumberByKey('TABLET_WINDOW_DEF_HEIGHT') /
        displayClass.densityPixels) : this.uiContext.px2vp(displayClass.height);
      this.windowWidthLink.set(this.windowWidth);
      this.windowHeightLink.set(this.windowHeight);
    } catch (err) {
      log.showError(`Failed to landscapeChanged: ${err}`);
    }
  }

  /**
   * 歌单变化
   */
  async albInfoUpdate() {
    log.showInfo('hisAVQueue click avqueue item bundleName ' + this.albInfo.bundleName +
      'avQueueName ' + this.albInfo.avQueueName + 'avQueueId ' + this.albInfo.avQueueId +
      'lastPlayedTime ' + this.albInfo.lastPlayedTime);

    this.isClick = true;

    AppStorage.setOrCreate('isClickLink', false);
    if (this.enableDc) {
      this.dcController?.setAppStorage('isClickLink', false);
    }
    AppStorage.setOrCreate('isLoadData', true);
    AppStorage.setOrCreate('isRefreshData', false);
    this.timeoutCancelLoading();
    this.clickAVQueueTime = new Date().getTime();
    this.mediaInfoProvider.startAlbum(this.albInfo, this.albumInfoLisData);
  }

  /**
   * 防止频繁同一操作 防抖
   * @returns
   */
  debounce(): boolean {
    log.showInfo('debounce set')
    let currentTimeStamp: number = new Date().getTime();
    if (this.preOrNextOperateTimeStamp && currentTimeStamp - this.preOrNextOperateTimeStamp < 500) {
      log.warn(' next operate too frequency');
      return false;
    }
    this.preOrNextOperateTimeStamp = currentTimeStamp;
    return true;
  }

  controlCenterShowDevReport() {
    const startTime: number | undefined = AppStorage.get('showDevTime');
    if (startTime) {
      this.reportShowDeviceList(startTime);
      globalStorage.setBooleanByKey('controlCenterShowDev', true);
      if (this.enableDc) {
        this.dcController?.callGlobalStorage({name: 'controlCenterShowDev', value: true});
      }
      AppStorage.delete('showDevTime');
    }
  }

  reportShowDeviceList(startTime: number) {
    let isShowSwitch: number = globalStorage.getNumberByKey('isShowSwitch') as number;
    if (isShowSwitch === 0) {
      this.mediaInfoProvider.reportShowDeviceList(this.curSessionId, startTime, isShowSwitch);
    }
  }

  /**
   * 历史歌单更新
   */
  async albumInfoListUpdate() {
    if (!this.mediaTransitionDone) {
      this.albumDelayFlag = true;
      return;
    }
    log.showInfo(`hisAVQueue albumInfoListUpdate `);

    if (!this.albumInfoLisData || this.albumInfoLisData.length <= 0) {
      log.showInfo(`hisAVQueue albumInfoList is empty `);
      this.albumInfoListIsData = false;
      this.albumInfoList = [];
      this.albumInfoListNew = [];
      this.updateTopMargin();
      return;
    }

    this.albumInfoList = [...this.albumInfoLisData];
    log.showInfo(`hisAVQueue animate metaDataTemp: ${this.metaDataTemp?.avQueueId}`);

    this.albumInfoListIsData = true;

    // 获取冷启动第一次刷新的歌单数量
    if (this.isFirstDataLength && (this.metaDataMap == undefined || JSON.stringify(this.metaDataMap) == '{}')) {
      this.firstDataLength = this.albumInfoList.length;
    }
    // 实时获取冷启动和热启动歌单数量
    if (this.isFirstDataLength) {
      this.secondDataLength = this.albumInfoList.length;
    }

    log.showInfo(`hisAVQueue animate avqueuelist: ${this.albumInfoList.length}`);

    this.albumInfoListNew = this.albumInfoList;
    this.isClick = false;

    // 历史歌单数据更新之后，开始执行动画，第一个卡片从中心点从50%缩放到100%，其余歌单回到原位置即（0,0）点（因上方歌单除第一个歌单其余的都向左位移一个歌单距离，动画开始执行歌单向右位移）
    // 如有4个歌单，点击第四个，本身和相邻歌单不做延迟，剩余两首歌单依次延迟时间为16ms
    if (this.indexTmp > -1 && !this.canStartAnimate && (!this.hasStart || this.hasFinished) &&
      !this.isLandscapeLayout()) {
      // 有点击 当前无动效执行 未开始或已结束
      log.showInfo(`hisAVQueue animate canStartAnimate is TRUE: ${this.canStartAnimate} ${this.isFirstDataLength}`);
      if (this.albumInfoList.length !== 0) {
        this.canStartAnimate = true; //开始执行历史歌单动画
        log.showInfo('hisAVQueue albumInfoList not empty, canStartAnimate');
      } else {
        // 动画不触发直接刷新isFirstDataLength，确保metadata变化时主副标题能触发刷新
        this.isFirstDataLength = !this.canStartAnimate;
        AppStorage.setOrCreate('isTextOpacity', !this.canStartAnimate);
        log.showInfo(`hisAVQueue list empty: ${this.isFirstDataLength} ${AppStorage.get<boolean>('isTextOpacity')}`);
        // 直接刷新完成动画标识，触发大图刷新
        AppStorage.setOrCreate('finishAnimate', true);
      }
    }
    this.updateTopMargin();
  }

  /**
   * 歌单加载停止
   */
  timeoutCancelLoading() {
    log.debug(`hisAVQueue  setTimeout isClick: ${this.isClick}`);
    this.timeoutID = setTimeout(() => {
      this.isClick = false;
      if (this.albInfo) {
        this.mediaInfoProvider.reportStartMediaPlayBack(this.albInfo, -1);
        this.clickAVQueueTime = 0;
      }
    }, 3000);
  }

  /**
   * 历史记录变化
   */
  historicalDataUpdate() {
    AppStorage.setOrCreate('isLoadData', false);
    this.clickRefreshList();
    if (this.timeoutID !== null) {
      clearTimeout(this.timeoutID);
      this.timeoutID = null;
    }
    this.metaDataTempHis = this.metaDataTemp;
    this.bigImageDataTemp = this.metaDataTemp;
    log.showInfo(`hisAVQueue historicalDataUpdate()`);
    this.mediaInfoProvider.reportStartMediaPlayBack(this.albInfo,
      new Date().getTime() - this.clickAVQueueTime);
    this.clickAVQueueTime = 0;
  }

  clickRefreshList(): void {
    if (!this.canStartAnimate && (!this.hasStart || this.hasFinished) && !this.isLandscapeLayout()) {
      if (this.albumInfoListNew.length !== 0) {
        this.canStartAnimate = true;
        log.showInfo('clickRefreshList albumInfoList not empty, canStartAnimate');
      } else {
        AppStorage.setOrCreate('finishAnimate', true);
        this.isClick = false;
        log.showInfo('clickRefreshList no need start animate');
      }
    } else {
      this.isClick = false;
      log.showInfo('clickRefreshList,not click album');
    }
  }

  /**
   * 媒体信息变化
   */
  metaDataUpdate() {
    if (AppStorage.get<boolean>('isRefreshData')) {
      this.refreshPLayIndex();
      log.showInfo('metaDataUpdate return,isRefreshData is true');
      return
    }
    let isRefresh = AppStorage.get<boolean>('isLoadData');
    if (!isRefresh) {
      log.showInfo('metaDataUpdate return,isRefresh is false');
      return;
    }

    this.metaDataTemp = this.metaDataMap[this.curSessionId];
    if (!this.metaDataTemp) {
      log.showInfo('metaDataUpdate return,this.metaDataTemp is empty');
      return;
    }

    let mediaImage = this.metaDataTemp?.mediaImage;
    if (!mediaImage) {
      log.showInfo('metaDataUpdate return,mediaImage is empty');
      return;
    }

    let avQueueId = this.metaDataTemp.avQueueId;
    let albumId = this.albInfo.avQueueId;
    if (!avQueueId || avQueueId !== albumId) {
      log.showInfo(`metaDataUpdate return,avQueueId:${CommonUtils.getMaskStr(avQueueId)},albumId:${CommonUtils.getMaskStr(albumId)}`);
      return;
    }

    if (typeof mediaImage === 'string' && CommonUtils.isBase64Image(mediaImage)) {
      ImageDownloaderUtils.mediaImage = mediaImage;
      this.historicalDataUpdate();
      this.albumPicMap.clear();
      this.albumPicMap.set(avQueueId, mediaImage);
      this.avQueueColdId = avQueueId;
      log.debug(`metaDataUpdate avQueueId: ${CommonUtils.getMaskStr(avQueueId)},albumId:${CommonUtils.getMaskStr(albumId)}`);
    } else if ((typeof mediaImage) !== 'string') {
      let albumPic = this.albumPicMap.get(avQueueId);
      if (albumPic) {
        ImageDownloaderUtils.mediaImage = albumPic;
        log.debug('metaDataUpdate,clickDataUpdate,albumPic');
      } else {
        ImageDownloaderUtils.mediaImage = mediaImage;
        log.debug('metaDataUpdate,clickDataUpdate,mediaImage');
      }
      this.historicalDataUpdate();
      this.avQueueColdId = avQueueId;
      log.showInfo(`metaDataUpdate avQueueId: ${CommonUtils.getMaskStr(avQueueId)},albumId:${CommonUtils.getMaskStr(albumId)}`);
    }
    this.isHasTitle = !!this.metaDataTemp?.title
  }

  castStateChange() {
    AppStorage.setOrCreate('isLoadData', true);
    this.updateTopMargin(true);
  }

  getMusicAuthorBoolean(): boolean {
    const metadata: AVSessionManager.AVMetadata = this.metaDataMap[this.curSessionId];
    return !!metadata?.title
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

  /**
   * appName变更
   */
  appNameChange() {
    if (!this.isPC) {
      return;
    }
    if (this.curSessionId && this.appNameMap[this.curSessionId]) {
      this.firstColumnTextConst = this.appNameMap[this.curSessionId];
    } else {
      this.firstColumnTextConst = $r('app.string.LocalDevice');
    }
  }

  /**
   * 设备列表变更
   */
  onDevicesUpdated(): void {
    this.displayDeviceList = this.mergedDeviceList?.filter((device: LocalDeviceInfo) => {
      return device?.authenticationStatus === 1;
    }) || [];
    const displayCount = this.displayDeviceList.length || 1;
    const count = this.isExpand ? displayCount : displayCount;
    // padding不参与大字体计算
    let deviceListHeight = count * MeasuringUtil.getHeight(16, Constants.PANEL_LIST_ITEM_CONTENT_HEIGHT,
      this.textMaxFontScale, this.getFontSizeScale());
    deviceListHeight += Constants.DEVICE_LIST_BOTH_PADDING;
    this.deviceListHeight = deviceListHeight > Constants.DEVICE_LIST_MAX_HEIGHT ?
    Constants.DEVICE_LIST_MAX_HEIGHT : deviceListHeight;
    log.showInfo(`update deviceList length ${count}`);

    // 通话设备列表
    const callDisplayCount = this.callDeviceList.length || 1;
    let callDeviceListHeight = callDisplayCount * MeasuringUtil.getHeight(16,
      Constants.PANEL_LIST_ITEM_CONTENT_HEIGHT, this.textMaxFontScale, this.getFontSizeScale());
    callDeviceListHeight += Constants.DEVICE_LIST_BOTH_PADDING;
    this.callDeviceListHeight = callDeviceListHeight > Constants.DEVICE_LIST_MAX_HEIGHT ?
      Constants.DEVICE_LIST_MAX_HEIGHT : callDeviceListHeight;
    log.showInfo(`update callDeviceList length ${callDisplayCount}`);
  }

  /**
   * sessionList变更
   */
  async onSessionListUpdated() {
    this.curSessionId = this.sessionList[this.curForceMedia] || '';
    if (this.enableDc) {
      this.dcController?.setAppStorage('CurSessionId', this.sessionList[this.curForceMedia] || '');
    }
    let tempSessionListBig: string[] = [];
    tempSessionListBig.push(this.sessionList[0]);
    this.sessionListBIG = tempSessionListBig;
    this.isVideo = this.sessionList.length > 0 ?
      !!this.mediaInfoProvider.getIsVideo(this.sessionList[this.curForceMedia]) : false;
  }

  /**
   * 当前sessionId变化
   */
  async sessionIdChanged() {
    log.showInfo(`session id changed: ${this.curSessionId?.length < 10 ? '' : (this.curSessionId?.substr(0, 5) + '**' +
      this.curSessionId?.substr(this.curSessionId?.length - 5))}, ${this.isShowDev}`)
    if (globalStorage.getBooleanByKey('isColdStarting')) {
      log.warn('do not start discovery while cold starting')
      return;
    }
    this.castDeviceControl?.startControl(this.curSessionId);
    this.isVideo = this.sessionList.length > 0 ?
      !!this.mediaInfoProvider.getIsVideo(this.sessionList[this.curForceMedia]) : false;
  }

  /**
   * 冷启动监听
   */
  addColdStartDoneListener() {
    CommunicationUtil.addLocalEventListener('coldStartDone', this.getColdStartDoneCallback());
  }

  /**
   * 状态变化引起的topMargin改变
   */
  updateTopMarginByState() {
    if (this.isText) {
      this.updateTopMargin();
    }
  }

  /**
   * 计算顶部边距、卡片高度等数据
   * @param skipAnimation
   */
  updateTopMargin(skipAnimation: boolean = false) {
    if (this.isPC) {
      this.playCardTopMargin = 0;
      this.maxDeviceListHeight = this.screenHeight - Constants.PC_STATUS_BAR_HEIGHT - this.playbackCardHeight -
      Constants.PLAYBACK_CARD_TOP_MIN_MARGIN - Constants.PLAYBACK_DEVICE_LIST_MARGIN_TOP - 24;
      log.showInfo(`cal top margin res: isTablet, screen:${this.screenHeight}, maxheigth:${this.maxDeviceListHeight}`);
      // window resize
      let newUpHeight: number =
        this.isShowDev ? MeasuringUtil.getTotalHeight(1, this.displayDeviceList.length, this.isShowDev)
          : (this.windowWidth + 16 + 8 + 8 + 21 + 2 + 19 + 40 + 48 + 40);
      log.showInfo(' do first resize to newUp ' + newUpHeight);
      let windowHandleHere: window.Window = window.findWindow(Constants.WINDOW_NAME);
      windowHandleHere.resize(globalStorage.getNumberByKey('TABLET_WINDOW_DEF_WIDTH') + Constants.TABLET_WINDOW_SHADOW_PADDING,
        newUpHeight * globalStorage.getNumberByKey('windowUxRate') * Constants.TABLET_WINDOW_ANIMATE_RATE + Constants.TABLET_WINDOW_SHADOW_PADDING_TOP + Constants.TABLET_WINDOW_SHADOW_PADDING_BOTTOM);
      return;
    }

    let deviceHeight: number = 0; // 设备列表高度（历史歌单高度）
    let callCardHeight: number = 0; // 通话卡片高度
    let playbackCardHeight: number = 0; // 媒体卡片高度
    let totalHeight: number = 0; // 总高度
    let isSmallPicDefaultHeight: boolean = false;
    let landScapeCardHeight: number = this.hasCall ? Constants.PANEL_LANDSCAPE_HEIGHT :
      Constants.LANDSCAPE_LARGE_MEDIA_CARD_HEIGHT;
    if (this.isShowDev) {
      deviceHeight = Constants.CARD_EDGE_HALF_PADDING +
        (this.showDevType === ShowDevType.CALL ? this.callDeviceListHeight : this.deviceListHeight);
      playbackCardHeight = this.showDevType === ShowDevType.MEDIA ?
        Constants.PANEL_PORTRAIT_HEIGHT_SMALL : 0;
      callCardHeight = this.showDevType === ShowDevType.CALL ? Constants.CALL_CARD_HEIGHT : 0;
      isSmallPicDefaultHeight = !this.isHasTitle;
    } else if (this.albumInfoListIsData && !this.hasCall) {
      // 无投播
      deviceHeight = 0;
      playbackCardHeight = this.isLandscapeLayout() ? landScapeCardHeight :
        Constants.PORTRAIT_MEDIA_CARD_HEIGHT;
      isSmallPicDefaultHeight = this.isLandscapeLayout() && !this.isHasTitle ? true : false;
    } else {
      deviceHeight = 0;
      if (this.hasCall && !this.curModeIsStack) {
        callCardHeight = Constants.CALL_CARD_HEIGHT + Constants.CARD_EDGE_HALF_PADDING;
        playbackCardHeight = this.isLandscapeLayout() ? Constants.PANEL_PORTRAIT_HEIGHT_SMALL +
        Constants.CARD_EDGE_HALF_PADDING : Constants.PANEL_PORTRAIT_HEIGHT_SMALL;
        isSmallPicDefaultHeight = !this.isHasTitle ? true : false;
      } else {
        playbackCardHeight = this.isLandscapeLayout() ? landScapeCardHeight :
          Constants.PORTRAIT_MEDIA_CARD_HEIGHT;
        isSmallPicDefaultHeight = this.isLandscapeLayout() && !this.isHasTitle ? true : false;
      }
    }
    playbackCardHeight = isSmallPicDefaultHeight ? playbackCardHeight : MeasuringUtil.getHeight(16,
      MeasuringUtil.getHeight(14, playbackCardHeight, this.textMaxFontScale, this.getFontSizeScale()),
      this.textMaxFontScale, this.getFontSizeScale());
    if (this.isLandscapeLayout()) {
      deviceHeight = 0;
    }
    // 投播banner存在时的高度
    if (this.isShowCastBanner() && !this.isShowDev) {
      deviceHeight = Constants.CAST_BANNER_HEIGHT + Constants.CAST_BANNER_MARGIN_TOP;
    }
    //播控中心和设备列表总高度
    totalHeight = this.isLandscapeLayout() && this.isShowDev ? landScapeCardHeight :
      playbackCardHeight + deviceHeight + callCardHeight;
    if (!this.isLandscape) {
      playbackCardHeight = playbackCardHeight - 25;
      totalHeight = totalHeight - 25;
    }
    log.showInfo(`height updated: this.playbackCardHeight: ${playbackCardHeight}, totalHeight: ${totalHeight}, curModeIsStack: ${this.curModeIsStack}`);
    let calMarginHeight: number =
      this.uiContext.px2vp((this.screenHeight * this.densityPixels) - this.uiContext.vp2px(totalHeight)) / 2;

    // 避免重复更新
    if (this.playbackCardHeight !== playbackCardHeight) {
      this.playbackCardHeight = playbackCardHeight;
    }
    this.updateTopMarginHeight(calMarginHeight, skipAnimation);
  }

  getCardHeight(): number {
    if (!this.albumInfoListNew) {
      return 0;
    }
    if (this.albumInfoListNew.length === 1) {
      return Constants.HISTORY_CARD_HEIGHT - 16
    }
    if (this.albumInfoListNew.length === 2) {
      return Constants.HISTORY_CARD_HEIGHT + 32;
    }
    return Constants.HISTORY_CARD_HEIGHT + 40
  }

  getHistoryMarginTop() {
    if (!this.albumInfoLisData) {
      return 0;
    }
    if (this.albumInfoLisData.length === 1) {
      return Constants.ONE_HISTORY_ITEM_MARGIN_TOP;
    }
    return Constants.OTHERS_HISTORY_ITEM_MARGIN_TOP;
  }

  /**
   * 更新顶部边距
   * @param height
   * @param skipAnimation
   */
  updateTopMarginHeight(height: number, skipAnimation: boolean) {
    log.showInfo(`updateTopMarginHeight: ${height}`);
    let topMargin: number = height <= 0 || ControlCenterPluginMgr.isPcMode ? 0 : height;
    if (this.playCardTopMargin === topMargin) {
      return;
    }
    if (skipAnimation || !this.showAnimateDone) {
      this.playCardTopMargin = topMargin;
      this.showAnimateDone = true;
      this.expandAnimation = false;
    } else if (this.mediaTransitionDone) {
      this.uiContext.animateTo({
        tempo: 1.0,
        curve: Curves.interpolatingSpring(0, 1, 228, 25),
        iterations: 1,
        playMode: PlayMode.Normal,
        onFinish: () => {
          this.showAnimateDone = true;
          this.expandAnimation = false;
        }
      }, () => {
        this.playCardTopMargin = topMargin;
      });
    }
  }

  /**
   * 投播按钮图标
   * @returns
   */
  getCurSwitchIcon() : string {
    log.showInfo(`getshowing curswitch : Localdevice: ${this.curOutputDevice.deviceId?.toString().length < 10 ? '' :
      (this.curOutputDevice.deviceId?.toString().substr(0, 5) + '**' +
        this.curOutputDevice.deviceId?.toString().substr(this.curOutputDevice.deviceId?.toString().length - 5))}` +
        `LocalType: ${this.curOutputDevice.deviceType},
        remoteType: ${this.curRemoteOutputDev}, deviceSource: ${this.curOutputDevice.deviceSource}`);
    if (this.curOutputDevice.deviceSource !== DeviceSource.LOCAL) {
      switch (this.curOutputDevice.deviceType) {
        case AVSessionManager.DeviceType.DEVICE_TYPE_SMART_SPEAKER:
          return AVCastPickerDeviceIconName.SOUND_BOX_SYMBOL;
        case AVSessionManager.DeviceType.DEVICE_TYPE_BLUETOOTH:
          return AVCastPickerDeviceIconName.BLUETOOTH_SYMBOL;
        case this.LOST_DEVICE_TYPE_PAD:
          return AVCastPickerDeviceIconName.PAD_SYMBOL;
        case this.LOST_DEVICE_TYPE_PC:
          return AVCastPickerDeviceIconName.MATEBOOK_SYMBOL;
        default:
          return AVCastPickerDeviceIconName.PAD_SYMBOL;
      }
    }
    switch (this.curOutputDevice.deviceType) {
      case audio.DeviceType.SPEAKER:
        if (CommonUtils.isShowCarIcon(this.curOutputDevice.networkId, this.curOutputDevice.deviceType)) {
          return AVCastPickerDeviceIconName.CAR_SYMBOL;
        } else {
          return this.isVideo ? AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL :
            AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
        }
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
        return AVCastPickerDeviceIconName.WIRED_SYMBOL;
      case audio.DeviceType.BLUETOOTH_A2DP:
      case audio.DeviceType.BLUETOOTH_SCO:
        return `${CommonUtils.getBluetoothFillIcon(this.curOutputDevice.deviceAddress)}`;
      case audio.DeviceType.NEARLINK:
        return `${CommonUtils.getNearlinkFillIcon(this.curOutputDevice.deviceAddress)}`;
      case Constants.DEVICE_TYPE_HEARING_AID:
        return AVCastPickerDeviceIconName.HEARING_AID_SYMBOL;
      case audio.DeviceType.EARPIECE:
        if (CommonUtils.isShowCarIcon(this.curOutputDevice.networkId, this.curOutputDevice.deviceType)) {
          return AVCastPickerDeviceIconName.CAR_SYMBOL;
        }
      default:
        return this.isVideo ? AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL :
          AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
    }
  }

  /**
   * 设置屏幕信息
   */
  setDisplayInfo() {
    try {
      const displayClass = display.getDefaultDisplaySync();
      const totalHeight = displayClass.height / displayClass.densityPixels;
      this.densityPixels = displayClass.densityPixels;
      this.screenHeight = totalHeight;
      log.showInfo(`screenHeight: ${this.screenHeight}`)

      this.windowWidth = this.isPC ? (globalStorage.getNumberByKey('TABLET_WINDOW_DEF_WIDTH') /
        (Constants.TABLET_WINDOW_ANIMATE_RATE * displayClass.densityPixels)) : this.uiContext.px2vp(displayClass.width);
      this.windowHeight = this.isPC ? (globalStorage.getNumberByKey('TABLET_WINDOW_DEF_HEIGHT') /
        displayClass.densityPixels) : this.uiContext.px2vp(displayClass.height);
      this.windowWidthLink.set(this.windowWidth);
      this.windowHeightLink.set(this.windowHeight);
    } catch (err) {
      log.showError(`Failed to setDisplayInfo: ${err}`);
    }

    if (this.hasCall && this.curModeIsStack) {
      this.UpStack(true);
    }
  }

  /**
   * 是否为本地扬声器
   * @returns
   */
  isLocalSpeaker() {
    return this.curOutputDevice.deviceType === audio.DeviceType.SPEAKER &&
      this.curOutputDevice.deviceSource === DeviceSource.LOCAL &&
      !CommonUtils.isShowCarIcon(this.curOutputDevice.networkId, this.curOutputDevice.deviceType);
  }

  /**
   * 设备样式
   * @returns
   */
  getDeviceStyle() {
    if (this.isFoldable()) {
      if (this.getFoldStatus()) {
        if (!this.isLandscape && this.isShowDev) {
          return { top: $r('sys.float.ohos_id_card_margin_middle') } as Margin
        } else {
          return { top: 0 } as Margin
        }
      } else {
        return { top: $r('sys.float.ohos_id_card_margin_middle') } as Margin
      }
    } else {
      if (!this.isLandscapeLayout() && this.isShowDev) {
        return {
          top: $r('sys.float.ohos_id_card_margin_middle'),
          bottom: $r('sys.float.ohos_id_card_margin_middle')
        } as Margin
      } else {
        return { top: 0 } as Margin
      }
    }
  }

  /**
   * 计算媒体卡片的宽高
   * @param isSmallCard
   * @returns
   */
  getCardHeightAndStyle(isSmallCard?: boolean): StyleObj {
    if (isSmallCard === undefined) {
      isSmallCard = this.isShowDev
    }
    let width: number = 0;
    let height: number = 0;
    let isSmallPicDefaultHeight: boolean = false;
    if (this.isLandscapeLayout()) {
      width = this.isSmallPic ? (Constants.PANEL_LANDSCAPE_WIDTH - Constants.LANDSCAPE_CARD_MARGIN) / 2 :
        (isSmallCard ? Constants.LANDSCAPE_LARGE_MEDIA_CARD_HEIGHT : Constants.LANDSCAPE_LARGE_MEDIA_CARD_WIDTH);
      height = this.isSmallPic ? Constants.PANEL_LANDSCAPE_HEIGHT : Constants.LANDSCAPE_LARGE_MEDIA_CARD_HEIGHT;
      isSmallPicDefaultHeight = !this.isHasTitle ? true : false;
    } else {
      width = Constants.PANEL_PORTRAIT_WIDTH;
      height = isSmallCard || this.isSmallPic ?
        Constants.PANEL_PORTRAIT_HEIGHT_SMALL : Constants.PORTRAIT_MEDIA_CARD_HEIGHT;
      height = height;
      isSmallPicDefaultHeight = (isSmallCard || this.isSmallPic) && !this.isHasTitle ? true : false;
    }
    height = isSmallPicDefaultHeight ? height : MeasuringUtil.getHeight(16, MeasuringUtil.getHeight(14, height,
      this.textMaxFontScale, this.getFontSizeScale()), this.textMaxFontScale, this.getFontSizeScale());
    let styleObj: StyleObj = { width, height }
    this.panelWidth = width;
    this.panelHeight = height;

    if (ControlCenterPluginMgr.isPcMode) {
      let position = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      position.width = this.uiContext.vp2px(312);
      let listHeight = this.showDevType === ShowDevType.CALL ? this.callDeviceListHeight : this.deviceListHeight;
      position.height = this.uiContext.vp2px(height + (this.isShowDev ? (listHeight + 24) : 0));
      if (StatusBarType.isMacStyle(AppStorage.get('statusBarType') as number)) {
        let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
        position.left = controlCenterPosition.left + controlCenterPosition.width - position.width;
      }
      EvtBus.post(WindowPositionChangeEvent,
        { windowName: PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL,
          position: PluginPosition.POSITION_RIGHT,
          area: position,
          caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER});
    }

    return styleObj;
  }

  /**
   * 手点击设备列表按钮时的处理
   * @param isStack
   */
  UpStack(isStack: boolean) {
    let isMedia: number = Number((this.getCardHeightAndStyle().height + '').substring(0, 3))
    let isCall: number = Number(this.getCallAndStackCardStyle().callHeight.substring(0, 3))
    if (this.hasCall) {
      this.cardStackController?.clickInit(isStack, this.isLandscapeLayout(), this.hasCall, isMedia, isCall)
    }
  }

  /**
   * 本机扬声器及通话场景（麦克风，蓝牙SCO）返回按钮默认样式
   * @returns 是否使用默认样式（无设备连接）
   */
  isLocalDeviceState(): boolean {//2  1   7   24
    return ((this.curOutputDevice.deviceType == audio.DeviceType.SPEAKER &&
      this.curOutputDevice.networkId === 'LocalDevice') ||
      this.curOutputDevice.deviceType == audio.DeviceType.EARPIECE ||
      this.curOutputDevice.deviceType == audio.DeviceType.BLUETOOTH_SCO ||
      this.curOutputDevice.deviceType == audio.DeviceType.REMOTE_CAST);
  }

  /**
   * 设备切换按钮的判断
   * @returns
   */
  IsShowButtonIcon():boolean {
    if (this.curOutputDevice.deviceSource == DeviceSource.LOCAL && this.isLocalDeviceState()) {
      return false;
    } else if (DeviceState.CONNECTING !== this.curOutputDevice.deviceState) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * 关闭设备列表
   */
  showDevFalse() {
    log.showInfo('showDevFalse')
    this.isShowDev = false;
    this.curModeIsStack = false;
    log.showInfo(`curModeIsStack 3 = ${this.curModeIsStack}`)
    if (this.cardStackController) {
      this.cardStackController.isClick = false;
      this.cardStackController.isCallUp = false;
      this.cardStackController.isMediaUp = false;
      this.cardStackController.BoxClipStatus();
    }
  }

  /**
   * 点击设备列表
   * @param isCallDev
   */
  clickCurSwitchIcon(isCallDev: boolean = false) {
    this.showDevStartTime = new Date().getTime();
    if (!this.debounce() || this.mediaTransitionFlag > 0) {
      return;
    }
    this.isShowDeviceAnim = !this.isShowDeviceAnim;
    this.deviceReady = true;
    this.delayTime = !this.isShowDev;
    this.isText = false;
    this.showDevType = isCallDev ? ShowDevType.CALL : ShowDevType.MEDIA;
    this.castBannerEffect = this.getCastBannerTransition(true, this.showDevType);

    // 字体(通过isShowDev控制)
    this.uiContext.animateTo({
      curve: Curve.Friction,
      duration: 333,
      onFinish: () => {
        this.isText = true;
        if (this.isShowDev) {
          this.reportShowDeviceList(this.showDevStartTime);
        }
      }
    }, () => {
      log.showInfo(' click device list button');
      log.showInfo('mergedDeviceListLength----' + this.mergedDeviceList.length);
      // 判断是否是有通话接入 有 则 为堆叠模式，显示媒体小图及设备列表， 媒体设备禁用
      if (this.isShowDev) {
        // 设备列表消失
        this.showDevFalse();
        globalStorage.setNumberByKey('isShowSwitch', 1);
        if (this.enableDc) {
          this.dcController?.callGlobalStorage({name: 'isShowSwitch', value: 1});
        }
      } else {
        // 设备列表出现
        this.isShowDev = true;
        globalStorage.setNumberByKey('isShowSwitch', 0);
        if (this.enableDc) {
          this.dcController?.callGlobalStorage({name: 'isShowSwitch', value: 0});
        }
      }
      log.showInfo(`device list size: ${this.mergedDeviceList.length}, show device list: ${this.isShowDev}`);
      AppStorage.setOrCreate('isShowDev', this.isShowDev);
      this.updateTopMargin(true);
    });
  }

  /**
   * 是否显示投播快捷入口
   * @returns
   */
  isShowCastBanner(): boolean {
    return !!this.castSession && this.sessionList.length > 0 &&
      this.castSession.sessionId !== this.sessionList[0];
  }

  /**
   * 计算 通话卡片和堆叠卡片的高度
   * @returns
   */
  getCallAndStackCardStyle() {
    log.showInfo(`getCallAndStackCardStyle start : isLandscape--${this.isLandscape}, curModeIsStack--${this.curModeIsStack}`)
    let callHeight: string;
    let stackHeight: string;
    if (this.isLandscapeLayout()) {
      callHeight = '240vp'
      stackHeight = '240vp'
    } else {
      // 竖屏： 堆叠卡片为媒体卡片的高
      callHeight = '200vp'
      stackHeight = String(this.playbackCardHeight + 12) + 'vp'
    }
    let styleObj: StyleObjForCall = { callHeight, stackHeight }
    log.showInfo(`getCallAndStackCardStyle done : styleObj-- ${JSON.stringify(styleObj)}`)
    return styleObj
  }

  /**
   * 通话卡片更新
   */
  hasCallUpdated() {
    log.showInfo(`has call updated: ${this.hasCall}`);
    this.isSmallPic = this.hasCall;
    this.showDevType = this.hasCall ? ShowDevType.CALL : ShowDevType.MEDIA;
    this.castBannerEffect = this.getCastBannerTransition(this.hasCall, this.showDevType);
  }

  /**
   * 判断是否有通话
   */
  checkHasCall() {
    log.showInfo(`check Has Call start : hasCall-- ${this.hasCall}, isShowDev---${this.isShowDev}`)
    //   有通话 显示设备
    if (this.hasCall && this.isShowDev) {
      this.isSmallPic = true
      this.deviceDisable = true
    } else if (this.hasCall && !this.isShowDev) {
      //   有通话 不显示设备
      this.isSmallPic = true
      this.deviceDisable = false
    } else {
      //   没有通话
      this.isSmallPic = false
      this.deviceDisable = false
    }
    log.showInfo(`check Has Call done : curModeIsStack: ${this.curModeIsStack} | isSmallPic---${this.isSmallPic} |
    deviceDisable---${this.deviceDisable}`)
  }

  isLandscapeLayout() {
    // 折叠状态的折叠屏
    if (this.isFoldable()) {
      return this.getFoldStatus() && this.isLandscape;
    } else if (this.isPhone) {
      return this.isLandscape;
    }
    return false;
  }

  private getScreenState():boolean {
    if (DeviceHelper.isFoldExpandedOrHalfButNotSmallFoldProduct() || DeviceHelper.isPad() ||
      CommonUtils.isUltraScreenProductInGState()) {
      return false;
    } else {
      return true;
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

  @Builder
  systemSceneBg(isDeviceCard: boolean = false) {
    if (ControlCenterPluginMgr.isPcMode) {
      Column() {
        Column()
          .backgroundEffect({ radius: 100 })
          .backgroundColor('#ffffffff')
          .backgroundBrightnessInternal(this.colorModeViewData.statusBarPanelOption)
          .width('100%')
          .height(isDeviceCard ? (this.showDevType === ShowDevType.CALL ?
            this.callDeviceListHeight : this.deviceListHeight) : '100%')
          .borderRadius(Constants.MEDIA_CARD_BORDER_RADIUS_PC_MODE)
      }
      .margin(isDeviceCard ? this.getDeviceStyle() : undefined)
      .borderRadius(Constants.MEDIA_CARD_BORDER_RADIUS_PC_MODE)
    }
  }

  /**
   * 横屏布局
   */
  @Builder landscapeBoxBuilder() {
    Scroll(this.scroller) {
      Row() {
        Column() {
          if (this.hasCall && (!this.isShowDev || this.showDevType === ShowDevType.CALL)) {
            this.callCard()
          }
          this.mediaCard()
          if (this.isShowCastBanner() && !this.isShowDev) {
            this.castBanner()
          }
        }
        this.splitColumn()
        this.deviceCard()
      }
      .width(Constants.PANEL_LANDSCAPE_WIDTH)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
      .constraintSize({minHeight: '100%'})
      .padding({
        top: this.hasCall ? this.playCardTopMargin > Constants.PHONE_STATUS_BAR_HEIGHT ?
          this.playCardTopMargin : Constants.PHONE_STATUS_BAR_HEIGHT : this.playCardTopMargin,
        bottom: this.hasCall ? Constants.PHONE_STATUS_BAR_HEIGHT : this.playCardTopMargin,
      })
    }
    .width('100%')
    .height('100%')
    .scrollBar(BarState.Off)
    .clip(false)

  }

  handleTouch(event: TouchEvent) {
    if (!(!this.isShowDev && this.albumInfoListIsData && !this.curModeIsStack && !this.hasCall) || !event) {
      return;
    }
    if (event.type === TouchType.Move) {
      this.endPosition = event.touches[0].screenY
      if (this.endPosition > this.startPosition) {
        this.uiContext.animateTo({ curve: Curves.springCurve(0, 1, 228, 30), iterations: 1,
          playMode: PlayMode.Normal }, () => {
          this.distance = (this.endPosition - this.startPosition) / 4 < (Number(this.getCardHeightAndStyle()
            .height) * 0.2) ? (this.endPosition - this.startPosition) / 4 : (Number(this.getCardHeightAndStyle()
            .height) * 0.2);
        });
      } else if (this.startPosition - 30 >= this.endPosition) {
        this.uiContext.animateTo({ curve: Curves.springCurve(0, 1, 228, 30), iterations: 1,
          playMode: PlayMode.Normal }, () => {
          this.distance = (this.startPosition - this.endPosition) / 4 < (Number(this.getCardHeightAndStyle()
            .height) * 0.2) ? -(this.startPosition - this.endPosition) / 4 : -(Number(this.getCardHeightAndStyle()
            .height) * 0.2);
        });
      }
    } else if (event.type === TouchType.Up) {
      this.uiContext.animateTo({ curve: Curves.springCurve(0, 1, 228, 30), iterations: 1,
        playMode: PlayMode.Normal }, () => {
        this.distance = 0;
      })
    } else if (event.type === TouchType.Down) {
      this.startPosition = event.touches[0].screenY;
    }
  }

  getHistoryAndDeviceClip() {
    const checkCall: boolean = !this.hasCall || this.showDevType === ShowDevType.MEDIA;
    const checkDisplay: boolean = !this.isQuiting;
    const checkCast: boolean = this.isShowCastBanner() && (this.mediaTransitionFlag > 0 || this.isQuiting);
    return checkCall && checkDisplay && !checkCast;
  }

  @Builder historyAndDeviceBuilder() {
    Stack({ alignContent: Alignment.Top }) {
      this.deviceCard()
    }
    .onTouch((event?: TouchEvent) => {
      event?.stopPropagation();
    })
    .width('100%')
    .clip(this.getHistoryAndDeviceClip())
  }

  getPortraitBoxClip() {
    let checkCall: boolean = this.hasCall && this.showDevType === ShowDevType.CALL;
    let checkAnim: boolean = this.mediaTransitionFlag > 0 || this.isQuiting;
    return checkCall && !checkAnim;
  }

  /**
   * 竖屏布局
   */
  @Builder portraitBoxBuilder() {
    Scroll(this.scroller) {
      Column() {
        Column()
          .width('100%')
          .height(this.playCardTopMargin)
          .key('top_margin_area_No.0')
        Column() {
          if (this.hasCall && (!this.isShowDev || this.showDevType === ShowDevType.CALL)) {
            this.callCard()
          }
          Column() {
            this.mediaCard()
            this.historyAndDeviceBuilder()
            if (this.isShowCastBanner() && !this.isShowDev) {
              this.castBanner()
            }
          }
          .clip(this.getPortraitBoxClip())
          .constraintSize(this.hasCall ? {minHeight: Constants.PANEL_PORTRAIT_MOVE_HEIGHT} : undefined)
        }
        .translate({ x: 0, y: this.distance })
        .onTouch((event: TouchEvent) => {
          this.handleTouch(event);
        })
      }
      .width('100%')
      .constraintSize({minHeight: '100%'})
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width(ControlCenterPluginMgr.isPcMode ? Constants.PANEL_PORTRAIT_WIDTH :
      Constants.PANEL_PORTRAIT_WIDTH + Constants.CARD_PADDING)
    .height('100%')
    .scrollBar(BarState.Off)
    .clip(false)
  }

  /**
   * 媒体卡片
   */
  @Builder mediaCard() {
    Column() {
      MediaInfoCard({
        sessionId:this.curSessionId,
        index: this.curForceMedia,
        isShowDev: $isShowDev,
        curForceMedia: $curForceMedia,
        isLandscape: $isLandscape,
        isSmallPic: $isSmallPic,
        isClickIndex: $isClick,
        alInfoTmpList: $albumInfoList,
        albInfo: $albInfo,
        bigImageDataTemp: $bigImageDataTemp,
        isText: $isText,
        isFriction: $isFriction,
        isFirstDataLength: $isFirstDataLength,
        firstDataLength: $firstDataLength,
        albumInfoListIsData: $albumInfoListIsData,
        exitApplication: $exitApplication,
        isFoldDevice: $isFoldDevice,
        isVideo: $isVideo,
        isButtonHolding: $isButtonHolding,
        fun: () => {
          this.updateTopMargin()
        },
        mediaTransitionDone: $mediaTransitionDone,
        fadeOpacity: this.hasCall ? 1 : this.fadeOpacity,
        curOutputDev: $curOutputDevice,
        panelWidth: this.getCardHeightAndStyle().width,
        panelHeight: this.getCardHeightAndStyle().height,
        curSwitchIcon: this.getCurSwitchIcon(),
        isShowButtonIcon: this.IsShowButtonIcon(),
        playbackCardHeight: $playbackCardHeight,
        cardStackController: this.cardStackController,
        showDevType: this.showDevType,
        pointOpacityFirst: this.pointMediaOpacityFirst,
        pointOpacitySecond: this.pointMediaOpacitySecond,
        pointOpacityThird: this.pointMediaOpacityThird,
        callDeviceListHeight: this.callDeviceListHeight,
        clickCurSwitchIcon: () => {
          this.clickCurSwitchIcon(false);
        },
        isShowDeviceAnim: $isShowDeviceAnim,
        isShowPrefer: $isShowPrefer,
      }) {
        this.systemSceneBg(false)
      }
    }
    .padding({ top: this.hasCall && !this.isShowDev ? Constants.CARD_EDGE_HALF_PADDING : 0 })
    .zIndex(2)
  }

  /**
   * 横屏卡片与设备列表中间间隔
   */
  @Builder splitColumn() {
    Column()
      .width(this.isShowDev ? Constants.LANDSCAPE_CARD_MARGIN :0)
  }

  /**
   * 设备列表
   */
  @Builder deviceCard() {
    Column() {
      if (ControlCenterPluginMgr.isPcMode) {
        Stack({ alignContent: Alignment.Top }) {
          this.systemSceneBg(true)
          // 设备列表的代码
          if (this.isShowDev && this.showDevType === ShowDevType.CALL) {
            this.deviceList(ShowDevType.CALL)
          } else if (this.isShowDev && this.showDevType === ShowDevType.MEDIA) {
            this.deviceList(ShowDevType.MEDIA)
          }
        }
      } else {
        // 设备列表的代码
        if (this.isShowDev && this.showDevType === ShowDevType.CALL) {
          this.deviceList(ShowDevType.CALL)
        } else if (this.isShowDev && this.showDevType === ShowDevType.MEDIA) {
          this.deviceList(ShowDevType.MEDIA)
        }
      }
    }
    .width(this.isLandscapeLayout() && !this.isShowDev ? 0 : this.panelWidth)
    .opacity(this.isShowDev ? this.deviceListOpacity : 0)
    .zIndex(-1)
    .onTouch((event?: TouchEvent) => {
      event?.stopPropagation();
    })
  }

  @Builder deviceList(showDevType: ShowDevType) {
    Column() {
      Scroll(this.scroller) {
        DeviceListCard({
          prefix: 'merged',
          selectMode: 'checkbox',
          curOutputDev: showDevType === ShowDevType.CALL ? this.curCallDevice : this.curOutputDevice,
          deviceList: showDevType === ShowDevType.CALL ? this.callDeviceList : this.displayDeviceList,
          showDevType: showDevType,
          isExpand: $isExpand,
          hideDeviceScroll: $hideDeviceScroll,
          dsControl: $castDeviceControl,
          dcController: this.dcController,
          deviceDisable: $deviceDisable,
          curSessionId: showDevType === ShowDevType.CALL ?
            (this.callSession?.sessionId || '') : this.curSessionId,
        })
          .width('100%')
      }
      .borderRadius(ControlCenterPluginMgr.isPcMode ?
        Constants.MEDIA_CARD_BORDER_RADIUS_PC_MODE : Constants.MEDIA_CARD_BORDER_RADIUS)
      .constraintSize({
        maxHeight: this.isLandscapeLayout() ? (this.hasCall ? Constants.PANEL_LANDSCAPE_HEIGHT :
          Constants.LANDSCAPE_LARGE_MEDIA_CARD_HEIGHT) : Constants.DEVICE_LIST_MAX_HEIGHT
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        let listHeight = Number(newValue.height);
        listHeight = listHeight > Constants.DEVICE_LIST_MAX_HEIGHT ?
          Constants.DEVICE_LIST_MAX_HEIGHT : listHeight;
        if (listHeight === 0) {
          return;
        }
        if (this.showDevType === ShowDevType.CALL && this.callDeviceListHeight !== listHeight) {
          log.showInfo(`call device list area change: ${listHeight}`);
          this.callDeviceListHeight = listHeight;
        } else if (this.showDevType === ShowDevType.MEDIA && this.deviceListHeight !== listHeight) {
          log.showInfo(`device list area change: ${listHeight}`);
          this.deviceListHeight = listHeight;
        } else {
          return;
        }
        this.controlCenterShowDevReport();
      })
      .edgeEffect(EdgeEffect.Spring)
    }
    .backgroundColor(this.isPC ? Constants.TABLET_WINDOW_BACKGROUND_COLOR : $r('app.color.media_control_card_bgc'))
    .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
    .saturate(this.isPC ? 1.7 : 1)
    .shadow(this.isPC ? {
      radius: Constants.TABLET_WINDOW_SHADOW_RADIUS,
      color: Constants.TABLET_WINDOW_SHADOW_COLOR,
      offsetX: Constants.TABLET_WINDOW_SHADOW_OFFSET_X,
      offsetY: Constants.TABLET_WINDOW_SHADOW_OFFSET_Y,
    } : { radius : 0})
    .backdropBlur(this.isPC ? 60 : undefined)
    .border({
      width: this.isPC ? 1 : 0,
      color: this.isPC ? '#33FFFFFF' : '#00000000',
    })
    .borderRadius(ControlCenterPluginMgr.isPcMode ?
      Constants.MEDIA_CARD_BORDER_RADIUS_PC_MODE : Constants.MEDIA_CARD_BORDER_RADIUS)
    .clip(Constants.SECOND_PANEL_CLIP)
    .width(this.panelWidth)
    .margin(this.getDeviceStyle())
    .transition(this.getDeviceCardTransition())
    .key('device_card')
  }

  getDeviceCardTransition(): TransitionEffect {
    if (this.isLandscapeLayout()) {
      if (this.deviceReady) {
        const transOptions: TranslateOptions = this.showDevType === ShowDevType.CALL ?
          { x: this.panelWidth / -2 - (Constants.LANDSCAPE_CARD_MARGIN * (this.delayTime ? 1.5 : 3)) } :
          { x: this.panelWidth / -2 - (Constants.LANDSCAPE_CARD_MARGIN * 1.5),
            y: this.hasCall ? Constants.CALL_CARD_HEIGHT / (this.delayTime ? 1.5 : 0.6) : 0 };
        return TransitionEffect.translate(transOptions)
          .animation({ curve: Curves.springCurve(0, 1, 228, 25) })
          .combine(TransitionEffect.opacity(0)
            .animation({ duration: 150, curve: Curve.Linear, delay: 83 }))
          .combine(TransitionEffect.rotate({ y: 1, angle: -60 })
            .animation({ duration: 250, curve: Curve.Friction, delay: this.delayTime ? 83 : 0 }))
          .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
            .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
      } else {
        return TransitionEffect.IDENTITY;
      }
    } else {
      let translateLength: number = this.showDevType !== ShowDevType.CALL ? this.deviceListHeight :
        (this.isQuiting ? this.callDeviceListHeight : this.callDeviceListHeight +
        Constants.PANEL_PORTRAIT_HEIGHT_SMALL);
      return TransitionEffect.translate({ y: translateLength * -1})
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
        .combine(TransitionEffect.opacity(0)
          .animation({ duration: 150, curve: Curve.Sharp }))
        .combine(TransitionEffect.rotate({ x: 1, angle: 60 })
          .animation({ duration: 250, curve: Curve.Friction }))
        .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
    }
  }

  getCastBannerTransition(clickShowDev: boolean, showDevType?: ShowDevType): TransitionEffect{
    if (clickShowDev && this.hasCall) {
      return TransitionEffect.translate({y: this.callDeviceListHeight})
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
        .combine(TransitionEffect.opacity(0)
          .animation({ duration: 150, curve: Curve.Sharp }))
        .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
    }
    return TransitionEffect.translate({ y: Constants.CAST_BANNER_HEIGHT / -2 })
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0)
        .animation({ duration: 150, curve: Curve.Sharp }))
      .combine(TransitionEffect.rotate({ x: 1, angle: 60 })
        .animation({ duration: 250, curve: Curve.Friction }))
      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
  }

  getCastBannerQuitTransition() {
    const opacityAnimation: AnimateParam = this.isQuiting ?
      { duration: 100, curve: Curve.Sharp } :
      { duration: 100, curve: Curve.Sharp, delay: 50 };
    if (this.isLandscapeLayout()) {
      return TransitionEffect.translate({ x: (2 * Constants.PANEL_LANDSCAPE_WIDTH - this.panelWidth) / -4,
        y: Constants.CAST_BANNER_HEIGHT / -2 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
        .combine(TransitionEffect.opacity(0).animation(opacityAnimation))
        .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
    } else {
      const translateY: number = this.hasCall ? (this.getCardHeightAndStyle().height +
        Constants.CALL_CARD_HEIGHT) / -2 : (this.getCardHeightAndStyle().height - 120) * -1;
      return TransitionEffect.translate({x: this.panelWidth / -4, y: translateY})
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
        .combine(TransitionEffect.opacity(0).animation(opacityAnimation))
        .combine(TransitionEffect.scale({ x: 0.46, y: 0.46, z: 0.46 })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
    }
  }

  @Builder castBanner() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        if (this.castSession && this.appIconMap[this.castSession.sessionId]) {
          Image(this.appIconMap[this.castSession.sessionId])
            .width(`${Constants.CAST_BANNER_IMG_SIZE}vp`)
            .height(`${Constants.CAST_BANNER_IMG_SIZE}vp`)
            .borderRadius(Constants.CAST_BANNER_IMG_BORDER_RADIUS)
            .draggable(false)
        }
        Row(){
          Text($r('app.string.av_cast_banner_title', this.castSession?.deviceName || ''))
            .fontColor($r('app.color.media_control_text_primary'))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
            .fontSize(16)
            .maxFontScale(this.titleMaxFontScale)
            .wordBreak(WordBreak.BREAK_ALL)
            .accessibilityLevel('yes')
            .accessibilityGroup(true)
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .width('100%')
        }
        .width(`calc(100% - ${Constants.CAST_BANNER_ICON_WIDTH + Constants.CAST_BANNER_IMG_SIZE}vp)`)
        .padding({left: Constants.CAST_BANNER_TITLE_MARGIN, right: Constants.CAST_BANNER_TITLE_MARGIN})
        SymbolGlyph($r('sys.symbol.chevron_right'))
          .fontSize(`${Constants.CAST_BANNER_ICON_SIZE}vp`)
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .fontColor([$r('sys.color.icon_fourth')])
          .draggable(false)
          .width(`${Constants.CAST_BANNER_ICON_WIDTH}vp`)
      }
      .clip(true)
      .backgroundColor($r('app.color.media_control_card_bgc'))
      .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
      .borderRadius(Constants.MEDIA_CARD_LANDSCAPE_BORDER_RADIUS)
      .width(this.panelWidth)
      .height(Constants.CAST_BANNER_HEIGHT)
      .padding(Constants.CAST_BANNER_PADDING)
      .margin({ top: Constants.CAST_BANNER_MARGIN_TOP })
      .onTouch((event?: TouchEvent) => {
        event?.stopPropagation();
      })
      .onClick(() => {
        if (this.castSession?.sessionId) {
          this.isJumping = true;
          this.mediaInfoProvider.startAimApp(this.castSession.sessionId);
        }
      })
      .key('cast_banner')
      .zIndex(-1)
      .transition(this.mediaTransitionFlag > 0 || this.isQuiting ?
        this.getCastBannerQuitTransition() : this.castBannerEffect)
      .id('cast_banner')
  }

  getCallCardTransition(): TransitionEffect {
    if (this.mediaTransitionFlag > 0 || this.isQuiting) {
      return TransitionEffect.IDENTITY;
    }
    const scaleOptions: ScaleOptions = this.isLandscapeLayout() ?
      { x: 0.5, y: 0.5, z: 0.5 } : { x: 0.46, y: 0.46, z: 0.46 };
    return TransitionEffect.translate({y: Constants.CARD_EDGE_HALF_PADDING * 2 - this.callCardHeight})
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0)
        .animation({ duration: 150, curve: Curve.Sharp }))
      .combine(TransitionEffect.scale(scaleOptions)
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
  }

  /**
   * 通话卡片
   */
  @Builder callCard() {
    Column() {
      CallInfoCard({
        isLandscape: this.isLandscape,
        panelWidth: this.panelWidth,
        fadeOpacity: this.fadeOpacity,
        textMaxFontScale: this.textMaxFontScale,
        pointOpacityFirst: this.pointCallOpacityFirst,
        pointOpacitySecond: this.pointCallOpacitySecond,
        pointOpacityThird: this.pointCallOpacityThird,
        curCallDevice: this.curCallDevice,
        dcController: this.dcController,
        mediaTransitionDone: this.mediaTransitionDone,
        mediaTransitionFlag: this.mediaTransitionFlag,
        isButtonHolding: $isButtonHolding,
        clickCurSwitchIcon: () => {
          this.clickCurSwitchIcon(true);
        }
      })
        .onTouch((event: TouchEvent) => {
          if (this.isButtonHolding || event?.type !== TouchType.Up) {
            return;
          }
        })
    }
    .onAreaChange((oldValue: Area, newValue: Area) => {
      let cardHeight = Number(newValue.height);
      if (cardHeight === 0 || cardHeight === this.callCardHeight) {
        return;
      }
      this.callCardHeight = cardHeight;
      log.showInfo(`callCardHeight change: ${cardHeight}`);
    })
    .transition(this.getCallCardTransition())
    .key('call_card')
  }

  /**
   * 小外屏的标题和退出按钮
   */
  @Builder NavigationBarBuilder() {
    Flex({justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center}) {
      Column() {
        Text($r('app.string.access_audio_control'))
          .fontSize(20)
          .fontWeight(700)
          .fontColor('#FFFFFFFF')
          .foregroundBrightness(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark)
          .maxFontScale(1)
      }
      .width(224)
      .height(29)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)

      Column() {
        Button({ type: ButtonType.Circle }) {
          SymbolGlyph($r(ButtonIconName.CANCEL_SYMBOL))
            .fontSize('20vp')
            .backgroundColor(Constants.TRANSLUCENT_COLOR)
            .fontColor(['#FFFFFFFF'])
            .foregroundBrightness(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark)
            .draggable(false)
            .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_COLOR)
        }
        .backgroundColor('#19000000')
        .onClick(() => {
          log.showInfo(`Exit the device list`)
          this.disappear()
        })
        .width(40)
        .height(40)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.End)
      .backgroundColor(Constants.TRANSLUCENT_COLOR)
    }
    .width('100%')
    .height(Constants.SMALL_SCREEN_DEVICE_ITEM_HEIGHT)
    .margin({ top: -8 })
    .opacity(this.fadeOpacity)
  }

  /**
   * 小外屏设备列表二级页
   */
  @Builder smallScreenDeviceListBuilder() {
    Column() {
      Row() {}.width('100%').height(32).backgroundColor(Constants.TRANSLUCENT_COLOR)
      this.NavigationBarBuilder()

      Row().width('100%').height(8)

      DeviceListCard({
        prefix: 'merged',
        selectMode: 'smallScreenDeviceList',
        curOutputDev: this.showDevType === ShowDevType.CALL ? this.curCallDevice : this.curOutputDevice,
        deviceList: this.showDevType === ShowDevType.CALL ? this.callDeviceList : this.displayDeviceList,
        showDevType: this.showDevType,
        isExpand: $isExpand,
        hideDeviceScroll: $hideDeviceScroll,
        dsControl: $castDeviceControl,
        dcController: this.dcController,
        deviceDisable: $deviceDisable,
        curSessionId: this.showDevType === ShowDevType.CALL ?
          (this.callSession?.sessionId || '') : this.curSessionId,
      })
        .width('100%')
        .onAreaChange((oldValue: Area, newValue: Area) => {
          log.showInfo(`smallDeviceList onAreaChange`)
          this.controlCenterShowDevReport();
        })
    }
    .key('small_device_card')
    .padding({ left: Constants.SMALL_SCREEN_MEDIA_CARD_LEFTRIGHTPADDING,
      right: Constants.SMALL_SCREEN_MEDIA_CARD_LEFTRIGHTPADDING})
    .height('100%')
    .width('100%')
  }

  build() {
      Stack(){
        Column() {
          if (this.isLandscapeLayout()) {
            this.landscapeBoxBuilder()
          } else {
            this.portraitBoxBuilder()
          }
        }
        .direction(Direction.Ltr)
        .onTouch((event?: TouchEvent) => {
          if (event?.type === TouchType.Up) {
            const parameters: pageParameters = this.enableDc ? (DcMediaController.showingWant?.parameters || {}) :
              (CardMediaController.showingWant?.parameters || {});
            if (this.isShowDev && parameters.message !== 'switch') {
              log.showInfo(`return to the big picture interface`);
              this.clickCurSwitchIcon(this.showDevType === ShowDevType.CALL);
            } else {
              log.showInfo(`exit media center`);
              this.disappear();
            }
          }
        })
        .width('100%')
        .height('100%')
        .alignItems(this.isCenter ? HorizontalAlign.Center : HorizontalAlign.End)
        .padding({ right: this.isCenter ? 0 : Constants.FOLD_PADDING_RIGHT})
        .onAreaChange((newValue:Area)=>{
          // 冷启动和热启动两种场景，等播控中心最外层容器完成渲染，设置标识传到mediaInfoCard组件
          setTimeout(() => {
            if (this.isFoldDevice) {
              if (this.getFoldStatus()) {
                //折叠屏折叠态
                if (this.albumInfoList.length >= 0 && !this.isLandscape &&
                  (this.metaDataMap == undefined || JSON.stringify(this.metaDataMap) == '{}')) {
                  this.isDisplay = true;
                  AppStorage.setOrCreate('isDisplay', this.isDisplay);
                } else if (this.albumInfoList.length >= 0 && !this.isLandscape &&
                  (this.metaDataMap != undefined && JSON.stringify(this.metaDataMap) != '{}')) {
                  this.isStartPlaying = true;
                  AppStorage.setOrCreate('isStartPlaying', this.isStartPlaying);
                }
              } else {
                //折叠屏展开态
                if (this.albumInfoList.length >= 0 && (this.metaDataMap == undefined ||
                  JSON.stringify(this.metaDataMap) == '{}')) {
                  this.isDisplay = true;
                  AppStorage.setOrCreate('isDisplay', this.isDisplay);
                } else if (this.albumInfoList.length >= 0 &&
                  (this.metaDataMap != undefined && JSON.stringify(this.metaDataMap) != '{}')) {
                  this.isStartPlaying = true;
                  AppStorage.setOrCreate('isStartPlaying', this.isStartPlaying);
                }
              }
            } else {
              //直板机
              if (this.albumInfoList.length >= 0 && !this.isLandscapeLayout() &&
                (this.metaDataMap == undefined || JSON.stringify(this.metaDataMap) == '{}')) {
                this.isDisplay = true;
                AppStorage.setOrCreate('isDisplay', this.isDisplay);
              } else if (this.albumInfoList.length >= 0 && !this.isLandscapeLayout() &&
                (this.metaDataMap != undefined && JSON.stringify(this.metaDataMap) != '{}')) {
                this.isStartPlaying = true;
                AppStorage.setOrCreate('isStartPlaying', this.isStartPlaying);
              }
            }
          }, 500)
        })
        .key('listDiaLogBuilder')
        .visibility(this.pageVisibility)
      }
      .width('100%')
      .height('100%')
      // 为你推荐,偏好设置页面存在的时候，会设置透明度为0。页面关闭则设置为1
      .opacity(this.isPad ? (this.isShowPrefer ? 0 : 1) : 1)
  }
}