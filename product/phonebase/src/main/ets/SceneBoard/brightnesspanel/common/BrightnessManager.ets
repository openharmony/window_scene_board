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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { CommonConstants, SCBConstants } from '@ohos/commonconstants';
import systemParameter from '@ohos.systemparameter';
import dataShare from '@ohos.data.dataShare';
import Brightness from '@ohos.brightness';
import settings from '@ohos.settings';

const TAG = 'BrightnessManager';
const ADJUST_GEAR_NUM = 16;
const DEFAULT_BRIGHTNESS = 100;
const BRIGHTNESS_WIDTH = 212;
const LOG: Logger = Logger.getLogHelper(LogDomain.HOME);
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
let brightnessValue = AppStorage.setAndRef('BrightnessValue4Panel', DEFAULT_BRIGHTNESS);

export class BrightnessManager {
  private helper?: dataShare.DataShareHelper;
  private uri: string = '';
  private context?: Context;
  private sliderChangeMode: number = 0;

  constructor() {
    if (!this.isSupportBrightnessMultiInputFeature()) {
      return;
    }
    this.uri = CommonConstants.getUriSync(CommonConstants.KEY_BRIGHTNESS_STATUS);
    LOG.showInfo(TAG, 'settings geturi of brightness is ' + CommonConstants.URI_VAR);
    this.context = GlobalContext.getContext();
    this.init();
  }

  public isSupportBrightnessMultiInputFeature(): boolean {
    return uiType === SCBConstants.UITYPE_PAD || DeviceHelper.isUltraScreenProduct();
  }

  async init(): Promise<void> {
    if (!this.isSupportBrightnessMultiInputFeature()) {
      return;
    }
    LOG.showInfo(TAG, 'init');
    try {
      if (this.context === undefined) {
        return;
      }
      this.helper = await dataShare.createDataShareHelper(this.context, this.uri);
      LOG.showInfo(TAG, `init helper ${this.helper}`);
      this.registerBrightness();
      this.getValue();
    } catch (error) {
      LOG.showError(TAG, `[init] error ${JSON.stringify(error)}`);
    }
  }

  registerBrightness(): void {
    if (!this.isSupportBrightnessMultiInputFeature()) {
      return;
    }
    try {
      this.helper?.on('dataChange', this.uri, () => {
        if (this.sliderChangeMode === 1) {
          LOG.showInfo(TAG, 'sliderChangeMode is moving, Ignor this change');
          return;
        }
        LOG.showInfo(TAG, 'after brightness datachange settings getValue' + this.sliderChangeMode);
        this.getValue();
      });
    } catch (error) {
      LOG.showError(TAG, `[registerBrightness] error ${JSON.stringify(error)}`);
    }
  }

  unregisterBrightness(): void {
    if (!this.isSupportBrightnessMultiInputFeature()) {
      return;
    }
    try {
      this.helper?.off('dataChange', this.uri, () => {
        LOG.showInfo(TAG, 'unregister brightness helper');
      });
    } catch (error) {
      LOG.showError(TAG, `[unRegisterBrightness] error ${JSON.stringify(error)}`);
    }
  }

  getValue(): void {
    if (!this.isSupportBrightnessMultiInputFeature()) {
      return;
    }
    let defaultValue: number = Number.parseInt(systemParameter.getSync('const.display.brightness.default'));
    if (this.context === undefined) {
      return;
    }
    let data = settings.getValueSync(this.context, CommonConstants.KEY_BRIGHTNESS_STATUS, JSON.stringify(defaultValue));
    brightnessValue.set(Number.parseInt(data));
  }

  getMin(): number {
    return parseInt(systemParameter.getSync('const.display.brightness.min'));
  }

  getMax(): number {
    return parseInt(systemParameter.getSync('const.display.brightness.max'));
  }

  countUIValue(physicsValue: number): number {
    let range = this.getMax() - this.getMin();
    let percentage = Math.pow(((physicsValue - this.getMin()) / range), 1 / 1.8);
    let brightnessUI = BRIGHTNESS_WIDTH * percentage;
    LOG.showInfo(TAG, `phsics value:${physicsValue};countUIValue percentage:${percentage};ui value:${brightnessUI}`);
    return brightnessUI;
  }

  countPhysicalValue(uiValue: number): number {
    let range = this.getMax() - this.getMin();
    let brightness = Math.pow(uiValue / range, 1.8) * range + this.getMin();
    LOG.showInfo(TAG, `count brightness value according to ui value: ${brightness};range: ${range}`);
    return Math.round(brightness);
  }

  /**
   * 获取亮度百分比
   *
   * @param uiValue 亮度条宽度
   * @returns 亮度百分比
   */
  public getBrightnessPercentage(uiValue: number): string {
    return (uiValue / BRIGHTNESS_WIDTH * 100).toFixed(0);
  }

  setBrightnessValue(value: number): void {
    if (!this.isSupportBrightnessMultiInputFeature()) {
      return;
    }
    try {
      Brightness.setValue(value);
    } catch (err) {
      LOG.showInfo(TAG, `setValue err: ${JSON.stringify(err)}`);
    }
  }

  getInterval(): number {
    try {
      let maxNum = this.getMax();
      let minNum = this.getMin();
      return Math.ceil((maxNum - minNum) / ADJUST_GEAR_NUM);
    } catch (err) {
      LOG.showInfo(TAG, `setValue err: ${JSON.stringify(err)}`);
      return 0;
    }
  }

  addValue(): number | undefined {
    if (!this.isSupportBrightnessMultiInputFeature()) {
      return undefined;
    }
    let currentNum: number = brightnessValue.get();
    let addNum: number = currentNum + this.getInterval();
    let maxNum: number = this.getMax();
    const physicsValue: number = addNum >= maxNum ? maxNum : addNum;
    this.setBrightnessValue(physicsValue);
    return physicsValue;
  }

  subValue(): number | undefined {
    if (!this.isSupportBrightnessMultiInputFeature()) {
      return undefined;
    }
    let currentNum: number = brightnessValue.get();
    let subNum: number = currentNum - this.getInterval();
    let minNum: number = this.getMin();
    const physicsValue: number = subNum <= minNum ? minNum : subNum;
    this.setBrightnessValue(physicsValue);
    return physicsValue;
  }
}

let mBrightnessManager = new BrightnessManager();

export default mBrightnessManager as BrightnessManager;