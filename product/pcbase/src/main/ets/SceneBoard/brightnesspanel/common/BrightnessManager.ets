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

import { Log, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { CommonConstants } from '@ohos/commonconstants';
import systemParameter from '@ohos.systemparameter';
import dataShare from '@ohos.data.dataShare';
import Brightness from '@ohos.brightness';
import settings from '@ohos.settings';

const TAG = 'BrightnessManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
// CCM配置最小亮度值
const DISPLAY_BRIGHTNESS_MIN: number = 1;
// CCM配置最大亮度值
const DISPLAY_BRIGHTNESS_MAX: number = 255;
const ADJUST_GEAR_NUM = 16;
const DEFAULT_BRIGHTNESS = 100;
let mBrightnessValue = AppStorage.setAndLink('BrightnessValue', DEFAULT_BRIGHTNESS);

export class BrightnessManager {
  helper?: dataShare.DataShareHelper;
  uri: string;
  context: Context;
  sliderChangeMode?: number;
  readonly SLIDER_CHANG_MODE_MOVING: number = 1;
  readonly ADJUST_GEAR: number = ADJUST_GEAR_NUM;
  private readonly BRIGHTNESS_WIDTH: number = 312;

  constructor() {
    this.uri = CommonConstants.getUriSync(CommonConstants.KEY_BRIGHTNESS_STATUS);
    Log.showInfo(TAG, 'settings geturi of brightness is ' + CommonConstants.URI_VAR);
    this.context = GlobalContext.getContext();
    this.init();
  }

  async init(): Promise<void> {
    Log.showInfo(TAG, 'init');
    try {
      this.helper = await dataShare.createDataShareHelper(this.context, this.uri);
      Log.showInfo(TAG, `init helper ${this.helper}`);
      this.registerBrightness();
      this.getValue();
    } catch (error) {
      Log.showError(TAG, `[init] error ${JSON.stringify(error)}`);
    }
  }

  registerBrightness(): void {
    try {
      this.helper?.on('dataChange', this.uri, () => {
        if (this.sliderChangeMode === 1) {
          Log.showInfo(TAG, 'sliderChangeMode is moving, Ignor this change');
          return;
        }
        Log.showInfo(TAG, 'after brightness datachange settings getValue' + this.sliderChangeMode);
        this.getValue();
      });
    } catch (error) {
      Log.showError(TAG, `[registerBrightness] error ${JSON.stringify(error)}`);
    }
  }

  unRegisterBrightness(): void {
    try {
      this.helper?.off('dataChange', this.uri, () => {
        Log.showInfo(TAG, 'unregister brightness helper');
      });
    } catch (error) {
      Log.showError(TAG, `[unRegisterBrightness] error ${JSON.stringify(error)}`);
    }
  }

  getValue(): void {
    let defaultValue: number = Number.parseInt(systemParameter.getSync('const.display.brightness.default'));
    let data = settings.getValueSync(this.context, CommonConstants.KEY_BRIGHTNESS_STATUS, JSON.stringify(defaultValue));
    mBrightnessValue.set(Number.parseInt(data));
  }

  getMin(): number {
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

  getMax(): number {
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

  getRange(): number {
    let range = this.getMax() - this.getMin();
    return range;
  }

  setPCValue(value: number): void {
    try {
      log.showInfo(`set brightness value: ${value}`);
      Brightness.setValue(value);
    } catch (err) {
      Log.showInfo(TAG, `setValue err: ${JSON.stringify(err)}`);
    }
  }

  onBrightnessChange(uiVar: number): void {
    let physicsValue = this.countPhysicsValue(uiVar);
    Log.showInfo(TAG, `onBrightnessChange ui value: ${uiVar};physicsValue: ${physicsValue}`);
    this.setPCValue(physicsValue);
  }

  countUIValue(physicsValue: number): number {
    let range = this.getRange();
    if (range <= 0) {
      return this.getMin();
    }
    let percentage = Math.pow(((physicsValue - this.getMin()) / range), 1 / 1.8);
    let brightnessUI = range * percentage + this.getMin();
    Log.showInfo(TAG, `phsics value:${physicsValue};countUIValue percentage:${percentage};ui value:${brightnessUI}`);
    return brightnessUI;
  }

  private countPhysicsValue(uiVar: number): number {
    let range = this.getRange();
    if (range <= 0) {
      return this.getMin();
    }
    let brightness = Math.pow(uiVar / this.BRIGHTNESS_WIDTH, 1.8) * range + this.getMin();
    Log.showInfo(TAG, `uiVar: ${uiVar};count brightness value according to ui value: ${brightness};range: ${range}`);

    if (brightness > mBrightnessManager.getMax()) {
      brightness = mBrightnessManager.getMax();
    } else if (brightness < mBrightnessManager.getMin()) {
      brightness = mBrightnessManager.getMin();
    }

    if (brightness - this.getMin() < 1) {
      brightness = Math.floor(brightness);
    } else if (this.getMax() - brightness < 1) {
      brightness = Math.ceil(brightness);
    } else if (brightness < range * 1 / 3) {
      brightness = Math.ceil(brightness);
    }

    return brightness;
  }

  getInterval(): number {
    try {
      return this.BRIGHTNESS_WIDTH / this.ADJUST_GEAR;
    } catch (err) {
      Log.showInfo(TAG, `setValue err: ${JSON.stringify(err)}`);
      return 0;
    }
  }

  addValue(currentNum: number): void {
    let addNum = currentNum + this.getInterval();
    Log.showInfo(TAG, `addValue currentNum: ${currentNum} addNum: ${addNum}`);
    let maxNum = this.BRIGHTNESS_WIDTH;
    if (addNum >= maxNum) {
      this.onBrightnessChange(maxNum);
    } else {
      this.onBrightnessChange(addNum);
    }
  }

  subValue(currentNum: number): void {
    let subNum: number = currentNum - this.getInterval();
    let minNum = this.getMin();
    Log.showInfo(TAG, `subValue currentNum: ${currentNum} subNum: ${subNum}`);
    if (subNum <= minNum) {
      this.onBrightnessChange(minNum);
    } else {
      this.onBrightnessChange(subNum);
    }
  }
}

let mBrightnessManager = new BrightnessManager();

export default mBrightnessManager as BrightnessManager;