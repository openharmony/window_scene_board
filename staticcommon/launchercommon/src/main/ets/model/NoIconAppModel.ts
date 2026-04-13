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
import { bundleResourceManager } from '@kit.AbilityKit';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { AppItemInfo, CommonConstants } from '../TsIndex';

const TAG = 'NoIconAppModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 当前包管理没有接口能获取到无图标应用信息，暂时采用白名单管控，5.1包管理提供接口后整改删除
// 注意： 此白名单只包含有卡片的无图标应用，不是全量的无图标应用，请勿误用
const NO_ICON_APP_BUNDLE: string[] = [
  'com.ohos.audioaccessorymanager',
  'com.ohos.sceneboard',
  'com.ohos.musicservice',
  'com.ohos.suggestion',
  'com.ohos.systemmanagerform',
  'com.ohos.ai.familyassistant'
];

export class NoIconAppModel {
  private static instance: NoIconAppModel;
  private noIconAppInfoMap: Map<string, NoIconAppInfo> = new Map();

  static getInstance(): NoIconAppModel {
    if (!NoIconAppModel.instance) {
      NoIconAppModel.instance = new NoIconAppModel();
    }
    return NoIconAppModel.instance;
  }

  /*
   * clear noIconAppInfoMap
   *
   */
  public clearCache(): void {
    this.noIconAppInfoMap = new Map();
  }

  public getNoIconAppItemBundleList(): string[] {
    return NO_ICON_APP_BUNDLE;
  }

  public checkNoIconAppItem(bundle: string): boolean {
    return NO_ICON_APP_BUNDLE.includes(bundle);
  }

  public getNoIconAppItemByBundle(bundle: string): AppItemInfo | undefined {
    let appItem: AppItemInfo = new AppItemInfo();
    if (CheckEmptyUtils.checkStrIsEmpty(bundle) || !NO_ICON_APP_BUNDLE.includes(bundle)) {
      log.showInfo(`getNoIconAppItemByBundle bundle is empty or is not noIconApp, bundleName: ${bundle}`);
      return undefined;
    }
    appItem.bundleName = bundle;
    appItem.applicationName = this.updateNoIconAppInfo(bundle).label;
    if (CheckEmptyUtils.checkStrIsEmpty(appItem.applicationName)) {
      return undefined;
    }
    return appItem;
  }

  public getNoIconAppItemInfo(): AppItemInfo[] {
    let noIconAppList: AppItemInfo[] = [];
    NO_ICON_APP_BUNDLE.forEach(bundle => {
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = bundle;
      // 适配一键锁屏别名
      if (bundle === CommonConstants.SCENEBOARD_BUNDLE) {
        appItem.applicationName = ResourceManager.getInstance().getStringByName('lock_screen');
      } else {
        appItem.applicationName = this.updateNoIconAppInfo(bundle).label;
      }
      if (CheckEmptyUtils.checkStrIsEmpty(appItem.applicationName)) {
        return;
      }
      noIconAppList.push(appItem);
    });
    log.showInfo(`current noIconAppList:${noIconAppList.length} `);
    return noIconAppList;
  }

  public checkIfBundleIsNoIconApp(bundle: string): boolean {
    return NO_ICON_APP_BUNDLE.includes(bundle);
  }

  public updateNoIconAppInfo(bundle: string): NoIconAppInfo {
    let noIconAppInfo: NoIconAppInfo = new NoIconAppInfo();
    if (this.noIconAppInfoMap.has(bundle)) {
      return this.noIconAppInfoMap.get(bundle) as NoIconAppInfo;
    }
    try {
      let resourceInfo: bundleResourceManager.BundleResourceInfo = bundleResourceManager.getBundleResourceInfo(bundle);
      log.showInfo(`get NoIconApp info, bundle: ${bundle}, label: ${resourceInfo.label}`);
      noIconAppInfo.label = resourceInfo.label;
      this.noIconAppInfoMap.set(bundle, noIconAppInfo);
    } catch (error) {
      log.error('getBundleResourceInfo failed: ', error);
    }
    return noIconAppInfo;
  }
}

export class NoIconAppInfo {
  public label: string = '';
}