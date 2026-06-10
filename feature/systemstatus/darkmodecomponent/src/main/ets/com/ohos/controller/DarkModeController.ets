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

import Context from '@ohos.app.ability.common';
import taskpool from '@ohos.taskpool';
import uiAppearance from '@ohos.uiAppearance';
import config from '@ohos.accessibility.config';
import { BusinessError } from '@ohos.base';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import { AccessibilityUtil, DarkModeEvent } from '@ohos/systemuicommon';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { DarkModeSwitchDoneEvent } from '@ohos/systemuicommon/src/main/ets/event/DarkModeSwitchDoneEvent';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import {
  LogDomain,
  LogHelper,
  DataProperty,
  AppStorageUtil
} from '@ohos/basicutils';
import {
  ConfigurationEvent,
  EvtBus,
  EventManager,
  DeviceHelper,
  sEventManager,
  PluginClickInfo,
  obtainStartAbilityWithWant,
  GlobalContext,
} from '@ohos/frameworkwrapper';
import { FASlotName, ExtAppConstants } from '@ohos/commonconstants';
import lazy { SCBScreenSession } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSession';
import Constants from '../common/Constants';
import { DarkModeData } from './../common/Constants';

const TAG: string = 'Ctrl.DarkModeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const SET_MODE_DELAY: number = 2000;
const REQUEST_FOCUS_DELAY: number = 500;
const SUB_WINDOW_HEIGHT: number = 280;

export class DarkModeController extends ToggleBaseViewModel {
  /**
   * 上下文
   */
  public context: Context.ExtensionContext;
  public mDarkModeData: DarkModeData = new DarkModeData();

  /**
   * 多事件管理器
   */
  private darkModeEventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 深色模式事件
   */
  private darkModeEvent: DarkModeEvent = DarkModeEvent.create();
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';

  private isLockDarkMode: boolean = false;
  /**
   * 接口调用限流timeId
   */
  private callApiLimitTimeId: number = -1;

  public startServiceFunc: (() => void) | undefined = () => {
    log.showInfo('startService');
    if (this.customCommonData.scene === ToggleScene.PHONE) {
      this.handleOnControlCenterWithScreenLockForUIE((): void => {
        sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.DARK_MODE, {
          clickType: 'window',
          bundleName: 'com.ohos.settings',
          abilityName: 'DarkModeExtensionSettingsAbility',
          uiExtensionType: 'sys/commonUI',
          windowHeight: SUB_WINDOW_HEIGHT
        } as PluginClickInfo);
      }, true);
    } else {
      this.handleGoSettingWithScreenLock(():void => this.goSettings());
    }
  }

  constructor() {
    super();
    this.context = GlobalContext.getContext();
    this.mDarkModeData.icon = $r('app.media.ic_controlcenter_dark_mode');
    this.mDarkModeData.label = $r('app.string.control_center_complex_toggle_dark_mode_title');
  }

  setCustomCommonData(scene?: ToggleScene | undefined): void {
    // 设置场景
    this.customCommonData.scene = scene;
  }

  getLottieOpenName(): string {
    return Constants.LOTTIE_DATA_OPEN;
  }

  getLottieCloseName(): string {
    return Constants.LOTTIE_DATA_CLOSE;
  }

  getLottieDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  /**
   * 获取开启动画新lottie名称
   */
  getNewLottieOpenName(): string {
    return 'new_dark_mode.json';
  }

  getNewLottieCloseName(): string {
    return 'new_dark_mode.json';
  }

  isLoadLottie(): boolean {
    return true;
  }

  getViewData(): ToggleViewData {
    return this.mDarkModeData;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    AppStorageUtil.setOrCreate('DarkModeModel_DarkModeStatus', this.mDarkModeData, new DataProperty(true, false));
    this.mDarkModeData = AppStorage.get<DarkModeData>('DarkModeModel_DarkModeStatus') as DarkModeData;
    this.darkModeEventMgr.on(ConfigurationEvent, this.handleConfigurationEvent)
      .produceOn(DarkModeEvent, this.onProduceDarkModeEvent);

    this.initDarkModeState();
  }

  private initDarkModeState(): void {
    try {
      taskpool.execute(getDarkMode).then((result: Object) => {
        log.showInfo(`getDarkMode, result: ${result}`);
        this.setDarkModeState(result as boolean);
        log.showInfo(`init state: ${this.mDarkModeData.status}`);
      });
    } catch (error) {
      log.showError(`getDarkMode is failed: ${error}`);
    }
  }

  /**
   * 设置深色模式状态
   *
   * @param isDarkMode 是否深色模式
   */
  private setDarkModeState(isDarkMode: boolean): void {
    this.switchHighContrastText(!isDarkMode);
    this.mDarkModeData.status = isDarkMode;
    this.mDarkModeData.isOn = isDarkMode;

    // 发送深色模式切换事件
    if (this.darkModeEvent.isDarkMode !== isDarkMode) {
      this.darkModeEvent.isDarkMode = isDarkMode;
      EvtBus.post(DarkModeEvent, this.darkModeEvent);
    }
  }

  /**
   * 深色模式事件生产者
   *
   * @returns 事件
   */
  private onProduceDarkModeEvent = (): DarkModeEvent => {
    return this.darkModeEvent;
  }

  /**
   * 处理config属性事件
   *
   * @param event 事件
   */
  private handleConfigurationEvent = (event: ConfigurationEvent | null): void => {
    try {
      let newState: boolean = event?.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      log.showInfo(`handleConfigurationEvent, isDark: ${newState}, oldDarkStatus: ${this.mDarkModeData.status}`);
      this.setDarkModeState(newState);
      // 点击切换深色模式之后需要将置灰效果取消，增加延时防止label闪
      setTimeout(() => {
        this.mDarkModeData.isUnavailable = false;
      }, 15)

      // 需要在上下文切换深浅色模式后单独发送该事件，防止解析时上下文未修改对应深浅色模式
      EvtBus.post(DarkModeSwitchDoneEvent, DarkModeSwitchDoneEvent.create());
    } catch (err) {
      log.error(`uiAppearance.getDarkMode is failed: ${err}`);
    }
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    this.darkModeEventMgr.offAll();
  }

  addStateChangedListener(): void {
  }

  removeStateChangedListener(): void {
  }

  isAvailable(): boolean {
    return true;
  }

  handleOneClick(): void {
    log.showInfo(`handleClick, current:${this.mDarkModeData.status}, isLockDarkMode:${this.isLockDarkMode}`);
    if (this.isLockDarkMode) {
      return;
    } else {
      setTimeout(() => {
        log.showInfo('Timeout,  reset dark mode status');
        this.isLockDarkMode = false;
        this.mDarkModeData.isUnavailable = false;
        setTimeout(() => AccessibilityUtil.requestFocusAccessibility('transition_toggledark_mode'),
          REQUEST_FOCUS_DELAY);
      }, SET_MODE_DELAY);
      this.isLockDarkMode = true;
      this.mDarkModeData.isUnavailable = true;
    }
    this.switchColorModeStatus(!this.mDarkModeData.status);
  }

  startService(): void {
    log.showInfo('startService');
    this.handleGoSettingWithScreenLock(():void => this.goSettings());
  }

  private goSettings(): void {
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'dark_settings',
      moduleName: this.mdName
    }));
  }

  private switchColorModeStatus(isDark: boolean): void {
    log.showInfo('switchColorModeStatus start');
    taskpool.execute(switchColorMode, isDark).then((result: Object) => {
      log.info(`switchColorMode to ${isDark}, result: ${result}`);
      if (result as number !== 0) {
        this.initDarkModeState();
      }
    });
  }

  private switchHighContrastText(isDarkMode: boolean) {
    if (isDarkMode) {
      return;
    }
    config.highContrastText.set(isDarkMode).then(() => {
      log.showInfo(`highContrastText set ${isDarkMode} success`);
    }).catch((err: BusinessError) => {
      log.error(`highContrastText set ${isDarkMode} err: ` + err);
    });
  }
}

async function switchColorMode(isOn: boolean): Promise<number> {
  'use concurrent';
  try {
    await uiAppearance.setDarkMode(isOn ? uiAppearance.DarkMode.ALWAYS_DARK : uiAppearance.DarkMode.ALWAYS_LIGHT);
    return 0;
  } catch (err) {
    return err?.code;
  }
}

async function getDarkMode(): Promise<boolean> {
  'use concurrent';
  try {
    let darkMode: boolean = uiAppearance.getDarkMode() === uiAppearance.DarkMode.ALWAYS_DARK;
    return darkMode;
  } catch (err) {
    const TAG = 'Ctrl.DarkModeController';
    const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
    log.showError('uiAppearance getDarkMode error', err);
    return false;
  }
}