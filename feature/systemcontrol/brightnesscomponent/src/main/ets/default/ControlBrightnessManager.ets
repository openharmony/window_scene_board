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

import { GlobalContext, DeviceHelper } from '@ohos/frameworkwrapper';
import { CommonConstants } from '@ohos/commonconstants';
import { MemoryManager } from '@ohos/frameworkcommon';
import { LogHelper, LogDomain, SingletonHelper } from '@ohos/basicutils';
import settings from '@ohos.settings';
import systemParameter from '@ohos.systemparameter'
import dataShare from '@ohos.data.dataShare';
import taskpool from '@ohos.taskpool';
import Brightness from '@ohos.brightness';

// CCM配置最小亮度值
const DISPLAY_BRIGHTNESS_MIN: number = 1;
// CCM配置最大亮度值
const DISPLAY_BRIGHTNESS_MAX: number = 255;
// CCM配置默认亮度值
const DISPLAY_BRIGHTNESS_DEFAULT: number = 102;
// dataShare最多重试次数
const MAX_RETRY_TIMES: number = 5;
// 重试间隔
const RETRY_INTERVAL_MS: number = 1500;
const TAG = 'Control-brightnessManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);


export class ControlBrightnessManager {
  public helper: dataShare.DataShareHelper | undefined = undefined;
  public uri: string;
  public context: Context;
  public sliderChangeMode: SliderChangeMode | undefined = undefined;
  public SLIDER_CHANG_MODE_MOVING = 1;
  public isPC: boolean = DeviceHelper.isPC();
  public brightnessCache: number = 100;
  public isControlCenterVisible: boolean = false;
  private taskPoolSequence: taskpool.SequenceRunner = new taskpool.SequenceRunner(taskpool.Priority.LOW);
  private taskTimerId?: number;
  private needExecuteTaskOnceMore: boolean = false;
  private brightnessValue: AbstractProperty<number> = AppStorage.setAndRef('BrightnessValue', 100);

  constructor() {
    this.uri = CommonConstants.getUriSync(CommonConstants.KEY_BRIGHTNESS_STATUS);
    log.showInfo('settings geturi of brightness is ' + CommonConstants.URI_VAR);
    this.context = GlobalContext.getContext();
    this.init(MAX_RETRY_TIMES);
  }

  public static getInstance(): ControlBrightnessManager {
    return SingletonHelper.getInstance(ControlBrightnessManager, TAG);
  }

  async init(retryTimes: number): Promise<void> {
    log.showInfo('init');
    if (retryTimes <= 0) {
      log.showError('init failed, no retry times');
      return;
    }
    try {
      this.helper = await dataShare.createDataShareHelper(this.context, this.uri);
      log.showInfo(`init helper ${this.helper}`);
      this.registerBrightness();
      taskpool.execute(getBrightValue, this.context).then((res: Object) => {
        this.brightnessValue.set(res as number);
        this.brightnessCache = res as number;
      }).catch((error: object) => {
        log.showError(`getBrightValue error:${error}`);
      });
    } catch (error) {
      log.showError(`createDataShareHelper error:${error}`);
      setTimeout(() => {
        this.init(retryTimes - 1);
      }, RETRY_INTERVAL_MS);
    }
  }

  registerBrightness() {
    this.helper?.on('dataChange', this.uri, () => {
      if (this.sliderChangeMode === SliderChangeMode.Moving) {
        log.showInfo(`sliderChangeMode is moving, Ignor this change`);
        return;
      }
      log.showInfo(`after brightness datachange settings getValue, ${this.sliderChangeMode}`);
      this.executeTaskDelay();

    });
  }

  /**
   * 执行亮度值刷新任务
   */
  public executeTaskDelay(): void {
    if (!this.needExecuteTask()) {
      return;
    }
    this.taskTimerId = setTimeout(() => {
      try {
        let task = new taskpool.Task(getBrightValue, this.context);
        this.taskPoolSequence.execute(task).then((res: Object) => {
          this.brightnessCache = res as number;
          log.showInfo(`getBrightValue, this.brightnessCache:${this.brightnessCache}`);
          if (this.isControlCenterVisible || this.isPC) {
            this.setBrightnessUiValue(res as number);
          }
          this.resetTaskFlags();
        }).catch((error: object) => {
          log.showError('getBrightValue error', error);
        });
      } catch (error) {
        log.showError('taskpool execute error', error);
      }
    }, 100);
    log.showDebug('executeTaskDelay, taskID:%{public}d', this.taskTimerId);
  }

  private resetTaskFlags() {
    this.taskTimerId = undefined;
    if (this.needExecuteTaskOnceMore) {
      this.executeTaskDelay();
      this.needExecuteTaskOnceMore = false;
      log.showDebug('resetTaskFlags execute task once more');
    }
  }

  private needExecuteTask(): boolean {
    if (MemoryManager.getInstance().checkIsStaticMemoryScene()) {
      log.showInfo('StaticMemory no change brightness')
      return false;
    }
    if (this.taskTimerId == undefined) {
      return true;
    }
    if (!this.isControlCenterVisible) {
      log.showDebug('needExecuteTask, taskID:%{public}d', this.taskTimerId);
      clearTimeout(this.taskTimerId)
      return true;
    }
    // 控制中心可见，task还未执行完毕，等待上次任务执行完之后，再执行新任务
    this.needExecuteTaskOnceMore = true;
    log.showDebug('needExecuteTask wait task done, taskID:%{public}d', this.taskTimerId);
    return false;
  }

  unRegisterBrightness() {
    try {
      this.helper?.off('dataChange', this.uri, () => {
        log.showInfo(`unregister brightness helper`);
      })
    } catch (error) {
      log.showWarn(`Failed to unRegisterBrightness, error: ${error.message}`);
    }
  }

  getMin() {
    try {
      let minValue = Number.parseInt(systemParameter.getSync('const.display.brightness.min'));
      if (isNaN(minValue)) {
        return DISPLAY_BRIGHTNESS_MIN;
      }
      return minValue;
    } catch (error) {
      log.showError('getMin from systemParameter error', error);
      // 获取异常时按照默认值返回
      return DISPLAY_BRIGHTNESS_MIN;
    }
  }

  getMax() {
    try {
      let maxValue = Number.parseInt(systemParameter.getSync('const.display.brightness.max'));
      if (isNaN(maxValue)) {
        return DISPLAY_BRIGHTNESS_MAX;
      }
      return maxValue;
    } catch (error) {
      log.showError('getMax from systemParameter error', error);
      // 获取异常时按照默认值返回
      return DISPLAY_BRIGHTNESS_MAX;
    }
  }

  getDefault() {
    try {
      let defaultValue = Number.parseInt(systemParameter.getSync('const.display.brightness.default'));
      if (isNaN(defaultValue)) {
        return DISPLAY_BRIGHTNESS_DEFAULT;
      }
      return defaultValue;
    } catch (error) {
      log.showError('getDefault from systemParameter error', error);
      // 获取异常时按照默认值返回
      return DISPLAY_BRIGHTNESS_DEFAULT;
    }
  }

  setBrightnessUiValue(value?: number) {
    if (value !== undefined) {
      log.showInfo(`set brightness value: ${value}`)
      this.brightnessValue.set(value);
      return;
    }
    log.showDebug(`set brightness value with cache: ${this.brightnessCache}`)
    this.brightnessValue.set(this.brightnessCache);
  }

  /**
   * 设置控制中心是否可见
   *
   * @returns void
   */
  setControlCenterVisible(visible: boolean): void {
    this.isControlCenterVisible = visible;
  }
}

@Concurrent
export function getBrightValue(context: Context): number {
  let defaultValue: number = Number.parseInt(systemParameter.getSync('const.display.brightness.default'));
  if (isNaN(defaultValue)) {
    defaultValue = 102;
  }
  let data = '0';
  try {
    data = settings.getValueSync(context, CommonConstants.KEY_BRIGHTNESS_STATUS, JSON.stringify(defaultValue));
  } catch (error) {
    const TAG = 'Control-brightnessManager';
    const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
    log.showError('getBrightValue error', error);
  }
  let brightValue: number = Number.parseInt(data);
  if (isNaN(brightValue)) {
    brightValue = defaultValue;
  }
  return brightValue;
}

@Concurrent
export function setBrightValue(value: number, continuous: boolean): void {
  try {
    Brightness.setValue(value, continuous);
  } catch (error) {
    const TAG = 'Control-brightnessManager';
    const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
    log.showError('Brightness setValue error', error);
  }
}