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

import { AppStorageUtil, DataProperty, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';
import { settings } from '@kit.BasicServicesKit';
import { DeviceHelper, EvtBus, GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';
import { AutoBrightnessEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';

const TAG = 'Ctrl.BrightnessController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const AUTO_SCREEN_BRIGHTNESS_DEFAULT_VALUE_STR = '1';

export class BrightnessController extends BaseController<BrightnessData> {
  private mBrightnessData = new BrightnessData();
  private autoBrightnessState: boolean = true;
  private isLottieDataLoading: boolean = false;
  private defaultLottieData: object | undefined = undefined;

  constructor() {
    super();
    log.showInfo('init BrightnessController');
    AppStorageUtil.setOrCreate('BrightnessController_lottieDataReady', false, new DataProperty(true, false));
    // 只需要匹配开启的动画资源即可
    this.onStart();
    try {
      log.showInfo(`init autoBrightness registerKeyObserver start`);
      settings.registerKeyObserver(GlobalContext.getContext(), settings.display.AUTO_SCREEN_BRIGHTNESS,
        settings.domainName.DEVICE_SHARED, () => {
          try {
            this.autoBrightnessState = sSettingsUtil.getValue(settings.display.AUTO_SCREEN_BRIGHTNESS,
              AUTO_SCREEN_BRIGHTNESS_DEFAULT_VALUE_STR) === AUTO_SCREEN_BRIGHTNESS_DEFAULT_VALUE_STR;
            log.showInfo(`observer:autoBrightness autoBrightnessState=${this.autoBrightnessState}`);
            this.loadDefaultLottie();
            EvtBus.post(AutoBrightnessEvent, {'autoBrightness': this.autoBrightnessState});
          } catch (e) {
            log.showError(`autoBrightness callback err:${e}`);
          }
        });
      // 部分设备开机不打开自动亮度，需要查询一次开关状态。
      this.autoBrightnessState = sSettingsUtil.getValue(settings.display.AUTO_SCREEN_BRIGHTNESS,
        AUTO_SCREEN_BRIGHTNESS_DEFAULT_VALUE_STR) === AUTO_SCREEN_BRIGHTNESS_DEFAULT_VALUE_STR;
    } catch (e) {
      log.showError(`init autoBrightness registerKeyObserver error:${e}`);
    }
    this.loadDefaultLottie();
  }

  /**
   * 加载首页默认LOTTIE，保持常驻
   */
  public loadDefaultLottie(): void {
    this.loadLottieDataAsync(this.getDefaultLottieName(), (value) => {
      log.info('load Default lottie success');
      AppStorageUtil.setOrCreate('BrightnessController_lottieDataReady', false, new DataProperty(true, false));
      this.defaultLottieData = value;
      AppStorageUtil.setOrCreate('BrightnessController_lottieDataReady', true, new DataProperty(true, false));
    });
  }

  private getDefaultLottieName(): string {
    return RTLUtil.isRTL() ? this.getMirrorLottieOpenName() : this.getNewLottieOpenName();
  }

  /**
   * 是否需要加载lottie
   */
  isLoadLottie(): boolean {
    return true;
  }

  getNewLottieOpenName(): string {
    return 'sun.json';
  }

  getMirrorLottieOpenName(): string {
    return 'sun_mirror.json';
  }

  getData(): CommonData {
    return this.mBrightnessData;
  }

  isAvailable(): boolean {
    return true;
  }

  async initLottieData(): Promise<void> {
    log.info('initLottieData');
    if (DeviceHelper.isPC()) {
      return;
    }
    if (this.isLottieDataLoading) {
      log.info('Lottie data is loading');
      return;
    }
    this.isLottieDataLoading = true;
    // 这里只加载二级页亮度条图标，不常驻
    await this.loadLottieDataAsync(this.getNewLottieOpenName(), (value) => {
      log.info('load normal lottie success');
      this.records.openLottie = value;
    });
    await this.loadLottieDataAsync(this.getMirrorLottieOpenName(), (value) => {
      log.info('load mirror lottie success');
      this.records.mirrorOpenLottie = value;
    });
    this.isLottieDataLoading = false;
  }

  matchLottieData(darkMode: boolean): object {
    log.showInfo(`matchLottieData isRTL:${RTLUtil.isRTL()}  autoBrightnessState:${this.autoBrightnessState}`);
    if (this.defaultLottieData !== undefined) {
      return this.defaultLottieData;
    }
    return RTLUtil.isRTL() ? this.records.mirrorOpenLottie : this.records.openLottie;
  }

  matchDefaultLottieData(): object {
    log.showInfo(`matchDefaultLottieData isRTL:${RTLUtil.isRTL()}  autoBrightnessState:${this.autoBrightnessState}`);
    return RTLUtil.isRTL() ? this.records.mirrorOpenLottie : this.records.openLottie;
  }

  onStop(): void {
    log.showInfo('onStop');
    super.onStop();
    settings.unregisterKeyObserver(GlobalContext.getContext(), settings.display.AUTO_SCREEN_BRIGHTNESS,
      settings.domainName.DEVICE_SHARED);
  }

  /**
   * 移除lottie缓存
   */
  removeLottieData(): void {
    log.showInfo('remove brightness LottieData');
    this.records = {};
    this.isAlreadyLoadLottie = false;
  }

  /**
   * 设置自动亮度开关状态
   *
   * @param state 新开关状态
   */
  public setAutoBrightnessState(state: boolean) {
    log.showInfo(`setAutoBrightnessState new state=${state}`);
    if (!sSettingsUtil.setValue(settings.display.AUTO_SCREEN_BRIGHTNESS, state ? '1' : '0')) {
      log.showWarn('setAutoBrightnessState setValue fail');
    }
  }

  /**
   * 查询自动亮度开关状态
   *
   * @return boolean 自动亮度开关状态
   */
  public getAutoBrightnessState(): boolean {
    return this.autoBrightnessState;
  }

  /**
   * 更新自动亮度开关状态：用户切换时需要重新查询
   */
  public updateAutoBrightnessState(): void {
    this.autoBrightnessState = sSettingsUtil.getValue(settings.display.AUTO_SCREEN_BRIGHTNESS,
      AUTO_SCREEN_BRIGHTNESS_DEFAULT_VALUE_STR) === AUTO_SCREEN_BRIGHTNESS_DEFAULT_VALUE_STR;
  }
}

export class BrightnessData extends CommonData {
  public status: boolean = true;
}

let sBrightnessController = SingletonHelper.getInstance(BrightnessController, TAG);

export default sBrightnessController as BrightnessController;