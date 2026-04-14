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
import {
  CheckEmptyUtils,
  FileUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ILayoutConfig } from './ILayoutConfig';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { BusinessError } from '@ohos.base';
import { CommonConstants, ConfigParseUtil } from '../TsIndex';
import DefaultGestureDockLayoutInfo from '../configs/DefaultGestureDockLayoutInfo';
import util from '@ohos.util';
import type ctx from '@ohos.app.ability.common';

const TAG: string = 'GestureDockModeConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * GestureDock layout mode configuration
 */
export class GestureDockModeConfig extends ILayoutConfig {
  /**
   * The index of GestureDock layout mode configuration
   */
  static GESTURE_DOCK_MODE_CONFIG = 'GestureDockModeConfig';
  private readonly IS_SUPPORT_GESTURE_DOCK: boolean = true;
  private readonly RECENT_APP_MAX_COUNT_GESTURE_DOCK: number = 3;
  private readonly RESIDENT_APP_MAX_COUNT_GESTURE_DOCK: number = 15;

  public constructor() {
    super();
  }

  public initConfig(): void {
  }

  public getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  public getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_MODE;
  }

  public getConfigName(): string {
    return GestureDockModeConfig.GESTURE_DOCK_MODE_CONFIG;
  }

  public getPersistConfigJson(): string {
    return JSON.stringify({});
  }

  /**
   * Get recent missions instance
   *
   * @return {GestureDockModeConfig} GestureDockModeConfig instance
   */
  public static getInstance(): GestureDockModeConfig {
    return SingletonHelper.getInstance(GestureDockModeConfig, TAG);
  }


  /**
   *  Get is support gesture dock
   *
   * @return {boolean} value
   */
  public getIsSupportGestureDock(): boolean {
    let isSupportGestureDock = this.IS_SUPPORT_GESTURE_DOCK;
    try {
      let isSupportStr = systemParameterEnhance.getSync('const.recent.is_support_gesture_dock');
      isSupportGestureDock = isSupportStr.trim().toLocaleLowerCase() === 'true';
      log.showInfo(`read config file getResidentAppMaxCount: ${isSupportStr}.`);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      log.showWarn(`read config file failed, tag: getIsSupportGestureDock, error code: ${code}, message: ${message}.`);
    }
    return isSupportGestureDock;
  }

  /**
   *  Get recent app max count
   *
   * @return {number} limit value
   */
  public getRecentAppMaxCount(): number {
    let recentAppMaxCount = this.RECENT_APP_MAX_COUNT_GESTURE_DOCK;
    try {
      let maxNumStr = systemParameterEnhance.getSync('const.recent.recent_app_max_count_gesture_dock');
      log.showInfo(`read config file getRecentAppMaxCount: ${maxNumStr}.`);
      recentAppMaxCount = parseInt(maxNumStr);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      log.showWarn(`read config file failed, tag: getRecentAppMaxCount, error code: ${code}, message: ${message}.`);
    }
    return recentAppMaxCount;
  }

  /**
   *  Get resident app max count
   *
   * @return {number} limit value
   */
  public getResidentAppMaxCount(): number {
    let residentAppMaxCount = this.RESIDENT_APP_MAX_COUNT_GESTURE_DOCK;
    try {
      let maxNumStr = systemParameterEnhance.getSync('const.recent.resident_app_max_count_gesture_dock');
      residentAppMaxCount = parseInt(maxNumStr);
      log.showInfo(`read config file getResidentAppMaxCount: ${maxNumStr}.`);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      log.showWarn(`read config file failed, tag: getResidentAppMaxCount, error code: ${code}, message: ${message}.`);
    }
    return residentAppMaxCount;
  }

  /**
   *  Get resident app layout config
   *
   * @return {json} value
   */
  public async getResidentAppLayoutConfig(): Promise<DefaultGestureDockLayoutInfo | undefined> {
    log.info('getResidentAppLayoutConfig -> start.');
    let cfgFiles: string = '';
    let gestureDockLayout: DefaultGestureDockLayoutInfo | undefined;
    try {
      cfgFiles = await ConfigParseUtil.getConfig('etc/gesture_dock_info.json');
      gestureDockLayout = FileUtils.readJsonFile(cfgFiles);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      log.showWarn(`read config file failed, tag: getResidentAppLayoutConfig, error code: ${code}, message: ${message}.`);
    }
    if (CheckEmptyUtils.isEmpty(gestureDockLayout)) {
      try {
        gestureDockLayout = await this.getConfigFromFile('gesture_dock_info.json');
        log.info(`getResidentAppLayoutConfig legnth :${gestureDockLayout?.layoutInfo.length}`);
      } catch (error) {
        log.showError(`getResidentAppLayoutConfig readJsonFile is error:${(error as BusinessError).message}`);
      }
    }
    return gestureDockLayout;
  }

  private async getConfigFromFile(fileName: string): Promise<DefaultGestureDockLayoutInfo | undefined> {
    let defaultConfig: DefaultGestureDockLayoutInfo | undefined;
    try {
      await (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).resourceManager
        .getRawFileContent(fileName).then(value => {
          let textDecoder = new util.TextDecoder('utf-8', { ignoreBOM: true });
          const configFromFile = textDecoder.decodeWithStream(value, { stream: false });
          if (configFromFile) {
            defaultConfig = JSON.parse(configFromFile);
          }
          return defaultConfig;
        }).catch((error: Error) => {
          log.showError('getRawFileContent promise error is ' + error);
        });
    } catch (error) {
      log.showError(`promise getRawFileContent failed, error code: ${error.code}, message: ${error.message}.`);
    }
    return defaultConfig;
  }
}