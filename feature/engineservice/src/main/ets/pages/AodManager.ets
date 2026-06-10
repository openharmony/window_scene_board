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

import lazy fs from '@ohos.file.fs';

import lazy { WallpaperUtils } from './WallpaperUtils';
import lazy { BusinessError } from '@ohos.base';
import lazy commonEventManager from '@ohos.commonEventManager';
import lazy settings from '@ohos.settings';
import { Log } from '../utils/Log';
import { JsonFileUtil } from '../utils/JsonFileUtil';
import { Constants } from '../utils/Constants';

/**
 * 全屏AOD
 */
const FULL_AOD: string = 'fullScreen';

/**
 * 半屏AOD一镜到底
 */
const PARTIAL_AOD_LONGTAKE: string = 'customClock';

/**
 * 在线半屏AOD一镜到底
 */
const ONLINE_PARTIAL_AOD_LONGTAKE: string = 'digitalClock';

/**
 * AOD开关状态落盘数据库key值
 */
const AOD_SETTINGS_KEY: string = 'settings.sceneboard.aod_state';

/**
 * AOD开关状态变化事件监听
 */
const CUSTOM_EVENT_AOD_SETTING_CHANGE: string = 'custom.event.AOD_SETTING_CHANGE';

const TAG: string = 'AodManager';

/**
 * AOD管理类
 *
 * @since 2024-08-22
 */
export class AodManager {
  private subscriber: commonEventManager.CommonEventSubscriber | undefined;

  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [CUSTOM_EVENT_AOD_SETTING_CHANGE],
    publisherBundleName: 'com.ohos.sceneboard',
  };

  /**
   * 是否处理半屏AOD一镜到底
   *
   * @return true 半屏AOD一镜到底 false 其他类型，可能是全屏AOD或者半屏非一镜到底
   */
  public isTransitPartialAod(): boolean {
    let aodManifestPath: string = WallpaperUtils.getAodManifestPath();
    try {
      if (fs.accessSync(aodManifestPath)) {
        let aodType: string = JsonFileUtil.getManifestType(aodManifestPath);
        Log.info(TAG, `Get AOD type ${aodType}`);
        return aodType === PARTIAL_AOD_LONGTAKE;
      }
      return false;
    } catch (e) {
      Log.error(TAG, `isTransitPartialAod error: ${e?.code}}`);
      return false;
    }
  }

  /**
   * 是否处理半屏AOD一镜到底
   *
   * @return true 半屏AOD一镜到底 false 其他类型，可能是全屏AOD或者半屏非一镜到底
   */
  public isOnlinePartialAod(): boolean {
    let aodManifestPath: string = WallpaperUtils.getAodWallpaperPath();
    try {
      if (fs.accessSync(aodManifestPath)) {
        let aodType: string = JsonFileUtil.getManifestType(aodManifestPath);
        Log.info(TAG, `isOnlinePartialAod Get AOD type ${aodType}`);
        return aodType === ONLINE_PARTIAL_AOD_LONGTAKE;
      }
      return false;
    } catch (e) {
      Log.error(TAG, `isOnlinePartialAod error: ${e?.code}}`);
      return false;
    }
  }

  /**
   * 判断是否为全屏AOD
   *
   * @returns true 是 false 否
   */
  public isFullAod(): boolean {
    let aodManifestPath: string = WallpaperUtils.getAodManifestPath();
    try {
      if (fs.accessSync(aodManifestPath)) {
        let aodType: string = JsonFileUtil.getManifestType(aodManifestPath);
        return aodType === FULL_AOD;
      }
      return false;
    } catch (e) {
      Log.error(TAG, `isFullAod error: ${e?.code}}`);
      return false;
    }
  }

  /**
   * 获取当前设置中AOD开关状态
   *
   * @returns 1 开启 0 关闭
   */
  public getAodSwitchState(): number {
    try {
      // 开机时通过getcontext接口获取的context不正确，需从engineServiceAbility直接获取
      let context: Context | undefined = AppStorage.get<Context>('AodSettingsSwitchStatusContext');
      if (context === undefined) {
        Log.warn(TAG, 'getAodSwitchState context is undefined');
        return Constants.INITIAL_VALUE;
      }
      let aodSettingState: object = JSON.parse(
        settings.getValueSync(context, AOD_SETTINGS_KEY, '', settings.domainName.USER_SECURITY));
      if (Number.isNaN(aodSettingState) || !aodSettingState) {
        Log.warn(TAG, 'Failed to read proper AOD switch state from settings');
        return Constants.INITIAL_VALUE;
      }
      return aodSettingState['switch'];
    } catch (err) {
      Log.error(TAG, `Error on getting AOD switch state ${err?.message}`);
      return Constants.INITIAL_VALUE;
    }
  }

  /**
   * 初始化监听AOD开关状态变化
   *
   * @param eventExecution 监听生效执行函数
   */
  public initAodSettingsSubscriber(eventExecution: () => void): void {
    try {
      this.subscriber = commonEventManager.createSubscriberSync(this.subscribeInfo);
      if (!this.subscriber) {
        Log.error(TAG, 'createSubscriber failed');
        return;
      }
      commonEventManager.subscribe(this.subscriber, async (err: BusinessError,
        eventData: commonEventManager.CommonEventData) => {
        if (err) {
          Log.error(TAG, 'initAodSettingsSubscriber subscriber err code is ${err?.code}, message is ${err?.message}');
        } else {
          if (!eventData) {
            Log.error(TAG, 'System error,eventData is null');
            return;
          }
          eventExecution();
        }
      });
    } catch (error) {
      Log.error(TAG, 'createSubscriber failed, code is ${error?.code}, message is ${error?.message}');
    }
  }

  /**
   * 销毁监听AOD开关状态变化
   */
  public destroyAodSettingsSubscriber(): void {
    try {
      commonEventManager.unsubscribe(this.subscriber, () => {
        Log.info(TAG, 'destroyAodSettingsSubscriber success');
      });
    } catch (error) {
      Log.error(TAG, `destroyAodSettingsSubscriber failed, code is ${error?.code}, message is ${error?.message}`);
    }
  }
}