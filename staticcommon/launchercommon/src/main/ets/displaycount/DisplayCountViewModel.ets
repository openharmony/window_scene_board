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
import { ScreenOrientation, ScreenState, ScreenStateModel, ScreenStateMonitor } from '@ohos/frameworkwrapper';
import { PageInfoManager } from '../cache/layout/PageInfoManager';
import { StyleConstants } from '../constants/StyleConstants';
import { DeviceState } from '../constants/CommonConstants';
import { DisplayCountData } from './DisplayCountData';

const TAG = 'DisplayCountViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const PRE_NEXT_MARGIN = 0.01;

// 三折屏设备每6页一组计算
const THREE_FOLD_GROUP = 6;

/**
 * DisplayCount viewmodel类
 */
export class DisplayCountViewModel {
  private displayCountData: DisplayCountData = new DisplayCountData();
  private static mInstance: DisplayCountViewModel;

  private constructor() {
  }

  /**
   * 获取单例
   * @returns 单例
   */
  public static getInstance(): DisplayCountViewModel {
    if (!DisplayCountViewModel.mInstance) {
      DisplayCountViewModel.mInstance = new DisplayCountViewModel();
    }
    return DisplayCountViewModel.mInstance;
  }

  /**
   * 获取DisplayCountData
   * @returns DisplayCountData
   */
  public getDisplayCountData(): DisplayCountData {
    return this.displayCountData;
  }

  /**
   * 计算displayCount
   * 横竖屏变化、屏幕旋转的时候需要重新计算
   * @param isPortrait
   * @param folderStatus
   */
  public calculate(isPortrait: boolean, folderStatus: DeviceState): void {
    if (folderStatus === DeviceState.DEFAULT_STATE) {
      this.setDisplayCount(StyleConstants.DEFAULT_1);
      return;
    }
    let displayCount: number = StyleConstants.DEFAULT_2;
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3 && !isPortrait &&
      ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState === ScreenState.G) {
      displayCount = StyleConstants.DEFAULT_3;
    }
    this.setDisplayCount(displayCount);
    log.showInfo(TAG, 'init displayCount:%{public}d, folderStatus:%{public}d, isPortrait:%{public}s',
      displayCount, folderStatus, isPortrait);
  }

  /**
   * 计算三折屏displayCount
   */
  public calculateThreeFolDisplayCount(): void {
    if (PageInfoManager.getInstance().getMaxDisplayCount() !== StyleConstants.DEFAULT_3) {
      return;
    }
    let displayCount: number = StyleConstants.DEFAULT_1;
    let screenModel: ScreenStateModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
    if (screenModel.screenState === ScreenState.F) {
      displayCount = StyleConstants.DEFAULT_1;
    } else if (screenModel.screenState === ScreenState.M) {
      displayCount = StyleConstants.DEFAULT_2;
    } else if (screenModel.screenState === ScreenState.G) {
      displayCount =
        screenModel.orientation === ScreenOrientation.PORTRAIT ? StyleConstants.DEFAULT_2 : StyleConstants.DEFAULT_3;
    } else {
      log.showError(TAG, 'error breakpoint width:%{public}d height:%{public}d screenState:%{public}s orientation:%{public}s',
        screenModel.width, screenModel.height, screenModel.screenState, screenModel.orientation);
    }
    log.showInfo(TAG, 'breakpoint width:%{public}d height:%{public}d screenState:%{public}s orientation:%{public}s displayCount:%{public}d',
      screenModel.width, screenModel.height, screenModel.screenState, screenModel.orientation, displayCount);
    this.setDisplayCount(displayCount);
  }

  /**
   * 获取displayCount
   * @returns displayCount
   */
  public getDisplayCount(): number {
    return this.displayCountData.getDisplayCount();
  }

  /**
   * 设置displayCount
   * @returns displayCount
   */
  private setDisplayCount(displayCount: number): void {
    let origValue = this.displayCountData.getDisplayCount();
    if (displayCount === origValue) {
      log.showInfo(TAG, 'setDisplayCount displayCount=%{public}d equal return', displayCount);
      return;
    }
    log.showInfo(TAG, 'setDisplayCount displayCount=%{public}d', displayCount);
    this.displayCountData.setDisplayCount(displayCount);
    PageInfoManager.getInstance().setDisplayCount(displayCount);
    let pageIndex = PageInfoManager.getInstance().getPageIndex();

    let modulus = pageIndex % THREE_FOLD_GROUP;
    // 三屏到二屏旋转场景
    if (origValue === 3 && displayCount === 2) {
      if (modulus === 0 || modulus === 1) {
        // 例如123 旋转 12场景
        this.setNextMargin(PRE_NEXT_MARGIN);
      } else if (modulus === 4 || modulus === 5) {
        // 例如456 旋转 56场景
        this.setPreMargin(PRE_NEXT_MARGIN);
      }
    }
  }

  /**
   * 获取nextMargin
   * @returns nextMargin
   */
  public getNextMargin(): number {
    return this.displayCountData.getNextMargin();
  }

  /**
   * 设置nextMargin
   * @param displayCount
   */
  public setNextMargin(nextMargin: number): void {
    log.showInfo(TAG, 'setPreMargin nextMargin:%{public}d', nextMargin);
    this.displayCountData.setNextMargin(nextMargin);
  }

  /**
   * 获取preMargin
   * @returns preMargin
   */
  public getPreMargin(): number {
    return this.displayCountData.getPreMargin();
  }

  /**
   * 设置preMargin
   * @param preMargin
   */
  public setPreMargin(preMargin: number): void {
    log.showInfo(TAG, 'setPreMargin preMargin:%{public}d', preMargin);
    this.displayCountData.setPreMargin(preMargin);
  }

  /**
   * 获取cacheCount
   * @returns cacheCount
   */
  public getCacheCount(): number {
    return this.displayCountData.getCacheCount();
  }

  /**
   * 设置cacheCount
   * @param cacheCount
   */
  public setCacheCount(cacheCount: number): void {
    log.showInfo(TAG, `setCacheCount:${cacheCount}`);
    this.displayCountData.setCacheCount(cacheCount);
  }
}