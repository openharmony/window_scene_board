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

import { HashMap } from '@kit.ArkTS';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppIconCheckAndFixIface } from '../interface/AppIconCheckAndFixIface';
import { AppModel } from '../../TsIndex';
import { LostBundleInfo } from '../viewmodel/AppIconCheckAndFixManager';

const TAG = 'AppIconFixer';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 单次最多修复10个应用的布局信息
const BATCH_FIX_SIZE: number = 10;
// 批次处理的间隔
const BATCH_FIX_INTERVAL: number = 2000;

/**
 * 图标修复器
 * 用于修复图标丢失，包含图标Image、opacity以及桌面图标缓存缺失
 */
export class AppIconFixer {
  /**
   * 修复图标Image问题
   *
   * @param bundleName 包名
   * @param appIconCheckAndFix 图标检测&修复接口
   * @param lostBundleInfos 修复前的Image异常检测结果
   */
  public fixIconImage(bundleName: string = '', appIconCheckAndFix: HashMap<string, AppIconCheckAndFixIface[]>,
    lostBundleInfos: LostBundleInfo[]): void {
    if (!this.isCheckCacheValid(lostBundleInfos, bundleName)) {
      log.showWarn('fixIconImage invalid check cache');
      return;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      appIconCheckAndFix.forEach((ifaces: AppIconCheckAndFixIface[], key: string) => {
        ifaces.forEach((item) => {
          item.fixIconImage();
        });
      });
      return;
    }
    if (appIconCheckAndFix.hasKey(bundleName)) {
      let iface: AppIconCheckAndFixIface[] = appIconCheckAndFix.get(bundleName);
      iface.forEach((item) => {
        item.fixIconImage();
      });
    }
  }

  /**
   * 修复图标不透明度问题
   *
   * @param bundleName 包名
   * @param appIconCheckAndFix 图标检测&修复接口
   * @param lostBundleInfos 修复前的不透明度异常检测结果
   */
  public fixIconOpacity(bundleName: string = '', appIconCheckAndFix: HashMap<string, AppIconCheckAndFixIface[]>,
    lostBundleInfos: LostBundleInfo[]): void {
    if (!this.isCheckCacheValid(lostBundleInfos, bundleName)) {
      log.showWarn('fixIconOpacity invalid check cache');
      return;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      appIconCheckAndFix.forEach((ifaces: AppIconCheckAndFixIface[], key: string) => {
        ifaces.forEach((item) => {
          item.fixIconOpacity();
        });
      });
      return;
    }
    if (appIconCheckAndFix.hasKey(bundleName)) {
      let iface: AppIconCheckAndFixIface[] = appIconCheckAndFix.get(bundleName);
      iface.forEach((item) => {
        item.fixIconOpacity();
      });
    }
  }

  /**
   * 修复图标缓存异常
   *
   * @param bundleName 包名
   * @param lostBundleInfos 修复前的缓存异常检测结果
   */
  public async fixIconCache(bundleName: string = '', lostBundleInfos: LostBundleInfo[]): Promise<void> {
    if (!this.isCheckCacheValid(lostBundleInfos, bundleName)) {
      log.showWarn('fixIconCache invalid check cache');
      return;
    }

    // 空包名则对全部异常应用触发刷新, 单次只刷新5个
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      this.batchFixIconCache(lostBundleInfos);
      return;
    }

    // 刷新对应异常包名的应用
    lostBundleInfos.forEach((item: LostBundleInfo) => {
      if (item.bundleName === bundleName) {
        AppModel.getInstance().reloadLostAppItem(item.bundleName, item.appIndex);
      }
    })
  }

  private batchFixIconCache(lostBundleInfos: LostBundleInfo[]): void {
    let index = 0;
    const timer = setInterval(() => {
      // 获取当前批次
      const batch = lostBundleInfos.slice(index, index + BATCH_FIX_SIZE);

      // 处理当前批次
      batch.forEach((item: LostBundleInfo) => {
        AppModel.getInstance().reloadLostAppItem(item.bundleName, item.appIndex);
      });
      index += BATCH_FIX_SIZE;

      // 检查是否完成
      if (index >= lostBundleInfos.length) {
        clearInterval(timer);
        log.showWarn('batchFixIconCache end');
      }
    }, BATCH_FIX_INTERVAL);
  }

  /**
   * 检测结果中是否有对应的异常数据, 没有异常数据不能触发修复
   *
   * @param lostBundleInfos 检测出来的丢失应用信息
   * @param bundleName 丢失图标的包名
   * @returns 检测结果中是否有对应应用出现丢失
   */
  private isCheckCacheValid(lostBundleInfos: LostBundleInfo[], bundleName: string): boolean {
    if (CheckEmptyUtils.isEmptyArr(lostBundleInfos)) {
      log.showWarn(`lostBundleInfos is empty`);
      return false;
    }

    // 支持空串包名，代表支持检测结果中所有的异常
    if (bundleName === '') {
      log.showWarn(`all bundle name need to fix`);
      return true;
    }

    let isExistInCache: boolean = false;
    for (let index = 0; index < lostBundleInfos.length; index++) {
      if (lostBundleInfos[index].bundleName === bundleName) {
        isExistInCache = true;
        break;
      }
    }
    log.showWarn(`checkResultCache is valid: ${isExistInCache}`);
    return isExistInCache;
  }
}