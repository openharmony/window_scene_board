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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ApsUtils } from '@ohos/frameworkwrapper';
// import apsManager from '@ohos.graphic.apsManager';

const TAG = 'SystemParamUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * Utils to get system params
 */
export class SystemParamUtils {
  public static getSystemParam(param: string, defVal: string): string {
    try {
      let val: string = systemParameterEnhance.getSync(param, defVal);
      log.showInfo(`get ${param} from system params.`);
      return val;
    } catch (error) {
      log.showInfo(`get system param fail cause: ${error}.`);
      return defVal;
    }
  }

  /**
   * 设置系统属性
   *
   * @param param 参数名
   * @param value 参数值
   * @returns 是否设置成功
   */
  public static setSystemParam(param: string, value: string): boolean {
    try {
      systemParameterEnhance.setSync(param, value);
      return true;
    } catch (error) {
      log.showError(`setSystemParam failed. code: ${error.code}`);
    }
    return false;
  }

  /**
   * @description 判断当前产品是否为2D产品,需要关闭并隐藏某些特性,比如锁屏编辑、熄屏显示
   * @returns true:2D产品,关闭并隐藏特性; false:非2D产品,打开并展示特性
   */
  public static isHddProduct(): boolean {
    try {
      return systemParameterEnhance.getSync('const.scene_board.off_personalization_feature', 'false') === 'true';
    } catch (e) {
      log.showError('Get Hdd Product Param Error');
      return false;
    }
  }

  /**
   * 通过APS设置改成经是否接入120Hz场景
   *
   * @param isOpen: true 打开 / false 关闭
   */
  public static setHighFrame(isOpen: boolean): void {
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, isOpen ? 1 : 0);
  }
}
