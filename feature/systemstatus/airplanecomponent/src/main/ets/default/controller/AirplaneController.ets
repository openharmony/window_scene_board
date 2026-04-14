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
import {
  SingletonHelper,
  LogDomain,
  LogHelper,
  AppStorageUtil,
  DataProperty,
} from '@ohos/basicutils';
import {
  EvtBus,
  sSettingsUtil,
  sEventManager,
  obtainStartAbilityWithWant,
  DeviceHelper,
  GlobalContext,
} from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import { RTLUtil } from '@ohos/componenthelper';
import Constants from '../common/Constants';
import connect from '@ohos.net.connection';
import commonEvtMgr from '@ohos.commonEventManager';
import { CommonEventData } from 'commonEvent/commonEventData';
import { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { AirplaneStateEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { EdmAdminManager } from '@ohos/systemuicommon/src/main/ets/manager/EdmAdminManager';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'Model.AirplaneController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const AIRPLANE_MODE_STATUS_CLOSE = '0';

const AIR_PLANE_MODE: string = 'settings.telephony.airplanemode';
const PERSIST_EDM_AIR_PLANE_CONFIG: string = 'persist.edm.airplane_mode_disable';

const SUBSCRIBE_INFO: EventSubscribeInfo = {
  events: [
  commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED,
  ]
};

interface EventSubscribeInfo {
  events: Array<string>;
}

export class AirplaneController extends ToggleBaseViewModel {
  private mSubscriber: CommonEventSubscriber | null = null;
  private isWaitingLastActionDone: boolean = false;
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';
  private openLottie?: object;
  private mirrorOpenLottie?: object;
  private emergencyRescueMode: boolean = false;

  constructor() {
    super();
    this.getViewData().icon = $r('app.media.airplane');
    this.getViewData().label = $r('app.string.airplane_mode');
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): AirplaneController {
    let controller: AirplaneController = SingletonHelper.getInstance(AirplaneController, TAG);
    return controller;
  }

  decorateStyle(style: ToggleStyle): ToggleStyle | undefined {
    style.toggleParam?.isSupportRTL(true);
    return style;
  }

  getLottieOpenName(): string {
    return Constants.LOTTIE_DATA_OPEN;
  }

  getLottieCloseName(): string {
    return Constants.LOTTIE_DATA_CLOSE;
  }

  getNewLottieOpenName(): string {
    return Constants.NEW_LOTTIE_DATA_OPEN;
  }

  getNewLottieCloseName(): string {
    return Constants.NEW_LOTTIE_DATA_CLOSE;
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getMirrorLottieOpenName(): string {
    return Constants.LOTTIE_MIRROR_DATA_OPEN;
  }

  isLoadLottie(): boolean {
    return true;
  }

  initLottieData(): void {
    log.info(`initLottieData this.isAlreadyLoadLottie=${this.isAlreadyLoadLottie}`);
    if (this.isAlreadyLoadLottie) {
      return;
    }
    this.isAlreadyLoadLottie = true;
    this.loadLottieData(this.getNewLottieOpenName(), data => this.openLottie = data);
    this.loadLottieData(this.getMirrorLottieOpenName(), data => this.mirrorOpenLottie = data);
  }

  /**
   * 移除lottie缓存
   */
  removeAllLottieData(): void {
    log.showInfo('removeAllLottieData');
    this.openLottie = undefined;
    this.mirrorOpenLottie = undefined;
    this.isAlreadyLoadLottie = false;
  }

  matchLottieData(darkMode: boolean): object {
    return RTLUtil.isRTL() ? this.mirrorOpenLottie! : this.openLottie!;
  }

  initAirplaneState(): void {
    let state = sSettingsUtil.getValue(AIR_PLANE_MODE, AIRPLANE_MODE_STATUS_CLOSE);
    log.showInfo(`initAirplaneState state = ${state}`)
    if (state === AIRPLANE_MODE_STATUS_CLOSE) {
      this.getViewData().isOn = false;
      EvtBus.post(AirplaneStateEvent, AirplaneStateEvent.getInstance(false));
    } else {
      this.getViewData().isOn = true;
      EvtBus.post(AirplaneStateEvent, AirplaneStateEvent.getInstance(true));
    }
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    AppStorageUtil.setOrCreate('AirplaneModel_AirplaneStatus', this.getViewData(), new DataProperty(true, false));
    this.viewData = AppStorage.get<ToggleViewData>('AirplaneModel_AirplaneStatus') as ToggleViewData;
    this.initAirplaneState();
    this.updateDisableState();
    try {
      commonEvtMgr.createSubscriber(SUBSCRIBE_INFO).then((subscriber) => {
        log.showInfo('init createSubscriber end');
        this.mSubscriber = subscriber;
        commonEvtMgr.subscribe(subscriber, (err, data) => {
          if (err && err.code !== 0) {
            log.showError(`Can't handle common event, err: ${err.message}`);
            return;
          }
          log.showInfo(`receive event data:${data?.event}`);
          this.handleCommonEvent(data);
        });
      });
      settings.registerKeyObserver(GlobalContext.getContext(), Constants.EMERGENCY_RESCUE_MODE_KEY,
        settings.domainName.DEVICE_SHARED, () => {
        this.emergencyRescueMode = sSettingsUtil.getValue(Constants.EMERGENCY_RESCUE_MODE_KEY,
          Constants.EMERGENCY_RESCUE_MODE_DEFAULT_VALUE) === Constants.EMERGENCY_RESCUE_MODE_OPEN_VALUE;
        log.showInfo(`emergency_rescue_mode update: ${this.emergencyRescueMode}`);
        this.updateDisableState();
      });
      this.emergencyRescueMode = sSettingsUtil.getValue(Constants.EMERGENCY_RESCUE_MODE_KEY,
        Constants.EMERGENCY_RESCUE_MODE_DEFAULT_VALUE) === Constants.EMERGENCY_RESCUE_MODE_OPEN_VALUE;
    } catch (error) {
      log.showError('subscribe airplane error');
    }
  }

  handleCommonEvent(data: CommonEventData): void {
    if (data && data.event === commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED) {
      log.showInfo('mAirplaneData.status change ' + data.data + 'code : ' + data.code);
      let status: boolean = true;
      if (String(data.code) === AIRPLANE_MODE_STATUS_CLOSE) {
        status = false;
      }
      //在设置界面切换开关
      if (!this.isWaitingLastActionDone && this.getViewData().isOn != status) {
        this.getViewData().isOn = status;
        EvtBus.post(AirplaneStateEvent, AirplaneStateEvent.getInstance(status));
      }
      //回调状态和当前图标状态不符合
      if (this.isWaitingLastActionDone && this.getViewData().isOn != status) {
        this.switchAirplaneStatus(this.getViewData().isOn);
        log.showInfo('handleCommonEvent mAirplaneData status !== current');
        return;
      }
      this.isWaitingLastActionDone = false;
      return;
    }
  }

  onStop(): void {
    super.onStop();
    try {
      if (this.mSubscriber) {
        commonEvtMgr.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      }
    } catch (error) {
      log.showError('unsubscribe airplane error');
    }
  }

  /**
   * 是否需要监听卫星通信状态
   */
  needListenSatelliteMode(): boolean {
    return true;
  }

  addStateChangedListener(): void {
  }

  removeStateChangedListener(): void {
  }

  isAvailable(): boolean {
    return true;
  }

  switchAirplaneStatus(isOn: boolean): void {
    log.showInfo('switchAirplaneStatus');
    try {
      if (!isOn) {
        connect.disableAirplaneMode((error) => {
          log.showInfo(`disableAirplaneMode, result: ${error}`);
        });
      } else {
        connect.enableAirplaneMode((error) => {
          log.showInfo(`enableAirplaneMode, result: ${error}`);
        });
      }
    } catch (error) {
      this.isWaitingLastActionDone = false;
      log.showError('handleClick error');
    }
    return;
  }

  handleOneClick(): void {
    if (this.getViewData().isUnavailable) {
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_AIR_PLANE_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      log.showWarn('airplane disabled');
      return;
    }
    log.showInfo(`handleClick, status: ${this.getViewData().isOn}, isWaiting: ${this.isWaitingLastActionDone}`);
    this.getViewData().isOn = !this.getViewData().isOn;
    if (!this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = true;
      this.switchAirplaneStatus(this.getViewData().isOn);
      EvtBus.post(AirplaneStateEvent, AirplaneStateEvent.getInstance(this.getViewData().isOn));
    }
  }

  private goAirplaneSetting(): void {
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'mobile_network_entry',
      moduleName: this.mdName
    }
    ));
  }

  /**
   * 更新快捷开关的置灰状态
   */
  updateDisableState(): void {
    if (this.isSatelliteMode || this.emergencyRescueMode ||
      !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_AIR_PLANE_CONFIG)) {
      this.getViewData().isUnavailable = true;
    } else {
      this.getViewData().isUnavailable = false;
    }
    log.showInfo(`updateDisableState isUnavailable: ${this.getViewData().isUnavailable}`);
    this.initAirplaneState();
  }
}

let sAirplaneController = SingletonHelper.getInstance(AirplaneController, TAG);

export default sAirplaneController as AirplaneController;