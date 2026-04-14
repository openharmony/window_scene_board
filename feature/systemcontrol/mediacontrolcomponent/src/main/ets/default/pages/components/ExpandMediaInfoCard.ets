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
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { DropDownEvent, TargetPanel, WindowEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { sEventManager } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import { obtainLocalEvent } from '@ohos/frameworkwrapper/src/main/ets/utils/EventUtil';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import AVSessionManager from '@ohos.multimedia.avsession';
import image from '@ohos.multimedia.image';
import Constants, {
  AVCastPickerDeviceIconName,
  DeviceSource,
  GeometryOptions,
  ImageCallback,
  ShowDevType,
  LocalDeviceInfo,
  DeviceState,
  ButtonIconName,
} from '../../Util/Constants';
import MeasuringUtil from '../../Util/MeasuringUtil';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import audio from '@ohos.multimedia.audio';
import { MediaControllerSlider } from '../../Util/MediaControllerSlider';
import { DcMediaController } from '../../Controller/DcMediaController';
import { CardMediaControllerDc } from '../../Controller/CardMediaControllerDc';
import { CardMediaController, ShowingMesTS } from '../../Controller/CardMediaController';
import ControlButtonGroup from './ControlButtonGroup';
import { LocalEventCallback } from '../../Util/LocalEventCallBack';
import CommonUtils from '../../Util/CommonUtils';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { globalStorage } from '../../Util/GlobalStorage';
import Curves from '@ohos.curves';
import SessionInfoProvider from '../../Controller/SessionInfoProvider';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { CastDeviceControl } from '../../Controller/CastDeviceControl';
import { CastDeviceControlDc } from '../../Controller/CastDeviceControlDc';
import CommunicationUtil from '../../Util/CommunicationUtil';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { BusinessError as BasicBusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';
import { MediaInfoListData } from '../../viewmodel/MediaInfoListData';
import JumpingNotes from './JumpingNotes';
import { RecentlyPlayList } from './RecentlyPlayList';
import PreferenceUtils from '../../Util/PreferencesUtils';
import display from '@ohos.display';
import { PageLoad } from './PageLoad';

const TAG: string = 'ExpandMediaInfoCard_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const DISABLE_TOAST: string = 'DISABLE_TOAST';
const SHOW_TOAST: string = 'SHOW_TOAST';

@Component
export struct ExpandMediaInfoCard {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private sessionProvider: SessionInfoProvider | undefined;
  @State private castDeviceControl: CastDeviceControl | CastDeviceControlDc | undefined = undefined;
  @State recentlyPlayTitle: string = this.getResourceString($r('app.string.RecentlyPlay'));
  @State showDevStartTime: number = 0;
  @StorageLink('CurSessionId') private curSessionId: string = '';
  private pInfoName = globalStorage.getStringByKey('packageName');
  private pInfoVersion = globalStorage.getStringByKey('packageVersion');
  private isSmallFoldOuterScreen: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Link isShowDev: boolean;
  @Link showDevType: ShowDevType;
  @StorageLink('hasCall') hasCall: boolean = false;
  @State opacityValueOne: number = 0.1; // 播放动画透明度1
  @State opacityValueTwo: number = 0.1; // 播放动画透明度2
  @State opacityValueThree: number = 0.1; // 播放动画透明度3
  @State private fadeOpacity: number = 1; // 淡入淡出元素的透明度
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  @State firstColumnTextConst: Resource | string = $r('app.string.LocalDevice');
  @StorageLink('CurDeviceSelect') @Watch('playStateUpdate') curOutputDevice: LocalDeviceInfo =
    { deviceType: audio.DeviceType.SPEAKER, deviceId: 0, deviceName: 'xxx', deviceSource: DeviceSource.LOCAL };
  @StorageLink('MediaImg') @Watch('isTextOpacityFunction') mediaImage: string | image.PixelMap = '';
  @StorageLink('MediaArtist') artist: string | boolean = ResUtils.getInnerString($r('app.string.no_media_title'));
  @StorageLink('ControlMediaTitle') title: string | boolean = '';
  @StorageLink('MediaIcon') appIcon: string | image.PixelMap = '';
  @State @Watch('playStateUpdate') playState: number = 0;
  @StorageLink('sessionList') @Watch('onSessionListUpdated') sessionList: Array<string> = [];
  @State hasMedia: boolean = false;
  @StorageLink('appIconShow') isIconShow: boolean = false;
  @StorageLink('hasLyric') hasLyric: boolean = false;
  @StorageLink('appName') curAppName: string | boolean = '';
  @State mediaType: AVSessionManager.AVSessionType = 'audio';
  @StorageLink('MediaValidCommands') @Watch('onValidCommandsChange') validCommands: Array<string> = [];
  @State skipIntervals: number = 15;
  @State assetId: string | number = '';
  @State isFavor: boolean = false
  @State @Watch('updateShowPlayButton')isShowPlayButton: boolean = false;
  @State isClickSlider: boolean = false;

  @State mediaSmallImgWidth: number = Constants.EXPAND_PICTURE_SIZE_SMALL;
  @State mediaSmallImgHeight: number = Constants.EXPAND_PICTURE_SIZE_SMALL;
  @State mediaBigImgWidth: number = Constants.EXPAND_PICTURE_SIZE;
  @State mediaBigImgHeight: number = Constants.EXPAND_PICTURE_SIZE;
  @State iconBigImgX: number = (Constants.PANEL_EXPAND_WIDTH - Constants.PIC_CONTAINER_WIDTH -
  this.mediaBigImgWidth) / 2 + this.mediaBigImgWidth - Constants.EXPAND_ICON_SIZE;
  @State iconBigImgY: number = (Constants.PANEL_EXPAND_WIDTH - Constants.PIC_CONTAINER_WIDTH -
  this.mediaBigImgHeight) / 2 + this.mediaBigImgHeight - Constants.EXPAND_ICON_SIZE;
  @State iconSmallImgX: number = (Constants.EXPAND_PICTURE_SIZE_SMALL -
  this.mediaSmallImgWidth) / 2 + this.mediaSmallImgWidth - Constants.EXPAND_ICON_SIZE_SMALL;
  @State iconSmallImgY: number = (Constants.EXPAND_PICTURE_SIZE_SMALL -
  this.mediaSmallImgHeight) / 2 + this.mediaSmallImgHeight - Constants.EXPAND_ICON_SIZE_SMALL;

  private preOrNextOperateTimeStamp: number = new Date().getTime();

  // 淡入淡出相关变量
  @State newLyricOpacity: number = 0;
  @State oldLyricOpacity: number = 1;
  @State newMusicAuthorTwo: string = ''; //新副标题
  @State oldMusicAuthorTwo: string = '';
  @State newGetText: string = ''; //新歌曲名称
  @State oldGetText: string = '';
  @State newMediaImage: string | image.PixelMap = ''; //新歌曲大图
  @State oldMediaImage: string | image.PixelMap = '';
  @State newIconImage: string | image.PixelMap = '';
  @State oldIconImage: string | image.PixelMap = '';
  @State newScale: number = 0.5;
  @State oldScale: number = 1;
  @State newImageOpacity: number = 0;
  @State oldImageOpacity: number = 1;
  @StorageLink('clickAlbum') isClickAlbum: boolean = false; //是否点击歌单
  @State progressOpacity: number = 1;
  @State newProgressStartTime: string = '';
  @State oldProgressStartTime: string = '';
  @State newProgressEndTime: string = '';
  @State oldProgressEndTime: string = '';

  @State private progressTextColor: Resource = $r('app.color.media_control_text_secondary');
  @State private progressTextBrightness: boolean = true;
  @State duration: number = -6; // 0111')private duration: number = -6; // 0111
  @State private speed: number = 1;
  @State private movePosition: number = 0; // position to show
  @State private movingPosition: number = 0; // position to get lyric
  @State private trueMovePosition: number = 0; // position truely show
  @State private moveFlag: number = 0;
  @State private moveStartCachePosition: Array<number> = [];
  @State private moveFlagStep: number = 2;
  @State private progressHeight: number = 4;
  @State loopMode: number = AVSessionManager.LoopMode.LOOP_MODE_SEQUENCE;
  @State private shortTimeUpdateCount: number = 0; //进度条seek后快速返回原位置逻辑 回调计数
  @State private callSeekCount: number = 0; //进度条seek后快速返回原位置逻辑 操作计数
  @State @Watch('onIsMarqueeStart') isMarqueeStart: boolean | null = true;

  // 可用功能
  @State private isShowSeek: boolean = true;
  @State isOperateProgress: boolean = false;

  private controller: CardMediaController | CardMediaControllerDc = this.enableDc ?
    CardMediaControllerDc.getInstance() : CardMediaController.getInstance(); // 开启worker时，使用DC子线程controller
  private dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  @State isClickFastForward: boolean = false;
  @State isClickRewind: boolean = false;
  private songNameTextSize: Resource = $r('sys.float.ohos_id_text_size_body1');
  private avControllerCallback:LocalEventCallback | undefined = undefined;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private timerId: number | undefined = undefined;
  private OPERATE_MIN_INTERVAL: number = 500; // 防抖时间
  private lastPlayState: number = 0;
  @StorageLink('CurRemoteDevSelect') curRemoteOutputDev: number = -1;
  @StorageLink('playbackPosition') private playbackPosition: AVSessionManager.PlaybackPosition = {
    elapsedTime: 0,
    updateTime: 0
  };
  @StorageLink('isVideo') isVideo: boolean = false;
  // AVSession缺失设备类型，标识PC
  private readonly LOST_DEVICE_TYPE_PC = 8;
  // AVSession缺失设备类型，标识PAD
  private readonly LOST_DEVICE_TYPE_PAD = 6;
  private isDoubleExpand: boolean = true;
  private animTimerId: number | undefined = undefined; //耳机连接时，播放动画的timer
  // 窗口
  private isDisableToast: boolean = true;
  /**
   * 下拉事件
   */
  @StorageLink('dropDownEvent')
  @Watch('onDropdownChanged')
  dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存，防止丢帧
  private seekDoneCallback: LocalEventCallback | undefined = undefined;
  @StorageLink('mediaInfoListData') @Watch('historyDataChange') mediaInfoListData: MediaInfoListData[] = [];
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();
  private swiperController: SwiperController = new SwiperController();
  @Link @Watch('isShowPreferAction')isShowPrefer: boolean;
  @Provide('maxTextFontScale') maxTextFontScale: number = Constants.EXPAND_TEXT_MAX_FONT_SCALE;
  @State isShowMore: Visibility = Visibility.None;
  @State isListItemClicked: boolean = false;
  @State playingLayoutScale: number = 1;
  @StorageLink('isExistAvQueueInfo') isExistAvQueueInfo: boolean = false;
  @StorageProp('canColdStart') @Watch('canColdStartChange') canColdStart: boolean = false;
  /**
   * 缓存下拉目标面板
   */
  lastTargetPanel: TargetPanel = TargetPanel.NONE;

  public updateTransition: (clickShowDev: boolean, showDevType: ShowDevType) => void =
    (clickShowDev: boolean, showDevType: ShowDevType) => {};

  getSeekDoneCallback(): LocalEventCallback {
    if (!this.seekDoneCallback) {
      this.seekDoneCallback = new LocalEventCallback(() => {
        this.isOperateProgress = false;
      });
    }
    return this.seekDoneCallback;
  }

  /**
   * 下拉事件参数改变回调
   * 监听状态变化，0=TargetPanel.NONE，收起，2=控制中心
   */
  onDropdownChanged() {
    if (this.lastTargetPanel === this.dropDownEvent.target) {
      return;
    }
    CommunicationUtil.clearListener('seekDone');
    CommunicationUtil.addLocalEventListener('seekDone', this.getSeekDoneCallback());
    log.showInfo(`onDropdownChanged, targetChanged: last=${this.lastTargetPanel}, cur=${this.dropDownEvent.target}`);
    log.showInfo(`onDropdownChanged isExistAvQueueInfo: ${this.isExistAvQueueInfo}, hasMedia: ${this.hasMedia}`);
    // 控制中心与通知中心切换
    if (this.lastTargetPanel !== TargetPanel.NONE && this.dropDownEvent.target !== TargetPanel.NONE) {
      this.lastTargetPanel = this.dropDownEvent.target;
      return;
    }
    this.lastTargetPanel = this.dropDownEvent.target;
    this.initCastDeviceControl();
    // 关闭控制中心
    if (this.dropDownEvent.target === TargetPanel.NONE) {
      CommunicationUtil.removeLocalEventListener('seekDone', this.getSeekDoneCallback());
      return;
    }
    //只有未在播放的时候 旧图必须在旧的容器,大图做冷启动时的淡入淡出动画
    if (!this.hasMedia || !this.title) {
      this.newImageOpacity = 1;
      this.oldImageOpacity = 0;
      this.newScale = 1;
      this.oldScale = 1;
    }
    this.isMarqueeStart = true;
    if (!this.isLocalSpeaker() && this.playState === 2 && this.isPlaying()) {
      if (this.animTimerId === undefined) {
        this.animTimerId = setInterval(() => {
          this.opacityValueOneFn();
          this.opacityValueTwoFn();
          this.opacityValueThreeFn();
        }, 1300)
      }
    }
  }

  async initCastDeviceControl() {
    if (this.dropDownEvent.target === 2) {
      this.castDeviceControl = this.enableDc ? CastDeviceControlDc.getInstance() : CastDeviceControl.getInstance();
      this.controller.doSessionCollection(); // 刷新session
      this.isDisableToast = true;
      this.isShowToast();
    } else if (this.dropDownEvent.target === 0) {
      this.castDeviceControl?.release();
      this.castDeviceControl = undefined;
      this.isDisableToast = false;
      this.isShowToast();
    }
  }
  /**
   * sessionList变更
   */
  async onSessionListUpdated() {
    this.curSessionId = this.sessionList[0] || '';
    if (this.enableDc) {
      this.dcController?.setAppStorage('CurSessionId', this.sessionList[0] || '');
    }
  }

  onValidCommandsChange() {
    if (!this.validCommands?.includes('setLoopMode') && this.curRemoteOutputDev < 0) {
      this.loopMode = 0;
    }
  }

  /**
   * 获取共享元素的绑定key，获取共享元素的绑定参数
   */
  getGeometryKey(name: string): string {
    return name;
  }

  getBigImageGeometryKey(isNew: boolean, newImageOpacity: number, oldImageOpacity: number, name: string): string {
    if (this.currentIndex === 0) {
      return `${name}List`
    }
    if (isNew) {
      return newImageOpacity === 1 ? name : `${name}Flag`;
    } else {
      return oldImageOpacity === 1 ? name : `${name}Flag`;
    }
  }

  getGeometryOptions(): GeometryOptions | undefined {
    return { hierarchyStrategy: TransitionHierarchyStrategy.NONE };
  }

  onImageComplete(newValue: ImageCallback, _width: number, isSmall?: boolean) { // _width容器的宽度  newValue-图片的宽高
    let iconWidth = isSmall ? Constants.EXPAND_ICON_SIZE_SMALL : Constants.EXPAND_ICON_SIZE;
    const minPortraitRatio: number = 13 / 18;
    const maxLandscapeRatio: number = 16 / 9;
    let bigSmallSizeRatio: number = 1;
    const realRatio: number = newValue.width / newValue.height;
    let calRatio: number = 1;
    if (realRatio >= minPortraitRatio && realRatio <= maxLandscapeRatio) {
      calRatio = realRatio;
    } else if (realRatio > maxLandscapeRatio) {
      calRatio = maxLandscapeRatio;
    } else { // w/h < 13/18
      calRatio = minPortraitRatio;
    }
    this.mediaSmallImgWidth = Math.min(_width, _width * calRatio) * bigSmallSizeRatio;
    this.mediaSmallImgHeight = Math.min(_width, _width / calRatio) * bigSmallSizeRatio;
    if (!isSmall) {
      this.mediaBigImgWidth = Math.min(_width, _width * calRatio);
      this.mediaBigImgHeight = Math.min(_width, _width / calRatio);
      this.iconBigImgX = (_width - this.mediaBigImgWidth) / 2 + this.mediaBigImgWidth - iconWidth;
      this.iconBigImgY = (_width - this.mediaBigImgHeight) / 2 + this.mediaBigImgHeight - iconWidth;
      log.showInfo(TAG, `onImageComplete---${calRatio}, mediaImg size=[${this.mediaBigImgWidth},
      ${this.mediaBigImgWidth}], ` + `icon position=[${this.iconBigImgX}, ${this.iconBigImgY}],` + `_width=[${_width}`);
    } else {
      this.iconSmallImgX = (_width - this.mediaSmallImgWidth) / 2 + this.mediaSmallImgWidth - iconWidth;
      this.iconSmallImgY = (_width - this.mediaSmallImgHeight) / 2 + this.mediaSmallImgHeight - iconWidth;
      log.showInfo(TAG, `onImageComplete---${calRatio}, mediaImg size=[${this.mediaSmallImgWidth},
      ${this.mediaSmallImgWidth}], ` + `icon position=[${this.iconSmallImgX}, ${this.iconSmallImgY}],` + `_width=[${_width}`);
    }
  }

  private getRenderingStrategy(iconName: string): SymbolRenderingStrategy {
    if (iconName === AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL ||
      iconName === AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL) {
      return SymbolRenderingStrategy.SINGLE;
    }
    return SymbolRenderingStrategy.MULTIPLE_OPACITY;
  }

  /**
   * 本机扬声器及通话场景（麦克风，蓝牙SCO）返回按钮默认样式
   * @returns 是否使用默认样式（无设备连接）
   */
  isLocalDeviceState(): boolean {//2  1   7   24
    return ((this.curOutputDevice.deviceType == audio.DeviceType.SPEAKER &&
      this.curOutputDevice.networkId === 'LocalDevice') ||
      (this.curOutputDevice.deviceType === audio.DeviceType.EARPIECE &&
      !AppStorage.get('isConnectedPadCar')) ||
      (this.curOutputDevice.deviceType == audio.DeviceType.SPEAKER &&
      this.curOutputDevice.networkId !== 'LocalDevice' &&
      !CommonUtils.isShowCarIcon(this.curOutputDevice.networkId, this.curOutputDevice.deviceType)) ||
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
          return AVCastPickerDeviceIconName.CAST_MORE_SYMBOL;
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
      default:
        return this.isVideo ? AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL :
        AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
    }
  }

  onIsMarqueeStart() {
    log.showInfo(`isMarqueeStartChange: ${this.isMarqueeStart}`);
  }

  isShowToast() {
    log.showInfo(`isShowToast in expandMediaInfoCard`);
    try {
      commonEventManager.publish(this.isDisableToast ? DISABLE_TOAST : SHOW_TOAST, (err: BasicBusinessError) => {
        if (err) {
          log.error(`disable toast error: code: ${err?.code} message: ${err?.message}`);
        } else {
          log.showWarn('disable toast success');
        }
      });
    } catch (err) {
      log.error(`Faild to close device menu. message: ${err?.message}`);
    }
  }

  aboutToAppear() {
    this.initController();
    this.controller.doSubscribeNotify();
    // 修复清除卡片后点击播放异常闪烁
    this.controller.startShowing(TAG, true);
    this.setMediaDataListener();
    this.eventMgr.on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
      this.onScreenOnOffEvent(event)
    });

    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      // 隐藏控制中心
      if (event.windowName === 'SysUI_Dropdown' &&
        event.eventType === WindowEvent.EVENT_TYPE_HIDE && this.animTimerId !== undefined) {
          clearInterval(this.animTimerId);
          this.animTimerId = undefined;
          this.opacityValueOne = 0.1;
          this.opacityValueTwo = 0.1;
          this.opacityValueThree = 0.1;
      }
      if (event.windowName === 'SysUI_Dropdown' &&
        event.eventType === WindowEvent.EVENT_TYPE_HIDE) {
          this.isMarqueeStart = false;
          this.clearTimerAndProgressData(false);
          this.isListItemClicked = false;
          AppStorage.setOrCreate('showPlayLoading', false);
      }
      if (event.windowName === 'SysUI_Dropdown' && event.eventType === WindowEvent.EVENT_TYPE_SHOW) {
        this.initCurrentIndex();
      }
    });
    this.initCurrentIndex();
  }

  async initController() {
    this.sessionProvider = await SessionInfoProvider.getInstance();
  }

  initCurrentIndex() {
    if((this.hasMedia && this.title) || !this.isExistAvQueueInfo ) {
      this.currentIndex = 1;
    } else {
      this.currentIndex = 0;
    }
  }


  onScreenOnOffEvent(event: ScreenOnOffEvent) {
    if (event.event == 'usual.event.SCREEN_OFF') {
      this.isMarqueeStart = false;
      this.clearTimerAndProgressData(false);
      return;
    }
  }

  getScreenStatus(): number {
    if (DeviceHelper.getOrientation() === 1 || DeviceHelper.getOrientation() === 3 ) {
      return 1;
    } else {
      return 0;
    }
  }

  reportShowDeviceList(startTime: number) {
    if (globalStorage.getNumberByKey('isShowSwitch') === 0) {
      this.controller.reportExpandShowDeviceList(this.curSessionId, startTime);
    }
  }

  //点击投播按钮
  clickSwitchIcon() {
    this.showDevStartTime = new Date().getTime();
    this.showDevType = ShowDevType.MEDIA;
    this.updateTransition(true, this.showDevType);
    // 字体(通过isShowDev控制)
    this.uiContext.animateTo({
      curve: Curve.Friction,
      duration: 333,
      onFinish: () => {
        if (this.isShowDev) {
          this.reportShowDeviceList(this.showDevStartTime);
        }
      }
    }, () => {
      log.showInfo(' click device list button');
      if (this.isShowDev) {
        this.isShowDev = false;
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
    });
  }

  isPlaying() {
    return CommonUtils.isPlaying(this.playState, this.lastPlayState, this.curRemoteOutputDev >= 0);
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

  startInterval(): void {
    if (this.timerId != undefined) {
      clearInterval(this.timerId);
    }
    if (this.isOperateProgress) {
      return;
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
    }, this.OPERATE_MIN_INTERVAL / (this.speed ? this.speed : 1))
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

  setMediaDataListener() {
    this.isShowSeek = this.validCommands.includes('seek')
    this.avControllerCallback = new LocalEventCallback((mediaInfo: ShowingMesTS) => {
      log.showInfo(` media data update: ${JSON.stringify(mediaInfo)} `);
      setTimeout(() => {
        this.mediaDataUpdate(mediaInfo);
      }, 0);
    });
    CommunicationUtil.addLocalEventListener('mediaUpdate', this.avControllerCallback);
  }

  mediaDataUpdate(mediaInfo: ShowingMesTS) {
    this.updateBasicInfo(mediaInfo);
    this.updateProgress(mediaInfo);
    this.playStateUpdate();
  }

  /**
   * 重置进度条相关变量
   */
  initSliderChange() {
    this.progressHeight = 4;
    this.isClickSlider = false;
  }

  updateProgress(mediaInfo: ShowingMesTS) {
    if (mediaInfo.duration != undefined) {
      // 音频总时长，当总时长大于24:00:00，显示24:00:00
      let duration = Math.floor(mediaInfo.duration);
      if (duration > 24 * 60 * 60 * 1000) {
        duration = 24 * 60 * 60 * 1000;
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

  //左侧时间
  getProgressStart(): string {
    if (!this.duration || this.duration <= 0) {
      return '--:--';
    }
    if (this.movePosition <= 0) {
      if (!this.isClickAlbum) {
        return '00:00';
      }
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
    }
    return result;
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
      if (this.isMarqueeStart && !this.isOperateProgress) {
        this.movePosition = this.calcNewPosition();
      }
      log.showInfo(` this.movePosition result: ${this.movePosition}`);
    }
  }

  updateBasicInfo(mediaInfo: ShowingMesTS) {
    if (mediaInfo.playState !== undefined) {
      log.showInfo(`parse media data: playState = ${mediaInfo.playState}`);
      this.playState = mediaInfo.playState;
      const playState: number = mediaInfo.playState as number;
      if (playState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
        this.lastPlayState = playState;
      }
    }
    if (mediaInfo.loopMode !== undefined) {
      if (typeof mediaInfo.loopMode === 'number') {
        log.debug(`parse media data: loopMode = ${mediaInfo.loopMode}`);
        this.loopMode = mediaInfo.loopMode as number;
      } else if (mediaInfo.loopMode === '') {
        this.loopMode = 0;
        if (mediaInfo.isFavor === undefined) {
          this.isFavor = false;
          log.showInfo(`init, isFavor = ${this.isFavor}`);
        }
        log.showInfo(`init, loopMode = ${this.loopMode}`);
      }
    }
    if (mediaInfo.isFavor !== undefined) {
      log.debug(`parse media data: isFavor = ${mediaInfo.isFavor}`);
      this.isFavor = mediaInfo.isFavor as boolean;
    }
    if (mediaInfo.validCommands !== undefined) {
      this.isShowSeek = mediaInfo.validCommands.includes('seek');
    }
    if (mediaInfo.musicAssetId !== undefined) {
      log.debug(`parse media data: assetId = ${CommonUtils.getMaskStr(mediaInfo.musicAssetId as string || '')}`);
      this.assetId = mediaInfo.musicAssetId as string || '';
    }
    if (mediaInfo.hasMedia !== undefined) {
      log.debug(`parse media data: hasMedia = ${mediaInfo.hasMedia}`);
      this.hasMedia = mediaInfo.hasMedia;
    }
    if (mediaInfo.mediaPlayerIcon !== undefined) {
      log.debug(`parse media data: mediaPlayerIcon = ${JSON.stringify(mediaInfo.mediaPlayerIcon)}`);
      if (!mediaInfo.mediaPlayerIcon) {
        this.appIcon = '';
      } else {
        this.appIcon = mediaInfo.mediaPlayerIcon as string;
      }
    }
    if (mediaInfo.skipIntervals !== undefined) {
      log.debug(`parse media data: skipIntervals = ${mediaInfo.skipIntervals}`);
      this.skipIntervals = mediaInfo.skipIntervals;
    }
    if (mediaInfo.mediaType !== undefined) {
      log.debug(`parse media data: mediaType = ${mediaInfo.mediaType}`);
      this.mediaType = mediaInfo.mediaType;
    }

    if (!this.mediaImage && !this.title && !this.artist) {
      this.duration = -6;
      this.hasMedia = false;
    }
    if (mediaInfo.validCommands === undefined || mediaInfo.validCommands.length === 0) {
      this.isShowPlayButton = this.canColdStart;
      log.showInfo(`no validCommands, isShowPlayButton = ${this.isShowPlayButton}`);
      return;
    }
    let validPlayOrPause: boolean = this.validCommands?.includes('play') && this.validCommands?.includes('pause');
    this.isShowPlayButton = this.hasMedia ? validPlayOrPause : this.canColdStart;
    log.showInfo(`this.mediaImage = ${this.mediaImage}, this.mediaType = ${!!this.mediaType}, isShowPlayButton = ${this.isShowPlayButton}`);
  }

  canColdStartChange() {
    let validPlayOrPause: boolean = this.validCommands?.includes('play') && this.validCommands?.includes('pause');
    this.isShowPlayButton = this.hasMedia ? validPlayOrPause : this.canColdStart;
  }

  unsetMediaDataListener() {
    if (!this.avControllerCallback) {
      return;
    }
    CommunicationUtil.removeLocalEventListener('mediaUpdate', this.avControllerCallback);
  }

  aboutToDisappear(): void {
    this.clearTimerAndProgressData(true)
    this.unsetMediaDataListener();
    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
    if (this.timerId) {
      clearInterval(this.timerId);
    }
    if (this.animTimerId !== undefined) {
      clearInterval(this.animTimerId);
      this.animTimerId = undefined;
    }
    this.isListItemClicked = false;
    log.showInfo(`aboutToDisappear:`);
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
      result = `${hours.toString().padStart(2, '0')}:${result}`
    }
    return result;
  }

  getText(): string {
    return typeof this.title === 'string' ? this.title : '';
  }

  getTitleText(isNew?: boolean): string {
    if (this.isClickAlbum) {
      return isNew ? this.newGetText : this.oldGetText;
    }
    if (isNew) {
      return this.getText() || this.newGetText;
    } else {
      return this.getText() || this.oldGetText;
    }
  }

  /**
   * 歌词/副标题文字淡入淡出
   */
  isTextOpacityFunction() {
    if ((this.mediaImage && (typeof this.mediaImage !== 'string' ||
      CommonUtils.isBase64Image(this.mediaImage))) && this.title && this.artist) {
      if (globalStorage.getBooleanByKey('coldStartAnim')) { //冷启动动画
        let currentTimeStamp = new Date().getTime(); //防止图片回传多次
        if (currentTimeStamp > this.preOrNextOperateTimeStamp &&
          currentTimeStamp - this.preOrNextOperateTimeStamp < 200) {
          return;
        }
        this.preOrNextOperateTimeStamp = currentTimeStamp;
        log.showInfo('coldStartAnim start');
        this.mediaImageChange();
        this.iconChange();
        this.uiContext.animateTo({
          duration: 250,
          curve: Curve.Sharp,
          onFinish: () => {
            // 动画完成之后，所有值初始化
            globalStorage.setBooleanByKey('coldStartAnim', false);
            this.newMediaImage = this.getMediaImage();
            this.oldMediaImage = this.getMediaImage();
            this.newIconImage = this.appIcon;
            this.oldIconImage = this.appIcon;
            this.oldScale = 1;
            this.newScale = 0.5;
          }
        }, () => {
          this.newImageOpacity = 0;
          this.oldImageOpacity = 1;
        })
      } else if (this.isClickAlbum) { //点击歌单的淡入淡出动画
        log.showInfo('isClickAlbum:' + this.isClickAlbum + ',startAnim');
        // 点击歌单 执行动画逻辑处理
        // 通过透明度交替替换新旧值
        // -------------------
        this.titleChange();
        this.artistChange();
        this.mediaImageChange();
        this.iconChange();
        this.ProgressStartTimeChange();

        this.uiContext.animateTo({ //标题、副标题淡入淡出
          duration: 150,
          curve: Curve.Sharp,
          onFinish: () => {
            // 动画完成之后，所有值初始化
            this.newGetText = this.getText()
            this.oldGetText = this.getText()
            this.newMusicAuthorTwo = this.getMusicAuthor()
            this.oldMusicAuthorTwo = this.getMusicAuthor()
            this.oldProgressStartTime = this.getProgressStart() || '--:--';
            this.oldProgressEndTime = this.getProgressEnd() || '--:--';
            this.newProgressStartTime = this.getProgressStart() || '--:--';
            this.newProgressEndTime = this.getProgressEnd() || '--:--';
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

        //大图动画
        if (this.oldImageOpacity === 0) {
          this.uiContext.animateTo({
            curve: Curves.interpolatingSpring(0, 1, 228, 25),
          }, () => {
            this.newScale = 0.5;
          });

          this.uiContext.animateTo({
            curve: Curve.Sharp,
            duration: 150,
          }, () => {
            this.newImageOpacity = 0;
          });

          this.uiContext.animateTo({
            curve: Curve.Sharp,
            duration: 150,
            delay: 50
          }, () => {
            this.oldImageOpacity = 1;
          });

          this.uiContext.animateTo({
            curve: Curves.interpolatingSpring(0, 1, 228, 25),
            delay: 50,
            onFinish:() => {
              AppStorage.setOrCreate('clickAlbum', false);
              this.newMediaImage = this.getMediaImage();
              this.oldMediaImage = this.getMediaImage();
              this.newIconImage = this.appIcon;
              this.oldIconImage = this.appIcon;
            }
          }, () => {
            this.oldScale = 1;
          });
        } else {
          this.uiContext.animateTo({
            curve: Curves.interpolatingSpring(0, 1, 228, 25),
          }, () => {
            this.oldScale = 0.5;
          });

          this.uiContext.animateTo({
            curve: Curve.Sharp,
            duration: 150,
          }, () => {
            this.oldImageOpacity = 0;
          });

          this.uiContext.animateTo({
            curve: Curves.interpolatingSpring(0, 1, 228, 25),
            delay: 50,
            onFinish:() => {
              AppStorage.setOrCreate('clickAlbum', false);
              this.newMediaImage = this.getMediaImage();
              this.oldMediaImage = this.getMediaImage();
              this.newIconImage = this.appIcon;
              this.oldIconImage = this.appIcon;
            }
          }, () => {
            this.newScale = 1;
          });

          this.uiContext.animateTo({
            curve: Curve.Sharp,
            duration: 150,
            delay: 50
          }, () => {
            this.newImageOpacity = 1;
          });
        }
      } else {
        this.titleChange();
        this.artistChange();
        this.mediaImageChange();
        this.iconChange();
        this.ProgressStartTimeChange();

        let timer: number;
        timer = 0;
        clearTimeout(timer);
        timer = setTimeout(() => {
          // 因avsession前两条数据返回的是老数据，获取到新数据的时间不等，所以做延迟获取数据处理
          this.newGetText = this.getText()
          this.oldGetText = this.getText()
          this.newMusicAuthorTwo = this.getMusicAuthor()
          this.oldMusicAuthorTwo = this.getMusicAuthor()
          this.newMediaImage = this.getMediaImage()
          this.oldMediaImage = this.getMediaImage()
          this.newIconImage = this.appIcon;
          this.oldIconImage = this.appIcon;
          this.oldProgressStartTime = this.getProgressStart() || '--:--';
          this.oldProgressEndTime = this.getProgressEnd() || '--:--';
          this.newProgressStartTime = this.getProgressStart() || '--:--';
          this.newProgressEndTime = this.getProgressEnd() || '--:--';
          clearTimeout(timer);
          timer = 0;
        }, 100);
      }
    }
  }

  getResourceString(data: Resource) {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return ResUtils.getInnerString(data);
    } else {
      return ResourceVm.instance.getString(data);
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

  @Builder headerBuilder() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Row() {
        Text(this.firstColumnTextConst)
          .fontColor($r('app.color.media_control_text_primary'))
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .fontWeight(FontWeight.Medium)
          .fontSize(14)
          .maxFontScale(1.45)
          .padding({ right: this.isRTL() ? 24 : 0 })
          .accessibilityLevel('yes')
          .accessibilityGroup(true)
          .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        if (this.IsShowButtonIcon()) {
          Flex({
            direction: FlexDirection.Row,
            justifyContent: FlexAlign.SpaceBetween,
            alignItems: ItemAlign.Center
          }) {
            Image($r('app.media.device_switch_point'))
              .draggable(false)
              .size({ width: 4, height: 4 })
              .fillColor($r('app.color.media_control_ponit'))
              .opacity(this.opacityValueOne)
              .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
            Image($r('app.media.device_switch_point'))
              .draggable(false)
              .size({ width: 4, height: 4 })
              .fillColor($r('app.color.media_control_ponit'))
              .opacity(this.opacityValueTwo)
              .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
            Image($r('app.media.device_switch_point'))
              .draggable(false)
              .size({ width: 4, height: 4 })
              .fillColor($r('app.color.media_control_ponit'))
              .opacity(this.opacityValueThree)
              .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
          }
          .width(18)
          .margin({ left: 6, right: 6 })
          Text(this.curOutputDevice.deviceName)
            .fontColor($r('app.color.media_control_text_primary'))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(1.45)
            .maxLines(1)
            .wordBreak(WordBreak.BREAK_ALL)
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .accessibilityLevel('yes')
            .accessibilityGroup(true)
        }
      }
      .height('100%')
      .alignItems(VerticalAlign.Center)
      .width(`calc(100%) - ${Constants.COMMON_PICTURE_SIZE + 24}vp)`)
      .layoutWeight(1)
      .flexGrow(1)
      .key('media_expand_card_title')
      .id('mediaExpandCardTitleEnd')
      .geometryTransition('mediaExpandCardTitle', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
      .opacity(this.fadeOpacity)

      Row() {
        Column() {
          SymbolGlyph($r(this.getCurSwitchIcon()))
            .fontSize(Constants.PANEL_EXPAND_SWITCH_SIZE)
            .backgroundColor(Constants.TRANSLUCENT_COLOR)
            .fontColor(this.IsShowButtonIcon() ? [$r('app.color.media_control_switch_active_full')] :
              [$r('app.color.media_control_switch_full')])
            .foregroundBrightness(this.colorModeViewData.getPrimaryFgOption(this.IsShowButtonIcon()))
            .draggable(false)
            .renderingStrategy(this.getRenderingStrategy(this.getCurSwitchIcon()))
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
        .accessibilityText(ResUtils.getInnerString($r('app.string.access_audio_control')))
        .width(Constants.COMMON_SWITCH_SIZE)
        .height(Constants.COMMON_SWITCH_SIZE)
        .borderRadius(120)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.IsShowButtonIcon() ? $r('app.color.media_control_switch_active_bgc') :
          (this.colorModeViewData.isBrightnessActive ?
          $r('app.color.media_control_color_brightness') : $r('app.color.media_control_component_normal')))
        .backgroundBrightnessInternal(this.colorModeViewData.getTopOption(this.IsShowButtonIcon()))
        .id('switchIconEnd_expand')
        .geometryTransition('switchIcon_expand', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
        .key('showing_switch_for_media_expandCard')
      }
      .accessibilityGroup(true)
      .onClick(() => {
        this.clickSwitchIcon();
      })
      .accessibilityLevel('yes')
      .accessibilityText(ResUtils.getInnerString($r('app.string.access_audio_control')))
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width(Constants.COMMON_SWITCH_SIZE + 24)
      .margin({left: this.isRTL() ? -12 : 0, right: this.isRTL() ? 0 : 12})
    }
    .zIndex(2)
    .width('100%')
    .height(Constants.COMMON_PICTURE_SIZE + 24)
    .padding({ left: 24 })
  }

  @Builder textBuilder(){
    if (this.hasMedia && this.title) {
      this.titleBuilder();
      this.subtitleBuilder();
    } else {
      Row() {
        Text($r('app.string.no_media_title'))
          .fontColor($r('app.color.media_control_text_secondary'))
          .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossSubOption)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(1.45)
          .fontWeight(FontWeight.Regular)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)
          .key('media_music_subtitle')
          .height(40)
          .accessibilityLevel('yes')
          .accessibilityGroup(true)
          .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      }
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('100%')
      .id('notPlay')
      .margin({top : this.isShowDev || this.hasCall ? 0 : 16 })
    }
  }
  @Builder titleBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      this.songNameBuilder(false)
      this.songNameBuilder(true)
    }
    .accessibilityLevel('yes')
    .clip(true)
    .id('textPlay')
  }

  @Builder songNameBuilder(isNew: boolean) {
    Flex({
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start
    }) {
      Row() {
        if (this.isPlaying() && this.isMarqueeStart) {
          Marquee({
            start: true,
            step: 6,
            loop: -1,
            fromStart: !this.isRTL() ? true : false,
            src: this.getTitleText(isNew)
          })
            .fontColor($r('sys.color.font_primary'))
            .fontSize(MeasuringUtil.getFontSize(this.songNameTextSize, 1.45, this.getFontSizeScale()))
            .fontWeight(600)
            .align(!this.isRTL() ? Alignment.Start : Alignment.End)
            .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
            .key('media_music_title')
        } else {
          Text(this.getTitleText(isNew))
            .fontColor($r('sys.color.font_primary'))
            .fontSize(this.songNameTextSize)
            .maxFontScale(1.45)
            .fontWeight(600)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
            .key('media_music_title')
        }
      }
    }
    .width('100%')
    .accessibilityLevel(isNew ? 'yes' : 'no-hide-descendants')
    .opacity(isNew ? this.newLyricOpacity : this.oldLyricOpacity)
    .height(MeasuringUtil.getHeight(16, 24, 1.45, this.getFontSizeScale()))
  }

  @Builder subtitleBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      this.subtitleRow(false)
      this.subtitleRow(true)
    }
    .clip(true)
    .accessibilityLevel('yes')
    .id('subtitleText')
  }

  @Builder subtitleRow(isNew: boolean = false) {
    Row() {
      if (this.isPlaying() && this.isMarqueeStart) {
        Marquee({
          start: true,
          step: 6,
          loop: -1,
          fromStart: !this.isRTL() ? true : false,
          src: this.getSubtitleText(isNew)
        })
          .fontColor($r('sys.color.font_secondary'))
          .fontSize(MeasuringUtil.getFontSize($r('sys.float.ohos_id_text_size_body2'), 1.45, this.getFontSizeScale()))
          .fontWeight(FontWeight.Regular)
          .align(!this.isRTL() ? Alignment.Start : Alignment.End)
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
          .key('media_music_lyrics')
      } else {
        Text(this.getSubtitleText(isNew))
          .fontColor($r('sys.color.font_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(1.45)
          .fontWeight(FontWeight.Regular)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .textAlign(TextAlign.Start)
          .key('media_music_subtitle')
      }
    }
    .accessibilityLevel(isNew ? 'yes' : 'no-hide-descendants')
    .width('100%')
    .height(MeasuringUtil.getHeight(14, 19, 1.45, this.getFontSizeScale()))
    .opacity(isNew ? this.newLyricOpacity : this.oldLyricOpacity)
  }

  @Builder progressStack() {
    Stack({ alignContent: Alignment.Center }) {
      this.progressBuilder(false);
      this.progressBuilder(true);
    }
    .accessibilityLevel('yes')
    .id('expandProgressStack')
  }

  @Builder progressBuilder(isNew: boolean) {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      Text(this.getProgressStartTime(isNew) || '--:--')
        .fontSize(10)
        .maxFontScale(1.45)
        .fontWeight(FontWeight.Regular)
        .fontColor(this.progressTextColor)
        .foregroundBrightness(this.progressTextBrightness ? this.colorModeViewData.foregroundTertiaryGlossSubOption :
        this.colorModeViewData.foregroundPrimaryOption)
        .maxLines(1)
        .width(this.duration >= 3600 * 1000 ?
          MeasuringUtil.getHeight(10, 46, 1.45, this.getFontSizeScale(), true, true) :
          MeasuringUtil.getHeight(10, 30, 1.45, this.getFontSizeScale(), true))
        .flexShrink(0)
        .textAlign(TextAlign.Start)
        .key('media_progress_start')
        .textOverflow({overflow: TextOverflow.Clip})
        .id('mediaProcessStart')
        .geometryTransition(this.getGeometryKey('mediaProcessLeft'), this.getGeometryOptions())
        .height('100%')
        .accessibilityLevel('no')
        .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧

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
              left: 0,
              right:0
            })
            .trackColor($r('app.color.media_control_component_normal'))
            .trackThickness(4)
            .blockColor('#00ffffff')
            .showSteps(false)
            .showTips(false)
            .enabled(false)
            .accessibilityLevel('no')
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
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
              left: 0,
              right: 0
            },
            sliderTrackThickness: this.progressHeight,
            sliderIsActive: this.isShowSeek,
            sliderSelectedColor: (this.isShowSeek ?
            $r('app.color.media_control_slider_primary') : $r('app.color.media_control_component_normal')),
            sliderTrackColor: ($r('app.color.media_control_component_normal')),
            sliderBlockColor: (Color.Transparent),
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
              switch (mode) {
                case SliderChangeMode.Begin:
                  this.isClickSlider = true;
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
                  AppStorage.setOrCreate('isRefreshData', true);
                  log.showInfo(`slider onChange end to seek, click value :
                  ${TAG}: ${JSON.stringify(this.moveStartCachePosition)}, ${value}, ${this.movePosition}`);
                  break;
                case SliderChangeMode.Moving:
                  break;
                case SliderChangeMode.End:
                  if (!this.isClickSlider) {
                    return;
                  }
                  AppStorage.setOrCreate('isRefreshData', true);
                  this.isClickSlider = false;
                  this.progressTextColor = $r('app.color.media_control_text_secondary');
                  this.progressTextBrightness = true;
                  log.showInfo(`slider onChange end to seek, value : ${value}`);
                  if (value <= this.duration) {
                    this.callSeekCount++;
                    log.showInfo(`MediaControllerSlider on callSeekCount add ${this.callSeekCount}`)
                    this.controller.callSeek(value);
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
            sliderKey: 'expandMediaInfoCard_progress',
          })
        }
      }
      .margin({ left: 8, right: 8 })
      .backgroundColor(Constants.TRANSLUCENT_COLOR)
      .clip(true)
      .id('mediaProcessMiddle')
      .geometryTransition(this.getGeometryKey('mediaProcessBar'), this.getGeometryOptions())
      .transition(
        TransitionEffect.asymmetric(
          TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 150 }),
          TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 150 })
        )
      )

      Text(this.getProgressEndTime(isNew) || '--:--')
        .fontSize(10)
        .maxFontScale(1.45)
        .fontWeight('sys.string.ohos_id_text_font_family_regular')
        .fontColor(this.progressTextColor)
        .foregroundBrightness(this.progressTextBrightness ? this.colorModeViewData.foregroundTertiaryGlossSubOption :
        this.colorModeViewData.foregroundPrimaryOption)
        .textAlign(TextAlign.End)
        .maxLines(1)
        .width(this.duration >= 3600 * 1000 ?
          MeasuringUtil.getHeight(10, 46, 1.45, this.getFontSizeScale(), true, true) :
          MeasuringUtil.getHeight(10, 30, 1.45, this.getFontSizeScale(), true))
        .flexShrink(0)
        .textOverflow({overflow: TextOverflow.Clip})
        .id('mediaProcessTotal')
        .geometryTransition(this.getGeometryKey('mediaProcessTotalRight'), this.getGeometryOptions())
        .height('100%')
        .opacity(isNew ? this.newLyricOpacity : this.oldLyricOpacity)
        .accessibilityLevel('no')
        .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
    }
    .width('100%')
    .height(40)
    .padding({left: 24, right: 24, top: 13, bottom : 13})
    .flexShrink(0)
    .margin({top : this.isShowDev || this.hasCall ? 12 : undefined})
    .accessibilityLevel(isNew ? 'no-hide-descendants' : 'yes')
    .opacity(isNew ? this.newLyricOpacity : this.oldLyricOpacity)
  }

  updateShowPlayButton() {
    log.showInfo(`update isShowPlayButton state update: ${this.isShowPlayButton}`);
  }

  @Builder controlButtonGroupBuilder() {
    ControlButtonGroup({
      sceneType: 'expandMediaInfoCard',
      sessionType: this.mediaType,
      iconSize: 28,
      validCommands: this.validCommands,
      isPlaying: this.isPlaying(),
      isHasMedia: this.hasMedia,
      isForceDark: true,
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
      duration: this.duration,
      clickPlayButton: () => {
        this.tabsController.changeIndex(1);
        this.swiperController.changeIndex(1);
        this.currentIndex = 1;
      }
    })
      .width('100%')
      .backgroundColor(Color.Transparent)
      .height(48)
      .constraintSize({ minHeight: 48 })
      .flexShrink(0)
      .clip(true)
      .padding({ left: 12, right: 12 })
      .id('controlButton')
      .geometryTransition(this.getGeometryKey('controlButtonGroup'), this.getGeometryOptions())
      .key('Buttons')
  }

  @Builder mediaBigImageStack(isNew: boolean) {
    Stack({ alignContent: Alignment.Center }) {
      if (this.mediaImage && (typeof this.mediaImage !== 'string' || CommonUtils.isBase64Image(this.mediaImage)) && 
        this.title && this.recentlyPlayTitle !== this.title) {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius(Constants.MEDIA_IMAGE_RADIUS_SIZE_BIG)
          .backgroundColor(Color.Transparent)
          .id('mediaBigImageBg')
          .geometryTransition(this.getBigImageGeometryKey(isNew, this.newImageOpacity, this.oldImageOpacity, 'ImageBg'), this.getGeometryOptions())
          .zIndex(0)
        Image(this.getBigImage(isNew))
          .alt($r('app.media.ic_nomusic_img'))
          .fillColor($r('app.color.media_control_icon_disable'))
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .width(this.mediaBigImgWidth)
          .height(this.mediaBigImgHeight)
          .borderRadius(Constants.MEDIA_IMAGE_RADIUS_SIZE_BIG)
          .draggable(false)
          .align(Alignment.Center)
          .objectFit(ImageFit.Contain)
          .syncLoad(true)
          .onComplete((newValue: ImageCallback) => {
            this.onImageComplete(newValue, Constants.PANEL_EXPAND_WIDTH - Constants.PIC_CONTAINER_WIDTH, false);
          })
          .id('mediaBigImage')
          .geometryTransition(this.getBigImageGeometryKey(isNew, this.newImageOpacity, this.oldImageOpacity, 'mediePicKey'), this.getGeometryOptions())
          .zIndex(1)
          .autoResize(false)
          .interpolation(ImageInterpolation.High)
          .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      } else {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius(Constants.MEDIA_IMAGE_RADIUS_SIZE_BIG)
          .clip(false)
          .backgroundColor($r('app.color.media_control_default_img_bgc'))
          .id('defaultBigBg')
          .geometryTransition(this.getBigImageGeometryKey(isNew, this.newImageOpacity, this.oldImageOpacity, 'defaultImageBg'), this.getGeometryOptions())
          .zIndex(0)
        Image($r('app.media.ic_nomusic_img_big'))
          .fillColor($r('app.color.media_control_icon_disable'))
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .width(64)
          .height(64)
          .draggable(false)
          .renderFit(RenderFit.RESIZE_COVER)
          .id('defaultBigImage')
          .geometryTransition(this.getBigImageGeometryKey(isNew, this.newImageOpacity, this.oldImageOpacity, 'defaultImageKey'), this.getGeometryOptions())
          .zIndex(1)
          .onComplete((newValue: ImageCallback) => {
            this.onImageComplete(newValue, Constants.PANEL_EXPAND_WIDTH - Constants.PIC_CONTAINER_WIDTH, false);
          })
          .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      }
    }
    .width('100%')
    .height('100%')
    .key('media_big_image')
  }

  @Builder mediaSmallImageBuilder(){
    Stack({ alignContent: Alignment.Center }) {
      if (((this.mediaImage && (typeof (this.mediaImage) !== 'string' ))) && this.title &&
        this.recentlyPlayTitle !== this.title) {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius((this.mediaSmallImgWidth === this.mediaSmallImgHeight ?
          Constants.MEDIA_IMAGE_RADIUS_SIZE_SMALL : 5))
          .backgroundColor(Color.Transparent)
          .id('mediaSmallImageBg')
          .geometryTransition(this.getGeometryKey('ImageBg'), this.getGeometryOptions())
          .zIndex(0)
        Image(this.mediaImage)
          .alt($r('app.media.ic_nomusic_img'))
          .fillColor($r('app.color.media_control_icon_disable'))
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
            .width('100%')
            .height('100%')
          .borderRadius((this.mediaSmallImgWidth === this.mediaSmallImgHeight ?
          Constants.MEDIA_IMAGE_RADIUS_SIZE_SMALL : 5))
          .draggable(false)
          .align(Alignment.Center)
          .objectFit(ImageFit.Contain)
          .onComplete((newValue: ImageCallback) => {
            this.onImageComplete(newValue, Constants.EXPAND_PICTURE_SIZE_SMALL, true);
          })
          .id('mediaSmallImage')
          .geometryTransition(this.getGeometryKey('mediePicKey'), this.getGeometryOptions())
          .zIndex(1)
          .autoResize(false)
          .interpolation(ImageInterpolation.Medium)
          .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      } else {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius((this.mediaSmallImgWidth === this.mediaSmallImgHeight ?
          Constants.MEDIA_IMAGE_RADIUS_SIZE_SMALL : 5))
          .clip(false)
          .backgroundColor($r('app.color.media_control_default_img_bgc'))
          .id('defaultSamllBg')
          .geometryTransition(this.getGeometryKey('defaultImageBg'), this.getGeometryOptions())
          .zIndex(0)
        Image($r('app.media.ic_nomusic_img_big'))
          .fillColor($r('app.color.media_control_icon_disable'))
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .width(18)
          .height(18)
          .draggable(false)
          .renderFit(RenderFit.RESIZE_COVER)
          .id('defaultImage')
          .geometryTransition(this.getGeometryKey('defaultImageKey'), this.getGeometryOptions())
          .zIndex(1)
          .onComplete((newValue: ImageCallback) => {
            this.onImageComplete(newValue, Constants.EXPAND_PICTURE_SIZE_SMALL, true);
          })
          .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
      }
    }
    .width('100%')
    .height('100%')
    .key('media_small_image')
  }

  @Builder iconSmallImageBuilder(){
    Column() {
      Image(this.appIcon)
        .size({ width: '100%', height: '100%'})
        .backgroundColor(Constants.TRANSLUCENT_COLOR)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
    }
    .clip(true)
    .size({
      width:Constants.EXPAND_ICON_SIZE_SMALL,
      height:Constants.EXPAND_ICON_SIZE_SMALL
    })
    .position(this.isRTL() ? { right: this.iconSmallImgX, top: this.iconSmallImgY } :
      { left: this.iconSmallImgX, top: this.iconSmallImgY })
    .backgroundColor(Constants.TRANSLUCENT_COLOR)
    .borderRadius(Constants.ICON_RADIUS_SIZE_SMALL)
    .align(Alignment.BottomEnd)
    .key('media_icon_samll_img')
    .id('mediaSmallIcon')
    .geometryTransition(this.getGeometryKey('iconImg'), this.getGeometryOptions())
  }

  @Builder iconBigImageBuilder(isNew: boolean) {
    Column() {
      Image(this.appIcon ? this.appIcon : ImageContent.EMPTY)
        .size({ width: '100%', height: '100%' })
        .backgroundColor(Constants.TRANSLUCENT_COLOR)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
    }
    .clip(true)
    .size({
      width: Constants.EXPAND_ICON_SIZE,
      height: Constants.EXPAND_ICON_SIZE
    })
    .position(this.isRTL() ? { right: this.iconBigImgX, top: this.iconBigImgY } :
      { left: this.iconBigImgX, top: this.iconBigImgY })
    .backgroundColor(Constants.TRANSLUCENT_COLOR)
    .borderRadius(Constants.ICON_RADIUS_SIZE_BIG)
    .align(Alignment.BottomEnd)
    .key('media_icon_big_img')
    .id('mediaBigIcon')
    .geometryTransition(this.getBigImageGeometryKey(isNew, this.newImageOpacity, this.oldImageOpacity, 'iconImg'), this.getGeometryOptions())
  }

  @Builder imagesBuilder(isNew: boolean) {
    Stack() {
      this.mediaBigImageStack(isNew);
      this.iconBigImageBuilder(isNew);
    }
    .alignContent(Alignment.BottomEnd)
    .backgroundColor(Constants.TRANSLUCENT_COLOR)
    .scale(isNew ? {x : this.newScale, y : this.newScale } : {x : this.oldScale, y : this.oldScale })
    .opacity(isNew ? this.newImageOpacity : this.oldImageOpacity)
    .height(Constants.PANEL_EXPAND_WIDTH - Constants.PIC_CONTAINER_WIDTH) //高度会畸变，不能去掉
  }

  @Builder largeImageBuilder() {
    Column() {
      Stack() {
        //专辑图片和图标淡入淡出
        if (!this.hasMedia || !this.title) {
          this.imagesBuilder(true);
        } else if (globalStorage.getBooleanByKey('coldStartAnim')) {
          this.imagesBuilder(false);
        } else {
          this.imagesBuilder(false);
          this.imagesBuilder(true);
        }
      }
      .accessibilityLevel('yes')
      .id('imagesBox')
      .transition(
        TransitionEffect.asymmetric(
          TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 250 }),
          TransitionEffect.OPACITY.animation({ curve: Curve.Sharp, duration: 250 })
        )
      )

      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.End,
        alignItems: ItemAlign.Start
      }) {
        this.textBuilder();
      }
      .width('100%')
      .height(MeasuringUtil.getHeight(16, MeasuringUtil.getHeight(14, 51, 1.45, this.getFontSizeScale()),
        1.45, this.getFontSizeScale()))
      .transition(this.getLargeImageTextInfoTransitionEffect())
    }
    .width('100%')
    .padding({ left: 24, right: 24 })
    .onClick(() => {
      this.controller.jumpAppWithScreenLock(this.curSessionId);
    })
  }
  @Builder samllImageBuilder() {
    Row() {
      Stack() {
        this.mediaSmallImageBuilder();
        this.iconSmallImageBuilder();
      }
      .alignContent(Alignment.BottomEnd)
      .backgroundColor(Constants.TRANSLUCENT_COLOR)
      .width(Constants.EXPAND_PICTURE_SIZE_SMALL)
      .height(Constants.EXPAND_PICTURE_SIZE_SMALL)
      Column() {
        this.textBuilder();
      }
      .width(`calc(100% - ${Constants.EXPAND_PICTURE_SIZE_SMALL}vp)`)
      .padding({ left: this.isRTL() ? 0 : 12, right: this.isRTL() ? 12 : 0})
      .transition(this.getSmallImageTextInfoTransitionEffect())
    }
    .alignItems(VerticalAlign.Center)
    .padding({ left: 24, right: 24 })
    .height(Constants.EXPAND_PICTURE_SIZE_SMALL)
    .width('100%')
    .onClick(() => {
      this.controller.jumpAppWithScreenLock(this.curSessionId);
    })
  }

  getMediaCardTransition(): TransitionEffect {
    if (!this.hasCall) {
      return TransitionEffect.IDENTITY;
    }
    return TransitionEffect.translate({y: Constants.PANEL_EXPAND_HEIGHT_SMALL})
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0)
        .animation({ duration: 150, curve: Curve.Sharp }))
      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5, z: 0.5 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) }))
  }

  getLargeImageTextInfoTransitionEffect(): TransitionEffect {
    return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
      .animation({ curve: Curve.Sharp, duration: 33, delay: 200 }),
      TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 50 }))
  }

  getSmallImageTextInfoTransitionEffect(): TransitionEffect {
    if (this.hasCall) {
      return TransitionEffect.IDENTITY;
    }
    if (this.currentIndex === 1) {
      return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
        .animation({ duration: 100, curve: Curve.Sharp, delay: 200 })
        .combine(TransitionEffect.translate({ x: 200 })
          .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })),
        TransitionEffect.opacity(0)
          .animation({ duration: 100, curve: Curve.Sharp })
          .combine(TransitionEffect.translate({ x: 200 })
            .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })))
    }
    return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
      .animation({ curve: Curve.Sharp, duration: 100, delay: 100 }),
      TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 100 }))
  }

  getRecentlyPlayTransitionEffect(): TransitionEffect {
    if (this.currentIndex === 1) {
      return TransitionEffect.opacity(0);
    } else {
      return TransitionEffect.asymmetric(TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 100, delay: 100 }),
        TransitionEffect.opacity(0)
          .animation({ curve: Curve.Sharp, duration: 100 }))
    }
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
      if (isVisible) {
        this.swiperController.changeIndex(this.currentIndex);
      }
    })
    .id('swiperEnd')
    .visibility(this.isShowDev || this.hasCall ? Visibility.Hidden : Visibility.Visible)
    .zIndex(1)
  }

  isShowPreferAction(){

  }

  /**
   * 猜你喜欢数据改变监听
   */
  recommendDataChange() {
  }

  /**
   * 最近播放数据改变监听
   */
  historyDataChange() {
  }

  @Builder
  recentlyPlayListGroupHead() {
    Row() {
      Text($r('app.string.RecentlyPlay'))
        .fontSize(12)
        .fontColor($r('sys.color.font_secondary'))
        .fontWeight($r('sys.string.ohos_id_text_font_family_regular'))
        .maxFontScale(this.maxTextFontScale)
    }
    .padding({ top: this.hasMedia && this.title ? 6 : 12, bottom: 12 })
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // 列表顶部正在播放的音乐信息
  @Builder
  playingLayout() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Stack() {
          if (!this.mediaImage || this.mediaImage === '') {
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
          } else {
            Image(this.mediaImage)
              .width(40)
              .height(40)
              .borderRadius(8)
              .draggable(false)
          }
        }

        Image(this.appIcon)
          .width(12)
          .height(12)
          .draggable(false)
      }
      .flexGrow(0)
      .flexShrink(0)
      .flexBasis('auto')
      .onClick(() => {
        this.controller.jumpAppWithScreenLock(this.curSessionId);
      })
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityText($r('app.string.access_cover_image'))

      Column() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Text(typeof this.title === 'string' ? this.title : '')
            .fontSize(14)
            .fontColor(this.isPlaying() ? $r('sys.color.icon_emphasize') : $r('sys.color.font_primary'))
            .fontWeight($r('sys.string.ohos_id_text_font_family_medium'))
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .flexBasis('auto')
            .maxFontScale(this.maxTextFontScale)
            .constraintSize({ maxWidth: Constants.RECENTLY_PLAY_TEXT_MAX_LENGTH })

          if (this.isMarqueeStart && this.isPlaying()) {
            JumpingNotes({
              lottieFileName: 'jumping_notes.json',
              isPlaying: this.isPlaying()
            })
              .margin({ left: this.isRTL() ? 0 : 4, right: this.isRTL() ? 4 : 0 })
              .width(16)
              .height(12)
          }
        }

        Text(typeof this.artist === 'string' ? this.artist : '')
          .width('100%')
          .fontSize(12)
          .fontColor(this.isPlaying() ? $r('sys.color.icon_emphasize') : $r('sys.color.font_primary'))
          .fontWeight($r('sys.string.ohos_id_text_font_family_regular'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 2 })
          .maxFontScale(this.maxTextFontScale)
          .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
      }
      .justifyContent(FlexAlign.Start)
      .padding({ left: this.isRTL() ? 0 : 12, right: this.isRTL() ? 12 : 0 })
      .onClick(() => {
        if (!this.isPlaying()) {
          this.controller?.callShowingPlay(false);
        }
        this.tabsController.changeIndex(1);
        this.swiperController.changeIndex(1)
      })
    }
    .margin({ bottom: 6 })
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

  @Builder
  recentlyPlayAndBigImageBuilder() {
    Tabs({ barPosition: BarPosition.Start, controller: this.tabsController, index: this.currentIndex }) {
      TabContent() {
        Column() {
          if (this.hasMedia && this.title) {
            this.playingLayout();
          }
          List() {
            if (this.mediaInfoListData && this.mediaInfoListData.length > 0) {
              ListItemGroup({ header: this.recentlyPlayListGroupHead(), space: 12 }) {
                RecentlyPlayList({
                  isFromExpandDevice: true,
                  isControlCenterOpen: !!this.isMarqueeStart,
                  clickAvQueueItem: (bundleName: string, avQueueId: string, sessionId: string) => {
                    this.controller?.playAvQueue(bundleName, avQueueId);
                  },
                  startAimApp: (sessionId: string) => {
                    this.controller?.jumpAppWithScreenLock(sessionId);
                  },
                  startDefaultAppNow: (sessionId: string, isFromSessionCreate: boolean, callPlay: boolean) => {
                    this.controller?.startShowingDefaultApp(sessionId, isFromSessionCreate);
                    this.tabsController.changeIndex(1);
                    this.swiperController.changeIndex(1);
                  },
                  clickActiveApp: (sessionId: string, isPlaying: boolean) => {
                    this.controller?.callPlay(sessionId, false, isPlaying);
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
          .scrollBar(BarState.Off)
          .height(Constants.FOLD_DEVICE_RECENTLY_PLAYING_HEIGHT)

          if (!(this.hasMedia && this.title)) {
            Flex({
              direction: FlexDirection.Column,
              justifyContent: FlexAlign.End,
              alignItems: ItemAlign.Start
            }) {
              this.textBuilder();
            }
            .width('100%')
            .height(MeasuringUtil.getHeight(16, MeasuringUtil.getHeight(14, 51, 1.45, this.getFontSizeScale()),
              1.45, this.getFontSizeScale()))
            .transition(this.getLargeImageTextInfoTransitionEffect())
          }
        }
        .transition(this.getRecentlyPlayTransitionEffect())
        .onTouch((event?: TouchEvent) => {
          event?.stopPropagation();
        })
      }
      .padding({ left: 24, right: 24 })
      .align(Alignment.TopStart)

      TabContent() {
        Column() {
          Stack() {
            this.largeImageBuilder();
          }
          .onClick(() => {
            this.controller.jumpAppWithScreenLock(this.curSessionId);
          })
        }
      }
    }
    .onSelected((index: number) => {
      this.currentIndex = index;
      this.swiperController.changeIndex(index, true);
    })
    .animationDuration(500)
    .animationMode(AnimationMode.CONTENT_FIRST_WITH_JUMP)
    .barHeight(0)
    .edgeEffect(EdgeEffect.Spring)
    .scrollable(this.isExistAvQueueInfo && this.hasMedia)
    .width('100%')
    .height(Constants.FOLD_DEVICE_TABS_HEIGHT)
  }

  @Builder
  headerAndDotBuilder() {
    Stack({ alignContent: Alignment.Top }) { // 解决层叠关系投音按钮点不到问题
      this.headerBuilder()
      if (this.isExistAvQueueInfo && this.hasMedia) {
        Column() {
          Column().width('100%').height(this.isShowDev || this.hasCall ? 24 : 32)
          this.tabsSwiper();
        }
        .clip(false)
      }
    }
    .height(this.isShowDev || this.hasCall ? 48 : 56)
  }

  build() {
    if (!this.isShowDev || this.showDevType === ShowDevType.MEDIA) {
      Stack({ alignContent: Alignment.Top }) {
        Column()
          .backgroundColor($r('app.color.media_control_card_bgc'))
          .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
          .saturate(1) //饱和度
          .shadow({ radius : 0})
          .width('100%')
          .height('100%')
          .borderRadius((!this.isShowDev) ?
            Constants.MEDIA_CARD_BORDER_RADIUS : Constants.MEDIA_CARD_LANDSCAPE_BORDER_RADIUS)
          .border({
            width: 0,
            color: '#00000000',
          })
          .backdropBlur(0)
          .id('mediaExpandPanel')
          .geometryTransition('mediaPanelExpand', { hierarchyStrategy: TransitionHierarchyStrategy.NONE })

        Column() {
          Column() {
            if (!this.isShowDev && !this.hasCall) {
              this.headerAndDotBuilder();
              this.recentlyPlayAndBigImageBuilder();
            } else {
              this.headerAndDotBuilder();
              this.samllImageBuilder();
            }
            this.progressStack();
            this.controlButtonGroupBuilder();
          }
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height(!this.isShowDev && !this.hasCall ? Constants.PANEL_EXPAND_HEIGHT :
        Constants.PANEL_EXPAND_HEIGHT_SMALL)
      .clip(false)
      .margin({left:0})
      .key('media_expand_card')
      .transition(this.getMediaCardTransition())
    } else {
      Column().width('100%')
    }
  }

  titleChange() {
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
    log.showInfo('old title:' + this.oldGetText + ',new title:' + this.newGetText);
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
  playStateUpdate() {
    if (this.isLocalSpeaker() || this.dropDownEvent.target !== TargetPanel.CONTROL_CENTER_PANEL) {
      // 避免重复刷帧
      clearInterval(this.animTimerId);
      this.animTimerId = undefined;
      this.opacityValueOne = 0.1;
      this.opacityValueTwo = 0.1;
      this.opacityValueThree = 0.1;
      return;
    }
    if (this.playState === 2 && this.isPlaying()) {
      if (this.animTimerId === undefined) {
        this.animTimerId = setInterval(() => {
          this.opacityValueOneFn();
          this.opacityValueTwoFn();
          this.opacityValueThreeFn();
        }, 1300);
      }
    } else {
      clearInterval(this.animTimerId);
      this.animTimerId = undefined;
      this.opacityValueOne = 0.1;
      this.opacityValueTwo = 0.1;
      this.opacityValueThree = 0.1;
    }
  }
  /**
   * 播放时，标题行动画-1
   */
  opacityValueOneFn() {
    this.uiContext.animateTo({
      duration: 250, // 动画时长
      curve: Curve.Linear, // 动画曲线
      delay: 0, // 动画延迟
      playMode: PlayMode.Normal // 动画模式
    }, () => {
      this.opacityValueOne = 0.4;
    })
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 250,
      playMode: PlayMode.Normal
    }, () => {
      this.opacityValueOne = 0.2;
    })
    this.uiContext.animateTo({
      duration: 600,
      curve: Curve.Linear,
      delay: 700,
      playMode: PlayMode.Normal
    }, () => {
      this.opacityValueOne = 0.1;
    })
  }

  /**
   * 播放时，标题行动画-2
   */
  opacityValueTwoFn() {
    this.uiContext.animateTo({
      duration: 350,
      curve: Curve.Linear,
      delay: 100,
      playMode: PlayMode.Normal
    }, () => {
      this.opacityValueTwo = 0.4;
    })
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 450,
      playMode: PlayMode.Normal
    }, () => {
      this.opacityValueTwo = 0.2;
    })
    this.uiContext.animateTo({
      duration: 400,
      curve: Curve.Linear,
      delay: 900,
      playMode: PlayMode.Normal
    }, () => {
      this.opacityValueTwo = 0.1;
    })
  }

  /**
   * 播放时，标题行动画-3
   */
  opacityValueThreeFn() {
    this.uiContext.animateTo({
      duration: 450,
      curve: Curve.Linear,
      delay: 250,
      playMode: PlayMode.Normal
    }, () => {
      this.opacityValueThree = 0.4;
    })
    this.uiContext.animateTo({
      duration: 350,
      curve: Curve.Linear,
      delay: 750,
      playMode: PlayMode.Normal
    }, () => {
      this.opacityValueThree = 0.2;
    })
    this.uiContext.animateTo({
      duration: 250,
      curve: Curve.Linear,
      delay: 1050,
      playMode: PlayMode.Normal
    }, () => {
      this.opacityValueThree = 0.1;
    })
  }

  artistChange() {
    if (this.oldMusicAuthorTwo.length == 0 && this.newMusicAuthorTwo.length == 0) {
      this.oldMusicAuthorTwo = this.getMusicAuthor();
    } else if (this.oldMusicAuthorTwo.length != 0 && this.newMusicAuthorTwo.length == 0) {
      this.newMusicAuthorTwo = this.getMusicAuthor();
    } else if (this.oldMusicAuthorTwo.length != 0 && this.newMusicAuthorTwo.length != 0) {
      if (this.oldLyricOpacity == 0) {
        this.oldMusicAuthorTwo = this.getMusicAuthor();
      } else {
        this.newMusicAuthorTwo = this.getMusicAuthor();
      }
    }
  }

  getMusicAuthor(): string {
    return typeof this.artist === 'string' ? this.artist : '';
  }

  getMediaImage(): string | image.PixelMap {
    if (this.mediaImage && (typeof this.mediaImage !== 'string' || CommonUtils.isBase64Image(this.mediaImage))) {
      return this.mediaImage;
    } else {
      return this.oldMediaImage;
    }
  }

  mediaImageChange() {
    if (!this.oldMediaImage && !this.newMediaImage) {
      this.oldMediaImage = this.getMediaImage();
    } else if (!!this.oldMediaImage && !this.newMediaImage) {
      this.newMediaImage = this.getMediaImage();
    } else if (!!this.oldMediaImage && !!this.newMediaImage) {
      if (this.oldImageOpacity == 0) {
        this.oldMediaImage = this.getMediaImage();
      } else {
        this.newMediaImage = this.getMediaImage();
      }
    }
  }

  iconChange() {
    if (!this.oldIconImage && !this.newIconImage) {
      this.oldIconImage = this.appIcon;
    } else if (!!this.oldIconImage && !this.newIconImage) {
      this.newIconImage = this.appIcon;
    } else if (!!this.oldIconImage && !!this.newIconImage) {
      if (this.oldImageOpacity == 0) {
        this.oldIconImage = this.appIcon;
      } else {
        this.newIconImage = this.appIcon;
      }
    }
  }

  getBigImage(isNew?: boolean): string | image.PixelMap {
    if (this.isClickAlbum || globalStorage.getBooleanByKey('coldStartAnim')) {
      return isNew ? this.newMediaImage : this.oldMediaImage;
    }
    if (isNew) {
      return this.getMediaImage() || this.newMediaImage;
    } else {
      return this.getMediaImage() || this.oldMediaImage;
    }
  }

  getBigIcon(isNew?: boolean): string | image.PixelMap {
    if (this.isClickAlbum || globalStorage.getBooleanByKey('coldStartAnim')) {
      return isNew ? this.newIconImage : this.oldIconImage;
    }
    if (isNew) {
      return this.appIcon || this.newIconImage;
    } else {
      return this.appIcon || this.oldIconImage;
    }
  }

  getSubtitleText(isNew?: boolean): string {
    if (this.isClickAlbum) {
      return isNew ? this.newMusicAuthorTwo : this.oldMusicAuthorTwo;
    }
    if (isNew) {
      return this.getMusicAuthor() || this.newMusicAuthorTwo;
    } else {
      return this.getMusicAuthor() || this.oldMusicAuthorTwo;
    }
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
}
