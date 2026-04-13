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

import { bundleManager } from '@kit.AbilityKit';
import Base from '@ohos.base';
import CommonEventManager from '@ohos.commonEventManager';
import { ORIGIN_ONLINE, ORIGIN_PRESET_FRAGMENT, ThemeResource, TServiceApi } from '@ohos/themeservice_inner_api';
import { FileUtil, NullableType, Singleton, TsLog } from '@ohos/themeservicebase';
import { ThemeCacheInfo } from '../../cache/ThemeInfoStoreCache';
import {
  IgnoreUpdateThemeInfoCache,
  UpdateThemeInfoCache,
  UpdateThemeRefreshTimeCache,
} from '../../cache/UpdateThemeInfoCache';
import { CommonEvent } from '../../util/CommonEvent';
import { TSPathUtils } from '../../util/TSPathUtils';
import { ThemeAppStatusService } from '../api/ThemeAppStatusService';
import { deleteOnlineThemeService } from './DeleteOnlineThemeServiceImpl';
import { activateThemeService } from './ThemeActivateServiceImpl';
import { themeInfoService } from './ThemeInfoServiceImpl';
import { TsRecommendCache } from '../../cache/TsRecommendCache';

const TAG: string = `ThemeAppStatusServiceImpl`;

export default class ThemeAppStatusServiceImpl implements ThemeAppStatusService {
  private readonly themeAppBundleName: string = 'com.ohos.thememanager';

  private subscriber?: CommonEventManager.CommonEventSubscriber;

  private readonly subscriberInfo: CommonEventManager.CommonEventSubscribeInfo = {
    events: [
    // 应用卸载
      CommonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED,
      // 应用完全卸载
      CommonEventManager.Support.COMMON_EVENT_PACKAGE_FULLY_REMOVED,
    ]
  };

  /**
   * 判断应用是否安装
   *
   * @param bundleName 应用包名
   * @returns true表示已安装, 反之未安装
   */
  async getBundleStatus(bundleName: string): Promise<boolean> {
    let bundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
    try {
      let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfo(bundleName, bundleFlags);
      if (!bundleInfo) {
        TsLog.error(TAG, 'getBundleInfo failed');
        return false;
      } else {
        // 已安装主题App
        TsLog.info(TAG, `getBundleInfo successfully: ${bundleName}`);
        return true;
      }
    } catch (err) {
      TsLog.error(TAG, `getBundleInfo failed:`, err);
      return false;
    }
  }

  /**
   * 注册卸载app公共事件监听
   */
  registerUninstallSubscriber(): void {
    TsLog.info(TAG, `registerSubscriber enter`);
    CommonEventManager.createSubscriber(this.subscriberInfo).then((res) => {
      this.subscriber = res;
      if (!this.subscriber) {
        TsLog.error(TAG, `Failed to subscribe to package remove event, subscriber is undefined.`);
        return;
      }
      try {
        CommonEventManager.subscribe(this.subscriber, (err, data) => this.handleSubscriberCallback(err, data));
        TsLog.info(TAG, `Successfully subscribe remove app event.`);
      } catch (err) {
        TsLog.error(TAG, 'commonEventManager subscriber error', err);
      }
    });
  }

  private handleSubscriberCallback(err: Base.BusinessError, data: CommonEventManager.CommonEventData): void {
    if (err) {
      TsLog.error(TAG, `Failed to receive commonEvent ${data?.event}. Code is ${err.code}, message is ${err.message}`);
      return;
    }
    TsLog.info(TAG, `receive commonEvent: ${data?.event}, receive remove app: ${data?.bundleName}`);
    try {
      this.subscriberInfo.events.find(async event => {
        if (data?.event !== event || data?.bundleName !== this.themeAppBundleName) {
          return;
        }
        TsLog.info(TAG, `receive remove app: ${data?.bundleName} event`);
        this.uninstallThemeAppProcess().finally(() => {
          CommonEvent.publish(CommonEvent.UNINSTALL_THEME_APP);
          TsLog.info(TAG, `publish TS handle UninstallThemeApp event.`);
        });
      })
    } catch (err) {
      TsLog.error(TAG, `handleSubscriberCallback catch exception.`, err);
    }
  }

  private async uninstallThemeAppProcess(): Promise<void> {
    // 判断主题app是否存在
    if (await this.getBundleStatus(this.themeAppBundleName)) {
      TsLog.warning(TAG, `getBundleStatus: ${this.themeAppBundleName} true`);
      return;
    }
    // 收到主题app卸载事件,恢复出厂主题
    await activateThemeService().activateDefaultTheme();
    await activateThemeService().activateDefaultFont();
    // 删除所有在线主题、上云主题缓存数据
    await this.deleteAllOnlineThemes();
    // 删除share/online目录内在线主题包资源
    FileUtil.trimDirAsync(TSPathUtils.getTsOnlineThemePath());
    // 删除更新信息的所有缓存
    await UpdateThemeInfoCache.getInstance().clear();
    await IgnoreUpdateThemeInfoCache.getInstance().clear();
    await UpdateThemeRefreshTimeCache.getInstance().clear();
    // 清除外屏在线主题、上云主题缓存数据
    await TServiceApi.subScreen().removeOnlineThemes();
    // 清除在线推荐主题缓存数据
    await TsRecommendCache.getInstance().clear();
  }

  private async deleteAllOnlineThemes(): Promise<void> {
    let themeCacheInfo: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
    if (!themeCacheInfo) {
      TsLog.warning(TAG, `themeCacheInfo is null`);
      return;
    }
    let onlineThemeResources: ThemeResource[] = [];
    try {
      for (const theme of themeCacheInfo) {
        if (theme.originType === ORIGIN_ONLINE || theme.originType === ORIGIN_PRESET_FRAGMENT) {
          // 过滤所有在线主题和上云主题
          onlineThemeResources.push(new ThemeResource(theme.id, 'theme'));
        }
      }
      TsLog.info(TAG, `online theme resource: ${onlineThemeResources.length}`);
      // 删除在线主题和上云主题包资源
      if (onlineThemeResources.length > 0) {
        await deleteOnlineThemeService.get().deleteTheme(onlineThemeResources);
      }
    } catch (error) {
      TsLog.error(TAG, `deleteAllOnlineThemes catch exception.`, error);
    }
  }
}

export const themeAppStatusService: Singleton<ThemeAppStatusService> =
  new Singleton<ThemeAppStatusService>(() => new ThemeAppStatusServiceImpl());
