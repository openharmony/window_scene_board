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
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import { ScreenOnOffEvent, MediaControlEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { DropDownEvent, TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { sEventManager } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { SCBTransitionManager, SCBUnlockTransitionController } from '@ohos/windowscene/src/main/ets/animation/SCBTransitionManager';
import { ObjectCopyUtil } from '@ohos/componenthelper/src/main/ets/utils/ObjectCopyUtil';
import Curves from '@ohos.curves';
import audio from '@ohos.multimedia.audio';
import AVSessionManager from '@ohos.multimedia.avsession';
import { CardMediaController, ShowingMesTS } from '../../Controller/CardMediaController';
import { CardMediaControllerDc } from '../../Controller/CardMediaControllerDc';
import { DcMediaController } from '../../Controller/DcMediaController';
import ControlButtonGroup from './ControlButtonGroup';
import CommonUtils from '../../Util/CommonUtils';
import CommunicationUtil from '../../Util/CommunicationUtil';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import {
  immersiveKgMgr,
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { IState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { OnStateChangeListener } from '@ohos/systemuiutils/src/main/ets/sysdialog/StateListenerRegister';
import { LiveUseScene } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { BannerPanelTypeState } from '@ohos/systemuicommon/src/main/ets/banner/common/info/BannerState';
import { ILiveIconClickListener, LiveViewData } from '@ohos/systemuicommon/src/main/ets/liveview/data/LiveViewData';
import { LocalEventCallback } from '../../Util/LocalEventCallBack';
import { WDefault } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/constants/WidgetPropertyConst';
import { globalStorage } from '../../Util/GlobalStorage';
import DeviceSwitchButton from './DeviceSwitchButton';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { AccessibilityAppName } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityAppName';
import { MediaControllerSlider } from '../../Util/MediaControllerSlider';
import { LengthMetrics } from '@ohos.arkui.node';
import { AnimationState } from '../../viewmodel/AnimationState';
import { AnimationController } from '../../Controller/AnimationController';
import MeasuringUtil from '../../Util/MeasuringUtil';
import Constants, { ImageCallback, LyricDataArray } from '../../Util/Constants';
import { throttle } from '../../Util/Tool';
import image from '@ohos.multimedia.image';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { bannerMgr } from '@ohos/systemuicommon/src/main/ets/banner/phone/BannerManager';
import BrightnessUtils from '../../Util/BrightnessUtils';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { SystemUIColorVm } from '@ohos/systemuicommon/src/main/ets/vm/SystemUIColorVm';
import { BannerVm } from '@ohos/systemuicommon/src/main/ets/vm/BannerVm';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';

const TAG = 'MediaPlaybackControllerItem_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const EVENT_BROADCASTING_CENTER_REMOVE = 'event.broadcast.center.notification.remove';
const CLOSE_DEVICE_MENU: string = 'CLOSE_DEVICE_MENU';
const CLOSE_DEVICE_MENU_DELAY: number = 300;
const TITLE_SIZE: number = 18;
const TITLE_MAX_SIZE: number = 26;
const SUBTITLE_SIZE: number = 16;
const SUBTITLE_MAX_SIZE: number = 22;
const DEFAULT_IMAGE_SIZE: number = 48;
const SWITCH_BUTTON_POSITION: number = -10;
const LATEST_NOTIFY_CARD_ID = 'LATEST_NOTIFY_CARD_ID';

interface CurOutputDev {
  deviceType: audio.DeviceType;
  deviceId: number;
  networkId?: string;
}

@Component
export struct MediaPlaybackControllerItem {
  @Prop isScreenLock: boolean = false;
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled() && !ThreadUtil.isMainThread;
  // notify property
  @Prop notifyId: string;
  // meta data
  @StorageLink('MediaTitle') title: string = '';
  @StorageLink('MediaArtist') artist: string = '';
  @StorageLink('MediaDisplayTags') mediaDisplayTags: number | undefined = 0;
  @StorageLink('MediaValidCommands') @Watch('onValidCommandsChange') validCommands: Array<string> = [];
  @StorageLink('appName') curAppName: string | boolean = '';
  @StorageLink('MediaImgShow') mediaImgShow: boolean = false;
  @StorageLink('MediaPlayState') playState: number = 0;
  @StorageLink('MediaImg') mediaImage: string | image.PixelMap = '';
  @StorageLink('isChangeSong') isChangeSong: boolean = false;
  @StorageLink('isChangeApp') isChangeApp: boolean = false;
  @State assetId: string | number = '';
  @State isFavor: boolean = false;
  @State loopMode: number | undefined = undefined;
  @State hasMedia: boolean = true;
  @State skipIntervals: number = 15;
  @State isShowPlayButton: boolean = false;
  @State isClickSlider: boolean = false;
  @StorageProp('currColorMode') currColorMode: number = 0;
  @StorageProp('fontSizeScale') fontSizeScale: number = 1;
  // app info
  @State appIcon: string = '';
  @State appIconShow: boolean = false;
  @State mediaType: AVSessionManager.AVSessionType = 'audio';
  @State recentlyPlayTitle: string = this.getResourceString($r('app.string.RecentlyPlay'));
  @State noPlayTitle: string = this.getResourceString($r('app.string.no_media_title'));
  // app storage
  @StorageLink('CurDevSelect')
  curOutputDev: CurOutputDev = { deviceType: audio.DeviceType.SPEAKER, deviceId: -1 };
  @StorageLink('CurRemoteDevSelect')
  curRemoteOutputDev: number = -1;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State isShowSeek: boolean = false;
  // class variable
  private controller: CardMediaController | CardMediaControllerDc = this.enableDc ?
    CardMediaControllerDc.getInstance() : CardMediaController.getInstance();
  private dcController: DcMediaController | undefined = this.enableDc ? DcMediaController.getInstance() : undefined;
  private exitTimer: number = 0;
  //进度条变量
  @State private duration: number = 0;
  @State @Watch('getMusicLyric') private movePosition: number = 0; // position to show
  @State @Watch('getMusicLyric') private movingPosition: number = 0; // position to get lyric
  @State private trueMovePosition: number = 0; // position truely show
  @StorageLink('playbackPosition') playbackPosition: AVSessionManager.PlaybackPosition = {
    elapsedTime: 0,
    updateTime: 0
  }; // position from avsession
  private timerId: number | undefined = undefined;
  @State private moveFlag: number = 0;
  @StorageLink('MediaSpeed') speed: number = 1;
  private operateMinInterval: number = 500; // 防抖时间
  @State private moveFlagStep: number = 2;
  @State private progressHeight: number = 4;
  @State isPhoneOrPad: boolean = DeviceHelper.isPhoneOrPad();

  // 封面图
  @State imagesX: number = DEFAULT_IMAGE_SIZE;
  @State imagesY: number = DEFAULT_IMAGE_SIZE;
  private isFreeShow: boolean = false;
  //歌词
  @State lyric: string | undefined = '';
  @StorageLink('hasLyric') isLyric: boolean = false;
  @State dataArray: Array<LyricDataArray> = [];
  @State lyricList: Array<string> = [];
  @State minute: number = 0
  @State second: number = 0
  @State millisecond: number = 0
  @State newLyric: string = '';
  @State @Watch('onIsMarqueeStart') isMarqueeStart: boolean | null = false;
  // 金标
  private songNameAreaWidth: number = 0;
  private songNameTextSize: number = 18;
  private goldFlagImage: Resource = $r('app.media.ic_audiovivid');
  private avControllerCallback: LocalEventCallback | undefined = undefined;
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
  @StorageLink('dropDownPanelHide') @Watch('onDropDownPanelHide') isDropDownPanelHide: boolean = true;
  @State imageReady: boolean = false;
  @State private moveStartCachePosition: number = -1;
  /**
   * 下拉事件
   */
  @StorageLink('dropDownEvent') @Watch('onDropdownChanged') dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  @Prop @Watch('setNotificationFromDeviceChange') isNotificationFromDeviceChange: boolean = false;
  private isDisplayedInNtfCenter: boolean = false;
  private isDisplayedInScreenLock: boolean = false;
  private notifyIdWithScreenLockSuffix: string = '';
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false; // 增加UI缓存，防止丢帧
  private audioRoutingManager = audio.getAudioManager().getRoutingManager();
  @State private sceneType: string = 'notify';
  @Prop iconClickListener?: ILiveIconClickListener;
  private groupKey: string = '';
  private lockShowTimer: number | undefined = undefined;
  private useScene: LiveUseScene = this.isScreenLock ? LiveUseScene.SCENE_SCREEN_LOCK : LiveUseScene.SCENE_NTF_CENTER;
  @Prop isShowBannerFromScreenLock: boolean = false;

  @ObjectLink itemData?: LiveViewData;
  @State private imgWidthSize: number = 64;
  @State private imgHeightSize: number = 64;

  @State private shortTimeUpdateCount: number = 0;
  @State private callSeekCount: number = 0;
  @State private dropdownProgress: number = 1;
  // 点击快进快退，更新position,用于打点
  @State @Watch('refreshPosition') isClickFastForward: boolean = false;
  @State @Watch('refreshPosition') isClickRewind: boolean = false;
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  @State mediaAnimState: AnimationState = AnimationController.getAnimationState();

  @StorageLink('foldStatusForOuterScreen') @Watch('updateDeviceScreen') foldStatus: number =
    AppStorage.get<number>('foldStatusForOuterScreen') as number;
  @Prop scene: string;
  @State private isLiveCardStyle: boolean = false;
  @Prop @Watch('ntfPanelVisibleChange') ntfPanelVisible: boolean = true;
  @State private isShowPicker: boolean = false;
  /*
    是否实况胶囊卡片，1.0与2.0共用
   */
  @State private isLiveScene: boolean = false;

  private lyricCache: string = '';

  private lastPlayState: number = 0;
  private isDoubleExpand: boolean = false; //true：双列控制中心展开态
  private isPlaybackPositionTempSetted = false;
  uiContext: UIContext = this.getUIContext();
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;
  private cardId: number = new Date().getTime();

  // 图标点击事件回调
  onIconClickV2?: () => void;

  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_${this.isScreenLock ? 'NFTCenter' : 'ScreenLock'}`,
    onLock: (): void => {
      log.showInfo('onLockReceived in media ntf, isScreenLock=' + this.isScreenLock);
      if (this.isNotificationFromDeviceChange && !this.isPlaying() && !this.isScreenLock &&
        this.title === this.recentlyPlayTitle) {
        this.controller.postNotificationCancelEvent(this.notifyId, 'screen lock');
        this.isNotificationFromDeviceChange = false;
      }
      this.isDisplayedInScreenLock = true;
    },
    onUnlock: (): void => {
      log.showInfo('onUnLockReceived in media ntf, isDevice=' + this.isNotificationFromDeviceChange +
        ', isLockDisplayed=' + this.isDisplayedInScreenLock + ', isScreenLock=' + this.isScreenLock);
      if (this.isNotificationFromDeviceChange && !this.isPlaying() && this.title === this.recentlyPlayTitle) {
        this.controller.postNotificationCancelEvent(this.notifyId, 'screen unlock');
        this.isNotificationFromDeviceChange = false;
      }
      this.isDisplayedInScreenLock = false;
    },
  };

  private onBannerStateChange: OnStateChangeListener = {
    onStateChange: (state: IState): void => {
      switch (state?.getStateType()) {
        case StateType.TYPE_BANNER_PANEL_TYPE:
          this.onBannerPanelChange(state as BannerPanelTypeState);
          break;

        default:
          break;
      }
    }
  };

  private onBannerPanelChange(state: BannerPanelTypeState): void {
    let isLivePanel = state?.isPanelLiveList() ?? false;
    log.showInfo(`banner state changed isLivePanel: ${isLivePanel}}`);
    this.isMarqueeStart = isLivePanel;
    if (this.isMarqueeStart) {
      this.controller.startShowing(TAG, true);
    }
  }

  async aboutToAppear() {
    let screenLockSuffix: string = this.isScreenLock ? CommunicationUtil.SCREEN_LOCK_NOTIFY_ID_SUFFIX : '';
    this.notifyIdWithScreenLockSuffix = this.notifyId + screenLockSuffix;
    if (this.scene === 'Live') {
      this.isLiveCardStyle = true;
      this.sceneType = 'liveCard'
    } else if (this.isScreenLock) {
      this.sceneType = 'screenLock'
    } else {
      this.sceneType = 'notify'
      AppStorage.setOrCreate(LATEST_NOTIFY_CARD_ID, this.cardId);
    }
    if (this.scene === 'Live' || this.useScene === LiveUseScene.SCENE_LIVE_LIST) {
      this.isLiveScene = true;
      bannerMgr.registerStateChangeListener(StateType.TYPE_BANNER_PANEL_TYPE, this.onBannerStateChange);
    }
    log.debug(`aboutToAppear notifyId: ${this.notifyId}， isDevice=${this.isNotificationFromDeviceChange}`);
    log.showInfo('aboutToAppear notifyId: ' + this.notifyId + ' ,notifyIdWithScreenLockSuffix: ' +
      this.notifyIdWithScreenLockSuffix + ', isDropDownPanelHide: ' + this.isDropDownPanelHide);
    log.showInfo(`cardId: ${this.cardId}, sceneType: ${this.sceneType}`);
    AppStorage.setOrCreate('isNotificationFromDeviceChange', this.isNotificationFromDeviceChange);
    if (this.enableDc) {
      this.dcController?.setAppStorage('isNotificationFromDeviceChange', this.isNotificationFromDeviceChange);
    }
    this.goldFlagState();
    this.controller.doSubscribeNotify();
    const forceRemove = this.isScreenLock ? false : await this.removeByTriggerDevice();
    this.controller.removeExistedNotification(this.notifyId, forceRemove);
    this.setMediaDataListener();
    this.subscribeNotificationDelete();
    EvtBus.on(MediaControlEvent, this.onMediaControlCallback); // 播控监听
    this.eventMgr.on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
      this.onScreenOnOffEvent(event)
    });
    let isCurScreenOn: boolean | undefined = AppStorage.get('isCurScreenOn');
    if (isCurScreenOn && (this.isScreenLock || !this.isDropDownPanelHide)) {
      this.isMarqueeStart = true;
    }
    this.controller.startShowing(TAG, true, true);
    AppStorage.setOrCreate('isMediaNtfShowing', true);
    if (this.enableDc) {
      this.dcController?.setAppStorage('isMediaNtfShowing', true);
    }
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
    // 至少要显示1000ms
    this.lockShowTimer = setTimeout(() => {
      this.isDisplayedInScreenLock = this.isNotificationFromDeviceChange && !!isCurScreenOn && this.isScreenLock;
      log.showInfo(`aboutToAppear set isLockDisplayed res = ${this.isDisplayedInScreenLock}`);
    }, 2000);
    this.updateDeviceScreen();
    this.ntfPanelVisibleChange();
  }

  async removeByTriggerDevice() {
    return !Constants.NOTIFY_TRIGGER_DEVICE_TYPE.includes(this.curOutputDev.deviceType) &&
      this.isNotificationFromDeviceChange;
  }

  aboutToDisappear() {
    log.showInfo(`mediaPlaybackControllerItem aboutToDisappear`);
    this.eventMgr.offAll();
    this.unsetMediaDataListener();
    EvtBus.off(MediaControlEvent, this.onMediaControlCallback); // 取消监听
    log.showInfo(`aboutToDisappear notifyId: ${this.notifyId}, sceneType: ${this.sceneType},` +
      `notifyIdWithScreenLockSuffix: ${this.notifyIdWithScreenLockSuffix}, cardId: ${this.cardId}`);
    this.clearTimerAndProgressData(false)
    if (this.sceneType === 'notify' && this.cardId === AppStorage.get(LATEST_NOTIFY_CARD_ID)) {
      AppStorage.setOrCreate('isMediaNtfShowing', false);
      if (this.enableDc) {
        this.dcController?.setAppStorage('isMediaNtfShowing', false);
      }
    }
    this.eventMgr.offAll();
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.unLockTransitionController, false);
    if (this.scene === 'Live' || this.useScene === LiveUseScene.SCENE_LIVE_LIST) {
      bannerMgr.unregisterStateChangeListener(StateType.TYPE_BANNER_PANEL_TYPE, this.onBannerStateChange);
    }
  }

  /**
   * 胶囊2.0显示隐藏
   */
  publishCapsuleChangeEvent(isAppear: string) {
    if (this.isLiveScene) {
      let options: commonEventManager.CommonEventPublishData = {
        data: isAppear,
      };
      try {
        commonEventManager.publish('EVENT_AVSESSION_MEDIA_CAPSULE_STATE_CHANGE', options, (err: BusinessError) => {
          if (err) {
            log.showError(`publishCapsuleChangeEvent error: code: ${err.code} message: ${err.message}`);
          } else {
            log.showInfo('publishCapsuleChangeEvent success' + isAppear);
          }
        });
      } catch (error) {
        log.showError(`publishCapsuleChangeEvent catch error: ${error?.message}`);
      }
    }
  }

  updateDeviceScreen(): void {
  }

  refreshPosition(value: string) {
    if (!this.isClickRewind && !this.isClickFastForward) {
      return;
    }
    if (value === 'isClickRewind') {
      this.isClickRewind = false;
      log.debug(`refeashMovePosition--if--${value}`);
    } else {
      this.isClickFastForward = false;
      log.debug(`refeashMovePosition--else--${value}`);
    }
    globalStorage.setNumberByKey('curPosition', this.movePosition);
    if (this.enableDc) {
      // 同步globalStorage至主线程
      this.dcController?.callGlobalStorage({name: 'curPosition', value: this.movePosition});
    }
  }

  private broadCastingCenterRemoveCallback = () => {
    log.showInfo('receive EVENT_BROADCASTING_CENTER_REMOVE event');
    try {
      let isShowPause: boolean = this.validCommands?.includes('pause');
      if (this.controller && isShowPause) {
        let screenLockSuffix: string = this.isScreenLock ? 'screenLock' : 'notify';
        globalStorage.setStringByKey('scenesType', screenLockSuffix);
        if (this.enableDc) {
          // 同步globalStorage至主线程
          this.dcController?.callGlobalStorage({name: 'scenesType', value: screenLockSuffix});
        }
        this.controller.callShowingPause();
        this.clearTimerAndProgressData(false)
        AppStorage.setOrCreate('isMediaNtfShowing', false);
        if (this.enableDc) {
          this.dcController?.setAppStorage('isMediaNtfShowing', false);
        }
      } else {
        log.showError('receive EVENT_BROADCASTING_CENTER_REMOVE event failed for no instance');
      }
    } catch (err) {
      log.showError(`catch event proccess failed code: ${err.code}, message: ${err.message}`);
    }
  }

  async subscribeNotificationDelete() {
    log.showInfo(`subscribeNotificationDelete begin`);
    sEventManager.subscribe(EVENT_BROADCASTING_CENTER_REMOVE, this.broadCastingCenterRemoveCallback);
  }

  isPlaying() {
    return CommonUtils.isPlaying(this.playState, this.lastPlayState, this.curRemoteOutputDev >= 0);
  }

  private deviceChangeCallback = (deviceChanged: audio.DeviceChangeAction) => {
    log.showInfo(`device change type:${JSON.stringify(deviceChanged.type)}`);
    if (!this) {
      log.showInfo(`this has been destroyed`);
      return;
    }
    if (this.isNotificationFromDeviceChange && deviceChanged.type == audio.DeviceChangeType.DISCONNECT &&
      !this.isPlaying() && (this.title === this.recentlyPlayTitle || this.title === this.noPlayTitle || !this.title)) {
      log.showInfo('headset disconnected and play state is not playing, remove notification');
      this.controller.postNotificationCancelEvent(this.notifyId, 'device disconnect');
      this.isNotificationFromDeviceChange = false;
    }
  }

  setMediaDataListener() {
    this.isShowSeek = this.validCommands.includes('seek')
    try {
      this.audioRoutingManager.on('deviceChange', audio.DeviceFlag.OUTPUT_DEVICES_FLAG, this.deviceChangeCallback);
    } catch (err) {
      log.showError(`Faild to on deviceChange. Code: ${err.code}, message: ${err.message}`);
    } 
    this.avControllerCallback = new LocalEventCallback((mediaInfo: ShowingMesTS) => {
      log.showInfo(` media data update: ${JSON.stringify(mediaInfo)} ` + this.notifyId);
      setTimeout(() => {
        this.mediaDataUpdate(mediaInfo);
      }, 0);
    });
    log.showInfo(` setMediaDataListener for notification id: ` + this.notifyIdWithScreenLockSuffix);
    CommunicationUtil.addLocalEventListener('mediaUpdate', this.avControllerCallback);
  }

  unsetMediaDataListener() {
    log.showInfo(`unsetMediaDataListener.off, this.isScreenLock: ${this.isScreenLock}`);
    try {
      this.audioRoutingManager.off('deviceChange', this.deviceChangeCallback);
    } catch (err) {
      log.showError(`Faild to off deviceChange. Code: ${err.code}, message: ${err.message}`);
    }    
    sEventManager.off(EVENT_BROADCASTING_CENTER_REMOVE, this.broadCastingCenterRemoveCallback);
    if (!this.avControllerCallback) {
      return;
    }
    log.showInfo(`unsetMediaDataListener for notification id: ` + this.notifyIdWithScreenLockSuffix);
    CommunicationUtil.removeLocalEventListener('mediaUpdate', this.avControllerCallback);
  }

  private closeDeviceMenu = throttle(() => {
    try {
      commonEventManager.publish(CLOSE_DEVICE_MENU, (err: BusinessError) => {
        if (err) {
          log.error(`close device menu error: code: ${err.code} message: ${err.message}`);
        } else {
          log.showWarn('close device menu success');
        }
      });
    } catch (err) {
      log.error(`Faild to close device menu. Code: ${err.code}, message: ${err.message}`);
    }
  }, CLOSE_DEVICE_MENU_DELAY)

  onDropdownChanged() {
    if (this.dropDownEvent && this.dropDownEvent.targetChanged !== 0) {
      this.closeDeviceMenu();
    }
    this.dropdownProgress = this.dropDownEvent?.progress;
    if (this.dropDownEvent.target === TargetPanel.NONE) {
      return;
    }
    this.isMarqueeStart = true;
    log.showInfo('dropDown ' + this.dropDownEvent.target + ',isDisplayedInScreenLock ' + this.isDisplayedInScreenLock);
    if (this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL &&
      this.isNotificationFromDeviceChange && !this.isDisplayedInScreenLock) {
      this.isDisplayedInNtfCenter = true;
    }
    if (this.isPlaying() && this.playState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY) {
      this.startInterval();
    }
    this.goldFlagState();
    log.showInfo(` isDisplayedInNtfCenter: ` + this.isDisplayedInNtfCenter);
  }

  onDropDownPanelHide() {
    if (!AppStorage.get('dropDownPanelHide')) {
      return;
    }
    log.showInfo('onDropDownPanelHide start. isScreenLock=' + this.isScreenLock);
    if (!this.isScreenLock) {
      this.isMarqueeStart = false;
      this.clearTimerAndProgressData(false);
    }
    if (this.isNotificationFromDeviceChange && !this.isPlaying() &&
      (this.isDisplayedInScreenLock || this.isDisplayedInNtfCenter) && this.title === this.recentlyPlayTitle) {
      log.showInfo('onDropDownPanelHide remove notification id: ' + this.notifyId);
      this.controller.postNotificationCancelEvent(this.notifyId, 'panel hide');
      this.isNotificationFromDeviceChange = false;
      this.isDisplayedInNtfCenter = false;
    }
  }

  checkImageShow(
    noImage: string | PixelMap | Resource,
    image: string | PixelMap | Resource
  ): string | PixelMap | Resource {
    if (!!this.mediaImage && this.mediaImage != 'unknown' && !this.mediaImage.toString()?.includes('http')) {
      return noImage;
    }
    return image;
  }

  onImageComplete(newValue: ImageCallback, _width: number) { // _width容器的宽度  newValue-图片的宽高
    log.info(`onImageComplete: ${newValue.width}, ${newValue.height} _width ${_width}`);
    let iconWidth = 16;
    const minPortraitRatio: number = 13 / 18;
    const maxLandscapeRatio: number = 16 / 9;
    const realRatio: number = newValue.width / newValue.height;
    let calRatio: number = 1;
    if (realRatio >= minPortraitRatio && realRatio <= maxLandscapeRatio) {
      log.debug(`onImageComplete, <= maxLandscapeRatio`);
      calRatio = realRatio;
      this.isFreeShow = true;
    } else if (realRatio > maxLandscapeRatio) {
      calRatio = maxLandscapeRatio;
      this.isFreeShow = false;
    } else { // w/h < 13/18
      calRatio = minPortraitRatio;
      this.isFreeShow = false;
    }
    this.imgWidthSize = Math.min(_width, _width * calRatio);
    this.imgHeightSize = Math.min(_width, _width / calRatio);
    this.imagesX = (_width - this.imgWidthSize) / 2 + this.imgWidthSize - iconWidth;
    this.imagesY = (_width - this.imgHeightSize) / 2 + this.imgHeightSize - iconWidth;
  }

  onIsMarqueeStart() {
    log.debug(`isMarqueeStartChange: ${this.isMarqueeStart}`);
  }

  ntfPanelVisibleChange() {
    if (this.ntfPanelVisible) {
      this.isShowPicker = true;
    }
  }

  deviceSwitchVisible(): boolean {
    return this.sceneType === 'notify' ? this.isShowPicker : true;
  }

  onScreenOnOffEvent(event: ScreenOnOffEvent) {
    log.showInfo(`onScreenOnOffEvent: ${event.event}, ${this.isScreenLock}, already=${this.isDisplayedInScreenLock}`);
    AppStorage.setOrCreate('isCurScreenOn', event.isScreenOn());
    if (this.enableDc) {
      this.dcController?.setAppStorage('isCurScreenOn', event.isScreenOn());
    }
    if (event.event === 'usual.event.SCREEN_OFF') {
      this.isMarqueeStart = false;
      this.clearTimerAndProgressData(false);
      clearTimeout(this.lockShowTimer);
      this.lockShowTimer = undefined;
    }
    if (event.event === 'usual.event.SCREEN_ON' && this.isScreenLock) {
      this.isMarqueeStart = true;
      this.controller.startShowing(TAG, true);
    }
    if (!this.isNotificationFromDeviceChange) {
      return;
    }
    if (event.event === 'usual.event.SCREEN_ON' && !this.isDisplayedInNtfCenter && !this.isDisplayedInScreenLock) {
      log.showInfo('notification has not display, display in screen lock');
      this.isDisplayedInScreenLock = true;
    }
  }

  setNotificationFromDeviceChange() {
    log.showInfo(`setNotificationFromDeviceChange: ${this.isNotificationFromDeviceChange}`)
    this.controller.setNotificationFromDeviceChange(this.isNotificationFromDeviceChange);
  }

  /**
   * 播控广播回调
   *
   * @param event 广播数据
   */
  onMediaControlCallback = (event: MediaControlEvent) => {
    log.showInfo('onMediaControlCallback: ' + JSON.stringify(event))
    if (event.data == MediaControlEvent.MEDIA_CONTROL_QUIT) {
      this.controller.doSubscribeNotify();
    }
  }

  @Builder
  goldLabelBuilder() {
    Row() {
      Row() {
        Image(this.goldFlagImage)
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
      .borderRadius('4vp')
      .clip(true)
      .opacity(this.goldFlagOpacity)
      .padding({
        left: '8vp',
        right: '8vp',
        top: '4vp',
        bottom: '4vp'
      })
      .height(16)
      .width(79)
      .backgroundColor('#66000000')
    }
    .flexGrow(0)
    .flexShrink(0)
    .flexBasis('auto')
    .margin({ right: 8 })
    .visibility(this.isShowGoldFlag ? Visibility.Visible : Visibility.None)
  }

  /**
   * 获取标题颜色
   * @param isPrimary 是否为主标题
   * @returns
   */
  getFontColor(isPrimary: boolean) {
    if (isPrimary) {
      return this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_primary');
    } else {
      return this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary');
    }
  }

  isHasMediaImage() {
    return !!this.mediaImage && this.mediaImage != 'unknown' && !this.mediaImage.toString()?.includes('http');
  }

  isDarkMode() {
    // 隔离主线程调用
    let colorMode = ThreadUtil.isMainThread ? this.currColorMode : SystemUIColorVm.instance.colorMode;
    return colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
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

  /**
   * 主标题
   */
  @Builder TitleBuilder() {
    Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
      if (this.isPlaying() && this.isMarqueeStart) {
        Marquee({
          start: true,
          step: 6,
          loop: -1,
          fromStart: !this.isRTL(),
          src: this.title || (this.curAppName ? this.curAppName.toString() : this.recentlyPlayTitle)
        })
          .fontSize(MeasuringUtil.getFontSize(TITLE_SIZE, 2,
            this.getFontSizeScale()))
          .fontWeight(600)
          .fontColor(this.getFontColor(true))
          .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(true, this.sceneType, this.isDarkMode()))
          .align(!this.isRTL() ? Alignment.Start : Alignment.End)
          .height(MeasuringUtil.getHeight(TITLE_SIZE, TITLE_MAX_SIZE,
            2, this.getFontSizeScale()))
          .width('100%')
          .accessibilityLevel('no')
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
      } else {
        Text(this.title || (this.curAppName ? this.curAppName.toString() : this.recentlyPlayTitle))
          .fontColor(this.getFontColor(true))
          .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(true, this.sceneType, this.isDarkMode()))
          .fontSize('18fp')
          .maxFontScale(2.0)
          .fontWeight(600)
          .maxLines(1)
          .textAlign(!this.isRTL() ? TextAlign.Start : TextAlign.End)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .height(MeasuringUtil.getHeight(TITLE_SIZE, TITLE_MAX_SIZE,
            2, this.getFontSizeScale()))
      }
    }
    .width('100%')
    .padding(!this.isRTL() ? { right: 32 } : { left: 32 })
    .onAreaChange((oldArea: Area, newValue: Area) => {
      this.songNameAreaWidth = newValue.width as number;
      this.titleWidth = this.getSongNameTextLength(this.title, this.songNameTextSize);
      log.showInfo(`parse media data: title = ${this.titleWidth}${this.goldFlagImage}`);
    })
    .margin({ top: -2 })
  }

  /**
   * 副标题
   */
  @Builder SubTitleBuilder() {
    Flex({ wrap: FlexWrap.NoWrap, alignItems: ItemAlign.Center}) {
      if (this.isPlaying() && this.isMarqueeStart) {
        Marquee({
          start: true,
          step: 6,
          loop: -1,
          fromStart: !this.isRTL(),
          src: (this.isLyric && this.newLyric) ? this.newLyric : this.artist
        })
          .fontSize(MeasuringUtil.getFontSize(SUBTITLE_SIZE, 2,
            this.getFontSizeScale()))
          .fontWeight(FontWeight.Regular)
          .fontColor(this.getFontColor(false))
          .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(false, this.sceneType, this.isDarkMode()))
          .align(!this.isRTL() ? Alignment.Start : Alignment.End)
          .accessibilityLevel('no')
          .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
      } else {
        Text((this.isLyric && this.newLyric) ? this.newLyric : this.artist)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontSize(SUBTITLE_SIZE)
          .maxFontScale(2.0)
          .fontWeight(FontWeight.Regular)
          .fontColor(this.getFontColor(false))
          .textAlign(!this.isRTL() ? TextAlign.Start : TextAlign.End)
          .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(false, this.sceneType, this.isDarkMode()))
      }
    }
    .width('100%')
    .height(MeasuringUtil.getHeight(SUBTITLE_SIZE, SUBTITLE_MAX_SIZE,
      2, this.getFontSizeScale()))
    .margin({ top: 0 })
  }

  @Builder bodyBuilder() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
      // album image
      Stack() {
        Button({ stateEffect: false }) {
          Column() {
            if (this.mediaAnimState.isListShow) {
              Image((this.mediaImgShow && this.mediaImage) ? this.mediaImage : $r('app.media.ic_nomusic_img'))
                .alt(this.checkImageShow('', $r('app.media.ic_nomusic_img')))
                .draggable(false)
                .objectFit(this.isFreeShow ? ImageFit.Contain : ImageFit.Cover)
                .fillColor(this.isLiveCardStyle ? '#33FFFFFF' : $r('sys.color.ohos_id_color_fourth'))
                .borderRadius($r('sys.float.corner_radius_level4'))
                .onError(() => {
                  log.showInfo('mediaImg show err' + this.mediaImage);
                  if (this.mediaImage && typeof this.mediaImage === 'object') {
                    return;
                  }
                  this.mediaImage = '';
                  this.imageReady = false;
                  this.clearMediaImageSize();
                })
                .onComplete(newValue => {
                  log.showInfo(`mediaImg show success: ${!!this.mediaImage}`);
                  if (newValue) {
                    if (this.isPhoneOrPad) {
                      this.onImageComplete(newValue, 64);
                    }
                    if (!this.mediaImgShow || !this.mediaImage) {
                      this.clearMediaImageSize();
                      this.imageReady = false
                    }
                  }
                })
                .renderGroup(this.isMarkingRenderGroup)
                .id(this.isScreenLock ? 'mediaControllerImage_list' : '')
                .geometryTransition(this.isScreenLock && this.mediaAnimState.isListGeo ?
                  'mediaControllerImage' : '', {hierarchyStrategy: TransitionHierarchyStrategy.ADAPTIVE})
                .transition(TransitionEffect.IDENTITY)
                .zIndex(this.mediaAnimState.isListGeo ? 100 : undefined)
                .backgroundColor(this.mediaAnimState.isListShow && this.mediaImage && this.isHasMediaImage() ?
                  Color.Transparent : (this.isLiveCardStyle ? '#19FFFFFF' : $r('sys.color.comp_background_secondary')))
                .autoResize(false)
                .interpolation(ImageInterpolation.Medium)
            }
          }
          .width(this.imgWidthSize)
          .height(this.imgHeightSize)
          .justifyContent(FlexAlign.Center)
          .borderRadius(this.imgWidthSize === this.imgHeightSize ? $r('sys.float.ohos_id_corner_radius_default_m') : 4)
        }
        .opacity(WDefault.MAX_VALUE)
        .type(ButtonType.Normal)
        .clip(false)
        .size({
          width: 64,
          height: 64
        })
        .backgroundColor(Color.Transparent)
        .borderRadius($r('sys.float.ohos_id_corner_radius_icon'))
        .align(Alignment.Center)
        if (this.appIconShow) {
          Column()
            .width(16)
            .height(16)
            .borderRadius(4)
            .visibility(Visibility.Hidden)
            .position(this.isRTL() ? { right: this.imagesX, top: this.imagesY } :
              { left: this.imagesX, top: this.imagesY })
          Image(this.appIcon)
            .width(16)
            .height(16)
            .borderRadius(4)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .draggable(false)
            .position(this.isRTL() ? { right: this.imagesX, top: this.imagesY } :
              { left: this.imagesX, top: this.imagesY })
            .opacity(WDefault.MAX_VALUE)
        }
      }
      .borderRadius(8)
      .width(64)
      .height(64)
      .flexShrink(0)
      .align(Alignment.BottomEnd)
      .hitTestBehavior(this.isScreenLock || this.isShowBannerFromScreenLock || Boolean(this.onIconClickV2) ?
        HitTestMode.Default : HitTestMode.None)
      .onClick(() => {
        log.showInfo('image onClicked isScreenLock ' + this.isScreenLock);
        if (this.isScreenLock || this.isShowBannerFromScreenLock) {
          this.itemData?.iconClickListener?.onIconClick( this.useScene, this.groupKey);
        }
        // 图标点击事件回调
        this.onIconClickV2?.();
      })
      .accessibilityLevel(this.isScreenLock || this.isShowBannerFromScreenLock ? 'yes' : 'no')
      .accessibilityText(ResUtils.getInnerString($r('app.string.access_cover_image')))

      // title
      Column() {
        Column() {
          this.TitleBuilder()
          this.SubTitleBuilder()
        }
        .accessibilityGroup(true)
        .accessibilityLevel('yes')

        // process bar
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Text(this.getProgressStart())
            .fontSize(10)
            .maxFontScale(1.45)
            .fontColor(this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
            .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(this.isClickSlider,
                this.sceneType, this.isDarkMode()))
            .flexShrink(0)
            .textAlign(TextAlign.Start)
            .padding(undefined)
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
              sceneType: this.sceneType,
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
              sliderSelectedColor: ((this.isPhoneOrPad ? (this.isShowSeek ?
                  this.isLiveCardStyle ? '#FFFFFF' : $r('app.color.media_item_slider_primary') :
                  this.isLiveCardStyle ? '#19FFFFFF' : $r('app.color.media_item_slider_normal')) :
                  (this.isShowSeek ? $r('sys.color.icon_emphasize') : $r('sys.color.icon_fourth')))),
              sliderTrackColor: (this.isLiveCardStyle ? '#19FFFFFF' : (
                this.isPhoneOrPad ? $r('app.color.media_item_slider_normal') : undefined)),
              sliderBlockColor: ('#00ffffff'),
              sliderWidth: '100%',
              sliderFlexShrink: 1,
              sliderShowSteps: false,
              sliderShowTips: false,
              sliderShowTipsContent: '',
              sliderBlockBorderWidth: 40,
              sliderEnabled: this.isShowSeek,
              sliderBlockStyle:
              {
                type: SliderBlockType.SHAPE,
                shape: new Path({ commands: 'M60 60 M30 30 L15 56 L45 56 Z' })
              },
              sliderChangeCallback:
              (value: number, mode: SliderChangeMode) => {
                log.showInfo(`slider onChange: ${value}, mode=${mode}, this.movePosition=${this.movePosition}`);
                this.movingPosition = value;
                if (value === 0 && this.movePosition < 0) {
                  log.error(TAG, 'slider position abnormal, return');
                  return;
                }
                log.showInfo(`slider mode: ${mode}`)
                switch (mode) {
                  case SliderChangeMode.Begin:
                    this.isClickSlider = true
                    log.showInfo(`sliderChangeMode begin`)
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
                    log.showInfo(`sliderChangeMode end: ${value}、${this.isClickSlider}`);
                    if (!this.isClickSlider) {
                      this.isClickSlider = false;
                      return;
                    }
                    this.isClickSlider = false;
                    this.moveFlag = this.moveFlagStep * this.speed;
                    if (value <= this.duration) {
                      globalStorage.setStringByKey('scenesType', this.isScreenLock ? 'screenLock' : 'notify');
                      if (this.enableDc) {
                        // 同步globalStorage至主线程
                        this.dcController?.callGlobalStorage({name: 'scenesType',
                          value: this.isScreenLock ? 'screenLock' : 'notify'});
                      }
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
              sliderKey: 'media_playback_controller_item_progress',
              bannerPanelType: this.enableDc && this.isLiveScene && BannerVm?.instance?.bannerType ?
                BannerVm.instance.bannerType : undefined,
            })
              .id('controllerProgress')
          }

          Text(this.getProgressEnd())
            .fontSize(10)
            .maxFontScale(1.45)
            .fontColor(this.isPhoneOrPad ? $r('app.color.media_control_temporary_text') : $r('sys.color.font_secondary'))
            .foregroundBrightness(BrightnessUtils.getInstance().getItemTextBrightnessOption(this.isClickSlider,
                this.sceneType, this.isDarkMode()))
            .flexShrink(0)
            .textAlign(TextAlign.End)
            .padding(undefined)
            .accessibilityLevel('no')
            .renderGroup(this.isMarkingRenderGroup) // 增加UI缓存，防止丢帧
        }
        .width('100%')
        .height(40)
        .margin({top: -3})
      }
      .margin({ start: LengthMetrics.vp(12) })
      .backgroundColor(Color.Transparent)
    }
    .width('100%')
  }

  @Builder deviceSwitchBuilder() {
    if (this.deviceSwitchVisible()) {
      Column() {
        DeviceSwitchButton({
          buttonSize: Constants.COMMON_SWITCH_SIZE,
          isLiveCardStyle: this.isLiveCardStyle,
          isLiveScene: this.isLiveScene,
          isDarkMode: this.isDarkMode(),
        })
      }
      .visibility((this.dropdownProgress || this.isScreenLock || this.isLiveScene) ?
        Visibility.Visible : Visibility.None)
      .justifyContent(FlexAlign.Center)
      .width(40)
      .height(40)
      .position(this.isRTL() ?
        { top: SWITCH_BUTTON_POSITION, left: SWITCH_BUTTON_POSITION } :
        { top: SWITCH_BUTTON_POSITION, right: SWITCH_BUTTON_POSITION })
      .zIndex(1)
    }
  }

  build() {
    Column() {
      AccessibilityAppName({
        name: this.curAppName ? this.curAppName.toString() : '',
        isAccessibilityMode: this.isAccessibilityMode
      })
      this.bodyBuilder()
      // 四元组按钮
      ControlButtonGroup({
        sceneType: this.isLiveCardStyle ? 'liveCard' : this.isScreenLock ? 'screenLock' : 'notify',
        sessionType: this.mediaType,
        iconSize: 24,
        validCommands: this.validCommands,
        isPlaying: this.isPlaying(),
        isHasMedia: this.hasMedia,
        isForceDark: this.isPhoneOrPad,
        skipIntervals: this.skipIntervals,
        assetId: this.assetId,
        isFavor: this.isFavor,
        loopMode: this.loopMode,
        isShowPlayButton: $isShowPlayButton,
        isClickSlider: this.isClickSlider,
        isClickRewind: $isClickRewind,
        isClickFastForward: $isClickFastForward,
        isDoubleExpand: this.isDoubleExpand,
        duration: this.duration,
        fun: () => {
          if (this.loopMode !== AVSessionManager.LoopMode.LOOP_MODE_SINGLE && this.isShowGoldFlag) {
            this.goldFlagEnd()
          }
        },
        clearTimerAndProgressData: (isClearData: boolean) => {
          log.showInfo(`clearTimerAndProgressData:${isClearData}`)
          this.clearTimerAndProgressData(isClearData)
        }
      })
        .width('100%')
        .backgroundColor(Color.Transparent)
        .height(48)
        .clip(true)
      // 投音按钮
      this.deviceSwitchBuilder()
    }
    .width('100%')
    .borderRadius(16)
    .clip(false)
    .brightness(1)
    .saturate(1)
    .padding({ left: 12, right: 12, top: 12, bottom: 4 })
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      log.showInfo(`onVisibleAreaChange visible: ${isVisible}, currentRatio:${currentRatio}` +
        `, isLiveScene: ${this.isLiveScene}, sceneType: ${this.sceneType}`);
      if (!this.isLiveScene) {
        return;
      }
      if (isVisible && currentRatio >= 1.0) {
        this.publishCapsuleChangeEvent('APPEAR');
        this.isMarqueeStart = true;
        this.controller.startShowing(TAG, true);
      }
      if (!isVisible && currentRatio <= 0.0) {
        this.publishCapsuleChangeEvent('DISAPPEAR');
        this.isMarqueeStart = false;
        this.clearTimerAndProgressData(false);
      }
    })
  }

  updateBasicInfo(mediaInfo: ShowingMesTS) {
    log.showInfo(`updateBasicInfo ${JSON.stringify(mediaInfo)}`);
    if (mediaInfo.playState != undefined) {
      log.showInfo(`parse media data: playState = ${mediaInfo.playState}`);
      this.playState = mediaInfo.playState as number;
      if (this.playState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
        this.lastPlayState = this.playState;
      }
    }
    if (mediaInfo.isFavor != undefined || this.isChangeApp) {
      log.debug(`parse media data: isFavor = ${mediaInfo.isFavor}`);
      this.isFavor = mediaInfo.isFavor as boolean;
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
      log.showInfo(`set assetId done: ${this.assetId}`);
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
      log.showInfo(`parse media data: mediaType = ${mediaInfo.mediaType}`);
      this.mediaType = mediaInfo.mediaType;
    }
    this.isShowPlayButton = (!!this.mediaImage || !!this.title || !!this.artist || !this.curAppName) &&
      !!this.mediaType && this.validCommands?.includes('play') && this.validCommands?.includes('pause');
    this.titleWidth = this.getSongNameTextLength(this.title, this.songNameTextSize);
  }

  updateGoldFlag(mediaInfo: ShowingMesTS) {
    log.debug(`updateGoldFlag displayTags: ${mediaInfo.displayTags} 、${this.isShowGoldFlag}`);
    if (!mediaInfo.displayTags) {
      return;
    }
    if (this.isChangeSong || this.tagsType) {
      this.tagsType = false;
      setTimeout(() => {
        this.tagsType = true;
      }, 1000)
      log.debug(`updateGoldFlag update`);
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

  updateProgress(mediaInfo: ShowingMesTS) {
    if (mediaInfo.duration != undefined) {
      // 音频总时长，当总时长大于24:00:00，显示24:00:00
      let duration = Math.floor(mediaInfo.duration);
      if (duration > 24 * 60 * 60 * 1000) {
        duration = 24 * 60 * 60 * 1000;
      }
      this.duration = duration;
      this.setProgreeUpDateTime(this.duration);
      if (!this.duration || this.duration < 0) {
        this.initSliderChange();
      }
    }
    let currentPlayState: number | boolean | undefined = mediaInfo?.playState || this.playState;
    if (mediaInfo.position !== undefined) {
      log.showInfo(` old updateTime: ${this.playbackPosition.updateTime}
       new updateTime: ${mediaInfo.position.updateTime}`);
      if (mediaInfo.position.updateTime > this.playbackPosition.updateTime) {
        this.playbackPosition = mediaInfo.position;
      }
      if (this.isPlaybackPositionTempSetted) {
        log.showInfo('set playbackPosition');
        this.playbackPosition = mediaInfo.position;
        this.isPlaybackPositionTempSetted = false;
      }
      if (mediaInfo.position.updateTime < 1) {
        this.playbackPosition = mediaInfo.position;
        this.playbackPosition.updateTime = new Date().getTime();
      }
      this.getSliderData(mediaInfo);
    } else if (currentPlayState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY && !mediaInfo.isCastController) {
      log.showInfo(`mediaInfo no position AND play state`);
      let currentTime = this.isPlaying() ? new Date().getTime() : this.playbackPosition.updateTime;
      this.movePosition = (currentTime - this.playbackPosition.updateTime) * this.speed +
      this.playbackPosition.elapsedTime;
      this.startInterval();
    } else if (currentPlayState === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
      log.showInfo(`mediaInfo no position AND buffer state`);
      this.clearTimerAndProgressData(false);
    } else {
      log.showInfo(`no position AND no play state`);
      this.clearTimerAndProgressData(false);
    }
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
    this.isPlaybackPositionTempSetted = true;
  }

  /**
   * 重置进度条相关变量
   */
  initSliderChange() {
    this.progressHeight = 4;
    this.isClickSlider = false;
  }

  updateLyric(mediaInfo: ShowingMesTS) {
    if (mediaInfo?.lyric) {
      this.lyric = mediaInfo.lyric;
    } else if (this.curRemoteOutputDev > 0 && !mediaInfo?.lyric) {
      this.lyric = '';
      return;
    }
    if (!this.lyric && (this.assetId !== mediaInfo?.musicAssetId)) {
      this.lyric = '';
      return;
    }
    this.loadMusicLyricList();
    if (this.lyric) {
      this.newLyric = this.getEachLyric();
    }
  }

  mediaDataUpdate(mediaInfo: ShowingMesTS) {
    let newMediaInfo: ShowingMesTS = ObjectCopyUtil.deepClone(mediaInfo);
    newMediaInfo.mediaPlayerIcon = !!newMediaInfo.mediaPlayerIcon;
    log.showInfo(`start parse media data: ${JSON.stringify(newMediaInfo)}`);
    if (this.isChangeSong && !mediaInfo.displayTags) {
      this.isShowGoldFlag = false;
    }
    if ((!this.isMarqueeStart) && !this.isChangeSong &&
      (!mediaInfo?.musicAssetId || this.assetId === mediaInfo?.musicAssetId) && !mediaInfo?.forceUpdate) {
      log.showInfo(`not update media data, isMarqueeStart: ${this.isMarqueeStart}
        , assetId: ${this.assetId}`);
      return;
    }
    this.updateBasicInfo(mediaInfo);
    this.updateGoldFlag(mediaInfo);
    this.updateProgress(mediaInfo);
    this.updateLyric(mediaInfo);
  }

  getSongNameTextLength(text: string, fontSize: number): number {
    let textLength: number = this.getUIContext().getMeasureUtils().measureText({
      textContent: text,
      fontSize: fontSize
    })
    let audioVividFlagWidth = this.AUDIO_VIVID_FLAG_WIDTH + this.GOLD_FLAG_MARGIN;
    let maxValidLength = this.songNameAreaWidth - audioVividFlagWidth;
    let length = (this.uiContext.px2vp(textLength) + 5) > maxValidLength ? maxValidLength :
      (this.uiContext.px2vp(textLength) + 5);
    log.debug('textLength:' + (this.uiContext.px2vp(textLength) + 5) + ' maxValidLength:' + maxValidLength + ' result:' + length);
    return length - 28;
  }

  goldFlagState() { //金标显示动画
    log.debug(`goldFlagState: ${this.isShowGoldFlag} mediaDisplayTags: ${this.mediaDisplayTags}`)
    setTimeout(() => {
      if (this.mediaDisplayTags) {
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
      }
    }, 200)
  }

  goldFlagEnd() { //金标消失动画
    log.debug('goldFlagEnd');
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

  getSliderData(mediaInfo: ShowingMesTS) {
    this.shortTimeUpdateCount++;
    log.debug(`MediaControllerSlider on this.getSliderData add: ${this.shortTimeUpdateCount}`);
    let currentPlayState = mediaInfo?.playState || this.playState;
    if (!this.timerId || this.moveFlag > 0) {
      this.moveFlag = 0;
      if (this.isPlaying() && this.isMarqueeStart) {
        if (currentPlayState === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING) {
          this.movePosition = this.playbackPosition?.elapsedTime;
          if (this.playbackPosition?.elapsedTime >= this.duration) {
            this.movePosition = this.duration;
          }
          log.showInfo(`buffer AND update position: ${this.movePosition}`);
        } else {
          this.movePosition = ((new Date().getTime()) - this.playbackPosition.updateTime) * this.speed +
          this.playbackPosition.elapsedTime;
          log.showInfo(`play AND update position: ${this.movePosition}`);
          this.startInterval();
        }
      } else {
        log.showInfo(`Resolve issues beyond the audition scope.`);
        if (this.isMarqueeStart) {
          this.movePosition = this.playbackPosition?.elapsedTime;
          if (this.playbackPosition?.elapsedTime >= this.duration) {
            this.movePosition = this.duration;
          }
        }
        this.clearTimerAndProgressData(false);
      }
    } else {
      log.showInfo(` have timerID AND update position: ${this.movePosition}`);
      if (currentPlayState !== AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY) {
        this.movePosition = this.playbackPosition?.elapsedTime;
        if (this.playbackPosition?.elapsedTime >= this.duration) {
          this.movePosition = this.duration;
        }
        this.clearTimerAndProgressData(false);
      } else {
        let currentTime = this.isPlaying() ? new Date().getTime() : this.playbackPosition.updateTime;
        this.movePosition = (currentTime - this.playbackPosition.updateTime) * this.speed +
        this.playbackPosition.elapsedTime;
      }
    }
    log.showInfo(` getSliderData result: ${this.movePosition}`);
  }

  startInterval(): void {
    if (this.timerId != undefined) {
      clearInterval(this.timerId);
      this.timerId = undefined;
    }
    this.timerId = setInterval(() => {
      let currentTime = this.isPlaying() ? new Date().getTime() : this.playbackPosition.updateTime;
      this.checkPowerActive();
      if (!this.isMarqueeStart) {
        log.showInfo(`startIntervalstartInterval: ${this.isMarqueeStart}`);
        return;
      }
      let newPosition =
        (currentTime - this.playbackPosition.updateTime) * this.speed + this.playbackPosition.elapsedTime;
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
      log.showInfo(`startInterval out: ${this.movePosition}`);
    }, this.operateMinInterval / (this.speed ? this.speed : 1))
  }

  checkPowerActive = throttle(() => {
    const isCurScreenOn: boolean | undefined = AppStorage.get('isCurScreenOn');
    if (isCurScreenOn === false) {
      log.showInfo(`curScreenOff to clear interval: ${isCurScreenOn}`)
      this.isMarqueeStart = false;
      this.clearTimerAndProgressData(false);
      clearTimeout(this.lockShowTimer);
      this.lockShowTimer = undefined;
    }
  }, 1000);

  getProgressStart(): string {
    log.debug(` getProgressStart start: ${this.duration}、${this.movePosition}`);
    if (!this.duration || this.duration <= 0) {
      return '--:--';
    }
    if (this.trueMovePosition !== undefined && this.duration <= this.trueMovePosition) {
      this.trueMovePosition = this.duration;
    }
    let curtime = Math.floor(this.trueMovePosition / 1000);
    let durationHours = Math.floor(this.duration / 1000 / 3600);
    let hours = Math.floor(curtime / 3600);
    let minutes = Math.floor((curtime / 60) % 60);
    let seconds = (curtime % 60);
    let result = `${minutes.toString().padStart(2, '0')}:${seconds.toFixed(0).padStart(2, '0')}`;
    if (durationHours > 0) {
      result = `${hours.toString().padStart(2, '0')}:${result}`
    }
    log.showInfo(` getProgressStart result: ${result}, ${this.duration}, ${this.trueMovePosition}`);
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
      result = `${hours.toString().padStart(2, '0')}:${result}`
    }
    return result;
  }

  /**
   * 设置是否有歌词，用于锁屏大卡动效判断
   * @param value
   */
  setHasLyric(value: boolean) {
    const hasLyric: boolean = AppStorage.get('hasLyric') as boolean;
    if (hasLyric !== value) {
      AppStorage.setOrCreate('hasLyric', value);
      if (this.enableDc) {
        this.dcController?.setAppStorage('hasLyric', value);
      }
    }
  }

  loadMusicLyricList() {
    if (!this.lyric || !this.lyric.startsWith('[')) {
      log.showInfo(`lyric error: ${this.lyric}`);
      this.setHasLyric(false);
      this.lyric = '';
      this.isLyric = false;
      this.lyricCache = '';
      this.dataArray = [];
      return;
    } else if (this.lyricCache === this.lyric) {
      log.showInfo(`lyric same`);
      return;
    }
    this.lyricCache = this.lyric || '';
    this.dataArray = [];
    this.setHasLyric(true);
    let newRegex: RegExp = new RegExp('[\r\n]+');
    this.lyricList = this.lyric.split(newRegex); //得到字符串分割的数组
    this.dataArray = CommonUtils.analyzeLyric(this.lyricList);
  }

  onValidCommandsChange() {
    if (!this.validCommands?.includes('setLoopMode') && this.curRemoteOutputDev < 0) {
      this.loopMode = undefined;
    }
  }

  clearMediaImageSize() {
    this.imagesX = DEFAULT_IMAGE_SIZE;
    this.imagesY = DEFAULT_IMAGE_SIZE;
  }

  /*获取歌词*/
  getMusicLyric(): string {
    try {
      if (this.newLyric != this.getEachLyric()) {
        this.newLyric = this.getEachLyric();
      }
    } catch {
      log.error(`get Lyric fail`);
    }
    return this.newLyric;
  }

  getEachLyric() {
    // 循环比对歌词，比对不成功就跳出循环，显示最后比对成功的值，最后一句比对下标，如果比对成功一直显示最后一句
    let oldLyric: string = this.artist ? this.artist : '';
    if (!this.dataArray || this.dataArray.length === 0) {
      return oldLyric;
    }
    if (this.dataArray && this.dataArray.length > 0 && this.dataArray[this.dataArray.length - 1]?.time <=
      (this.isClickSlider ? this.movingPosition : this.movePosition)) {
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
    return oldLyric;
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

  /**
   * 设置进度条定时器更新时间
   * 绘制进度条更新时间，分30分钟以上，30分钟内，1分钟以内 300 100 50
   * @param duration
   */
  setProgreeUpDateTime(duration: number) {
    if (duration <= 1000 * 1800) {
      if (duration <= 1000 * 60) {
        this.operateMinInterval = 50;
      } else {
        this.operateMinInterval = 100;
      }
    } else {
      this.operateMinInterval = 300;
    }
  }
}