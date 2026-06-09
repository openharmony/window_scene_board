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
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { DropDownEvent, TargetPanel, WindowEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { ScreenOnOffEvent, MediaControlEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiDfxEventUtil';
import { HiSysDataMediaCommand } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import audio from '@ohos.multimedia.audio';
import Curves from '@ohos.curves';
import AnimationIconLocal from './components/AnimationIconLocal';
import { CardMediaController } from '../Controller/CardMediaController';
import { DcMediaController } from '../Controller/DcMediaController';
import { CardMediaControllerDc } from '../Controller/CardMediaControllerDc';
import StyleConfiguration, { MediaControlCardLayoutStyle } from '../Util/StyleConfiguration';
import AVSessionManager from '@ohos.multimedia.avsession';
import display from '@ohos.display';
import image from '@ohos.multimedia.image';
import Constants, {
  ActionType,
  CurOutputDevTS,
  AVCastPickerDeviceIconName,
  GeometryOptions,
  ButtonIconName,
  SyncDeviceInfo,
  CallSessionInfo,
} from '../Util/Constants';
import { globalStorage } from '../Util/GlobalStorage';
import { LengthMetrics } from '@kit.ArkUI';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ControlCenterState } from '@ohos/controlcentercommon/src/main/ets/common/ControlCenterConstants';
import CommonUtils from '../Util/CommonUtils';
import { access } from '@kit.ConnectivityKit';
import { CommonConstants, DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { vibratorMgr } from '@ohos/launchercommon/src/main/ets/manager/VibratorManager';
import MeasuringUtil from '../Util/MeasuringUtil';
import { i18n } from '@kit.LocalizationKit';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityUtil';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import CommunicationUtil from '../Util/CommunicationUtil';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { MediaViewModelManager, MediaVMType } from '../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../viewmodel/SysConfigData';

const TAG = 'MediaCardComponent_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const COMPONENT_ID_MEDIA_IMG = TAG + '_Image_mediaImg';
const COMPONENT_ID_APP_ICON = TAG + '_Image_appIcon';
const COMPONENT_ID_PREVIOUS = TAG + '_Image_previous';
const COMPONENT_ID_PAUSE = TAG + '_Image_pause';
const COMPONENT_ID_NEXT = TAG + '_Image_next';
const COMPONENT_ID_OUTPUT_TYPE = TAG + '_Image_outputType';
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_ID_ARTIST = TAG + '_Text_artist';
const COMPONENT_ID_REWIND = TAG + '_Image_rewind';
const COMPONENT_ID_FAST_FORWARD = TAG + '_Image_fastForward';
const COMPONENT_ID_AUDIO_BUTTON = TAG + '_Audio_button';
const COMPONENT_ID_BUTTON_FIRST = TAG + '_button_first';
const TITLE_WIDTH: number = 113;
const TITLE_MARGIN_LEFT: number = 11;
const TITLE_MARGIN_RIGHT: number = 12;
const AV_SESSION_TYPE_VIDEO: string = 'video';
const MEDIA_BUTTON_SCALE: number = 1.2;
const PC_MEDIA_BUTTON_SCALE: number = 1.1;

@Component
export default struct MediaCardComponent {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  @StorageLink('CurSessionId') private curSessionId: string = '';
  @StorageLink('MediaImg') @Watch('updateShowPlayButton') mediaImg : string | image.PixelMap = '';
  @StorageLink('MediaImgShow') mediaImgShow : boolean = false;
  @StorageLink('MediaIcon') appIcon : string | image.PixelMap = '';
  @StorageLink('appIconShow') appIconShow : string | image.PixelMap = '';
  @StorageLink('ControlMediaTitle') @Watch('mediaStatueUpdate') title : string | boolean = '';
  @StorageLink('MediaArtist') @Watch('mediaStatueUpdate') artist : string | boolean =
    this.getResourceString($r('app.string.no_media_title'));
  @StorageLink('MediaPlayState') @Watch('mediaStatueUpdate') playState : number = 0;
  @StorageLink('MediaEnable') @Watch('mediaStatueUpdate') hasMedia : boolean = true;
  @StorageLink('MediaValidCommands') @Watch('mediaStatueUpdate') validCommands : Array<string> = [];
  @StorageLink('MediaSkipIntervals') @Watch('mediaStatueUpdate') skipIntervals: number = 15;
  @StorageLink('MediaType') @Watch('mediaStatueUpdate') mediaType: AVSessionManager.AVSessionType = 'audio'
  @StorageLink('appName') @Watch('updateShowPlayButton') curAppName: string | boolean = '';
  @StorageLink('CurDevSelect') @Watch('curOutputDevChanged') curOutputDev: CurOutputDevTS =
    {deviceType: audio.DeviceType.SPEAKER, deviceId: -1, networkId: 'LocalDevice'};
  @StorageLink('curCallDev') @Watch('curCallDevChanged') curCallDev: CurOutputDevTS =
    {deviceType: audio.DeviceType.SPEAKER, deviceId: -1, networkId: 'LocalDevice'};
  @StorageLink('CurRemoteDevSelect') @Watch('curRemoteOutputDevChanged') curRemoteOutputDev : number = -1;
  private controller: CardMediaController | CardMediaControllerDc = this.enableDc ?
    CardMediaControllerDc.getInstance() : CardMediaController.getInstance(); // 开启worker时，使用DC子线程controller
  private dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  @StorageLink('isVideo') isVideo: boolean = false;
  @Link isLandscape : boolean;
  @Link mediaLandscape: boolean;
  @State style : MediaControlCardLayoutStyle = StyleConfiguration.getMediaControlCardLayoutStyle();
  @State private isCanPlayNext: boolean = false;
  @State private isCanPlayPrevious: boolean = false;
  @State private isShowPlayButton: boolean = true;
  @State private isStartMarquee: boolean | null = false;
  @State private isCanFastForward: boolean = false;
  @State private isCanRewind: boolean = false;
  @State isForceDark: boolean = DeviceHelper.isPhoneOrPad();
  @State imageReady: boolean = false;
  @State imagesWidth: number = 0;
  @State imagesHeight: number = 0;
  @StorageLink('iconSmallX') imagesX: number = 48 - 16;
  @StorageLink('iconSmallY') imagesY: number = 48 - 16;
  @State mediaCardX: Length = 0;
  @State mediaCardY: Length = 0;
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private isPC: boolean = DeviceHelper.isPC();
  @StorageLink('imgSmallWidth') imgWidthSize: number = 48;
  @StorageLink('imgSmallHeight') imgHeightSize: number = 48;
  @StorageLink('ControlCenterState') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @State isLottieDisable: boolean = false;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private lastEventType: number = -1;
  private geometryOptions: GeometryOptions = { hierarchyStrategy: TransitionHierarchyStrategy.NONE };
  private isLongPress: boolean = false;
  private longPressTimer: number | undefined = undefined;
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;
  @StorageLink('foldStatusForOuterScreen') @Watch('updateImageSize') foldStatus: number =
    AppStorage.get<number>('foldStatusForOuterScreen') as number;
  @State isSmallFoldOuterScreen: boolean = false;
  @State iconTypeKey: string = 'center';
  @State private mediaMarqueeFontsize: number = ResUtils.getNumber($r('app.float.control_center_media_marquee_fontsize'));
  @State isCanPlay: boolean = false;
  @State @Watch('playStateUpdate') isPlaying: boolean = false;
  @State isFoldDevice: boolean = false; // 是否为折叠屏
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;
  @StorageLink('hasCall') hasCall: boolean = false;
  @StorageLink('callSessionInfo') callSession: CallSessionInfo | undefined = undefined;
  @State defaultResourceName: string = 'app.string.volume_channel_voice_call';
  @StorageLink('showPlayLoading') showPlayLoading: boolean = false;
  private showPlayLoadingTimer: number | undefined = undefined;
  @StorageProp('canColdStart') @Watch('updateShowPlayButton') canColdStart: boolean = false;

  // 是否做动效标记，数值改变触发动效
  @State fastForwardTriggerValue: number = 0;
  @State fastRewindTriggerValue: number = 0;
  @State playPauseTriggerValue: number = 0;

  @State private cardMediaPicSize: number = 0;
  @State private cardMediaIconSize: number = 0;
  @State private cardMediaPicRadius: number = 0;
  @State private cardMediaPicSmallRadius: number = 0;
  @State private cardMediaIconRadius: number = 0;
  @StorageLink('isFreeShow') isFreeShow: boolean = false;
  private lastPlayState: number = 0;
  @State titleReady: boolean = false;
  @StorageProp('Duration') @Watch('mediaStatueUpdate') duration: number | undefined = 0;
  @State @Watch('mediaStatueUpdate') isInCast: boolean = this.curRemoteOutputDev >= 0;

  /**
   * 下拉事件
   */
  @StorageLink('dropDownEvent')
  @Watch('onDropdownChanged')
  dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();

  /**
   * 缓存下拉目标面板
   */
  lastTargetPanel: TargetPanel = TargetPanel.NONE;

  private cacheEarphoneIcon: string = 'sys.symbol.earphone_bluetooth';

  /**
   * 组件key值，播控中心入口卡片key前缀
   */
  private static readonly KEY_MEDIA_CARD_PRE = 'control_center_media_card_';

  /**
   * 组件key值，播控中心入口卡片媒体图片部分
   */
  private static readonly KEY_PICTURE = 'picture';

  /**
   * 组件key值，播控中心入口卡片媒体文字部分
   */
  private static readonly KEY_TITLE = 'title';

  /**
   * 组件key值，播控中心入口卡片右上角设备图标按钮
   */
  private static readonly KEY_SWITCH = 'switch';

  /**
   * 组件key值，播控中心入口卡片右上角设备图标按钮
   */
  private static readonly KEY_PREVIOUS = 'previous';

  /**
   * 组件key值，播控中心入口卡片右上角设备图标按钮
   */
  private static readonly KEY_PLAY_OR_PAUSE = 'play_or_pause';

  /**
   * 组件key值，播控中心入口卡片右上角设备图标按钮
   */
  private static readonly KEY_NEXT = 'next';

  /**
   * 组件key值，播控中心入口卡片快退按钮
   */
  private static readonly KEY_REWIND = 'rewind';

  /**
   * 组件key值，播控中心入口卡片快进按钮
   */
  private static readonly KEY_FAST_FORWARD = 'fastForward';

  /**
   * AVSession缺失设备类型，标识PC
   */
  private readonly LOST_DEVICE_TYPE_PC = 8;

  /**
   * AVSession缺失设备类型，标识PAD
   */
  private readonly LOST_DEVICE_TYPE_PAD = 6;
  /**
   * AVSession缺失设备类型，标识phone
   */
  private readonly LOST_DEVICE_TYPE_PHONE = 7;

  /**
   * 按钮组件大小
   */
  private readonly BTN_SIZE: number = 38;
  private readonly BTN_MARGIN: number = -7;

  private isBussinessStyle: boolean = false;

  checkCall() {
    return this.hasCall && !this.isPC;
  }

  getCurSwitchIcon() : string {
    log.showInfo(`getshowing curswitch : Localdevice: ${this.curOutputDev.deviceId?.toString().length < 10 ? '' :
      (this.curOutputDev.deviceId?.toString().substr(0, 5) + '**' + this.curOutputDev.deviceId?.toString().substr(
        this.curOutputDev.deviceId?.toString().length - 5))}, ` + `LocalType: ${this.curOutputDev.deviceType},
        remoteType: ${this.curRemoteOutputDev}, network: ${this.curOutputDev.networkId?.toString().length}`);
    if (this.curRemoteOutputDev >= 0 && !this.checkCall()) {
      switch (this.curRemoteOutputDev) {
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
    let curDev = this.checkCall() ? this.curCallDev : this.curOutputDev;
    switch (curDev.deviceType) {
      case audio.DeviceType.SPEAKER:
        if (CommonUtils.isShowCarIcon(curDev.networkId, curDev.deviceType)) {
          return AVCastPickerDeviceIconName.CAR_SYMBOL;
        } else {
          return this.mediaType === 'video' && !this.checkCall() ?
            AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL : AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
        }
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
        return AVCastPickerDeviceIconName.WIRED_SYMBOL;
      case audio.DeviceType.BLUETOOTH_A2DP:
      case audio.DeviceType.BLUETOOTH_SCO:
        return this.getBluetoothEarphoneIcon(curDev);
      case audio.DeviceType.NEARLINK:
        return CommonUtils.getNearlinkFillIcon(curDev.deviceAddress);
      case Constants.DEVICE_TYPE_HEARING_AID:
        return AVCastPickerDeviceIconName.HEARING_AID_SYMBOL;
      default:
        return this.mediaType === 'video' && !this.checkCall() ? AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL :
          AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
    }
  }

  private getBluetoothEarphoneIcon(curDev: CurOutputDevTS): string {
    try {
      if (access.getState() !== access.BluetoothState.STATE_ON) {
        log.showInfo(`show cache earphone icon, state is ${access.getState()}`);
        // 蓝牙未开启，使用之前耳机图标，等待类型变化改图标
        return this.cacheEarphoneIcon;
      }
      // 蓝牙开启，可以重新获取图标
      this.cacheEarphoneIcon = CommonUtils.getBluetoothFillIcon(curDev.deviceAddress);
      return this.cacheEarphoneIcon;
    } catch (e) {
      log.showInfo(TAG, `getBluetoothEarphoneIcon get bluetoothState failed: ${e?.code}, ${e?.message}`);
      return CommonUtils.getBluetoothFillIcon(curDev.deviceAddress);
    }
  }

  /**
   * 下拉事件参数改变回调
   */
  onDropdownChanged() {
    if (this.lastTargetPanel === this.dropDownEvent.target) {
      return;
    }
    if (this.dropDownEvent.target === TargetPanel.NONE && this.isStartMarquee) {
      this.isStartMarquee = false;
    } else if (this.dropDownEvent.target !== TargetPanel.NONE && !this.isStartMarquee) {
      this.isStartMarquee = true;
    }
    log.showInfo(`onDropdownChanged, targetChanged: last=${this.lastTargetPanel}, cur=${this.dropDownEvent.target}`);
    this.controller.panelStateChange(this.dropDownEvent.target);
    this.lastTargetPanel = this.dropDownEvent.target;
  }

  curRemoteOutputDevChanged() {
    let sendData: SyncDeviceInfo = {
      remoteDevice: this.curRemoteOutputDev
    }
    CommunicationUtil.doLocalEventNotify('ntfRemoteDeviceUpdate', sendData);
    const isInCast = this.curRemoteOutputDev >= 0;
    if (this.isInCast !== isInCast) {
      this.isInCast = isInCast;
    }
  }

  curOutputDevChanged() {
    let sendData: SyncDeviceInfo = {
      deviceId: this.curOutputDev.deviceId,
      deviceType: this.curOutputDev.deviceType,
      deviceAddress: this.curOutputDev.deviceAddress,
      networkId: this.curOutputDev.networkId,
    }
    if (this.enableDc) {
      // 同步至主线程
      this.dcController?.setAppStorage('CurDevSelect', sendData);
    }
  }

  curCallDevChanged() {
    let sendData: SyncDeviceInfo = {
      deviceId: this.curCallDev.deviceId,
      deviceType: this.curCallDev.deviceType,
      deviceAddress: this.curCallDev.deviceAddress,
      networkId: this.curCallDev.networkId,
    }
    if (this.enableDc) {
      // 同步至主线程
      this.dcController?.setAppStorage('curCallDev', sendData);
    }
  }

  aboutToAppear() {
    log.showInfo(`MediaCardComponent aboutToAppear`);
    this.controller.doSubscribeNotify();
    this.controller.startShowing(TAG);
    // 播控监听
    EvtBus.on(MediaControlEvent, this.onMediaControlCallback);
    this.eventMgr.on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
      AppStorage.setOrCreate('isCurScreenOn', event.isScreenOn());
      if (this.enableDc) {
        this.dcController?.setAppStorage('isCurScreenOn', event.isScreenOn());
      }
      log.showInfo(`onScreenOnOffEvent isCurScreenOn: ${event.isScreenOn()}`);
    });
    this.setWindowEventListener();
    this.updateImageSize();
    this.getIsFoldable();
  }

  setWindowEventListener() {
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.windowName !== 'SysUI_Dropdown' || this.lastEventType === event.eventType) {
        return;
      }
      this.lastEventType = event.eventType;
      log.showInfo(`current state is ${this.controlCenterState}`);
      // 隐藏控制中心
      if (this.controlCenterState === ControlCenterState.MEDIA_CENTER &&
        event.eventType === WindowEvent.EVENT_TYPE_HIDE) {
        log.showInfo('current state change from media center to main layout');
        this.controller.closeSubWindow();
      }
      if (event.eventType === WindowEvent.EVENT_TYPE_HIDE) {
        this.showPlayLoading = false;
        this.clearLoadingTimer();
      }
    });
  }

  getIconColor(isShowButton: boolean): ResourceColor[] {
    if (this.isPC) {
      return (isShowButton ? [$r('app.color.ohos_id_color_primary')] :
        [$r('app.color.media_control_center_icon_disable_pc')]);
    } else {
      return isShowButton ? [$r('app.color.media_control_center_icon_primary')] :
        [$r('app.color.media_control_center_icon_disable')];
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.eventMgr.offAll();
    EvtBus.off(MediaControlEvent, this.onMediaControlCallback);
    this.showPlayLoading = false;
    this.clearLoadingTimer();
  }

  /**
   * 播控广播回调
   *
   * @param event 广播数据
   */
  onMediaControlCallback = (event: MediaControlEvent) => {
    if (this.enableDc) {
      this.dcController?.callGlobalContext({name: 'isMediaCenterShow', value: false});
    }
    if (event.data == MediaControlEvent.MEDIA_CONTROL_QUIT) {
      // 重置状态和动效标记，解决进入二级页面返回控制中心第一次点击播放按钮无动效问题
      this.isCanPlay = false;
      this.playPauseTriggerValue = 0;

      this.controller.doSubscribeNotify();
      this.controller.startShowing(TAG, true);
    }
  }

  mediaStatueUpdate() {
    log.debug(`media state update hasMedia isplay: ${this.hasMedia && this.isPlaying},`);
    log.debug(`media state update hasMedia: ${this.hasMedia}, ${this.playState}, ${this.title},
      media state update artist: ${this.artist}, ${this.curAppName}, ${this.validCommands}`);
    if (this.hasMedia && this.title === this.getResourceString($r('app.string.RecentlyPlay'))) {
      log.showInfo(`mediaStatueUpdate RECENTLY_PLAYED`);
      this.hasMedia = false;
    }
    this.isCanPlay = !!(this.title || this.artist);
    this.isCanPlayNext = this.isCanPlay && this.validCommands.includes('playNext');
    this.isCanPlayPrevious = this.isCanPlay && this.validCommands.includes('playPrevious');
    this.isCanFastForward = this.isCanPlay && this.validCommands?.includes('fastForward') && ((this.duration && this.duration > 0) || !this.isInCast);
    this.isCanRewind = this.isCanPlay && this.validCommands?.includes('rewind') && ((this.duration && this.duration > 0) || !this.isInCast);
    let validPlayOrPause: boolean = this.validCommands?.includes('play') && this.validCommands?.includes('pause');
    this.isShowPlayButton = this.hasMedia ? validPlayOrPause : this.canColdStart;
    if (this.playState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
      this.lastPlayState = this.playState;
    }
    let isPlay = CommonUtils.isPlaying(this.playState, this.lastPlayState, this.curRemoteOutputDev >= 0);
    if (this.isPlaying !== isPlay) {
      this.isPlaying = isPlay;
      this.showPlayLoading = false;
      this.clearLoadingTimer();
    }
  }

  updateShowPlayButton() {
    let validPlayOrPause: boolean = this.validCommands?.includes('play') && this.validCommands?.includes('pause');
    this.isShowPlayButton = this.hasMedia ? validPlayOrPause : this.canColdStart;
  }

  getSkipIntervalsIcon(isFastForward: boolean): string {
    if (this.skipIntervals === 10) {
      return isFastForward ? ButtonIconName.FAST_FORWARD_10 : ButtonIconName.FAST_REWIND_10;
    } else if (this.skipIntervals === 30) {
      return isFastForward ? ButtonIconName.FAST_FORWARD_30 : ButtonIconName.FAST_REWIND_30;
    } else {
      return isFastForward ? ButtonIconName.FAST_FORWARD_15 : ButtonIconName.FAST_REWIND_15;
    }
  }

  getSubTitle() {
    let result: string = '';
    if (!this.hasMedia) {
      result = this.getResourceString($r('app.string.no_media_title'));
    } else if (this.artist) {
      result = this.artist.toString();
    } else if ((!this.title && !this.curAppName) || (!this.title && this.curAppName)) {
      result = this.getResourceString($r('app.string.no_media_title'));
    } else {
      result = '';
    }
    return result;
  }

  clearMediaImageSize() {
    this.imgWidthSize = this.cardMediaPicSize;
    this.imgHeightSize = this.cardMediaPicSize;
    this.imagesX = this.cardMediaPicSize - this.cardMediaIconSize;
    this.imagesY = this.cardMediaPicSize - this.cardMediaIconSize;
    AppStorage.delete('portraitImagesWidth');
    AppStorage.delete('portraitImagesHeight');
    AppStorage.delete('portraitImagesX');
    AppStorage.delete('portraitImagesY');
  }

  updateImageSize() {
      this.cardMediaPicSize = this.style.cardMediaPicSize; //48
      this.cardMediaPicRadius =
        this.isBussinessStyle ? ResUtils.getConvertNumber($r('app.float.media_card_border_radius')) :
        ResUtils.getConvertNumber($r('sys.float.corner_radius_level6'));
      this.cardMediaPicSmallRadius = this.isBussinessStyle ?
        ResUtils.getConvertNumber($r('app.float.media_card_border_radius')) : this.style.cardMediaRadius;
      this.cardMediaIconSize = this.style.cardMediaIconSize; //16
      this.cardMediaIconRadius = ResUtils.getConvertNumber($r('sys.float.ohos_id_corner_radius_default_xs'));
  }

  playStateUpdate() {
    this.playPauseTriggerValue++;
  }

  checkImageShow(
    noImage: string | PixelMap | Resource,
    image: string | PixelMap | Resource
  ): string | PixelMap | Resource {
    if (!!this.mediaImg && this.mediaImg != 'unknown' && !this.mediaImg.toString()?.includes('http')) {
      return noImage;
    }
    return image;
  }

  checkImageColorShow(noColor: ResourceColor | undefined, color: ResourceColor | undefined): ResourceColor | undefined {
    if (!!this.mediaImg && this.mediaImg != 'unknown' && !this.mediaImg.toString()?.includes('http')) {
      return noColor;
    }
    return color;
  }

  onImageComplete(width: number = this.cardMediaPicSize, height: number = this.cardMediaPicSize, _width: number) {
    log.showInfo(`onImageCompletes: width: ${width}, height: ${height},,,${_width},,,,${this.cardMediaPicSize}`)
    let smallSizeRatio: number = 13 / 18;
    let bigSizeRatio: number = 16 / 9;
    let calRatio: number = 1;
    const realRatio: number = width / height;
    let bigSmallSizeRatio: number = this.cardMediaPicSize / _width;
    if ((width / height >= smallSizeRatio) && (width / height <= bigSizeRatio)) {
      if (width === height) {
        this.imgWidthSize = _width;
        this.imgHeightSize = _width;
      } else if (width > height) {
        this.imgWidthSize = _width;
        this.imgHeightSize = _width / realRatio;
      } else {
        this.imgWidthSize = _width / (height / width);
        this.imgHeightSize = _width;
      }
      calRatio = realRatio;
      this.isFreeShow = true;
    } else if ((width / height > bigSizeRatio)) {
      this.imgWidthSize = _width;
      this.imgHeightSize = this.imgWidthSize * (1 / bigSizeRatio);
      calRatio = bigSizeRatio;
      this.isFreeShow = false;
    } else { // w/h < 13/18
      this.imgHeightSize = _width;
      this.imgWidthSize = this.imgHeightSize * smallSizeRatio;
      calRatio = smallSizeRatio;
      this.isFreeShow = false;
    }
    let portraitWidth: number = Constants.PANEL_PORTRAIT_WIDTH - 48;
    let ratio: number = portraitWidth / _width;
    let portraitImageWidth: number = this.imgWidthSize * ratio;
    let portraitImageHeight: number = this.imgHeightSize * ratio;
    let imagesSmallWidth = Math.min(_width, _width * calRatio) * bigSmallSizeRatio;
    let imagesSmallHeight = Math.min(_width, _width / calRatio) * bigSmallSizeRatio;
    this.imagesX = (_width - imagesSmallWidth) / 2 + imagesSmallWidth - this.cardMediaIconSize;
    this.imagesY = (_width - imagesSmallHeight) / 2 + imagesSmallHeight - this.cardMediaIconSize;
    log.showInfo(`imagesSmallWidth: ${imagesSmallWidth}, imagesSmallHeight: ${imagesSmallHeight},
      imagesX: ${this.imagesX}, imagesY${this.imagesY}`);
    // 图片数据缓存，优化一镜到底
    AppStorage.setOrCreate('portraitImagesWidth', portraitImageWidth);
    AppStorage.setOrCreate('portraitImagesHeight', portraitImageHeight);
    AppStorage.setOrCreate('portraitImagesX', (portraitWidth - portraitImageWidth) / 2 + portraitImageWidth - 32);
    AppStorage.setOrCreate('portraitImagesY', (portraitWidth - portraitImageHeight) / 2 + portraitImageHeight - 32);
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

  /**
   * 按钮点击事件
   * @param type
   */
  clickAction(type: string) {
    log.showInfo(`clickAction: ${type}`);
    if (this.checkCall()) {
      log.showInfo('clickAction return with call');
      return;
    }
    switch (type) {
      // 上一首
      case ActionType.PREVIOUS:
        if (this.isCanPlayPrevious) {
          this.controller.callShowingPrevious();
        }
        break;
      // 下一首
      case ActionType.NEXT:
        if (this.isCanPlayNext) {
          this.controller.callShowingNext();
        }
        break;
      // 快进
      case ActionType.FAST_FORWARD:
        if (this.isCanFastForward) {
          this.controller.callRewindOrForward('fastForward', this.skipIntervals);
        }
        break;
      // 快退
      case ActionType.REWIND:
        if (this.isCanRewind) {
          this.controller.callRewindOrForward('rewind', this.skipIntervals);
        }
        break;
      // 播放&暂停
      case ActionType.PLAY_AND_PAUSE:
        if (this.isShowPlayButton) {
          if (!this.hasMedia) {
            this.showLoading();
            this.controller.startShowingDefaultApp();
          } else if (this.isPlaying) {
            this.controller.callShowingPause();
          } else {
            this.controller.callShowingPlay(false);
          }
        }
        break;
      default:
        break;
    }
  }

  /**
   * 点击卡片
   * @param isShowDev 进入投音页面
   */
  async clickCard(isShowDev: boolean = false) {
    if (this.isSmallFoldOuterScreen && !isShowDev) {
      let sessionId = this.checkCall() ? (this.callSession?.sessionId || '') : this.curSessionId;
      this.showPlayLoading = false;
      this.clearLoadingTimer();
      this.controller.jumpAppWithScreenLock(sessionId);
      return;
    }
    log.showInfo(`enter mediaCenter, isShowDev: ${isShowDev}`)
    // 退出动效没有执行结束，不能进入播控页面
    if (AppStorage.get('mediaExitTransitionDone') as boolean) {
      log.error(`Entry failed and the exit animation did not end.`);
      // 长按进入失败，重新触发
      if (this.isLongPress) {
        if (this.longPressTimer) {
          clearInterval(this.longPressTimer);
        }
        this.longPressTimer = setInterval(() => {
          this.clickCard(isShowDev);
        }, 50);
      }
      return;
    }
    clearInterval(this.longPressTimer);
    if (this.isLongPress) {
      this.isLongPress = false;
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    }
    globalStorage.setNumberByKey('isShowSwitch', (isShowDev ? 0 : 1));
    AppStorage.setOrCreate('showDevTime', isShowDev ? new Date().getTime() : undefined);
    this.setScenesTypeStorage('');
    if (this.enableDc) {
      // 同步globalStorage至主线程
      this.dcController?.callGlobalStorage({name: 'isShowSwitch', value: isShowDev ? 0 : 1});
      this.dcController?.callGlobalStorage({name: 'scenesType', value: ''});
    }
    // 设置默认封面图，优化一镜到底
    if (this.hasMedia && this.mediaImg && this.title) {
      AppStorage.setOrCreate('tempMediaImage', this.mediaImg);
    } else {
      AppStorage.delete('tempMediaImage');
    }
    if (this.hasMedia && this.title) {
      AppStorage.setOrCreate('tempMediaTitle', this.title.toString());
      AppStorage.setOrCreate('tempMediaSubTitle', this.getSubTitle());
    } else {
      AppStorage.delete('tempMediaTitle');
      AppStorage.delete('tempMediaSubTitle');
    }
    const deviceType = this.curRemoteOutputDev > 0 ? this.curRemoteOutputDev : this.curOutputDev.deviceType;
    this.showPlayLoading = false;
    this.clearLoadingTimer();
    this.controller.jumpInside(isShowDev, this.curOutputDev, deviceType, !(this.curRemoteOutputDev > 0));
    if (isShowDev) {
      HiDfxEventUtil.reportMediaControllerClick(HiSysDataMediaCommand.JUMP_INSIDE);
    }
    AccessibilityUtil.requestFocusAccessibility('media_card_first_Column_Text');
  }

  /**
   * 本机扬声器及通话场景（麦克风，蓝牙SCO）返回按钮默认样式
   * @returns 是否使用默认样式（无设备连接）
   */
  isLocalDeviceState(): boolean {
    let curDev = this.checkCall() ? this.curCallDev : this.curOutputDev;
    let isSpeaker = curDev.deviceType === audio.DeviceType.SPEAKER &&
      curDev.networkId === 'LocalDevice';
    let isEarpiece = curDev.deviceType === audio.DeviceType.EARPIECE;
    let isCar = curDev.deviceType === audio.DeviceType.SPEAKER &&
      curDev.networkId !== 'LocalDevice' &&
      !CommonUtils.isShowCarIcon(curDev.networkId, curDev.deviceType);
    let isRemoteCast = curDev.deviceType === audio.DeviceType.REMOTE_CAST;
    return isSpeaker || isEarpiece || isCar || isRemoteCast;
  }

  getIsFoldable() {
    try {
      this.isFoldDevice = display.isFoldable();
    } catch (error) {
      this.isFoldDevice = false;
    }
  }

  getFoldStatus() {
    try {
      const foldStatus = display.getFoldStatus();
      return foldStatus == 2;
    } catch (error) {
      log.error(`failed to getFoldStatus`);
      return false;
    }
  }

  /**
   * 获取共享元素的绑定id，用于横竖屏切换之后的id转换
   * @param name
   * @returns
   */
  getGeometryKey(name: string) {
    return this.mediaLandscape !== this.isLandscape && !DeviceHelper.isPad() &&
      !(this.isFoldDevice && !this.getFoldStatus()) ? `${name}Hide` : name;
  }

  getForegroundBrightness(isShowButton: boolean) {
    if (this.isBussinessStyle) {
      return isShowButton ? this.colorModeViewData?.foregroundPrimaryOptionOnBackground :
        this.colorModeViewData?.foregroundTertiaryGlossOption;
    }
    return this.colorModeViewData?.foregroundPrimaryOption;
  }

  private getTopRate(): BrightnessOptions | undefined {
    return this.colorModeViewData.getTopOption(false);
  }

  getFontSizeScale() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.fontSizeScale || 1;
    } else {
      return ResourceVm.instance.fontScale;
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

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  build() {
    Stack() {
      if (this.isBussinessStyle) {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
          this.ImageBuilder()
          Column() {
            this.TitleComponent()
            this.SubTitleComponent()
          }
          .width(TITLE_WIDTH)
          .margin({
            start: LengthMetrics.vp(TITLE_MARGIN_LEFT),
            end: LengthMetrics.vp(TITLE_MARGIN_RIGHT),
          })
          Column() {
            if (this.isLottieDisable) {
              Column()
            } else if (this.mediaType === AV_SESSION_TYPE_VIDEO) {
              this.VideoComponent()
            } else {
              this.AudioComponent()
            }
          }
          .layoutWeight(1)
        }
      } else if (this.controlCenterState !== ControlCenterState.MEDIA_CENTER) {
        if (!this.checkCall()) {
          Stack({ alignContent: Alignment.Top }) {
            Row().width('100%').height(40).id(this.getGeometryKey('mediaCardTitleStart'))
              .geometryTransition(this.getGeometryKey('mediaCardTitle'), this.geometryOptions)
            Row().width(1).height(0).id(this.getGeometryKey('goldFlagStart'))
              .geometryTransition(this.getGeometryKey('goldFlag'), this.geometryOptions)
            Row().width('100%').height('100%').id(this.getGeometryKey('recentlyPlayStart'))
              .geometryTransition(this.getGeometryKey('recentlyPlay'), this.geometryOptions)
            Row().width('100%').height(24).id(this.getGeometryKey('swiperStart'))
              .geometryTransition(this.getGeometryKey('swiper'), this.geometryOptions)
              .margin({ top: -this.style.cardMediaLayoutSize })
            if (this.isLandscape) {
              Column() {
                Column().width('100%').height(24).geometryTransition('songBoxLand', this.geometryOptions)
                Column().width('100%').height(16).geometryTransition('textPlayBoxLand', this.geometryOptions)
              }
              .margin({ top: 24, left: 68 })
            }
          }
          .zIndex(-1)
          .margin({
            left: -this.style.cardMediaLayoutSize,
            right: -this.style.cardMediaLayoutSize,
            top: -this.style.cardMediaLayoutSize,
            bottom: -5
          })
        }
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center }) {
          Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
          if (this.checkCall()) {
            this.CallImageBuilder()
            this.CallTitleBuilder()
          } else {
            this.ImageBuilder()
            this.TitleBuilder()
          }
        }
      }
        .id('control_media_card_title')
        this.SwitchBuilder()
      }
    }
    .align(Alignment.TopEnd)
    .width('100%')
    .height('100%')
    .padding({
      left: this.style.cardMediaLayoutSize,
      right: this.style.cardMediaLayoutSize,
      top: this.style.cardMediaLayoutSize,
      bottom: 5
    })
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        TapGesture()
          .onAction(() => {
            this.clickCard(false);
          }),
        LongPressGesture()
          .onAction(() => {
            this.isLongPress = true;
            this.clickCard(false);
          })
      )
    )
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Up && this.longPressTimer) {
        clearInterval(this.longPressTimer);
      }
    })
    .accessibilityLevel('no')
    .id('media_card')
    .key('media_card')
  }

  @Builder ImageBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
      Stack() {
        Stack() {
          if (this.hasMedia && this.mediaImg) {
            Column()
              .width(this.cardMediaPicSize)
              .height(this.cardMediaPicSize)
              .justifyContent(FlexAlign.Center)
              .borderRadius(this.cardMediaPicRadius)
              .clip(false)
              .backgroundColor(Color.Transparent)
              .id(this.getGeometryKey('mediaStartImgBg'))
              .geometryTransition(this.getGeometryKey('mediaImgBg'), this.geometryOptions)
              .zIndex(0)
            Image(this.mediaImg ? this.mediaImg : $r('app.media.ic_nomusic_img'))
              .alt(this.checkImageShow('', $r('app.media.ic_nomusic_img')))
              .backgroundColor(this.checkImageColorShow(Color.Transparent, this.isForceDark ?
                (this.colorModeViewData.isBrightnessActive ? this.colorModeViewData.mediaDefaultImgBgColor :
                $r('app.color.media_control_center_default_img_bgc')) : $r('app.color.ohos_id_color_component_normal')))
              .draggable(false)
              .id(COMPONENT_ID_MEDIA_IMG)
              .fillColor(this.isForceDark ? (this.colorModeViewData.isBrightnessActive ?
              this.colorModeViewData.mediaDefaultImgColor : $r('app.color.media_control_center_default_img_bgc_disable')) :
              $r('app.color.ohos_id_color_fourth'))
              .onError(() => {
                log.error('mediaImg show err');
                this.mediaImg = '';
                this.imageReady = false;
                this.clearMediaImageSize();
              })
              .onComplete((event) => {
                this.onImageComplete(event?.width, event?.height, this.cardMediaPicSize);
                if (!this.hasMedia || !this.mediaImg) {
                  this.imageReady = false
                  this.clearMediaImageSize();
                }
              })
              .onAppear(() => {
                log.showInfo(`onAppear ${this.getGeometryKey('mediaImg')}`);
              })
              .onDisAppear(() => {
                log.showInfo(`onDisAppear ${this.getGeometryKey('mediaImg')}`);
              })
              .align(Alignment.Center)
              .interpolation(ImageInterpolation.Medium)
              .objectFit(this.isFreeShow ? ImageFit.Contain : ImageFit.Cover)
              .borderRadius(this.imgWidthSize === this.imgHeightSize ? this.cardMediaPicRadius : 4)
              .id(this.getGeometryKey('mediaStartImg'))
              .geometryTransition(this.getGeometryKey('mediaImg'), this.geometryOptions)
              .zIndex(1)
              .width(this.imgWidthSize)
              .height(this.imgHeightSize)
              .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
          } else {
            Column()
              .width('100%')
              .height('100%')
              .borderRadius(this.cardMediaPicSmallRadius)
              .backgroundColor(this.isForceDark ? (this.colorModeViewData.isBrightnessActive ?
                this.colorModeViewData.mediaDefaultImgBgColor : $r('app.color.media_control_center_default_img_bgc')) :
              this.colorModeViewData.wifiBgOffColor)
              .backgroundBrightnessInternal(this.isBussinessStyle ? this.getTopRate() : undefined)
              .zIndex(0)
              .id(this.getGeometryKey('defaultStartBg'))
              .geometryTransition(this.getGeometryKey('defaultBg'), this.geometryOptions)
            Image($r('app.media.ic_nomusic_img_big'))
              .fillColor(this.isForceDark ? (this.colorModeViewData.isBrightnessActive ?
                this.colorModeViewData.mediaDefaultImgColor :
                $r('app.color.media_control_center_default_img_bgc_disable')) :
              $r('app.color.media_control_center_icon_disable_pc'))
              .foregroundBrightness(this.isBussinessStyle ? this.colorModeViewData?.foregroundTertiaryGlossOption :
                undefined)
              .onComplete((event) => {
                this.clearMediaImageSize();
              })
              .onAppear(() => {
                log.showInfo(`onAppear ${this.getGeometryKey('defaultImg')}`);
              })
              .onDisAppear(() => {
                log.showInfo(`onDisAppear ${this.getGeometryKey('defaultImg')}`);
              })
              .width(18)
              .height(18)
              .draggable(false)
              .renderFit(RenderFit.RESIZE_COVER)
              .zIndex(1)
              .id(this.getGeometryKey('defaultStartImage'))
              .geometryTransition(this.getGeometryKey('defaultImg'), this.geometryOptions)
              .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
          }
        }
        .width(this.imgWidthSize)
        .height(this.imgHeightSize)
        .align(Alignment.Center)

        // 应用图标
        Column() {
          Image((this.appIconShow && this.appIcon) ? this.appIcon : '')
            .draggable(false)
            .id(COMPONENT_ID_APP_ICON)
            .width('100%')
            .height('100%')
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
        .clip(true)
        .width(this.cardMediaIconSize)
        .height(this.cardMediaIconSize)
        .backgroundColor(Color.Transparent)
        .visibility(this.appIcon ? Visibility.Visible : Visibility.None)
        .borderRadius(this.cardMediaIconRadius)
        .id(this.getGeometryKey('mediaPublicIconStart'))
        .zIndex(2)
        .geometryTransition(this.getGeometryKey('publicIcon'), this.geometryOptions)
        .onAppear(() => {
          log.showInfo(`onAppear ${this.getGeometryKey('publicIcon')}`);
        })
        .onDisAppear(() => {
          log.showInfo(`onDisAppear ${this.getGeometryKey('publicIcon')}`);
        })
        .position(this.isRTL() ? { right: this.imagesX, top: this.imagesY } :
          { left: this.imagesX, top: this.imagesY })
      }
      .width('100%')
      .height('100%')
      .align(Alignment.Center)
      .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_PICTURE);
    }
    .width(this.cardMediaPicSize)
    .height(this.cardMediaPicSize)
    .alignSelf(ItemAlign.Start)
    .flexShrink(0)
  }

  @Builder TitleComponent() {
    Row() {
      if (this.isPlaying) {
        Marquee({
          start: this.isBussinessStyle ? true : this.isStartMarquee,
          src: this.hasMedia && this.title ? this.title.toString() : '',
          fromStart: !this.isRTL(),
          step: this.isBussinessStyle ? 2 : 6
        })
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
          .id(COMPONENT_ID_TITLE)
          .fontColor(this.isForceDark ? $r('app.color.media_control_center_text_primary') :
            $r('sys.color.font_primary'))
          .fontSize(MeasuringUtil.getFontSize($r('sys.float.ohos_id_text_size_body2'),
            this.isBussinessStyle ? this.mediaMarqueeFontsize : (this.isSmallFoldOuterScreen ? 1 : 1.15),
            this.getFontSizeScale()))
          .fontWeight(600)
          .align(!this.isRTL() ? Alignment.Start : Alignment.End)
          .foregroundBrightness(DeviceHelper.isPC() ? this.colorModeViewData.foregroundPrimaryOptionOnBackground :
            this.colorModeViewData.foregroundPrimaryOption)
          .accessibilityLevel('no')
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
      } else {
        Text((this.hasMedia && this.title) ? this.title.toString() : '')
          .draggable(false)
          .id(COMPONENT_ID_TITLE)
          .fontColor(this.isForceDark ? $r('app.color.media_control_center_text_primary') :
            $r('sys.color.font_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(this.isBussinessStyle ? this.mediaMarqueeFontsize : (this.isSmallFoldOuterScreen ? 1 : 1.15))
          .fontWeight(600)
          .textAlign(!this.isRTL() ? TextAlign.Start : TextAlign.End)
          .foregroundBrightness(DeviceHelper.isPC() ? this.colorModeViewData.foregroundPrimaryOptionOnBackground :
            this.colorModeViewData.foregroundPrimaryOption)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .height((this.getFontSizeScale() === 1 || this.isSmallFoldOuterScreen) ? 21 : 24)
    .id(this.getGeometryKey('songBoxStart'))
    .geometryTransition(this.getGeometryKey('songBox'), this.geometryOptions)
  }

  @Builder SubTitleComponent() {
    Row() {
      if (this.isPlaying) {
        Marquee({
          start: this.isBussinessStyle ? true : this.isStartMarquee,
          src: this.getSubTitle(),
          fromStart: true,
          step: this.isBussinessStyle ? 2 : 6
        })
          .id(COMPONENT_ID_ARTIST)
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
          .fontColor(this.isForceDark ? $r('app.color.media_control_center_text_secondary') :
            $r('sys.color.font_secondary'))
          .fontSize(MeasuringUtil.getFontSize($r('sys.float.ohos_id_text_size_body3'),
            this.isBussinessStyle ? this.mediaMarqueeFontsize : (this.isSmallFoldOuterScreen ? 1 : 1.15),
            this.getFontSizeScale()))
          .fontWeight(FontWeight.Regular)
          .foregroundBrightness(DeviceHelper.isPC() ? this.colorModeViewData.foregroundPrimaryOptionOnBackground :
            this.colorModeViewData.foregroundTertiaryGlossSubOption)
          .clip(true)
          .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
          .width('100%')
          .accessibilityLevel('no')
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
      } else {
        Text(this.getSubTitle())
          .draggable(false)
          .id(COMPONENT_ID_ARTIST)
          .fontColor(this.isForceDark ? $r('app.color.media_control_center_text_secondary') :
            $r('sys.color.font_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body3'))
          .maxFontScale(this.isBussinessStyle ? this.mediaMarqueeFontsize : (this.isSmallFoldOuterScreen ? 1 : 1.15))
          .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
          .fontWeight(FontWeight.Regular)
          .foregroundBrightness(DeviceHelper.isPC() ? this.colorModeViewData.foregroundPrimaryOptionOnBackground :
            this.colorModeViewData.foregroundTertiaryGlossSubOption)
          .maxLines(1)
          .textOverflow({
            overflow: this.isPlaying && this.isStartMarquee ? TextOverflow.MARQUEE : TextOverflow.Ellipsis
          })
          .clip(false)
          .width('100%')
      }
    }
    .offset({ y: this.getSubTitleBottom() })
    .margin({ top: (this.hasMedia && this.artist) ? 2 : 4 })
    .alignItems(VerticalAlign.Top)
    .id(this.getGeometryKey('textPlayBoxStart'))
    .geometryTransition(this.getGeometryKey('textPlayBox'), this.geometryOptions)
    .width('100%')
    .onAppear(() => {
      log.showInfo(`onAppear ${this.getGeometryKey('textPlayBox')}`);
    })
    .onDisAppear(() => {
      log.showInfo(`onDisAppear ${this.getGeometryKey('textPlayBox')}`);
    })
  }

  getSubTitleBottom(): Length {
    if (this.isBussinessStyle) {
      if (!this.hasMedia) {
        return this.uiContext.vp2px(-12) - 1 + 'px';
      } else if ((!this.title && !this.curAppName) || (!this.title && this.curAppName)) {
        return this.uiContext.vp2px(-12) - 1 + 'px';
      }
    }
    return 0;
  }

  isShowOnlyNextPrevious(): boolean {
    let isContainsNextOrPrevious = this.validCommands?.includes('playNext') ||
    this.validCommands?.includes('playPrevious');
    return !this.validCommands?.includes('rewind') && !this.validCommands?.includes('fastForward') &&
      isContainsNextOrPrevious;
  }

  isShowOnlyRewindForward(): boolean {
    let isContainsRewindOrForward = this.validCommands?.includes('rewind') ||
    this.validCommands?.includes('fastForward');
    return !this.validCommands?.includes('playNext') && !this.validCommands?.includes('playPrevious') &&
      isContainsRewindOrForward;
  }

  isShowVideoStyle(): boolean {
    if (this.mediaType === AV_SESSION_TYPE_VIDEO) { // false显示audio
      return !this.isShowOnlyNextPrevious();
    } else {
      return this.isShowOnlyRewindForward();
    }
  }

  @Builder TitleBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
        if (this.hasMedia && this.title) {
          this.TitleComponent()
        }
        this.SubTitleComponent()
      }
      .height((this.getFontSizeScale() === 1 || this.isSmallFoldOuterScreen) ?
        this.style.cardMediaTitleHeight : (this.style.cardMediaTitleHeight + 5))
      .margin({
        top: this.style.cardMediaLayoutTopSize,
      })
      .flexShrink(0)
      .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_TITLE)
      .id(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_TITLE)
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityNextFocusId(COMPONENT_ID_AUDIO_BUTTON)
      .onClick(() => {
        this.clickCard(false);
      })

      Stack() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Row().width(36).height('100%').id(this.getGeometryKey('mediaProcessNowStart'))
            .geometryTransition(this.getGeometryKey('mediaProcessNow'))
          Row().width('calc(100% - 72vp)').height('100%').id(this.getGeometryKey('mediaProcessStart'))
            .geometryTransition(this.getGeometryKey('mediaProcess'))
          Row().width(36).height('100%').id(this.getGeometryKey('mediaProcessTotalStart'))
            .geometryTransition(this.getGeometryKey('mediaProcessTotal'))
        }
        .height(this.BTN_SIZE)
        .visibility(Visibility.Hidden)
        .zIndex(0)

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Row().width(36).height('100%').id(this.getGeometryKey('mediaVolumeReduceStart'))
            .geometryTransition(this.getGeometryKey('mediaVolumeReduce'))
          Row().width('calc(100% - 72vp)').height('100%').id(this.getGeometryKey('mediaVolumeStart'))
            .geometryTransition(this.getGeometryKey('mediaVolume'))
          Row().width(36).height('100%').id(this.getGeometryKey('mediaVolumeAddStart'))
            .geometryTransition(this.getGeometryKey('mediaVolumeAdd'))
        }
        .height(this.BTN_SIZE)
        .visibility(Visibility.Hidden)
        .zIndex(1)

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          if (this.isLottieDisable) {
            Column()
          } else if (this.isShowVideoStyle()) {
            this.VideoComponent()
          } else {
            this.AudioComponent()
          }
        }
        .height(this.BTN_SIZE)
        .zIndex(2)
      }
      .height(this.BTN_SIZE)
      .width('100%')
    }
    .height(this.style.cardMediaLowerHalfHeight)
    .width('100%')
  }

  setScenesTypeStorage(value: string) {
    globalStorage.setStringByKey('scenesType', value);
    if (this.enableDc) {
      this.dcController?.callGlobalStorage({name: 'scenesType', value: value});
    }
  }

  @Builder VideoComponent() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Stack() {
        Column()
          .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
          .id(this.getGeometryKey('buttonPrevious'))
          .geometryTransition(this.getGeometryKey('buttonPrevious'), this.geometryOptions)
          .opacity(0)

        Button({ stateEffect: this.isCanRewind }) {
          SymbolGlyph($r(this.getSkipIntervalsIcon(false)))
            .fontSize(`${this.style.cardMediaRewindAndFastForwardButtonSize}vp`)
            .fontColor(this.getIconColor(this.isCanRewind))
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.getForegroundBrightness(this.isCanRewind))
            .opacity(this.isPC ? (this.isCanRewind ? 1 : 0.3) : 1)
            .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.DOWN), this.fastRewindTriggerValue)
            .id(COMPONENT_ID_REWIND)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }.onClick(() => {
          this.setScenesTypeStorage('controlCenter');
          if (this.isCanRewind) {
            this.fastRewindTriggerValue++;
          }
          this.clickAction(ActionType.REWIND);
        })
        .type(ButtonType.Circle)
        .focusable(this.isCanRewind)
        .accessibilityLevel('yes')
        .accessibilityDescription(this.isCanRewind && !this.checkCall() ? '' :
          this.getResourceString($r('app.string.access_unavailable')))
        .accessibilityText(this.getResourceString($r('app.string.access_rewind')))
        .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
        .backgroundColor(Color.Transparent)
        .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_REWIND)
        .geometryTransition(this.getGeometryKey('buttonRewind'), this.geometryOptions)
      }
      .margin({ start: LengthMetrics.vp(this.BTN_MARGIN) })

      Button({ stateEffect: this.isShowPlayButton && !this.checkCall() }) {
        if (this.showPlayLoading && !this.isPC && !this.checkCall()) {
          LoadingProgress()
            .size({ width: this.style.cardMediaButtonSize, height: this.style.cardMediaButtonSize })
            .color($r('app.color.media_control_center_icon_primary'))
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.getForegroundBrightness(true))
        } else {
          SymbolGlyph(this.isPlaying ? $r(ButtonIconName.PAUSE_SYMBOL) : $r(ButtonIconName.PLAY_SYMBOL))
            .fontSize(`${this.style.cardMediaButtonSize}vp`)
            .fontColor(this.getIconColor(this.isShowPlayButton && !this.checkCall()))
            .rotate({ angle: this.isRTL() ? 180 : 0 })
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.getForegroundBrightness(this.isShowPlayButton))
            .opacity(this.isPC ? (this.isShowPlayButton ? 1 : 0.3) : 1)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.isCanPlay ? this.playPauseTriggerValue : -1)
            .id(COMPONENT_ID_PAUSE)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
      }.onClick(() => {
        this.setScenesTypeStorage('controlCenter');
        this.clickAction(ActionType.PLAY_AND_PAUSE)
      })
      .type(ButtonType.Circle)
      .focusable(this.isShowPlayButton)
      .accessibilityLevel('yes')
      .accessibilityDescription(this.isShowPlayButton && !this.checkCall() ? '' :
        this.getResourceString($r('app.string.access_unavailable')))
      .accessibilityText(this.isPlaying ? this.getResourceString($r('app.string.access_pause')) :
        this.getResourceString($r('app.string.access_play')))
      .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
      .backgroundColor(Color.Transparent)
      .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_PLAY_OR_PAUSE)
      .geometryTransition(this.getGeometryKey('buttonPlay'), this.geometryOptions)

      Stack() {
        Column()
          .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
          .id(this.getGeometryKey('buttonNext'))
          .geometryTransition(this.getGeometryKey('buttonNext'), this.geometryOptions)
          .opacity(0)

        Button({ stateEffect: this.isCanFastForward }) {
          SymbolGlyph($r(this.getSkipIntervalsIcon(true)))
            .fontSize(`${this.style.cardMediaRewindAndFastForwardButtonSize}vp`)
            .fontColor(this.getIconColor(this.isCanFastForward))
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.getForegroundBrightness(this.isCanFastForward))
            .opacity(this.isPC ? (this.isCanFastForward ? 1 : 0.3) : 1)
            .symbolEffect(new BounceSymbolEffect(EffectScope.WHOLE, EffectDirection.DOWN),
              this.fastForwardTriggerValue)
            .id(COMPONENT_ID_FAST_FORWARD)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }.onClick(() => {
          this.setScenesTypeStorage('controlCenter');
          if (this.isCanFastForward) {
            this.fastForwardTriggerValue++;
          }
          this.clickAction(ActionType.FAST_FORWARD);
        })
        .type(ButtonType.Circle)
        .focusable(this.isCanFastForward)
        .accessibilityLevel('yes')
        .accessibilityDescription(this.isCanFastForward && !this.checkCall() ? '' :
          this.getResourceString($r('app.string.access_unavailable')))
        .accessibilityText(this.getResourceString($r('app.string.access_fast_forward')))
        .accessibilityNextFocusId('transition_togglewifi_ui_extension')
        .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
        .backgroundColor(Color.Transparent)
        .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_FAST_FORWARD)
        .geometryTransition(this.getGeometryKey('buttonForward'), this.geometryOptions)
      }
      .margin({ end: LengthMetrics.vp(this.BTN_MARGIN) })
    }
  }

  @Builder AudioComponent() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Stack() {
      if (!this.checkCall()) {
        Column()
          .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
          .id(this.getGeometryKey('buttonLoopModeStart'))
          .geometryTransition(this.getGeometryKey('buttonLoopMode'), this.geometryOptions)
          .opacity(0)
      }

        Button({ stateEffect: this.isCanPlayPrevious && !this.checkCall() }) {
          AnimationIconLocal({
            active: this.isCanPlayPrevious && !this.checkCall(),
            isControlCenter: 'center',
            scaleValue: this.isBussinessStyle ? PC_MEDIA_BUTTON_SCALE : MEDIA_BUTTON_SCALE,
          })
            .id(COMPONENT_ID_PREVIOUS)
            .size({ width: this.style.cardMediaPicSize, height: this.style.cardMediaPicSize })
            .rotate({ centerX: '50%', centerY: '50%', angle: 180 })
            .margin({ left: -5, top: -5 })
        }
        .onClick(() => {
          this.setScenesTypeStorage('controlCenter');
          this.clickAction(ActionType.PREVIOUS);
        })
        .type(ButtonType.Circle)
        .focusable(this.isCanPlayPrevious)
        .accessibilityLevel('yes')
        .accessibilityDescription(this.isCanPlayPrevious && !this.checkCall() ? '' :
          this.getResourceString($r('app.string.access_unavailable')))
        .accessibilityText(this.getResourceString($r('app.string.access_previous')))
        .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
        .backgroundColor(Color.Transparent)
        .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_PREVIOUS)
        .geometryTransition(this.getGeometryKey(this.checkCall() ? 'callButtonPrevious' : 'buttonPrevious'),
          this.geometryOptions)
        .id(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_PREVIOUS)
      }
      .margin({ start: LengthMetrics.vp(this.BTN_MARGIN) })

      Button({ stateEffect: this.isShowPlayButton && !this.checkCall() }) {
        if (this.showPlayLoading && !this.isPC && !this.checkCall()) {
          LoadingProgress()
            .size({ width: this.style.cardMediaButtonSize, height: this.style.cardMediaButtonSize })
            .color($r('app.color.media_control_center_icon_primary'))
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.getForegroundBrightness(true))
        } else {
          SymbolGlyph(this.isPlaying && !this.checkCall() ? $r(ButtonIconName.PAUSE_SYMBOL) :
            $r(ButtonIconName.PLAY_SYMBOL))
            .fontSize(`${this.style.cardMediaButtonSize}vp`)
            .fontColor(this.isBussinessStyle ? undefined : this.getIconColor(this.isShowPlayButton &&
              !this.checkCall()))
            .rotate({ angle: this.isRTL() ? 180 : 0 })
            .backgroundColor(Color.Transparent)
            .foregroundBrightness(this.getForegroundBrightness(this.isShowPlayButton))
            .opacity(this.isPC ? (this.isShowPlayButton ? 1 : 0.3) : 1)
            .symbolEffect(new ReplaceSymbolEffect(EffectScope.WHOLE), this.isCanPlay ? this.playPauseTriggerValue : -1)
            .id(COMPONENT_ID_PAUSE)
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
      }.onClick(() => {
        this.setScenesTypeStorage('controlCenter');
        this.clickAction(ActionType.PLAY_AND_PAUSE)
      })
      .type(ButtonType.Circle)
      .focusable(this.isShowPlayButton)
      .accessibilityLevel('yes')
      .accessibilityDescription(this.isShowPlayButton && !this.checkCall() ? '' :
        this.getResourceString($r('app.string.access_unavailable')))
      .accessibilityText(this.isPlaying ? this.getResourceString($r('app.string.access_pause')) :
        this.getResourceString($r('app.string.access_play')))
      .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
      .backgroundColor(Color.Transparent)
      .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_PLAY_OR_PAUSE)
      .geometryTransition(this.getGeometryKey(this.checkCall() ? 'callButtonPlay' : 'buttonPlay'), this.geometryOptions)
      .id(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_PLAY_OR_PAUSE)

      Stack() {
      if (!this.checkCall()) {
        Column()
          .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
          .id(this.getGeometryKey('buttonFavorStart'))
          .geometryTransition(this.getGeometryKey('buttonFavor'), this.geometryOptions)
          .opacity(0)
      }

        Button({ stateEffect: this.isCanPlayNext && !this.checkCall() }) {
          AnimationIconLocal({
            active: this.isCanPlayNext && !this.checkCall(),
            isControlCenter: 'center',
            scaleValue: this.isBussinessStyle ? PC_MEDIA_BUTTON_SCALE : MEDIA_BUTTON_SCALE,
          })
            .id(COMPONENT_ID_NEXT)
            .size({ width: this.style.cardMediaPicSize, height: this.style.cardMediaPicSize })
            .margin({ left: -5, top: -5 })
        }
        .onClick(() => {
          this.setScenesTypeStorage('controlCenter');
          this.clickAction(ActionType.NEXT);
        })
        .type(ButtonType.Circle)
        .focusable(this.isCanPlayNext)
        .accessibilityLevel('yes')
        .accessibilityDescription(this.isCanPlayNext && !this.checkCall() ? '' :
          this.getResourceString($r('app.string.access_unavailable')))
        .accessibilityText(this.getResourceString($r('app.string.access_next')))
        .size({ width: this.BTN_SIZE, height: this.BTN_SIZE })
        .backgroundColor(Color.Transparent)
        .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_NEXT)
        .accessibilityNextFocusId('transition_togglewifi_ui_extension')
        .geometryTransition(this.getGeometryKey(this.checkCall() ? 'callButtonNext' : 'buttonNext'),
          this.geometryOptions)
        .id(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_NEXT)
      }
      .margin({ end: LengthMetrics.vp(this.BTN_MARGIN) })
    }
    .margin({ end: LengthMetrics.vp(this.style.cardMediaButtonRight) })
  }

  private getRenderingStrategy(iconName: string): SymbolRenderingStrategy {
    if (iconName === AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL ||
      iconName === AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL) {
      return SymbolRenderingStrategy.SINGLE;
    }
    return SymbolRenderingStrategy.MULTIPLE_OPACITY;
  }

  @Builder SymbolIconBuilder() {
    SymbolGlyph($r(this.getCurSwitchIcon()))
      .fontSize(Constants.COMMON_CAST_SMALL_SIZE)
      .draggable(false)
      .id(COMPONENT_ID_OUTPUT_TYPE)
      .fontColor((this.isLocalDeviceState() && (this.curRemoteOutputDev < 0 || this.checkCall())) ?
        this.isForceDark ? [$r('app.color.media_control_center_switch_full')]
          : [$r('app.color.ohos_id_color_secondary')] :
        this.isForceDark ? [$r('app.color.media_control_center_switch_active_full')] :
        [$r('app.color.ohos_id_color_primary_contrary')])
      .foregroundBrightness(this.colorModeViewData.getPrimaryFgOption(
        !(this.isLocalDeviceState() && (this.curRemoteOutputDev < 0 || this.checkCall()))))
      .renderingStrategy(this.getRenderingStrategy(this.getCurSwitchIcon()))
      .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
  }

  @Builder SwitchBuilder() {
    Column() {
      Button({ stateEffect: false }) {
        this.SymbolIconBuilder()
      }
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          TapGesture()
            .onAction(() => {
              this.clickCard(true);
            }),
          LongPressGesture()
            .onAction(() => {
              this.isLongPress = true;
              this.clickCard(true);
            })
        )
      )
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Up && this.longPressTimer) {
          clearInterval(this.longPressTimer);
        }
      })
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .width('100%')
      .height('100%')
      .height(Constants.COMMON_SWITCH_SIZE)
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityText(this.getResourceString($r('app.string.access_switch_playback_device')))
      .id(COMPONENT_ID_AUDIO_BUTTON)
      .accessibilityNextFocusId(this.mediaType === 'video' ?
        MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_REWIND :
        MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_PREVIOUS)
    }
    .width(Constants.COMMON_SWITCH_SIZE)
    .height(Constants.COMMON_SWITCH_SIZE)
    .borderRadius(120)
    .justifyContent(FlexAlign.Center)
    .backgroundColor((this.isLocalDeviceState() && (this.curRemoteOutputDev < 0 || this.checkCall())) ?
      (this.isForceDark ? $r('app.color.media_control_center_component_normal') :
        $r('app.color.ohos_id_color_component_normal')) :
      (this.isForceDark ? $r('app.color.media_control_center_switch_active_bgc') :
        $r('app.color.ohos_id_color_emphasize')))
    .backgroundBrightnessInternal(this.colorModeViewData.getTopOption(
      !(this.isLocalDeviceState() && (this.curRemoteOutputDev < 0 || this.checkCall()))))
    .id(this.getGeometryKey(this.checkCall() ? 'callSwitchIconStart' : 'switchIconStart'))
    .geometryTransition(this.isSmallFoldOuterScreen ? '' :
      this.getGeometryKey(this.checkCall() ? 'callSwitchIcon' : 'switchIcon'), this.geometryOptions)
    .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_SWITCH)
  }

  @Builder
  CallImageBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
      Stack() {
        Column()
          .backgroundColor($r('app.color.media_control_default_img_bgc'))
          .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
          .width('100%')
          .height('100%')
          .id(this.getGeometryKey('callImgBgStart'))
          .geometryTransition(this.getGeometryKey('callImgBg'), this.geometryOptions)
        SymbolGlyph($r(ButtonIconName.CALL_SYMBOL))
          .fontSize(Constants.COMMON_CAST_SMALL_SIZE)
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .fontColor( [$r('sys.color.icon_emphasize')])
          .draggable(false)
          .id(this.getGeometryKey('callImgStart'))
          .geometryTransition(this.getGeometryKey('callImg'), this.geometryOptions)
        if (this.callSession?.appIcon) {
          Image(this.callSession?.appIcon)
            .backgroundColor(Constants.TRANSLUCENT_COLOR)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
            .width(this.cardMediaIconSize)
            .height(this.cardMediaIconSize)
            .position({
              top: Constants.COMMON_PICTURE_SIZE_LARGE - Constants.COMMON_PICTURE_SIZE_SMALL,
              left: this.isRTL() ? 0 : Constants.COMMON_PICTURE_SIZE_LARGE - Constants.COMMON_PICTURE_SIZE_SMALL,
              right: this.isRTL() ? Constants.COMMON_PICTURE_SIZE_LARGE - Constants.COMMON_PICTURE_SIZE_SMALL : 0,
            })
            .id(this.getGeometryKey('callIconStart'))
            .geometryTransition(this.getGeometryKey('callIcon'), this.geometryOptions)
        }
      }
      .alignContent(Alignment.Center)
      .width('100%')
      .height('100%')
      .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_PICTURE);
    }
    .width(this.cardMediaPicSize)
    .height(this.cardMediaPicSize)
    .alignSelf(ItemAlign.Start)
    .flexShrink(0)
  }

  getCallTitleTransition(): TransitionEffect {
    const transOptions: TranslateOptions = this.isLandscape ?
      {y: this.style.cardMediaTitleHeight * 2, x: Constants.PANEL_LANDSCAPE_WIDTH / 3} :
      {y: this.style.cardMediaTitleHeight * 3};
    const opacityAnimation: AnimateParam = this.controlCenterState === ControlCenterState.MEDIA_CENTER ?
      { duration: 100, curve: Curve.Sharp } :
      { duration: 100, curve: Curve.Sharp, delay: 100 };
    return TransitionEffect.translate(transOptions)
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0).animation(opacityAnimation))
  }

  getCallTitle(): string {
    return this.getResourceString($r('app.string.device_in_call'));
  }

  @Builder CallTitleBuilder() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start }) {
        Row() {
          Text(this.isRTL() ? `...${this.getCallTitle()}` : `${this.getCallTitle()}...`)
            .draggable(false)
            .id(COMPONENT_ID_TITLE)
            .fontColor($r('app.color.media_control_center_text_primary'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(this.isSmallFoldOuterScreen ? 1 : 1.15)
            .fontWeight(600)
            .textAlign(!this.isRTL() ? TextAlign.Start : TextAlign.End)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .height((this.getFontSizeScale() === 1 || this.isSmallFoldOuterScreen) ? 21 : 24)
        .id(this.getGeometryKey('callTitleStart'))
        Row() {
          Text(this.callSession?.appName || $r(this.defaultResourceName))
            .draggable(false)
            .id(COMPONENT_ID_ARTIST)
            .fontColor($r('app.color.media_control_center_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body3'))
            .maxFontScale(this.isSmallFoldOuterScreen ? 1 : 1.15)
            .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
            .fontWeight(FontWeight.Regular)
            .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossSubOption)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .clip(false)
            .width('100%')
        }
        .offset({ y: this.getSubTitleBottom() })
        .margin({ top: 2 })
        .alignItems(VerticalAlign.Top)
        .id(this.getGeometryKey('callSubTitleStart'))
        .width('100%')
      }
      .height((this.getFontSizeScale() === 1 || this.isSmallFoldOuterScreen) ?
        this.style.cardMediaTitleHeight : (this.style.cardMediaTitleHeight + 5))
      .margin({ top: this.style.cardMediaLayoutTopSize })
      .flexShrink(0)
      .key(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_TITLE)
      .id(MediaCardComponent.KEY_MEDIA_CARD_PRE + MediaCardComponent.KEY_TITLE)
      .transition(this.titleReady ? this.getCallTitleTransition() : TransitionEffect.IDENTITY)
      .onAppear(() => {
        this.titleReady = true;
      })
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityNextFocusId(COMPONENT_ID_AUDIO_BUTTON)
      .onClick(() => {
        this.clickCard(false);
      })

      Stack() {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Row().width(36).height('100%').id(this.getGeometryKey('callVolumeReduceStart'))
            .geometryTransition(this.getGeometryKey('callVolumeReduce'))
          Row().width('calc(100% - 72vp)').height('100%').id(this.getGeometryKey('callVolumeStart'))
            .geometryTransition(this.getGeometryKey('callVolume'))
          Row().width(36).height('100%').id(this.getGeometryKey('callVolumeAddStart'))
            .geometryTransition(this.getGeometryKey('callVolumeAdd'))
        }
        .height(this.BTN_SIZE)
        .visibility(Visibility.Hidden)

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          this.AudioComponent()
        }
        .height(this.BTN_SIZE)
      }
      .height(this.BTN_SIZE)
      .width('100%')
    }
    .height(this.style.cardMediaLowerHalfHeight)
    .width('100%')
  }
}