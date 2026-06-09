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
import { Logger, LogDomain } from '@ohos/basicutils';
import { Singleton } from '../utils/Singleton';
import { PluginParseMgr } from '../plugin/PluginParseManager';
import { PluginConstants } from '@ohos/frameworkwrapper';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import type { PluginInfo } from '@ohos/frameworkwrapper';

const TAG = 'StatusBarIconConfig';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export class StatusBarIconConfig {
  @Singleton.decorate()
  public static get instance(): StatusBarIconConfig { return new StatusBarIconConfig(); }

  /**
   * 不加载的状态栏图标
   */
  private unloadedIcon: string[] = [];

  init(): void {
    this.initDeviceUnloadedIcon();
  }

  /**
   * 读取CCM上的配置，获取不加载的状态栏图标
   */
  private initDeviceUnloadedIcon(): void {
    let value: string = '';
    try {
      value = systemParameterEnhance.getSync('const.product.status_bar_unsupported_icon', '');
      this.unloadedIcon = value.split(',');
      log.showInfo(TAG, `get unLoad icon ${this.unloadedIcon}`);
    } catch (error) {
      log.error(`getUnloadedIcon error:`, error);
    }
  }

  /**
   * 创建状态栏图标列表
   */
  createStatusBarIconList(): PluginInfo[] {
    return PluginParseMgr.getLocalPluginInfo(PluginConstants.ACTION_PLUGIN_STATUS_BAR)
      .filter((icon) => !this.unloadedIcon.includes(icon.getSlot()));
  }
}