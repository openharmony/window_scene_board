/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { CommonConstants } from '../CommonConstants';
import { GetEmergencyThermalLayoutFromConfig } from './GetEmergencyThermalLayoutFromConfig';
import { EmergencyThermalDefaultAppDto } from '../bean/EmergencyThermalDefaultAppDto';
import {
  AppItemInfo,
  launcherAbilityManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import DefaultEmergencyThermalLayoutInfo from '../bean/DefaultEmergencyThermalLayoutInfo';
import { EmergencyThermalAppVo } from '../bean/EmergencyThermalAppVo';

/**
 * Emergency Thermal function layout configuration
 */
const TAG = 'EmergencyThermalLayoutConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class EmergencyThermalLayoutConfig {

  private static mInstance: EmergencyThermalLayoutConfig;

  public static FILE_URL = 'etc/hw_launcher_emergency_thermal_default_apps.json';

  public static DEFAULT_FILE_NAME = 'emergencyThermalDefaultApps.json';

  private constructor() {}

  /**
   * Get an instance of the workspace function layout configuration
   */
  static getInstance(): EmergencyThermalLayoutConfig {
    if (EmergencyThermalLayoutConfig.mInstance == null) {
      EmergencyThermalLayoutConfig.mInstance = new EmergencyThermalLayoutConfig();
    }
    return EmergencyThermalLayoutConfig.mInstance;
  }

  /**
   * Get layout data
   * @param type: 1 and 2 are supported, 1 for emergency mode and 2 for thermal safety mode
   * @param layoutVo: list of layouts for receiving configuration
   * @returns
   */
  async initLayoutInfo(type: number, layoutVo: EmergencyThermalAppVo[]): Promise<void> {
    try {
      const configLayoutInfo = await this.getAllLayoutConfigFile();
      await this.checkAndInitLayout(configLayoutInfo.appsInfo, type, layoutVo);

    } catch (error) {
      log.showError(`promise getAllLayoutConfigFile failed, error code: ${error.code}, message: ${error.message}.`);
    }
  }

  private async checkAndInitLayout(layoutInfo: EmergencyThermalDefaultAppDto[], type: number,
    layoutVo: EmergencyThermalAppVo[]): Promise<void> {
    let apps: AppItemInfo[] = await launcherAbilityManager.getLauncherAbilityList(launcherAbilityManager.getUserId());
    if (!CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      layoutVo.splice(0);
      layoutInfo.filter(item => item.type === type)
        .forEach(element => {
          this.filterAndInitLayoutItem(apps, element, layoutVo);
        });
    }
    if (layoutVo.length > CommonConstants.MAX_APP_NUMBER) {
      layoutVo.splice(CommonConstants.MAX_APP_NUMBER);
    }
  }

  private filterAndInitLayoutItem(apps: AppItemInfo[], item: EmergencyThermalDefaultAppDto,
    rstList: EmergencyThermalAppVo[]): void {
    if (CheckEmptyUtils.isEmptyArr(apps)) {
      log.showError('filterLayoutItem apps is null.');
      return;
    }
    let installInfo = apps.find((appItem: AppItemInfo) => appItem.bundleName === item.bundleName &&
      appItem.abilityName === item.abilityName);

    if (installInfo) {
      let tmpVo: EmergencyThermalAppVo = new EmergencyThermalAppVo();
      tmpVo.appItem = installInfo;
      tmpVo.defaultEmergencyApp = NumberConstants.CONSTANT_NUMBER_ONE;
      rstList.push(tmpVo);
    }
  }

  /**
   * 获取预制的布局文件
   *
   * @returns 布局信息
   */
  protected async getAllLayoutConfigFile(): Promise<DefaultEmergencyThermalLayoutInfo> {
    return GetEmergencyThermalLayoutFromConfig.getInstance().getLayoutFromConfigFile(
      EmergencyThermalLayoutConfig.FILE_URL, EmergencyThermalLayoutConfig.DEFAULT_FILE_NAME);
  }
}
