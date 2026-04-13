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

import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import DefaultDesktopLayoutInfo from '../../configs/DefaultDesktopLayoutInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { SceneMsgEnum } from '../../TsIndex';
import { LayoutCacheDiffUtil } from './LayoutCacheDiffUtil';

const TAG = 'DesktopLayoutCacheData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DesktopLayoutCacheData {

  private mGridLayoutItemList: GridLayoutItemInfo[] = [];
  private mOuterGridLayoutItemList: GridLayoutItemInfo[] = [];

  private mGridLayoutInfo: DefaultDesktopLayoutInfo | null = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
  private isPadPortraitMode: boolean = false;
  private portraitLayoutInfo: DefaultDesktopLayoutInfo | null = null;
  private landscapeLayoutInfo: DefaultDesktopLayoutInfo | null = null;
  private mOuterLayoutInfo: DefaultDesktopLayoutInfo | null = null;
  private mfoldLayoutChangeListener: Function = (list: GridLayoutItemInfo[]) => {};
  // 横竖屏切换，简易、普通布局切换，内外屏切换后缓存更新后，需同步更新文件夹缓存
  private mFolderCacheListener?: () => void;
  private _isPad: boolean = false;

  constructor(gridLayoutInfo: DefaultDesktopLayoutInfo) {
    this.mGridLayoutItemList = gridLayoutInfo.layoutInfo;
    this.mGridLayoutInfo = gridLayoutInfo;
  }

  public setIsPad(isPad: boolean): void {
    log.showInfo(`setIsPad: ${isPad}`);
    this._isPad = isPad;
  }

  public isPad(): boolean {
    return this._isPad;
  }

  public setGridLayoutItemList(gridLayoutItemList: GridLayoutItemInfo[], isOuter?: boolean): void {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (!showOuter) {
      this.mGridLayoutItemList = gridLayoutItemList;
    } else {
      this.mOuterGridLayoutItemList = gridLayoutItemList;
    }
  }

  public getGridLayoutItemList(isOuter?: boolean): GridLayoutItemInfo[] {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (!showOuter) {
      if (CheckEmptyUtils.isEmptyArr(this.mGridLayoutItemList)) {
        log.showWarn(`the gridItemList is invalid`);
        return DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutInfo;
      }
      return this.mGridLayoutItemList;
    } else {
      if (CheckEmptyUtils.isEmptyArr(this.mOuterGridLayoutItemList)) {
        log.showWarn(`the outerGridItemList is invalid`);
        return DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutInfo;
      }
      return this.mOuterGridLayoutItemList;
    }
  }

  public getGridLayoutInfo(isOuter?: boolean): DefaultDesktopLayoutInfo {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (!showOuter) {
      if (!this.mGridLayoutInfo) {
        return DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      }
      return this.mGridLayoutInfo;
    } else {
      if (!this.mOuterLayoutInfo) {
        return DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      }
      return this.mOuterLayoutInfo;
    }
  }

  public updateLandscapeLayoutInfo(gridLayoutList: GridLayoutItemInfo[]): void {
    log.showInfo('updateLandscapeLayoutInfo isPadPortraitMode: %{public}s', this.isPadPortraitMode);
    if (this.landscapeLayoutInfo) {
      this.landscapeLayoutInfo.layoutInfo = gridLayoutList;
    }
    this.mFolderCacheListener?.();
  }

  public setGridLayoutInfo(gridLayoutInfo: DefaultDesktopLayoutInfo, isOuter?: boolean): void {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (!showOuter) {
      this.mGridLayoutInfo = gridLayoutInfo;
    } else {
      this.mOuterLayoutInfo = gridLayoutInfo;
    }
  }

  public updateLayoutListCache(gridLayoutList: GridLayoutItemInfo[], isOuter?: boolean,
    sceneMsg: string = SceneMsgEnum.CACHE_UPDATE_LAYOUT_LIST_CACHE_DEFAULT): void {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    log.showInfo(`updateLayoutListCache when ${sceneMsg}, updateLength:${gridLayoutList?.length}, showOuter:${showOuter}}`);
    if (!showOuter) {
      this.mGridLayoutItemList = gridLayoutList;
      if (this.mGridLayoutInfo) {
        this.mGridLayoutInfo.layoutInfo = this.mGridLayoutItemList;
      }
    } else {
      this.mOuterGridLayoutItemList = gridLayoutList;
      if (this.mOuterLayoutInfo) {
        this.mOuterLayoutInfo.layoutInfo = this.mOuterGridLayoutItemList;
      }
    }
  }

  public updateLayoutListCacheAndPrebuild(gridLayoutList: GridLayoutItemInfo[], isOuter?: boolean,
    sceneMsg: string = SceneMsgEnum.CACHE_UPDATE_LAYOUT_LIST_CACHE_AND_PREBUILD): void {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    log.showInfo(`updateLayoutListCacheAndPrebuild when ${sceneMsg}, updateLength:${gridLayoutList.length}, showOuter:${showOuter}}`);
    if (!showOuter) {
      LayoutCacheDiffUtil.printChangedLayoutItemsLog(this.mGridLayoutItemList, gridLayoutList, sceneMsg);
      this.mGridLayoutItemList = gridLayoutList;
      if (this.mGridLayoutInfo) {
        this.mGridLayoutInfo.layoutInfo = this.mGridLayoutItemList;
      }
      let folderItems: GridLayoutItemInfo[] = this.mGridLayoutItemList
        .filter(item => item.typeId === CommonConstants.TYPE_FOLDER);
      this.mfoldLayoutChangeListener(folderItems);
    } else {
      this.mOuterGridLayoutItemList = gridLayoutList;
      if (this.mOuterLayoutInfo) {
        this.mOuterLayoutInfo.layoutInfo = this.mOuterGridLayoutItemList;
      }
    }
  }

  public setListener(listener: Function): void {
    this.mfoldLayoutChangeListener = listener;
  }

  /**
   * 设置文件夹缓存listener
   *
   * @param listener
   */
  public setFolderCacheListener(listener: () => void): void {
    this.mFolderCacheListener = listener;
  }

  public getPortraitLayoutInfo(): DefaultDesktopLayoutInfo | null {
    return this.portraitLayoutInfo;
  }

  public setPortraitLayoutInfo(gridLayoutInfo: DefaultDesktopLayoutInfo): void {
    this.portraitLayoutInfo = gridLayoutInfo;
  }

  public getLandscapeLayoutInfo(): DefaultDesktopLayoutInfo | null {
    return this.landscapeLayoutInfo;
  }

  public setLandscapeLayoutInfo(gridLayoutInfo: DefaultDesktopLayoutInfo): void {
    this.landscapeLayoutInfo = gridLayoutInfo;
  }

  public getPadPortraitMode(): boolean {
    return this.isPadPortraitMode;
  }

  public setPadPortraitMode(isPadPortrait: boolean): void {
    this.isPadPortraitMode = isPadPortrait;
  }

  public getRotateLayoutInfo(): GridLayoutItemInfo[] {
    let layoutInfo = this.getRotateLayout();
    if (layoutInfo) {
      return layoutInfo.layoutInfo;
    }
    return [];
  }

  public getRotateLayout(): DefaultDesktopLayoutInfo | null {
    // 不是平板设备不分横竖屏，都返回横屏数据
    if (!this._isPad) {
      return this.landscapeLayoutInfo;
    }
    return this.isPadPortraitMode ? this.landscapeLayoutInfo : this.portraitLayoutInfo;
  }

  public changePadPortraitMode(isPortrait: boolean): void {
    log.showWarn('changePadPortraitMode isPortrait: %{public}s', isPortrait);
    this.isPadPortraitMode = isPortrait;
    if (this.isPadPortraitMode && this.portraitLayoutInfo) {
      this.mGridLayoutInfo = this.portraitLayoutInfo;
      this.mGridLayoutItemList = this.portraitLayoutInfo.layoutInfo;
    } else if (this.landscapeLayoutInfo) {
      this.mGridLayoutInfo = this.landscapeLayoutInfo;
      this.mGridLayoutItemList = this.landscapeLayoutInfo.layoutInfo;
    }
    this.mFolderCacheListener?.();
  }

  public clearCache(): void {
    this.mGridLayoutItemList = [];
    this.mGridLayoutInfo = null;
    this.portraitLayoutInfo = null;
    this.landscapeLayoutInfo = null;
    this.mFolderCacheListener?.();
  }
}