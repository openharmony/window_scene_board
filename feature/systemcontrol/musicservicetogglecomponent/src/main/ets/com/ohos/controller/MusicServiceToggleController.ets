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

import { rpc } from '@kit.IPCKit';
import { BusinessError, settings } from '@kit.BasicServicesKit';
import { Caller } from '@ohos.app.ability.UIAbility';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  EventManager,
  EvtBus,
  GlobalContext,
  PluginClickInfo,
  sSettingsUtil,
} from '@ohos/frameworkwrapper';
import {
  FASlotName,
  SettingsKeyConstants,
} from '@ohos/commonconstants'
import MusicServiceToggleConstants from '../common/MusicServiceToggleData';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import lazy { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { MusicServiceAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/MusicServiceAdapter';

const TAG = 'Ctrl.MusicServiceToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SUB_WINDOW_HEIGHT = 398;

/**
 * 听歌识曲开关业务Controller
 */
export class MusicServiceController extends ToggleBaseViewModel {
  private caller: Caller | undefined = undefined;

  public openDetailPageFunc: (() => void) | undefined = () => {
    if (this.getViewData().isUnavailable) {
      log.showWarn('Status isUnavailable');
      return;
    }
    this.handleOnControlCenterWithScreenLockForUIE((): void => {
      if (ControlCenterPluginMgr.isPcMode) {
        windowMgr.showWindowWithAnim(FASlotName.MUSIC_SERVICE)
        return;
      }
      sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.MUSIC_SERVICE, {
        clickType: 'window',
        bundleName: 'com.ohos.musicservice',
        abilityName: 'HumSearchMoreExtAbility',
        uiExtensionType: 'sys/commonUI',
        windowHeight: SUB_WINDOW_HEIGHT
      } as PluginClickInfo);
    }, true);
  }

  constructor() {
    super();
    this.getViewData().icon = $r('sys.symbol.identify_song');
    this.getViewData().label = $r('app.string.control_center_complex_toggle_musicservice_title');
  }

  public isLoadLottie(): boolean {
    return false;
  }

  public isDarkReverse(): boolean {
    return true;
  }

  public isAvailable(): boolean {
    return !DeviceHelper.isPC() || ControlCenterPluginMgr.isPcMode;
  }

  decorateStyle(style: ToggleStyle): ToggleStyle | undefined {
    style.toggleParam?.isSymbolIcon(true)
      .symbolEffect(new BounceSymbolEffect())
    return style;
  }

  public onStart(): void {
    super.onStart();
    log.showInfo('onStart')
    if (!this.isAvailable()) {
      log.showError('current device is not support music service');
      return;
    }
    this.initMusicServiceState();
  }

  private initMusicServiceState() {
    try {
      // 重置数据库状态
      if (sSettingsUtil.getSecureValue(SettingsKeyConstants.MUSIC_SERVICE_TOGGLE_STATE_KEY,
        MusicServiceToggleConstants.MUSIC_SERVICE_TOGGLE_STATE_DEFAULT_VALUE) ===
      MusicServiceToggleConstants.MUSIC_SERVICE_TOGGLE_STATE_DEFAULT_VALUE) {
        sSettingsUtil.setSecureValue(SettingsKeyConstants.MUSIC_SERVICE_TOGGLE_STATE_KEY,
          MusicServiceToggleConstants.MUSIC_SERVICE_TOGGLE_STATE_DEFAULT_CLOSE_VALUE);
      }
      settings.registerKeyObserver(GlobalContext.getContext(),
        SettingsKeyConstants.MUSIC_SERVICE_TOGGLE_STATE_KEY, settings.domainName.USER_SECURITY, () => {
          this.refreshCurrentState();
      });
    } catch (e) {
      log.showError(`initMusicServiceState error:${e}`);
    }
  }

  public onStop(): void {
    log.showInfo('onStop');
    if (!this.isAvailable()) {
      log.showError('current device is not support music service');
      return;
    }
    super.onStop();
    try {
      settings.unregisterKeyObserver(GlobalContext.getContext(),
        SettingsKeyConstants.MUSIC_SERVICE_TOGGLE_STATE_KEY, settings.domainName.USER_SECURITY);
    } catch (e) {
      log.showError(`settings unregisterKeyObserver error:${e}`);
    }
  }

  public handleOneClick(): void {
    log.showInfo('handleClick')
    if (this.getViewData().isUnavailable) {
      log.showWarn('ScreenLockStatus is locking');
      return;
    }
      let privacyAgreement = sSettingsUtil.getSecureValue(SettingsKeyConstants.MUSIC_SERVICE_TOGGLE_PRIVACY_AGREEMENT,
        MusicServiceToggleConstants.MUSIC_SERVICE_PRIVACY_MANAGEMENT_REJECT_VALUE);
    if (!this.getViewData().isOn) {
      DropDownPanelManager.setPanelDismissCallback(() => {
        log.showInfo('start music service Event - start');
        if (MusicServiceToggleConstants.MUSIC_SERVICE_PRIVACY_MANAGEMENT_AGREE_VALUE === privacyAgreement) {
          log.showInfo('start music service Ability directly');
          MusicServiceAdapter.handleAbilityState({
            isOpenAction: true,
            serviceRelease: this.resetState.bind(this),
            fail: this.refreshCurrentState.bind(this)
          }, `${TAG}_handleAbilityState`);
        } else {
          log.showInfo('Start musicservice Event - close');
          this.handleGoSettingWithScreenLock((): void => {
            log.showInfo('start music service Ability after locked');
            MusicServiceAdapter.handleAbilityState({
              isOpenAction: true,
              serviceRelease: this.resetState.bind(this),
              fail: this.refreshCurrentState.bind(this)
            }, `${TAG}_handleAbilityState`);
          });
        }
      });
      DropDownPanelManager.animToDismissEvent();
    } else {
      log.showInfo('start music service Event - close');
      if (MusicServiceToggleConstants.MUSIC_SERVICE_PRIVACY_MANAGEMENT_AGREE_VALUE === privacyAgreement) {
        this.getViewData().isOn = !this.getViewData().isOn;
        log.showInfo('start music service caller directly');
        MusicServiceAdapter.handleAbilityState({
          isOpenAction: false,
          serviceRelease: this.resetState.bind(this),
          fail: this.refreshCurrentState.bind(this)
        }, `${TAG}_handleAbilityState`);
      } else {
        this.handleGoSettingWithScreenLock((): void => {
          this.getViewData().isOn = !this.getViewData().isOn;
          log.showInfo('start music service caller after unlocked');
          MusicServiceAdapter.handleAbilityState({
            isOpenAction: false,
            serviceRelease: this.resetState.bind(this),
            fail: this.refreshCurrentState.bind(this)
          }, `${TAG}_handleAbilityState`);
        });
      }
      // 每次关闭按钮通过触发symbolTriggerValue的数值变化来触发symbol动效，初始值为-1
      this.getViewData().symbolTriggerValue = (Math.abs(this.getViewData().symbolTriggerValue) % 10) === 1 ? 2 : 1;
    }
    return;
  }

  private handleAbilityState(isOpenAction: boolean): void {
    if (this.caller === undefined) {
      this.startMusicServiceAbility(isOpenAction);
      return;
    }
    this.sendCallerMessage(isOpenAction);
  }

  private sendCallerMessage(isOpenAction: boolean) {
    if (this.caller !== undefined) {
      this.caller.call(isOpenAction ? 'startHumSearch' : 'stopHumSearch', new MySequence('data'))
        .then(() => {
          log.showInfo('handleAbilityState Caller call() called');
        }).catch((callErr: BusinessError) => {
          log.showError(`handleAbilityState Caller.call catch error, error: ${callErr}`);
          this.refreshCurrentState();
        });
    }
  }

  private startMusicServiceAbility(isOpenAction: boolean): void {
    let want: Want = {
      bundleName: 'com.ohos.musicservice',
      abilityName: 'MainAbility',
      parameters: {serviceType : 'humsearch', action: 'start'}
    }
    GlobalContext.getContext().startAbilityByCall(want).then((obj) => {
      this.caller = obj;
      try {
        // 第一次启动时为了保证底层服务感知到开关状态，需要再次调用Caller接口
        this.sendCallerMessage(isOpenAction);
        this.caller.onRelease((str) => {
          log.showInfo(`handleAbilityState Caller OnRelease CallBack is called ${str}`);
          this.caller = undefined;
          this.getViewData().isOn = false;
        });
      } catch (error) {
        log.showError(`caller.onRelease error, error.code: ${error.code}, error.message: ${error.message}`);
        this.refreshCurrentState();
      }
    }).catch((err: BusinessError) => {
      log.showError(`startMusicServiceAbility GetCaller error, error: ${err}`);
      this.refreshCurrentState();
    });
  }

  private refreshCurrentState() {
    try {
      let state = sSettingsUtil.getSecureValue(SettingsKeyConstants.MUSIC_SERVICE_TOGGLE_STATE_KEY,
        MusicServiceToggleConstants.MUSIC_SERVICE_TOGGLE_STATE_DEFAULT_CLOSE_VALUE);
      this.getViewData().isOn = state !==
      MusicServiceToggleConstants.MUSIC_SERVICE_TOGGLE_STATE_DEFAULT_CLOSE_VALUE;
      log.showInfo(`getSecureValue state=${state} this.getViewData().isOn=${this.getViewData().isOn}`)
    } catch (e) {
      log.showError(`refreshCurrentState error:${e}`);
    }
  }

  private resetState() {
    this.getViewData().isOn = false;
  }
}

class MySequence implements rpc.Parcelable {
  private msg?: string;

  constructor(message?: string) {
    this.msg = message;
  }

  public marshalling(dataOut: rpc.MessageSequence): boolean {
    if (!CheckEmptyUtils.isEmpty(this.msg)) {
      dataOut.writeString(this.msg)
    }
    return true;
  }

  public unmarshalling(dataIn: rpc.MessageSequence): boolean {
    if (!CheckEmptyUtils.isEmpty(dataIn)) {
      this.msg = dataIn.readString();
    }
    return true;
  }

}