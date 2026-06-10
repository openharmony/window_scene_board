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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  AppItemInfo,
  AppModel,
  CommonConstants,
  DockItemInfo,
  GridLayoutItemInfo,
  PageDesktopModel,
  StyleConstants,
  PageDesktopLayoutConfig,
  PageInfoManager,
  RdbStoreManager,
  LayoutViewModel,
  LaunchLayoutCacheManager
} from '@ohos/launchercommon';
import PageIndexTypeInfo from '@ohos/launchercommon/src/main/ets/bean/PageIndexTypeInfo';
import lazy {
  CleanPcModeDirtyIconCorrector
} from '@ohos/launchercommon/src/main/ets/db/gridlayoutcorrector/CleanPcModeDirtyIconCorrector';
import { gridLayoutCorrector } from '@ohos/launchercommon/src/main/ets/db/gridlayoutcorrector/GridLayoutCorrectorChain';
import PhoneDesktopLayoutInfo from './configs/PhoneDesktopLayoutInfo';

const TAG = 'PhonePageDesktopLayoutConfig';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export default class PhonePageDesktopLayoutConfig extends PageDesktopLayoutConfig {
  public mGridLayoutInfo = PhoneDesktopLayoutInfo.PHONE_LAYOUT_INFO;
  private isPadProduct: boolean = false;
  private static phoneInstance: PhonePageDesktopLayoutConfig;

  /**
   * 预制布局中没有配置的应用
   */
  private notInCCMBundleNameSet: Set<string> | undefined = undefined;

  /**
   * 应用找位的默认起始页
   * 直板机从第1页开始找位
   * 大折叠屏从第2页开始找位
   * 超大屏从第3页开始找位
   */
  protected findPositionStartPage: number = 1;

  /**
   * 重启需要检查最后空白页的个数
   * 如果是双折设备，检查最后1页的空白页是否可以删除
   * 如果是超大屏设备，检查最后2页的空白页是否可以删除
   */
  private checkLastBlankPageCount: number = 0;

  private constructor() {
    super();
    if (DeviceHelper.isLargeInFoldProduct()) {
      this.findPositionStartPage = StyleConstants.DEFAULT_2;
      this.checkLastBlankPageCount = 1;
    } else if (DeviceHelper.isUltraScreenProduct()) {
      this.findPositionStartPage = StyleConstants.DEFAULT_3;
      this.checkLastBlankPageCount = StyleConstants.DEFAULT_2;
    }
  }
  /**
   * PhoneLauncherLayoutStyleConfig of instance
   */
  static getInstance(): PhonePageDesktopLayoutConfig {
    if (PhonePageDesktopLayoutConfig.phoneInstance == null) {
      PhonePageDesktopLayoutConfig.phoneInstance = new PhonePageDesktopLayoutConfig();
    }
    return PhonePageDesktopLayoutConfig.phoneInstance;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }

  /**
   * 是否是pad product产品
   * @param isPadProduct
   */
  public setIsPadProduct(isPadProduct: boolean): void {
    this.isPadProduct = isPadProduct;
  }

  /**
   * 添加布局修护器
   * @param gridLayoutCorrector
   * @returns
   */
  protected async initGridLayoutCorrector(configFromRdb: GridLayoutItemInfo[], installedApps: AppItemInfo[],
    dockDataList: DockItemInfo[]): Promise<void> {
    await super.initGridLayoutCorrector(configFromRdb, installedApps, dockDataList);
    if (this.isPadProduct) {
      gridLayoutCorrector.addGridLayoutCorrector(new CleanPcModeDirtyIconCorrector());
    }
  }

  /**
   * 封装数据并完成写库操作
   * @param desktopMode
   */
  protected checkAppList(desktopMode?: number): void {
    // 获取系统所有图标集合
    const totalAppInfoList = AppModel.getInstance().getAppList();
    this.notInCCMBundleNameSet = new Set<string>();
    // BMS中有但CCM中没配置的应用
    totalAppInfoList.forEach((item: AppItemInfo) => {
      this.notInCCMBundleNameSet?.add(item.bundleName);
    });
    // 排除BMS中已有的应用
    this.mGridLayoutInfo.layoutInfo.forEach((item) => {
      if (item.typeId === CommonConstants.TYPE_APP) {
        this.notInCCMBundleNameSet?.delete(item.bundleName);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
        item.layoutInfo?.flat().forEach(folderItem => {
          this.notInCCMBundleNameSet?.delete(folderItem.bundleName);
        });
      }
    });
    log.showWarn(TAG, 'not in CCM app length:%{public}d -> %{public}s', this.notInCCMBundleNameSet?.size,
      Array.from(this.notInCCMBundleNameSet).join());
    super.checkAppList(desktopMode);
  }

  /**
   * 处理BMS所有应用尚未在CCM配置的应用
   * @param bundleNameSet 没有在CCM中配置的应用
   * @param totalAppInfoList BMS中所有的应用
   */
  protected dealNotInCCMApp(): void {
    if (!this.notInCCMBundleNameSet || this.notInCCMBundleNameSet.size === 0) {
      return;
    }

    const totalAppInfoList = AppModel.getInstance().getAppList();
    let res = LayoutViewModel.getInstance(this.singleContext).calculateDesktop();
    const rows = res.mRows ?? this.mGridLayoutInfo.layoutDescription.row;
    const columns = res.mColumns ?? this.mGridLayoutInfo.layoutDescription.column;
    this.notInCCMBundleNameSet.forEach((bundleName: string) => {
      let findApp = totalAppInfoList.find((item: AppItemInfo) => item.bundleName === bundleName);
      if (!findApp) {
        return;
      }
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = bundleName;
      info.abilityName = findApp.abilityName;
      info.moduleName = findApp.moduleName;
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [1, 1];
      info.container = CommonConstants.CONTAINER_DESKTOP;
      if(!Number.isNaN(Number(findApp.codePath))){
        info.intent = findApp.intent;
      }

      let startPage = this.findPositionStartPage;
      while (!this.findPosition(info, startPage, rows, columns)) {
        startPage = startPage + 1;
      };

      let isValid = this.updateAppInfoFromBMS(info, totalAppInfoList);
      if (isValid) {
        log.showWarn(TAG, 'dealNotInCCMApp bundleName:%{public}s page:%{public}d row:%{public}d column:%{public}d, rows:%{public}d columns:%{public}d',
          info.bundleName, info.page, info.row, info.column, rows, columns);
        this.mGridLayoutInfo.layoutInfo.push(info);
      }
    });
    // 预制布局中没有的应用处理完毕后，清空该数据
    this.notInCCMBundleNameSet.clear();
    this.notInCCMBundleNameSet = undefined;
  }

  /**
   * 查找空位
   * @param item
   * @param startPage
   * @returns
   */
  private findPosition(item: GridLayoutItemInfo, startPage: number, rows: number, columns: number): boolean {
    let page = startPage;
    let lastIndex = PageDesktopModel.getInstance()
      .getLastIndexOfGridOccupy(this.mGridLayoutInfo.layoutInfo, rows, columns, page);
    // 当前页已满
    if (lastIndex === rows * columns - 1) {
      return false;
    }
    // 在当前页最后一个占位后面增加一个元素
    item.row = Math.floor((lastIndex + 1) / columns);
    item.column = (lastIndex + 1) % columns;
    item.page = page;
    return true;
  }

  /**
   * 是否需要处理最后的空白屏
   * checkLastBlankPageCount大于0，并且最后1屏是空白屏才处理
   * @param pageCount 总也是
   * @returns
   */
  private isNeedDealLastBlankPage(pageCount: number): boolean {
    if (this.checkLastBlankPageCount < 1) {
      return false;
    }
    let lastPageList = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage(pageCount - 1);
    // 如果最后1屏不是空白屏返回
    if (lastPageList && lastPageList.length > 0) {
      return false;
    }
    return true;
  }

  protected async dealLastBlankPage(pageCount: number): Promise<void> {
    if (!this.isNeedDealLastBlankPage(pageCount)) {
      return;
    }
    let newPageCount = await this.dealLastBlankPages(pageCount);
    log.showWarn(TAG, 'newPageCount: %{public}d, oriPageCount: %{public}d checkLastBlankPageCount:%{public}d',
      newPageCount, pageCount, this.checkLastBlankPageCount);
    if (newPageCount !== pageCount) {
      PageInfoManager.getInstance().updatePageCount(newPageCount, 'dealLastBlankPage');
      this.mGridLayoutInfo.layoutDescription.pageCount = newPageCount;
    }
  }

  /**
   * 处理最后空白页
   * @param pageCount
   * @returns
   */
  private async dealLastBlankPages(pageCount: number): Promise<number> {
    // 查询空白屏是真实的还是补位添加的
    let blankPageArr: PageIndexTypeInfo[] = await RdbStoreManager.getInstance()
      .queryAllPageIndexTypeInfo(LayoutViewModel.getInstance().isSimpleLauncherMode(), false);
    // 检查最后1个空白页是否可以删除
    let canDelete = await this.isBlankPageCanDelete(blankPageArr, pageCount - 1);
    if(this.checkLastBlankPageCount === 1) {
      return canDelete ? pageCount - 1 : pageCount;
    }
    if(this.checkLastBlankPageCount === 2 && canDelete) {
      // 检查倒数第2个空白页是否可以删除
      canDelete = await this.isBlankPageCanDelete(blankPageArr, pageCount - 2);
      return canDelete ? pageCount - 2 : pageCount - 1;
    }
    return pageCount;
  }

  /**
   * 当前屏是否可以删除
   * 如果是用户在编辑模式下手动新增的空白屏，不能删除
   * 其它场景的空白屏可以删除
   * @param blankPageArr 空白屏数组
   * @param pageIndex 当前页
   * @returns
   */
  private async isBlankPageCanDelete(blankPageArr: PageIndexTypeInfo[], pageIndex: number): Promise<boolean> {
    let lastPageList = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage(pageIndex);
    if (lastPageList && lastPageList.length > 0) {
      return false;
    }
    for (let i = 0; i < blankPageArr.length; i++) {
      log.showInfo(TAG, `getBlankPageListFromRdb blankPageList ${blankPageArr[i].pageIndex} ${blankPageArr[i].type}`);
      if (blankPageArr[i].pageIndex === pageIndex) {
        return blankPageArr[i].type !== 'added';
      }
    }
    return true;
  }
}