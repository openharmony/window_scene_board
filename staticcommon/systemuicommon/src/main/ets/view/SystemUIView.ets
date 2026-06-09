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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceModeEnum } from '@ohos/commonconstants';
import {
  ColorModeChangeEvent,
  ScreenStatusChangeEvent,
  AccessibilityModeChangeEvent,
  GlobalContext,
  EvtBus,
  DeviceHelper} from '@ohos/frameworkwrapper';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { BannerPanelTypeState } from '../banner/common/info/BannerState';
import { bannerMgr } from '../banner/phone/BannerManager';
import { EmergencyThermalAppType } from '../constants/DeviceModeType';
import { AppLifeCycleManager } from '../manager/AppLifeCycleManager';
import { AccessibilityVm } from '../vm/AccessibilityVm';
import { BannerVm } from '../vm/BannerVm';
import { AppProtectedStatusVm } from '../vm/AppProtectedStatusVm';
import { DeviceInfoVm } from '../vm/DeviceInfoVm';
import { DropdownVm } from '../vm/DropdownVm';
import { ScreenStatusVm } from '../vm/ScreenStatusVm';
import { EnvVm } from '../vm/EnvVm';
import { ResourceVm } from '../vm/ResourceVm';
import { SystemUIColorVm } from '../vm/SystemUIColorVm';
import { SystemEffectVm } from '../vm/SystemEffectVm';
import { EnterpriseConfig } from '../model/EnterpriseConfig';
import { SCBSessionTerminateAdapter } from '../adapter/SCBSessionTerminateAdapter';
import { SCBSceneMissionManager, ScenePanelState } from '@ohos/windowscene';
import { ScreenLockAdapter } from '../adapter/ScreenLockAdapter';
import lazy { AodSnapshotAdapter } from '../adapter/AodSnapshotAdapter';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'SystemUIView');

@Component
export struct SystemUIView {
  /**
   *  应急模式状态
   */
  @StorageProp('deviceModeState') @Watch('onDeviceModeChange') deviceMode: DeviceModeEnum = DeviceModeEnum.BASE_MODE;
  /**
   *  应急模式应用列表
   */
  @StorageProp('emergencyInfoList') @Watch('onEmergencyListChange') emergencyList: EmergencyThermalAppType[] = [];
  /**
   *  热安全模式应用列表
   */
  @StorageProp('thermalInfoList') @Watch('onEmergencyListChange') thermalList: EmergencyThermalAppType[] = [];
  /**
   * 无障碍模式
   */
  @StorageProp('isAccessibilityMode') @Watch('onAccessibilityChange') isAccessibilityMode: boolean = false;

  /**
   * 锁屏状态
   */
  @StorageProp('lockStatus') @Watch('onScreenStatusChange') lockStatus: number =
    AppStorage.get<number>('lockStatus') ?? 0;

  /**
   * 小折叠状态栏
   */
  @StorageProp('foldStatusForOuterScreen') @Watch('onScreenStatusChange') foldStatusForOuterScreen: number =
    AppStorage.get<number>('foldStatusForOuterScreen') ?? DeviceState.DEFAULT_STATE;

  /**
   * 屏幕自动旋转状态
   */
  @StorageProp('AutoRotateModel_AutoRotateStatus') @Watch('onScreenStatusChange') autoRotateStatus: boolean = false;

  /**
   * 颜色变化
   */
  @StorageProp('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;

  @State @Watch('onBannerStateChange') bannerState: BannerPanelTypeState = bannerMgr.getBannerState().bannerPanelType;

  @StorageLink('enableControllerCenter') @Watch('onEnableControllerCenter') enableControllerCenter: boolean = true;

  @StorageLink('scenePanelState') @Watch('onScenePanelStateChange') scenePanelState: ScenePanelState =
    ScenePanelState.HOME;

  @StorageLink('pcmodeScenePanelState') @Watch('onPcModeScenePanelStateChange') pcModeScenePanelState: ScenePanelState =
    ScenePanelState.HOME;

  @StorageLink('onDeskTop') @Watch('onDeskTopChange') onDeskTop: boolean  = false;

  @StorageLink('singleDisplayPocketFoldDisplayMode')
  @Watch('onPocketStatusChange') singleDisplayPocketFoldDisplayMode: number = 0;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear begin');
    try {
      SystemEffectVm.instance.init();
      DeviceInfoVm.instance.init();
      EnvVm.instance.init();
      DropdownVm.instance.init();
      AppProtectedStatusVm.instance.init();
      SCBSceneMissionManager.getInstance().registerProductMissionProcessor(SCBSessionTerminateAdapter.instance);
      ResourceVm.instance.init();
      SystemUIColorVm.instance.init();
      AppLifeCycleManager.instance.init();
      BannerVm.instance.init();
      this.onAccessibilityChange();
      this.onDeviceModeChange();
      this.onEmergencyListChange();
      this.onScreenStatusChange();
      this.onColorModeChange();
      this.onPocketStatusChange();
      this.onUseNewScreenLockChange();
      EnterpriseConfig.loadConfig(GlobalContext.getContext());
      log.showInfo('aboutToAppear end');
    } catch (e) {
      log.showError('aboutToAppear error:' + e);
    }
  }

  build() { }

  onAccessibilityChange(): void {
    AccessibilityVm.instance.isEnabled = this.isAccessibilityMode;
    let accessibilityModeChange = AccessibilityModeChangeEvent.create(this.isAccessibilityMode);
    EvtBus.post(AccessibilityModeChangeEvent, accessibilityModeChange);
  }

  onEmergencyListChange(): void {
    if (this.deviceMode === DeviceModeEnum.EMERGENCY_MODE) {
      DeviceInfoVm.instance.setEmergencyAppList(this.emergencyList);
    } else if (this.deviceMode === DeviceModeEnum.THERMAL_SAFE_MODE) {
      DeviceInfoVm.instance.setEmergencyAppList(this.thermalList);
    }
  }

  onDeviceModeChange(): void {
    DeviceInfoVm.instance.setDeviceMode(this.deviceMode);
    this.onEmergencyListChange();
  }

  onBannerStateChange(): void {
    BannerVm.instance.setBannerType(this.bannerState.bannerPanelType, this.bannerState.secondaryPanelType);
  }
  
  onEnableControllerCenter(): void {
    log.showInfo(`onEnableControllerCenter: ${this.enableControllerCenter}`);
    EnvVm.instance.enableControllerCenter = this.enableControllerCenter;
  }

  onScreenStatusChange(): void {
    log.showInfo(`lockStatus: ${this.lockStatus}, foldStatusForOuterScreen: ${this.foldStatusForOuterScreen},
    autoRotateStatus: ${this.autoRotateStatus}`);
    let screenStatusChange = ScreenStatusChangeEvent.create(this.lockStatus, this.foldStatusForOuterScreen,
      this.autoRotateStatus);
    ScreenStatusVm.instance.lockStatus = this.lockStatus;
    EvtBus.post(ScreenStatusChangeEvent, screenStatusChange);
  }

  onColorModeChange(): void {
    log.showInfo('onColorModeChange: ' + this.currColorMode);
    let colorModeChange = ColorModeChangeEvent.create(this.currColorMode);
    EvtBus.post(ColorModeChangeEvent, colorModeChange);
  }

  onUseNewScreenLockChange(): void {
    log.showInfo('isUseNewScreenLock: ' + ScreenLockAdapter.isUseNewScreenLock());
    ScreenStatusVm.instance.isUseNewScreenLock = ScreenLockAdapter.isUseNewScreenLock();
  }
  
  onScenePanelStateChange(): void {
    log.showInfo(`onScenePanelStateChange: ${this.scenePanelState}`);
    EnvVm.instance.scenePanelState = this.scenePanelState;
  }

  onPcModeScenePanelStateChange(): void {
    log.showInfo(`onPcModeScenePanelStateChange: ${this.pcModeScenePanelState}`);
    EnvVm.instance.pcModeScenePanelState = this.pcModeScenePanelState;
  }

  onDeskTopChange(): void {
    log.showInfo(`onDeskTopChange: ${this.onDeskTop}`);
    EnvVm.instance.onDeskTop = this.onDeskTop;
  }

  onPocketStatusChange(): void {
      return;
  }
}