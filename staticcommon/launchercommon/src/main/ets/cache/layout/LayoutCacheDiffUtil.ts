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
import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { HashMap } from '@kit.ArkTS';
import { SceneMsgEnum } from '../../TsIndex';

const TAG = 'LayoutCacheDiffUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const GRIDLAYOUT_AREA_DEFAULT_LENGTH: number = 2;
const PRINT_LAYOUT_CHANGED_LOGS_COUNT: number = 5;

/**
 * 缓存变动工具类
 */
export class LayoutCacheDiffUtil {
  /**
   * 获取有更新的数据
   *
   * @param sourceGridLayoutList 原布局缓存
   * @param updateGridLayoutList 要更新的布局缓存
   * @returns map(uniqueKey,[原布局信息,更新后的布局信息])
   */
  public static getChangedItem(sourceGridLayoutList: GridLayoutItemInfo[],
    updateGridLayoutList: GridLayoutItemInfo[]): HashMap<string, [string, string]> {
    let resMap: HashMap<string, [string, string]> = new HashMap();
    if (CheckEmptyUtils.isEmpty(updateGridLayoutList)) {
      // 要更新的缓存没有数据，返回空map
      return resMap;
    }
    if (CheckEmptyUtils.isEmpty(sourceGridLayoutList)) {
      // 初始缓存没有数据，一般是初始化场景,直接返回更新数据
      updateGridLayoutList.forEach((item) => {
        resMap.set(LayoutCacheDiffUtil.genUniqueKey(item), ['', LayoutCacheDiffUtil.genValuableInfo(item)]);
      });
      return resMap;
    }
    let sourceMap: HashMap<string, string> = new HashMap();
    sourceGridLayoutList.forEach((item) => {
      sourceMap.set(LayoutCacheDiffUtil.genUniqueKey(item), LayoutCacheDiffUtil.genValuableInfo(item));
    });
    let updateMap: HashMap<string, string> = new HashMap();
    updateGridLayoutList.forEach((item) => {
      updateMap.set(LayoutCacheDiffUtil.genUniqueKey(item), LayoutCacheDiffUtil.genValuableInfo(item));
    });
    // 遍历要更新的缓存，封装数据
    updateGridLayoutList.forEach((item) => {
      let uniqueKey: string = LayoutCacheDiffUtil.genUniqueKey(item);
      let updateValue: string = LayoutCacheDiffUtil.genValuableInfo(item);
      if (sourceMap.hasKey(uniqueKey)) {
        if (updateValue !== sourceMap.get(uniqueKey)) {
          resMap.set(uniqueKey, [sourceMap.get(uniqueKey), updateValue]);
        }
      } else {
        resMap.set(uniqueKey, ['', LayoutCacheDiffUtil.genValuableInfo(item)]);
      }
    });
    // 补充source存在,但是update不存在的数据，对应从桌面布局移除节点的操作
    sourceGridLayoutList.forEach((item) => {
      let uniqueKey: string = LayoutCacheDiffUtil.genUniqueKey(item);
      let sourceValue: string = LayoutCacheDiffUtil.genValuableInfo(item);
      if (!resMap.hasKey(uniqueKey) && sourceValue !== updateMap.get(uniqueKey)) {
        resMap.set(uniqueKey, [sourceValue, '']);
      }
    });
    return resMap;
  }

  /**
   * 生成唯一Key值
   *
   * @param layoutInfo
   * @returns uniqueKey
   */
  public static genUniqueKey(layoutInfo: GridLayoutItemInfo): string {
    let uniqueKey: string =
      `${layoutInfo.bundleName}_${layoutInfo.typeId}_${layoutInfo.shortcutId}_${layoutInfo.abilityName}_${layoutInfo.moduleName}_${layoutInfo.appIndex}_${layoutInfo.infoId}`;
    return uniqueKey;
  }

  /**
   * 获取布局价值信息
   *
   * @param layoutInfo
   * @param GridLayoutItemInfo
   * @returns bundleName_所在页_容器ID_行_列_宽_高_类型_堆叠ID_文件夹ID_卡片ID
   */
  public static genValuableInfo(layoutInfo: GridLayoutItemInfo): string {
    if (CheckEmptyUtils.isEmpty(layoutInfo)) {
      log.showError(`genValuableInfo layoutInfo is enmpty`);
      return '';
    }
    let width = 0;
    let height = 0;
    if (layoutInfo.area && !CheckEmptyUtils.isEmptyArr(layoutInfo.area) &&
      layoutInfo.area.length === GRIDLAYOUT_AREA_DEFAULT_LENGTH) {
      width = layoutInfo.area[0];
      height = layoutInfo.area[1];
    }
    return `${layoutInfo.bundleName}_${layoutInfo.page}_${layoutInfo.container}_${layoutInfo.row}_${layoutInfo.column}_${width}_${height}_${layoutInfo.typeId}_${layoutInfo.formStackId}_${layoutInfo.folderId}_${layoutInfo.cardId}`;
  }

  /**
   * 打印缓存变动日志
   *
   * @param sourceGridLayoutList 原布局缓存
   * @param updateGridLayoutList 要更新的布局缓存
   * @param sceneMsg 场景
   * @param threshold 单次更新缓存打印数量阈值
   */
  public static printChangedLayoutItemsLog(sourceGridLayoutList: GridLayoutItemInfo[],
    updateGridLayoutList: GridLayoutItemInfo[], sceneMsg: string = SceneMsgEnum.CACHE_UPDATE_DEFAULT,
    threshold: number = PRINT_LAYOUT_CHANGED_LOGS_COUNT): void {
    let changedLayoutMap: HashMap<string, [string, string]> =
      LayoutCacheDiffUtil.getChangedItem(sourceGridLayoutList, updateGridLayoutList);
    if (!changedLayoutMap.isEmpty()) {
      let len: number = changedLayoutMap.length;
      let printCount: number = 0;
      for (const mMap of changedLayoutMap) {
        const key = mMap[0];
        const value = mMap[1];
        printCount++;
        if (!LayoutCacheDiffUtil.canPrintChangedLog(len, threshold, printCount)) {
          log.showWarn(`printChangedLayoutItemsLog limit, len:${len}, printCount:${printCount}, threshold;${threshold}`);
          return;
        }
        // 打印缓存更新日志
        log.showInfo(`gridlayoutChanged when ${sceneMsg}, uniqueKey:${key}, sourceLayout:${value[0]}, updateLayout:${value[1]}`);
      }
    }
  }

  /**
   * 判断是否需要打印日志
   * @param len
   * @param printCount
   * @param threshold
   * @returns true:可以打印  false:不打印
   */
  public static canPrintChangedLog(len: number, threshold: number, printCount?: number): boolean {
    if (printCount && printCount > threshold) {
      // 如果打印条数大于10条,后续不打印
      return false;
    }
    return true;
  }
}