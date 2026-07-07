/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import hgmnapi from '@ohos.libhgmnapi.z.so';
import commonEventManager from '@ohos.commonEventManager';
import { BusinessError } from '@kit.BasicServicesKit';
import power from '@ohos.power';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { settingsDataManager, ApsUtils } from '@ohos/frameworkwrapper';
import { sOutSideWindowMgr } from '@ohos/frameworkwrapper';
import { StartExitMotionLevel } from '@ohos/commonconstants/src/main/ets/constants/VisualEffectConstants';
import { StartAbilityUtil } from '@ohos/windowscene';

const TAG: string = 'StartAndExitVisualEffectManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DISPLAY_SCREEN_FREQ: string = 'settings.display.hw_screen_freq';

/**
 * 启动退出视效管理类
 */
export class StartAndExitVisualEffectManager {
  private static mInstance: StartAndExitVisualEffectManager;
  // 启动退出动效根据CCM配置禁用模糊
  private mIsStartExitBlurDisable: boolean = false;
  // 启动退出动效根据CCM配置禁用运动模糊
  private mIsMotionBlurDisable: boolean = false;
  // 启动退出动效根据CCM配置最高适用运动模糊帧率
  private mHighestMotionBlurEnable: number = -1;
  // 启动退出动效在省电模式下禁用模糊
  private mIsPowerSaveMode: boolean = false;
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  // 当前设备支持的帧率配置
  private supportedRates: number[] = [];
  // 当前帧率档位
  private freqIndex: number = -1;
  // 当前设置的帧率
  private deviceRate: number = -1;
  // 启动退出动效等级
  private startExitMotionLevel: StartExitMotionLevel = StartExitMotionLevel.NORMAL_BLUR;

  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED
    ]
  };

  private constructor() {
    this.mIsStartExitBlurDisable = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE);
    this.mIsMotionBlurDisable = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.MOTION_BLUR_DISABLE);
    this.mHighestMotionBlurEnable = SCBVisualEffectMgr.getFeatureParamNumber(VisualEffectConstants.HIGHEST_MOTION_BLUR_ENABLE);
    this.startExitMotionLevel = SCBVisualEffectMgr.getStartExitMotionLevel(VisualEffectConstants.ICON_START_EXIT_MOTION_BLUR_LEVEL);
    this.initSupportedRates();
    this.initDeviceRate();
    // 监听帧率事件
    settingsDataManager.registerKeyObserver(DISPLAY_SCREEN_FREQ, () => {
      log.showInfo('device rate change');
      this.initDeviceRate();
    });
    const isPriority: boolean = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.PRIORITY_PRELAUNCH_CAMERA_ENABLE);
    StartAbilityUtil.setPreLaunchPriority(isPriority);
    const restrictFrameRate: string = SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.RESTRICT_FRAME_RATE_MIDDLE);
    ApsUtils.setAppPackName(restrictFrameRate);
  }

  /**
   * 通过settingsData获取当前帧率档位，不同设备下支持的帧率配置不一致，分为以下三种档位配置：
   *  1. -1: 智能; 1: 标准
   *  2. -1: 智能; 1: 标准; 2: 高
   *  3. -1: 智能; 1: 标准; 2: 中; 3: 高
   */
  private initDeviceRate(): void {
    try {
      this.freqIndex = Number(settingsDataManager.getValue(null, DISPLAY_SCREEN_FREQ, '-1'));
      if (CheckEmptyUtils.isEmptyArr(this.supportedRates)) {
        this.initSupportedRates();
      }
      // 获取帧率配置项
      let ratesLen: number = this.supportedRates?.length;
      if (ratesLen <= 1) {
        log.showWarn(`get supported rates len: ${ratesLen}`);
        return;
      }
      if (this.freqIndex > 0 && this.freqIndex < ratesLen) {
        this.deviceRate = this.supportedRates[this.freqIndex];
      } else if (this.freqIndex === -1) {
        // 智能帧率时取最高档的帧率配置
        this.deviceRate = this.supportedRates[ratesLen - 1];
      }
      log.showInfo(`get settings rate: ${this.deviceRate}`);
    } catch (err) {
      log.showError(`get settings rate, err: ${err?.code}, errMessage: ${err?.message}`);
    }
  }

  /**
   * hgm获取每个档位支持的最高帧率，智能帧率默认是高档位的帧率配置
   */
  private initSupportedRates(): void {
    try {
      this.supportedRates = hgmnapi.getScreenSupportedRefreshRates(0);
      log.showInfo(`get supported rates: ${this.supportedRates?.toString()}`);
      return;
    } catch (err) {
      log.showError(`get screen supported refresh rates, err: ${err?.code}, errMessage: ${err?.message}`);
    }
  }

  public static getInstance(): StartAndExitVisualEffectManager {
    if (!StartAndExitVisualEffectManager.mInstance) {
      StartAndExitVisualEffectManager.mInstance = new StartAndExitVisualEffectManager();
    }
    return StartAndExitVisualEffectManager.mInstance;
  }

  /**
   * 返回模糊禁用状态
   * @returns true：禁用， false：不禁用
   */
  public isStartExitBlurDisable(): boolean {
    log.showInfo(`mIsStartExitBlurDisable: ${this.mIsStartExitBlurDisable}`);
    return this.mIsStartExitBlurDisable || this.startExitMotionLevel !== StartExitMotionLevel.NORMAL_BLUR || this.isPowerSaveMode();
  }

  /**
   * 返回是否启用壁纸模糊
   * @returns
   */
  public isStartExitWallpaperBlurDisable(): boolean {
    log.showWarn(`isStartExitWallpaperBlurDisable mIsStartExitBlurDisable: ${this.mIsStartExitBlurDisable}, startExitMotionLevel: ${this.startExitMotionLevel} `);
    return !this.mIsStartExitBlurDisable && !this.isPowerSaveMode() && this.startExitMotionLevel === StartExitMotionLevel.WALLPAPER_BLUR  &&
      !sOutSideWindowMgr.isShowNegative() && !sOutSideWindowMgr.isShowGlobalSearch();
  }

  /**
   * 返回运动模糊禁用状态
   * @returns true：禁用， false：不禁用
   */
  public isMotionBlurDisable(): boolean {
    return this.mIsMotionBlurDisable;
  }

  /**
   * 返回最高适用运动模糊帧率
   * @returns -1默认规格(90及以下帧率适用运动模糊)， 其他数值：运动模糊需要在配置帧率以下才适用
   */
  public getHighestMotionBlurEnable(): number {
    return this.mHighestMotionBlurEnable;
  }

  /**
   * 设置是否是省电模式
   * @param value
   */
  public setIsPowerSaveMode(value: boolean): void {
    this.mIsPowerSaveMode = value;
  }

  /**
   * 返回是否为省电模式
   * @returns true：是， false：不是
   */
  public isPowerSaveMode(): boolean {
    log.showInfo(`mIsPowerSaveMode: ${this.mIsPowerSaveMode}`);
    return this.mIsPowerSaveMode;
  }

  /**
   * 配置获取当前设置的帧率
   * @returns 当前配置的帧率
   */
  public getDeviceRate(): number {
    return this.deviceRate;
  }
}