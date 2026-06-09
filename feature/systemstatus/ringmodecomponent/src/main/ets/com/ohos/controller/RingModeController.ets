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

import audio from '@ohos.multimedia.audio';
import type context from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';
import notificationManager from '@ohos.notificationManager';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import {
  DeviceHelper,
  EventConstants,
  EvtBus,
  GlobalContext,
  HiDfxEventUtil,
  HiSysDataRingMode,
  HiSysEventUtil,
  obtainStartAbilityWithWant,
  PluginClickInfo,
  PluginRequestEvent,
  PluginSlot,
  sEventManager,
} from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ExtAppConstants, FASlotName } from '@ohos/commonconstants';
import { CommonConstants } from '@ohos/launchercommon';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { PluginWidthChangeEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import StyleConfiguration, { StatusRingModeComponentStyle } from '../common/StyleConfiguration';
import {
  AppStorageUtil,
  DataProperty,
  LogDomain,
  LogHelper,
  PixelMapUtil,
  SingletonHelper,
  AudioManagerHelper,
} from '@ohos/basicutils';
import { SysTypeCode } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { LiveType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { VibratorManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/VibratorManagerAdapter';
import Constants, { RingModeData } from '../common/Constants';

// instrument ignore file
const TAG: string = 'Model.RingModeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const INIT_MANAGER_MAX_TIME: number = 3;
const SUB_WINDOW_HEIGHT: number = 321;

export class RingModeController extends ToggleBaseViewModel {
  private mRingModeData: RingModeData = new RingModeData();
  private audioVolumeGroupManager: audio.AudioVolumeGroupManager | undefined;
  private isSupportVibrate: boolean = true;
  private modeData: number[] =
    [audio.AudioRingMode.RINGER_MODE_NORMAL, audio.AudioRingMode.RINGER_MODE_SILENT,
      audio.AudioRingMode.RINGER_MODE_VIBRATE];
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';

  private initNumber: number = 0;

  private style: StatusRingModeComponentStyle = StyleConfiguration.getStatusRingModeComponentStyle();

  private pluginWidthChangeEvent = PluginWidthChangeEvent.create(this.getSbPluginSlot(),
    ResUtils.getNumberFromLength(this.style.statusBarRingModeWidth));

  public startServiceFunc: (() => void) | undefined = () => {
    if (this.customCommonData.scene === ToggleScene.PHONE) {
      this.handleOnControlCenterWithScreenLockForUIE((): void => {
        sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.RING_MODE, {
          clickType: 'window',
          bundleName: 'com.ohos.settings',
          abilityName: 'SoundExtensionAbility',
          uiExtensionType: 'sys/commonUI',
          windowHeight: SUB_WINDOW_HEIGHT
        } as PluginClickInfo);
      }, true);
    } else {
      this.handleGoSettingWithScreenLock(():void => this.goRingModeSetting());
    }
  }

  constructor() {
    super();
    this.getViewData().icon = $r('app.media.ic_controlcenter_ring_on_filled');
    this.getViewData().label = $r('app.string.control_center_complex_toggle_ring_mode_title_on');
    this.onStart();
  }

  setCustomCommonData(scene?: ToggleScene | undefined): void {
    // 设置场景
    this.customCommonData.scene = scene;
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): RingModeController {
    return SingletonHelper.getInstance(RingModeController, TAG);
  }

  isLoadLottie(): boolean {
    return true;
  }

  public initLottieData(): void {
    log.showInfo(`initLottieData this.isAlreadyLoadLottie=${this.isAlreadyLoadLottie}`);
    if (this.isAlreadyLoadLottie) {
      return;
    }
    this.isAlreadyLoadLottie = true;
    this.loadLottieData(Constants.LOTTIE_DATA_SILENT_TO_RING_DARK, (value) => {
      this.records.ring = value;
    });
    this.loadLottieData(Constants.LOTTIE_DATA_RING_TO_VIBRATE_DARK, (value) => {
      this.records.vibrate = value;
    });
    this.loadLottieData(Constants.LOTTIE_DATA_VIBRATE_TO_SILENT_DARK, (value) => {
      this.records.silent = value;
    });
    this.loadLottieData(Constants.LOTTIE_DATA_RING_TO_SILENT_DARK, (value) => {
      this.records.ringToSilent = value;
    });
  }

  matchRingModeLottieData(newMode: audio.AudioRingMode): object | null {
    if (newMode === audio.AudioRingMode.RINGER_MODE_NORMAL) {
      return this.records.ring;
    } else if (newMode === audio.AudioRingMode.RINGER_MODE_VIBRATE) {
      return this.records.vibrate;
    } else {
      // 支持振动，振动到静音，不支持振动响铃到静音
      return this.isSupportVibrate ? this.records.silent : this.records.ringToSilent;
    }
  }

  matchLottieData(isDarkMode: boolean): object | null {
    let newMode = this.mRingModeData.mode;
    if (newMode === audio.AudioRingMode.RINGER_MODE_NORMAL) {
      return this.records.ring;
    } else if (newMode === audio.AudioRingMode.RINGER_MODE_VIBRATE) {
      return this.records.vibrate;
    } else {
      // 支持振动，振动到静音，不支持振动响铃到静音
      return this.isSupportVibrate ? this.records.silent : this.records.ringToSilent;
    }
  }

  async onStart(): Promise<void> {
    super.onStart();
    log.showInfo('onStart');
    AppStorageUtil.setOrCreate('RingModeModel_RingModeStatus', this.mRingModeData, new DataProperty(true, false));
    this.mRingModeData = AppStorage.get<RingModeData>('RingModeModel_RingModeStatus') as RingModeData;
    this.getViewData().isOn = true;
    sEventManager.subscribe(EventConstants.RING_MODE_EVENT, (ringModeEvent: audio.AudioRingMode) => {
      this.onRingModeEventReceived(ringModeEvent);
    });
    try {
      this.isSupportVibrate = systemParameterEnhance.getSync('const.vibrator.support_vibrator', 'true') === 'true';
      log.showInfo(`isSupportVibrate ${this.isSupportVibrate}`);
    } catch (error) {
      log.showError(`initVolumeGroupManager failed: ${error?.message}.`);
    }
    this.initVolumeGroupManager();
  }

  async initVolumeGroupManager(): Promise<void> {
    this.audioVolumeGroupManager = await AudioManagerHelper.getAudioManager()
      .getVolumeManager().getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
    if (this.audioVolumeGroupManager) {
      log.showInfo('audioVolumeGroupManager init success');
      try {
        this.handleUpdateState();
        this.audioVolumeGroupManager?.on('ringerModeChange', (data) => {
          log.showInfo(`Updated ringermode: ${data}`);
          this.handleUpdateState();
        });
      } catch (error) {
        log.showError(`initVolumeGroupManager failed: ${error?.message}.`);
      }
      return;
    }
    this.initNumber++;
    if (this.initNumber > INIT_MANAGER_MAX_TIME) {
      return;
    }
    log.showInfo(`initVolumeGroupManager time:${this.initNumber}`);
    this.initVolumeGroupManager();
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
  }

  /**
   * 响铃模式图标标示
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_RING;
  }

  addStateChangedListener(): void {
  }

  removeStateChangedListener(): void {
  }

  onRingModeEventReceived(ringModeEvent: audio.AudioRingMode): void {
    log.showDebug(`listen ring mode is ${ringModeEvent}`);
    if (ringModeEvent === audio.AudioRingMode.RINGER_MODE_SILENT &&
      this.mRingModeData.mode === audio.AudioRingMode.RINGER_MODE_NORMAL) {
      HiDfxEventUtil.reportQuickToggleRingMode(HiSysDataRingMode.SILENT);
      this.setAudioVolumeRingerMode(audio.AudioRingMode.RINGER_MODE_SILENT);
    }
    if (ringModeEvent === audio.AudioRingMode.RINGER_MODE_NORMAL &&
      this.mRingModeData.mode !== audio.AudioRingMode.RINGER_MODE_NORMAL) {
      HiDfxEventUtil.reportQuickToggleRingMode(HiSysDataRingMode.NORMAL);
      this.setAudioVolumeRingerMode(audio.AudioRingMode.RINGER_MODE_NORMAL);
    }
    if (ringModeEvent === audio.AudioRingMode.RINGER_MODE_VIBRATE &&
      this.mRingModeData.mode === audio.AudioRingMode.RINGER_MODE_NORMAL) {
      HiDfxEventUtil.reportQuickToggleRingMode(HiSysDataRingMode.VIBRATION);
      this.setAudioVolumeRingerMode(audio.AudioRingMode.RINGER_MODE_VIBRATE);
    }
  }

  updatePluginWidthChangeEvent(): void {
    let width = 0;
    if (this.mRingModeData.mode === audio.AudioRingMode.RINGER_MODE_VIBRATE) {
      width = ResUtils.getNumberFromLength(this.style.statusBarRingModeWidth);
    } else if (this.mRingModeData.mode === audio.AudioRingMode.RINGER_MODE_SILENT) {
      width = ResUtils.getNumberFromLength(this.style.statusBarRingOffWidth);
    }
    this.pluginWidthChangeEvent.setWidth(width);
    if (this.pluginWidthChangeEvent.getChangeDelta() > 0) {
      EvtBus.post(PluginWidthChangeEvent, this.pluginWidthChangeEvent);
    }
  }

  handleUpdateState(): void {
    this.getViewData().isOn = true;
    if (this.isAudioVolumeAvailable() && this.audioVolumeGroupManager) {
      this.audioVolumeGroupManager.getRingerMode().then((mode) => {
        log.showWarn(`handleUpdateState, mode: ${mode}`);
        this.setRingMode(mode);
        this.updatePluginWidthChangeEvent();
        // 更新可见性
        let isVisible = mode !== audio.AudioRingMode.RINGER_MODE_NORMAL;
        this.handleStatusBarState(isVisible);
      });
    }
  }

  getState(): number {
    return this.mRingModeData.mode;
  }

  private setRingMode(mode: audio.AudioRingMode): void {
    if (this.isSupportVibrate) {
      this.mRingModeData.mode = mode;
    } else {
      this.mRingModeData.mode =
        mode === audio.AudioRingMode.RINGER_MODE_VIBRATE ? audio.AudioRingMode.RINGER_MODE_SILENT : mode;
    }
    this.updateIconAndLabel();
  }

  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    if (oldState !== newState) {
      log.showInfo(`status bar status change, newState: ${newState}, oldState: ${oldState}`);
      // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }

  getData(): RingModeData {
    return this.mRingModeData;
  }

  isAvailable(): boolean {
    return true;
  }

  isAudioVolumeAvailable(): boolean {
    if (!this.audioVolumeGroupManager) {
      log.showError('audioVolumeGroupManager is invalid');
      return false;
    }
    return true;
  }

  setAudioVolumeRingerMode(mode: audio.AudioRingMode): void {
    if (!this.isAudioVolumeAvailable()) {
      return;
    }
    if (this.audioVolumeGroupManager) {
      this.audioVolumeGroupManager.setRingerMode(mode);
    }
    if (mode === audio.AudioRingMode.RINGER_MODE_VIBRATE) {
      VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_NOTICE,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    } else if (mode === audio.AudioRingMode.RINGER_MODE_NORMAL) {
      VibratorManagerAdapter.startVibration(Constants.VIBRATION_EFFECT_RING_NOTICE,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    }
  }

  changeMode(mode: audio.AudioRingMode): void {
    if (!this.isSupportVibrate && mode === audio.AudioRingMode.RINGER_MODE_NORMAL) {
      this.mRingModeData.mode = audio.AudioRingMode.RINGER_MODE_SILENT;
      this.updateIconAndLabel();
      HiDfxEventUtil.reportQuickToggleRingMode(audio.AudioRingMode.RINGER_MODE_NORMAL);
      this.setAudioVolumeRingerMode(audio.AudioRingMode.RINGER_MODE_SILENT);
      return;
    }
    this.mRingModeData.mode = this.modeData[mode];
    this.updateIconAndLabel();
    HiDfxEventUtil.reportQuickToggleRingMode(mode);
    this.setAudioVolumeRingerMode(this.modeData[mode]);
  }

  updateIconAndLabel(): void {
    if (this.mRingModeData.mode == audio.AudioRingMode.RINGER_MODE_SILENT) {
      this.getViewData().icon = $r('app.media.ic_controlcenter_ring_off_filled');
      this.getViewData().label = $r('app.string.control_center_complex_toggle_ring_mode_title_off');
    } else if (this.mRingModeData.mode == audio.AudioRingMode.RINGER_MODE_VIBRATE) {
      this.getViewData().icon = $r('app.media.ic_controlcenter_vibration_filled');
      this.getViewData().label = $r('app.string.control_center_complex_toggle_ring_mode_title_vibration');
    } else if (this.mRingModeData.mode == audio.AudioRingMode.RINGER_MODE_NORMAL) {
      this.getViewData().icon = $r('app.media.ic_controlcenter_ring_on_filled');
      this.getViewData().label = $r('app.string.control_center_complex_toggle_ring_mode_title_on');
    }
  }

  handleOneClick(): void {
    log.showInfo(`handleClick, status: ${this.getViewData().isOn} mode:${this.mRingModeData?.mode}`);
    log.showInfo(`isSupportVibrate: ${this.isSupportVibrate}`);
    this.changeMode(this.mRingModeData.mode);
    HiSysEventUtil.reportCCQuickToggleClickSound({
      LOCKSTATUS: AppStorage.get('lockStatus'),
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NEWSTATE: this.mRingModeData.mode,
      SCREENTYPE: 0
    });
  }

  private goRingModeSetting(): void {
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'volume_settings',
      moduleName: this.mdName
    }));
  }

  private async getRawFilePixelMap(rawImagePath: string): Promise<image.PixelMap | undefined> {
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      let context: context.Context = GlobalContext.getContext() as context.Context;
      let array = context.resourceManager.getMediaByNameSync(rawImagePath);
      let res: image.ImageSource = image.createImageSource(array.buffer);
      if (!res) {
        log.showError(`setIcon failed. no resourceManager`);
      } else {
        pixelMap = await res.createPixelMap({
          desiredSize: {
            width: vp2px(40),
            height: vp2px(40)
          },
        });
        PixelMapUtil.addName(pixelMap, `ringmode_setIcon_${rawImagePath}}`);
        res.release();
        log.showInfo('set ringmode Icon success');
      }
    } catch (err) {
      log.showError(`set ringmode Icon failed: ${err}`);
    };
    return pixelMap;
  }

  /**
   * 发布通知
   */
  private async publishNtf(mode: audio.AudioRingMode): Promise<void> {
    log.showInfo(`publishNtf start: mode: ${mode}`);
    try {
      const context: context.Context = GlobalContext.getContext() as context.Context;
      let capsuleContent = '';
      let iconPath = '';
      if (mode === audio.AudioRingMode.RINGER_MODE_NORMAL) {
        iconPath = Constants.RINGER_MODE_NORMAL_ICON;
        capsuleContent = context.resourceManager.getStringByNameSync(Constants.RINGER_MODE_NORMAL);
      } else if (mode === audio.AudioRingMode.RINGER_MODE_SILENT) {
        iconPath = Constants.RINGER_MODE_SILENT_ICON;
        capsuleContent = context.resourceManager.getStringByNameSync(Constants.RINGER_MODE_SILENT);
      } else if (mode === audio.AudioRingMode.RINGER_MODE_VIBRATE) {
        iconPath = Constants.RINGER_MODE_VIBRATE_ICON;
        capsuleContent = context.resourceManager.getStringByNameSync(Constants.RINGER_MODE_VIBRATE);
      }
      if (!iconPath.length) {
        log.showInfo('publish Ntf return: no mode');
        return;
      }
      const capsuleIcon = await this.getRawFilePixelMap(iconPath);
      if (!capsuleIcon) {
        log.showInfo('publish Ntf return: no icon');
        return;
      }
      const ringModeNtfRequest: notificationManager.NotificationRequest = {
        notificationSlotType: notificationManager.SlotType.LIVE_VIEW,
        id: Math.ceil(Math.random() * Constants.RING_MODE_NTF_ID),
        isRemoveAllowed: false,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
          systemLiveView: {
            typeCode: SysTypeCode.OTHER,
            liveViewType: LiveType.INSTANT as number,
            title: capsuleContent,
            text: capsuleContent,
            capsule: {
              title: capsuleContent,
              icon: capsuleIcon,
            }
          }
        },
        extraInfo: {
          isMute: true,
        }
      };
      await notificationManager.publish(ringModeNtfRequest);
      capsuleIcon.release();
      log.showInfo('publishRingMode instant live success');
    } catch (err) {
      log.showInfo(`publish fail: ${JSON.stringify(err)}`);
    }
  };
}