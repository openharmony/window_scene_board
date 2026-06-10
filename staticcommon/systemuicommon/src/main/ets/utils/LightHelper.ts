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

import fs from '@ohos.file.fs';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemParamUtils, GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'LightHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class LightHelper {
  /**
   * 标记文件。存在该文件，表示当前a为使用中的主题，a、b目录同一时刻只能有一个存在flag文件。
   */
  public static readonly FLAG_PATH_A: string = '/data/themes/a/app/flag';
  /**
   * 沙箱文件路径a
   */
  public static readonly SANDBOX_PATH_A: string = '/data/themes/a/system/description.json';
  /**
   * 标记文件。存在该文件，表示当前b为使用中的主题，a、b目录同一时刻只能有一个存在flag文件。
   */
  public static readonly FLAG_PATH_B: string = '/data/themes/b/app/flag';
  /**
   * 沙箱文件路径b
   */
  public static readonly SANDBOX_PATH_B: string = '/data/themes/b/system/description.json';
  private static readonly ORIGIN_VALUE: string = 'origin';
  private static readonly PRESET_VALUE: string = 'preset';
  private static readonly PRESET_FRAGMENT_VALUE: string = 'presetFragment';
  private static readonly ONLINE_VALUE: string = 'online';
  private static readonly HEX_NUMBER: number = 16;
  private static readonly IS_HDD_PRODUCT = SystemParamUtils.isHddProduct();
  private isPresetTheme: boolean = this.checkIsPresetTheme();
  private isShowLight: boolean = this.checkIsShowPointLight();


  public getIsPresetTheme(): boolean {
    return this.isPresetTheme;
  }

  public getIsShowLight(): boolean {
    return this.isShowLight;
  }

  public onThemeChange(): void {
    this.isPresetTheme = this.checkIsPresetTheme();
    this.isShowLight = this.checkIsShowPointLight();
  }

  private checkIsPresetTheme(): boolean {
    let isPreSet: boolean = true;
    log.showInfo('checkIsPresetTheme accessSync start');
    try {
      const configPath: string = fs.accessSync(LightHelper.FLAG_PATH_A) ? LightHelper.SANDBOX_PATH_A : LightHelper.SANDBOX_PATH_B;
      if (!fs.accessSync(configPath)) {
        log.showError(`theme description file not exist`);
        return isPreSet;
      }
      const descriptionString: string = fs.readTextSync(configPath);
      let description: object = JSON.parse(descriptionString);
      let origin: string = description[LightHelper.ORIGIN_VALUE] ?? '';
      if (origin === LightHelper.PRESET_VALUE || origin === LightHelper.PRESET_FRAGMENT_VALUE) {
        isPreSet = true;
      } else if (origin === LightHelper.ONLINE_VALUE) {
        isPreSet = false;
      } else {
        isPreSet = true;
      }
    } catch (e) {
      log.showError(`checkIsPresetTheme error ${e?.message}`);
    }
    log.showInfo(`checkIsPresetTheme end isPreSet=${isPreSet}`);
    return isPreSet;
  }


  private checkIsShowPointLight(): boolean {
    if (LightHelper.IS_HDD_PRODUCT) {
      log.showInfo('checkIsShowPointLight hdd product');
      return false;
    }
    if (this.isPresetTheme) {
      log.showInfo('checkIsShowPointLight preset theme');
      return true;
    }
    let lightColorResId = $r('app.color.Control_center_light_color').id;
    let transparentResId = $r('app.color.transparent').id;
    let lightColor = GlobalContext.getContext().
      resourceManager?.getColorSync(lightColorResId)?.toString(LightHelper.HEX_NUMBER);
    let transparent = GlobalContext.getContext().
      resourceManager?.getColorSync(transparentResId)?.toString(LightHelper.HEX_NUMBER);
    // 非官方预置主题且光的颜色属性为默认值或光的颜色属性为透明，不显示光效
    if (lightColor === transparent) {
      log.showInfo('checkIsShowPointLight lightColor is transparent');
      return false;
    }
    return true;
  }

  /**
   * Get instance of ThemeStyleManager.
   *
   * @returns instance
   */
  public static getInstance(): LightHelper {
    if (globalThis.LightHelperInstance == null) {
      globalThis.LightHelperInstance = new LightHelper();
    }
    return globalThis.LightHelperInstance;
  }
}
