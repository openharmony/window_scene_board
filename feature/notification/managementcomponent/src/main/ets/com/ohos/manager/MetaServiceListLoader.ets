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
import i18n from '@ohos.i18n';
import bundleManager from '@ohos.bundle.bundleManager';
import bundleResourceManager from '@ohos.bundle.bundleResourceManager';
import intl from '@ohos.intl';
import { LogDomain, LogHelper, SingletonHelper } from '../common/BasicCommon';
import { AppItem } from '../vm/appLstComponentViewModel';
import { MetaServiceStateVM } from '../vm/MetaServiceListVM';
import { Pinyin } from '@ohos/frameworkpinyin/src/main/ets/utils/Pinyin';
import { DeviceHelper } from '../common/DeviceHelper';

const TAG = 'ManagementComponent-MetaServiceListLoader';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class MetaServiceListLoader {
  public static get = SingletonHelper.createFactory(() => new MetaServiceListLoader());
  private metaServiceStateVM: MetaServiceStateVM = MetaServiceStateVM.get();
  private itemKey: number = 0;
  private lastSystemLocale: string = '';
  public metaServiceCacheMap: Map<number, AppItem> = new Map();

  /**
   * 获取元服务列表
   * @isRefresh 是否刷新
   * @returns 元服务列表
   */
  async getMetaServiceList(isRefresh: boolean = false): Promise<AppItem[]> {
    if (DeviceHelper.isPC()) {
      return [];
    }
    if (!this.metaServiceStateVM.isLoginAccount) {
      log.showInfo('not login account');
      return [];
    }
    log.showInfo('getMetaServiceList, isRefresh: %{public}s', isRefresh);
    const currentLocale: string = i18n.System.getSystemLocale();
    const isSameLocale: boolean = currentLocale === this.lastSystemLocale;
    if (!isRefresh && this.metaServiceCacheMap.size > 0 && isSameLocale) {
      // 不需要刷新 && 存在缓存数据 && 语言没有切换，则不需要重新获取数据，直接使用缓存
      log.showInfo('use cache');
      return Array.from(this.metaServiceCacheMap.values());
    }

    try {
      const result = await Promise.all([
        bundleManager.getAllBundleInfo(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION),
        bundleResourceManager.getAllBundleResourceInfo(bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_ICON |
        bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL)
      ]);
      const bundleInfos: bundleManager.BundleInfo[] = result[0];
      const bundleResourceInfos: bundleResourceManager.BundleResourceInfo[] = result[1];
      log.showInfo(`bundleInfos len: ${bundleInfos.length}, bundleResourceInfos len: ${bundleResourceInfos.length}`);
      this.metaServiceCacheMap.clear();
      await this.mergeAppList(bundleInfos, bundleResourceInfos);
      this.lastSystemLocale = currentLocale;
    } catch (err) {
      log.error('getMetaServiceList failed', err);
    }
    this.sortAppList();
    log.showInfo('getMetaServiceList success');
    return Array.from(this.metaServiceCacheMap.values());
  }

  /**
   * 合并元服务信息
   * @param allBundleResourceList 包信息
   * @param allResourceInfo 包资源信息
   * @returns 元服务信息
   */
  private async mergeAppList(bundleInfos: bundleManager.BundleInfo[],
    bundleResourceInfos: bundleResourceManager.BundleResourceInfo[]): Promise<void> {
    bundleInfos.forEach(element => {
      if (!element.appInfo || element.appInfo.bundleType !== 1) {
        return;
      }
      const resourceInfo =
        bundleResourceInfos.find(item => item.bundleName === element.appInfo.name &&
          item.appIndex === element.appIndex);
      if (!resourceInfo) {
        log.showInfo(`no resource info for ${element.appInfo.name}, ${element.appIndex}`);
        return;
      }
      if (this.metaServiceCacheMap.has(element.appInfo.uid)) {
        return;
      }
      this.metaServiceCacheMap.set(element.appInfo.uid, this.convertItem(resourceInfo, element.appInfo.uid));
    });
    log.showInfo(`metaSerive size is ${this.metaServiceCacheMap.size}`);
  }

  /**
   * 返回排序后的列表
   * @returns 排序后的列表
   */
  private sortAppList(): void {
    if (this.metaServiceCacheMap.size === 0) {
      return;
    }
    const sortedEntries = Array.from(this.metaServiceCacheMap.entries()).sort((a, b) => {
      // 英文模式下同样按照首字母排序
      const sortLocale = this.lastSystemLocale === 'en-Latn-CN' ? 'zh-CN' : this.lastSystemLocale;
      const collator = new intl.Collator(sortLocale);
      return collator.compare(a[1].sortTag, b[1].sortTag);
    })
    this.metaServiceCacheMap = new Map(sortedEntries);
  }

  private getSortTag(label: string): string {
    const pinyinUtil: Pinyin = new Pinyin();
    let sortTag = pinyinUtil.getFullChars(label);
    if (label.charCodeAt(0) > 255) {
      // 拼音中间用空格分开
      sortTag = sortTag.replace(/[A-Z]/g, ' $&').trim();
    }
    if (label.charCodeAt(0) <= 255) {
      sortTag = `${sortTag[0]}[${sortTag.slice(1)}`;
    }
    return sortTag.toUpperCase();
  }

  /**
   * 删除uid对应项
   * @param uid 应用uid
   */
  async deleteItem(uid: number): Promise<void> {
    this.metaServiceCacheMap.delete(uid);
  }

  /**
   * 更新uid对应项
   * @param uid 应用uid
   */
  async updateItem(uid: number): Promise<void> {
    const appItem = this.metaServiceCacheMap.get(uid);
    if (appItem) {
      this.metaServiceCacheMap.set(uid, await this.getAppItem(appItem.appBundleName, appItem.appIndex));
    }
  }

  /**
   * 获取单条AppItem信息
   * @param bundleName 包名
   * @param appIndex 分身索引
   * @returns 单条AppItem信息
   */
  private async getAppItem(bundleName: string, appIndex: number): Promise<AppItem> {
    const appItem: AppItem = new AppItem();
    try {
      const flags = bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_ICON |
      bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL;
      const bundleResourceInfo: bundleResourceManager.BundleResourceInfo =
        await bundleResourceManager.getBundleResourceInfo(bundleName, flags, appIndex);
      const bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfo(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);

      if (!bundleInfo || !bundleInfo.appInfo ||
        bundleInfo.appInfo.bundleType !== bundleManager.BundleType.ATOMIC_SERVICE) {
        log.error(`bundleInfo is invalid`);
        return appItem;
      }
      log.showInfo(`getAppItem success: ${bundleName}, ${appIndex}`);
      return this.convertItem(bundleResourceInfo, bundleInfo.appInfo.uid);
    } catch (err) {
      log.error(`Failed to getAppItem`, err);
      return appItem;
    }
  }

  private convertItem(resource: bundleResourceManager.BundleResourceInfo, uid: number): AppItem {
    const appItem = new AppItem();
    appItem.key = this.itemKey++;
    appItem.appTitle = resource.label;
    appItem.appIcon = resource.icon;
    appItem.appBundleName = resource.bundleName;
    appItem.appIndex = resource.appIndex;
    appItem.appSwitch = true;
    appItem.itemDescribeText = '';
    appItem.isMetaService = true;
    appItem.appUid = uid;
    appItem.sortTag = this.getSortTag(appItem.appTitle);
    log.showWarn(`convertItem bundleName: ${appItem.appBundleName}, appIcon is invalid? ${!appItem.appIcon}`);
    return appItem;
  }
}