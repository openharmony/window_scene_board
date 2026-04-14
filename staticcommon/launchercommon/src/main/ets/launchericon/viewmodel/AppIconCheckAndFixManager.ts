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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import lazy { AppIconChecker } from '../common/AppIconChecker';
import lazy { AppIconFixer } from '../common/AppIconFixer';
import { AppIconCheckAndFixIface } from '../interface/AppIconCheckAndFixIface';
import { AppIconCheckAndFixDebug } from '../debug/AppIconCheckAndFixDebug';
import { CommonConstants } from '../../constants/CommonConstants';

// 检测结果缓存时间，超时后自动清空缓存
const DELETE_CHECK_CACHE_DELAY: number = 300000;

// 图标检测结果
export enum INVALID_REASON {
  INVALID_ICON_IMAGE = 0,
  INVALID_ICON_OPACITY = 1,
  INVALID_ICON_LAYOUT_CACHE = 2,
}

export class LostBundleInfo {
  bundleName: string;
  moduleName: string;
  abilityName: string;
  appIndex: number;
  page: number;

  constructor(bundleName: string, moduleName: string , abilityName: string, appIndex: number, page?: number) {
    this.bundleName = bundleName;
    this.moduleName = moduleName;
    this.abilityName = abilityName;
    this.appIndex = appIndex;
    this.page = page ?? CommonConstants.INVALID_VALUE;
  }
}

const TAG = 'AppIconCheckAndFixManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 图标检测&修复管理类
 */
export class AppIconCheckAndFixManager {
  private static instance: AppIconCheckAndFixManager;
  private appIconCheckAndFix: HashMap<string, AppIconCheckAndFixIface[]> =
    new HashMap<string, AppIconCheckAndFixIface[]>();
  private appIconChecker?: AppIconChecker;
  private appIconFixer?: AppIconFixer;
  private clearCacheTimeoutId: number = CommonConstants.INVALID_VALUE;

  public static getInstance(): AppIconCheckAndFixManager {
    if (!AppIconCheckAndFixManager.instance) {
      AppIconCheckAndFixManager.instance = new AppIconCheckAndFixManager();
      AppIconCheckAndFixDebug.getInstance().register();
    }
    return AppIconCheckAndFixManager.instance;
  }

  /**
   * 注册图标检测&修复接口
   *
   * @param bundleName 包名, 同一个包名支持多个应用（分身、多图标应用）
   * @param appIconCheckAndFix 检测&修复能力
   */
  public registerAppIconCheckAndFix(bundleName: string, appIconCheckAndFix: AppIconCheckAndFixIface): void {
    log.showWarn(`registerAppIconCheckAndFix ${bundleName}`);
    if (!this.appIconCheckAndFix.hasKey(bundleName)) {
      this.appIconCheckAndFix.set(bundleName, [appIconCheckAndFix]);
      return;
    }
    this.appIconCheckAndFix.get(bundleName)?.push(appIconCheckAndFix);
  }

  /**
   * 反注册图标检测&修复接口
   *
   * @param bundleName 包名
   * @param appIconCheckAndFix 检测&修复能力
   */
  public unregisterAppIconCheckAndFix(bundleName: string, appIconCheckAndFix: AppIconCheckAndFixIface): void {
    log.showWarn(`unregisterAppIconCheckAndFix ${bundleName}`);
    if (!this.appIconCheckAndFix.hasKey(bundleName)) {
      return;
    }
    let index: number = this.appIconCheckAndFix.get(bundleName).indexOf(appIconCheckAndFix);
    if (index !== CommonConstants.INVALID_VALUE) {
      this.appIconCheckAndFix.get(bundleName).splice(index, 1);
    }
  }

  // just for debug cmd
  public checkIconForDebug(reason: number, bundleName?: string): LostBundleInfo[] {
    this.appIconChecker = new AppIconChecker();
    let lostBundleInfos: LostBundleInfo[] = [];
    if (reason === INVALID_REASON.INVALID_ICON_IMAGE) {
      lostBundleInfos = this.appIconChecker.checkIconImage(bundleName, this.appIconCheckAndFix);
    } else if (reason === INVALID_REASON.INVALID_ICON_OPACITY) {
      lostBundleInfos = this.appIconChecker.checkIconOpacity(bundleName, this.appIconCheckAndFix);
    } else if (reason === INVALID_REASON.INVALID_ICON_LAYOUT_CACHE) {
      this.appIconChecker.checkIconInLayoutCache(bundleName);
    } else {
      log.showError('invalid reason to check app icon debug');
    }
    return lostBundleInfos;
  }

  /**
   * 检查图标异常信息
   *
   * @param bundleName 包名
   * @returns 图标异常信息
   */
  public async checkIcon(bundleName?: string): Promise<HashMap<number, LostBundleInfo[]>> {
    this.appIconChecker = new AppIconChecker();
    this.appIconChecker.checkIconImage(bundleName, this.appIconCheckAndFix);
    this.appIconChecker.checkIconOpacity(bundleName, this.appIconCheckAndFix);
    await this.appIconChecker.checkIconInLayoutCache(bundleName);

    // 5分钟后自动清除检测结果缓存
    if (this.clearCacheTimeoutId !== CommonConstants.INVALID_VALUE) {
      clearTimeout(this.clearCacheTimeoutId);
    }
    this.clearCacheTimeoutId = setTimeout(() => {
      log.showWarn('clean appIconChecker cache');
      this.appIconChecker?.clearCheckResultCache();
      this.appIconChecker = undefined;
    }, DELETE_CHECK_CACHE_DELAY);
    return this.appIconChecker.getCheckResultCache();
  }

  /**
   * 修复异常的图标
   *
   * @param reason 修复场景
   * @param bundleName 待修复的图标包名, 空字符串代表所有包名
   * @returns 修复动作是否执行
   */
  public async fixIcon(reason: number, bundleName?: string): Promise<boolean> {
    if (!this.appIconChecker) {
      log.showWarn('need to check icon first before fix icon');
      return false;
    }
    log.showInfo(`fixIcon reason: ${reason}, bundleName: ${bundleName}`);
    this.appIconFixer = new AppIconFixer();
    if (reason === INVALID_REASON.INVALID_ICON_IMAGE) {
      let lostBundleInfos: LostBundleInfo[] =
        this.appIconChecker.getCheckResultCache().get(INVALID_REASON.INVALID_ICON_IMAGE);
      this.appIconFixer.fixIconImage(bundleName, this.appIconCheckAndFix, lostBundleInfos);
      this.appIconFixer = undefined;
      return true;
    } else if (reason === INVALID_REASON.INVALID_ICON_OPACITY) {
      let lostBundleInfos: LostBundleInfo[] =
        this.appIconChecker.getCheckResultCache().get(INVALID_REASON.INVALID_ICON_OPACITY);
      this.appIconFixer.fixIconOpacity(bundleName, this.appIconCheckAndFix, lostBundleInfos);
      this.appIconFixer = undefined;
      return true;
    } else if (reason === INVALID_REASON.INVALID_ICON_LAYOUT_CACHE) {
      let lostBundleInfos: LostBundleInfo[] =
        this.appIconChecker.getCheckResultCache().get(INVALID_REASON.INVALID_ICON_LAYOUT_CACHE);
      await this.appIconFixer.fixIconCache(bundleName, lostBundleInfos).then(() => {
        this.appIconFixer = undefined;
      });
      return true;
    } else {
      log.showError('invalid reason to fix app icon');
      this.appIconFixer = undefined;
      return false;
    }
  }
}