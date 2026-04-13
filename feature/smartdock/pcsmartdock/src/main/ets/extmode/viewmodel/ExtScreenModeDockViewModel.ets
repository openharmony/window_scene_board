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

import { CheckEmptyUtils, LogDomain, LogHelper, ObjUtil } from '@ohos/basicutils';
import { localEventManager, ViewType } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { CommonConstants, DockItemInfo, StyleConstants, EventConstants } from '@ohos/launchercommon';
import { ExtScreenModeDockBarModel } from '../model/ExtScreenModeDockBarModel';
import { PcDockAnimationMgr } from '../../default/manager/PcDockAnimationMgr';
import { PcDockPopupMgr } from '../../default/manager/PcDockPopupMgr';
import { EsDockEventManager } from './event/EsDockEventManager';
import { ExtendScreenDockEvent } from './event/ExtendScreenDockEvent';
import { DockArrowModel } from '../model/DockArrowModel';
import { curves } from '@kit.ArkUI';
import { ArrowType, FixedDockResource, HoverItemInfo } from '../../default/common/constants/FixedDockConstants';
import { DockArrowViewData } from './viewdata/DockArrowViewData';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { PcSmartDockStyleManager } from '../../default/common/PcSmartDockStyleManager';
import { PcDockStyleConfig } from '../../default/common/PcSmartDockStyleManager';
import { PCDockUtils } from '../../default/utils/PCDockUtils';

const TAG = 'ExtScreenModeDockViewModel';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

/**
 * 扩展屏Dock的VM类
 */
export class ExtScreenModeDockViewModel {
  private screenProp: SCBScreenProperty;
  private static instance: ExtScreenModeDockViewModel;
  private mStyleConfig: PcDockStyleConfig;
  private modelData: ExtScreenModeDockBarModel = new ExtScreenModeDockBarModel();
  private mDockAnimationMgr: PcDockAnimationMgr = PcDockAnimationMgr.getInstance(0);
  private mResidentScroller: Scroller | null = null;
  private mRecentScroller: Scroller | null = null;
  private mEventManager: EsDockEventManager = EsDockEventManager.getInstance();
  private currColorMode: number = 0;

  private constructor() {
    this.modelData.arrowModel = new DockArrowModel();
    this.screenProp = new SCBScreenProperty();
    this.screenProp.rsId = 12;
    this.screenProp.width = 3120;
    this.screenProp.height = 2080;
    this.mStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    logger.showInfo('Construct');
  }

  public static getInstance(): ExtScreenModeDockViewModel {
    if (!ExtScreenModeDockViewModel.instance) {
      ExtScreenModeDockViewModel.instance = new ExtScreenModeDockViewModel();
    }

    return ExtScreenModeDockViewModel.instance;
  }

  public initViewModel(screenProp: SCBScreenProperty): void {
    logger.showInfo(`Init - ${screenProp.screenId} - ${screenProp.width} - ${this.modelData.screenWidth}`);
    this.updateStyleConfig(screenProp);
    this.modelData.attachedScreenId = screenProp.screenId;
    this.modelData.screenWidth = px2vp(screenProp.width);
    this.mDockAnimationMgr = PcDockAnimationMgr.getInstance(screenProp.screenId);
  }

  public setCurrColorMode(currColorMode: number): void {
    this.currColorMode = currColorMode;
  }

  public updateStyleConfig(screenProp: SCBScreenProperty): void {
    this.screenProp = screenProp.getCopy();
    this.mStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
  }

  public initScroller(residentScroller: Scroller, recentScroller: Scroller): void {
    this.mResidentScroller = residentScroller;
    this.mRecentScroller = recentScroller;
  }

  public getResidentScroller(): Scroller | null {
    return this.mResidentScroller;
  }

  public getRecentScroller(): Scroller | null {
    return this.mRecentScroller;
  }

  public getModelData(): ExtScreenModeDockBarModel {
    return this.modelData;
  }

  /**
   * 获取屏幕对应的Dock View Type值
   *
   * @param screenId
   * @returns
   */
  public getDockViewType(screenId: number): ViewType {
    return this.isMainScreen(screenId) ? ViewType.SMART_DOCK : ViewType.SMART_DOCK_EXT_SCREEN;
  }

  /**
   * 是否是主显示器
   *
   * @param screenId
   * @returns
   */
  public isMainScreen(screenId: number): boolean {
    return SCBSceneSessionManager.getInstance().mainScreenId === screenId;
  }

  /**
   *
   * 根据全局常驻区图标信息更新本地常驻区图标信息
   *
   * @param globalResidentList
   * @param isPcMode
   */
  public updateLocalResidentList(globalResidentList: DockItemInfo[]): void {
    let localResidentList: DockItemInfo[] = [];
    let localSystemList: DockItemInfo[] = [];
    let recycleBinItem: DockItemInfo | null = null;
    let fileManagerItem: DockItemInfo | null = null;
    let recentCenterItem: DockItemInfo | null = null;
    let appCenterItem: DockItemInfo | null = null;
    for (let i = globalResidentList.length - 1; i >= 0; i--) {
      if (globalResidentList[i]?.abilityName === CommonConstants.APPCENTER_ABILITY) {
        appCenterItem = globalResidentList[i];
        continue;
      }
      if (globalResidentList[i]?.abilityName === CommonConstants.RECENT_ABILITY) {
        recentCenterItem = globalResidentList[i];
        continue;
      }
      if (PCDockUtils.isPcFileManager(globalResidentList[i]?.bundleName)) {
        fileManagerItem = globalResidentList[i];
        continue;
      }
      if (globalResidentList[i]?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
        recycleBinItem = globalResidentList[i];
        continue;
      }

      localResidentList.unshift(globalResidentList[i]);
    }

    if (recycleBinItem) {
      localSystemList.unshift(recycleBinItem); // 把垃圾桶加到常驻区的开头
    }
    if (fileManagerItem) {
      localSystemList.unshift(fileManagerItem); // 把文管加到常驻区的开头
    }
    if (recentCenterItem) {
      localSystemList.unshift(recentCenterItem); // 把任务中心常驻区的开头
    }
    if (appCenterItem) {
      localSystemList.unshift(appCenterItem); // 把应用中心加到常驻区的开头
    }
    logger.showInfo(`updateLocalResidentList globalResidentList: ${globalResidentList.length}, localResidentList: ${localResidentList.length},` +
      `localSystemList: ${localSystemList.length}`);
    this.modelData.localResidentList = localResidentList;
    this.modelData.systemItemList = localSystemList;
    this.mDockAnimationMgr.setSystemVisibleList(localSystemList);
  }

  public updateLocalResidentListExt(localResidentList: DockItemInfo[]): void {
    this.modelData.localResidentList = localResidentList;
  }

  /**
   * 更新本地最近任务区图标数据
   *
   * @param appList
   */
  public updateLocalRecentList(appList: DockItemInfo[]): void {
    let localRecentList: DockItemInfo[] = [];
    for (let i = 0; i < appList.length; i++) {
      localRecentList.push(appList[i]);
    }
    this.modelData.localRecentList = localRecentList;
  }

  /**
   *
   * 处理Dock应用图标数据变化事件 - Stage One
   *
   * @param isResident
   * @param gResidentList
   * @param gRecentList
   */
  public handleDockAppListDataChange(isResident: boolean, gResidentList: DockItemInfo[],
    gRecentList: DockItemInfo[]): void {
    logger.showInfo(`handleDockAppListDataChange ${isResident}`);

    if (isResident && !gResidentList) {
      logger.showWarn('gResidentList null');
      return;
    } else if (!isResident && !gRecentList) {
      logger.showWarn('gRecentList null');
      return;
    }

    let residentNum: number = 0;
    let recentNum: number = 0;

    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      // 2 means appCenter and recentCenter
      residentNum = gResidentList.length + 1;
    } else {
      residentNum = gResidentList.length;
    }
    recentNum = gRecentList.length + (this.existContinuableItem() ? 1 : 0);

    // 更新Dock分区图标数量
    this.modelData.residentNum = residentNum;
    this.modelData.recentNum = recentNum;

    logger.showInfo(`residentNum: ${this.modelData.residentNum}, recentNum: ${this.modelData.recentNum}`);
  }

  /**
   *
   * 处理Dock应用图标数据变化事件 - Stage Two
   *
   * @param isResident
   * @param globalResidentList
   * @param globalRecentList
   * @param isPcMode
   */
  public handleDockAppListChangeForAnimation(isResident: boolean, globalResidentList: DockItemInfo[],
    globalRecentList: DockItemInfo[], isPcMode: boolean): void {
    logger.showInfo(`handleDockAppListChangeForAnimation globalResidentList: ${globalResidentList.length},` +
      `globalRecentList: ${globalRecentList.length}`);
    this.updateLocalResidentList(globalResidentList);
    this.updateLocalRecentList(globalRecentList);
    this.updateDockArrowState();
    this.updateResidentAreaWidth();
    this.updateVisibleResidentList();

    // 分发事件
    this.mEventManager.postEsDockEvent(ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED,
      this.modelData.systemItemList);
    this.mEventManager.postEsDockEvent(ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED,
      this.modelData.localResidentList);
    this.mEventManager.postEsDockEvent(ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED,
      this.modelData.localRecentList);
  }

  /**
   * 单个图标Hover导致的宽度变化事件处理
   *
   * @param isResident
   * @param additionWidth
   */
  public handleWidthChangeOnSingleAppHover(isResident: boolean, additionWidth: number): void {
    this.modelData.additionResidentListWidth = additionWidth;
    this.modelData.residentListAreaWidth = this.modelData.baseResidentListWidth + additionWidth;
  }

  /**
   * Dock栏整体Hover事件处理
   *
   * @param isHover
   * @param dockViewData
   */
  public handleDockAppListHover(isHover: boolean, cb?: Function): void {
    this.mDockAnimationMgr.setIsHoveringDock(isHover);
    const isDockMenuShow = PcDockPopupMgr.getInstance().isDockMenuShow(this.screenProp.screenId);
    logger.showInfo(`ext fixedlayout,onhoverhappen, ${isHover}, ${isDockMenuShow}`);
    if (!isHover && !isDockMenuShow) {
      this.modelData.additionResidentListWidth = 0;
      this.modelData.additionRecentListWidth = 0;

      animateTo({
        curve: curves.springCurve(0, 1, 322, 30),
      }, () => {
        this.mDockAnimationMgr.resetAllEffect();
        this.modelData.residentListAreaWidth = this.modelData.baseResidentListWidth;
        this.modelData.recentListAreaWidth = this.modelData.baseRecentListWidth;
        cb?.();
      });

      logger.showInfo(`hoverOut ext list residentWidth: ${this.modelData.residentListAreaWidth},` +
        `recentListWidth: ${this.modelData.recentListAreaWidth}`);
    }
  }

  /**
   * 箭头Hover事件处理
   *
   * @param arrowType
   * @param isHover
   * @param arrowViewData
   */
  public handleArrowHover(arrowType: ArrowType, isHover: boolean, arrowViewData: DockArrowViewData): void {
    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT: {
        this.modelData.arrowModel!.isResidentLeftArrowHover = isHover;
        arrowViewData.isResidentLeftArrowHover = isHover;
        if (!this.modelData.arrowModel!.isResidentLeftArrowClickable) {
          break;
        }
        this.refreshResidentArrowBgColor(arrowViewData);
        break;
      }
      case ArrowType.RESIDENT_RIGHT: {
        this.modelData.arrowModel!.isResidentRightArrowHover = isHover;
        arrowViewData.isResidentRightArrowHover = isHover;
        if (!this.modelData.arrowModel!.isResidentRightArrowClickable) {
          break;
        }
        this.refreshResidentArrowBgColor(arrowViewData);
        break;
      }
      case ArrowType.RECENT_LEFT: {
        this.modelData.arrowModel!.isRecentLeftArrowHover = isHover;
        arrowViewData.isRecentLeftArrowHover = isHover;
        if (!this.modelData.arrowModel!.isRecentLeftArrowClickable) {
          break;
        }
        this.refreshRecentArrowBgColor(arrowViewData);
        break;
      }
      case ArrowType.RECENT_RIGHT: {
        this.modelData.arrowModel!.isRecentRightArrowHover = isHover;
        arrowViewData.isRecentRightArrowHover = isHover;
        if (!this.modelData.arrowModel!.isRecentRightArrowClickable) {
          break;
        }
        this.refreshRecentArrowBgColor(arrowViewData);
        break;
      }
      default:
        logger.showError('onHoverArrow:invalid arrow type');
        break;
    }
  }

  /**
   * Dock栏箭头Touch事件处理
   *
   *
   * @param arrowType
   * @param event
   * @param arrowViewData
   */
  public handleArrowTouch(arrowType: ArrowType, isDarkMode: boolean, event?: TouchEvent,
    arrowViewData?: DockArrowViewData): void {
    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT: {
        if (!this.modelData.arrowModel!.isResidentLeftArrowClickable) {
          break;
        }
        if (event?.type === TouchType.Down) {
          this.modelData.arrowModel!.residentLeftArrowBgColor = (isDarkMode ? FixedDockResource.ARROW_CLICK_DARK_COLOR :
          FixedDockResource.ARROW_CLICK_LIGHT_COLOR);
        }
        if (event?.type === TouchType.Up) {
          if (this.modelData.arrowModel!.isResidentLeftArrowHover) {
            this.modelData.arrowModel!.residentLeftArrowBgColor =
              (isDarkMode ? FixedDockResource.ARROW_HOVER_DARK_COLOR : FixedDockResource.ARROW_HOVER_LIGHT_COLOR);
          } else {
            this.modelData.arrowModel!.residentLeftArrowBgColor = null;
          }

          if (arrowViewData) {
            arrowViewData.residentLeftArrowBgColor = this.modelData.arrowModel!.residentLeftArrowBgColor;
          }
        }
        break;
      }
      case ArrowType.RESIDENT_RIGHT: {
        if (!this.modelData.arrowModel!.isResidentRightArrowClickable) {
          break;
        }
        if (event?.type === TouchType.Down) {
          this.modelData.arrowModel!.residentRightArrowBgColor =
            (isDarkMode ? FixedDockResource.ARROW_CLICK_DARK_COLOR :
            FixedDockResource.ARROW_CLICK_LIGHT_COLOR);
        }
        if (event?.type === TouchType.Up) {
          if (this.modelData.arrowModel!.isResidentRightArrowHover) {
            this.modelData.arrowModel!.residentRightArrowBgColor =
              (isDarkMode ? FixedDockResource.ARROW_HOVER_DARK_COLOR : FixedDockResource.ARROW_HOVER_LIGHT_COLOR);
          } else {
            this.modelData.arrowModel!.residentRightArrowBgColor = null;
          }
        }

        if (arrowViewData) {
          arrowViewData.residentRightArrowBgColor = this.modelData.arrowModel!.residentRightArrowBgColor;
        }
        break;
      }
      case ArrowType.RECENT_LEFT: {
        if (!this.modelData.arrowModel!.isRecentLeftArrowClickable) {
          break;
        }
        if (event?.type === TouchType.Down) {
          this.modelData.arrowModel!.recentLeftArrowBgColor = $r('sys.color.ohos_id_color_click_effect');
        }
        if (event?.type === TouchType.Up) {
          if (this.modelData.arrowModel!.isRecentLeftArrowHover) {
            this.modelData.arrowModel!.recentLeftArrowBgColor = $r('sys.color.ohos_id_color_hover');
          } else {
            this.modelData.arrowModel!.recentLeftArrowBgColor = null;
          }
        }

        if (arrowViewData) {
          arrowViewData.recentLeftArrowBgColor = this.modelData.arrowModel!.recentLeftArrowBgColor;
        }
        break;
      }
      case ArrowType.RECENT_RIGHT: {
        if (!this.modelData.arrowModel!.isRecentRightArrowClickable) {
          break;
        }
        if (event?.type === TouchType.Down) {
          this.modelData.arrowModel!.recentRightArrowBgColor = $r('sys.color.ohos_id_color_click_effect');
        }
        if (event?.type === TouchType.Up) {
          if (this.modelData.arrowModel!.isRecentRightArrowHover) {
            this.modelData.arrowModel!.recentRightArrowBgColor = $r('sys.color.ohos_id_color_hover');
          } else {
            this.modelData.arrowModel!.recentRightArrowBgColor = null;
          }
        }

        if (arrowViewData) {
          arrowViewData.recentRightArrowBgColor = this.modelData.arrowModel!.recentRightArrowBgColor;
        }
        break;
      }
      default:
        logger.showError('onTouchArrow:invalid arrow type');
        break;
    }

    this.mEventManager.doArrowChangeCallback();
  }

  private isDividerVisable(): boolean {
    if (!this.isDividerShow() || !this.mResidentScroller) {
      return false;
    }
    let index = this.modelData.localResidentList.length;
    const scroller: Scroller = this.mResidentScroller;
    try {
      let rect: RectResult = scroller.getItemRect(index);
      logger.showInfo(`isDividerVisable rect: ${rect.x}- ${rect.y}-${rect.width}-${rect.height} `);
      if (rect.x === 0 && rect.y === 0 && rect.width === 0 && rect.height === 0) {
        return false;
      }
      return true;
    } catch (error) {
      logger.showError(`getItemRect error`);
      return false;
    }
  }

  private onClickResidentLeftArrow(): void {
    if (!this.mResidentScroller) {
      return;
    }
    const dividerWidth: number = this.getDividerWidth();
    let dividerOffset: number = 0;
    let dividerScroolOffset: number = 0;
    if (this.isDividerShow()) {
      dividerOffset = this.isDividerVisable() ? 0 : dividerWidth;
      dividerScroolOffset = this.isDividerVisable() ? dividerWidth : 0;
    }
    const currentOffset: number = this.mResidentScroller.currentOffset().xOffset;
    const itemWidth: number = this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap;
    const index: number = Math.round(Math.ceil(currentOffset - dividerOffset) / itemWidth);
    this.doScroll(this.mResidentScroller, (index - this.modelData.residentMaxNum) * itemWidth + dividerScroolOffset);
  }

  private onClickResidentRightArrow(): void {
    if (!this.mResidentScroller) {
      return;
    }
    const dividerWidth: number = this.getDividerWidth();
    let dividerOffset: number = 0;
    let dividerScroolOffset: number = 0;
    if (this.isDividerShow()) {
      dividerOffset = this.isDividerVisable() ? 0 : dividerWidth;
      dividerScroolOffset = this.isDividerVisable() ? dividerWidth : 0;
    }
    const currentOffset: number = this.mResidentScroller.currentOffset().xOffset;
    const itemWidth: number = this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap;
    const index: number = Math.round(Math.floor(currentOffset - dividerOffset) / itemWidth);
    this.doScroll(this.mResidentScroller, (index + this.modelData.residentMaxNum) * itemWidth + dividerScroolOffset);
  }

  /**
   * Dock栏箭头点击事件处理
   *
   * @param arrowType
   * @param arrowViewData
   */
  public handleArrowClick(arrowType: ArrowType, arrowViewData: DockArrowViewData): void {
    logger.showDebug(`onClickArrow ${arrowType}`);
    if (!this.mResidentScroller) {
      return;
    }

    switch (arrowType) {
      case ArrowType.RESIDENT_LEFT: {
        if (!this.modelData.arrowModel!.isResidentLeftArrowClickable) {
          break;
        }
        this.mDockAnimationMgr.resetItemNearLeftArrowEffect();
        animateTo({
          curve: curves.springCurve(0, 1, 322, 30),
        }, () => {
          this.modelData.additionResidentListWidth = 0;
          this.modelData.residentListAreaWidth = this.modelData.baseResidentListWidth;
          this.mEventManager.doWidthChangeCallback();
        });
        this.onClickResidentLeftArrow();
        break;
      }
      case ArrowType.RESIDENT_RIGHT: {
        if (!this.modelData.arrowModel!.isResidentRightArrowClickable) {
          break;
        }
        this.mDockAnimationMgr.resetItemNearRightArrowEffect();
        this.onClickResidentRightArrow();
        break;
      }
      default:
        logger.showError('onClickArrow:invalid arrow type');
        break;
    }
  }

  public handleDockListScrollStart(): void {
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      return;
    }
    this.mDockAnimationMgr.setHoverItemColumnId('');
  }

  /**
   * Dock栏常驻区或者运行区图标列表事件处理 - 起始
   *
   * @param isResident
   * @param arrowViewData
   */
  public handleDockListReachStart(isResident: boolean, arrowViewData?: DockArrowViewData): void {
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      return;
    }
    this.onAreaReachStart(isResident, arrowViewData);
    this.calculateAreaStartIndex(isResident, arrowViewData);
  }

  /**
   *
   * Dock栏常驻区或者运行区图标列表事件处理 - 截止
   *
   * @param isResident
   * @param arrowViewData
   */
  public handleDockListReachEnd(isResident: boolean, arrowViewData?: DockArrowViewData): void {
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      return;
    }
    this.onAreaReachEnd(isResident, arrowViewData);
    this.calculateAreaStartIndex(isResident, arrowViewData);
  }

  /**
   *
   * Dock栏常驻区或者运行区图标列表事件处理 - 滚动列表结束
   *
   * @param isResident
   */
  public handleDockListScrollEnd(isResident: boolean): void {
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      return;
    }
    this.onAreaScrollStop(isResident);
    this.calculateAreaStartIndex(isResident);

    let itemId: string = this.mDockAnimationMgr.getHoverItemColumnId();
    logger.showInfo(`handleDockListScrollEnd hoverItemColumnId: ${itemId}`);
    if (!CheckEmptyUtils.isEmpty(itemId)) {
      let hoverItemInfo: HoverItemInfo = {
        hoverItemId: itemId,
        screenId: this.screenProp.screenId,
      }
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_ITEM_HOVER_CHANGE, hoverItemInfo);
    }
  }

  private checkStartIndexOffset(isResident: boolean): void {
    const itemWidth: number = this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap;
    if (isResident) {
      if (!this.mResidentScroller) {
        return;
      }

      const currentOffset: number = this.mResidentScroller.currentOffset().xOffset;
      logger.debug(`checkStartIndexOffset ${isResident}: ${this.modelData.residentStartIndex}, ${itemWidth}, ${currentOffset}`);
      const disOffset = this.modelData.residentStartIndex * itemWidth - currentOffset;
      if (Math.abs(disOffset) > 0.1) {
        this.doScroll(this.mResidentScroller, this.modelData.residentStartIndex * itemWidth);
        this.updateResidentArrowState(0);
      }
    } else {
      if (!this.mRecentScroller) {
        return;
      }

      const currentOffset: number = this.mRecentScroller.currentOffset().xOffset;
      logger.debug(`checkStartIndexOffset ${isResident}: ${this.modelData.recentStartIndex}, ${itemWidth}, ${currentOffset}`);
      const disOffset = this.modelData.recentStartIndex * itemWidth - currentOffset;
      if (Math.abs(disOffset) > 0.1) {
        this.doScroll(this.mRecentScroller, this.modelData.recentStartIndex * itemWidth);
        this.updateRecentArrowState(0);
      }
    }
  }

  private onAreaScrollStop(isResident: boolean): void {
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      return;
    }
    if (isResident) {
      if (this.modelData.residentScrollCount > 0) {
        this.modelData.residentScrollCount--;
      }
      this.updateResidentArrowState(0);
    } else {
      if (this.modelData.recentScrollCount > 0) {
        this.modelData.recentScrollCount--;
      }
      this.updateRecentArrowState(0);
    }
  }

  private onAreaReachEnd(isResident: boolean, arrowViewData?: DockArrowViewData): void {
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      return;
    }
    if (isResident) {
      this.modelData.arrowModel!.isResidentLeftArrowClickable = true;
      this.modelData.arrowModel!.isResidentRightArrowClickable = false;

      if (arrowViewData) {
        arrowViewData.isResidentLeftArrowClickable = true;
        arrowViewData.isResidentRightArrowClickable = false;
      }

      this.updateResidentArrowState(0, arrowViewData);
    } else {
      if (this.modelData.recentNum <= this.modelData.recentMaxNum) {
        return;
      }
      this.modelData.arrowModel!.isRecentLeftArrowClickable = true;
      this.modelData.arrowModel!.isRecentRightArrowClickable = false;

      if (arrowViewData) {
        arrowViewData.isRecentLeftArrowClickable = true;
        arrowViewData.isRecentRightArrowClickable = false;
      }

      this.updateRecentArrowState(0, arrowViewData);
    }
  }

  private calculateAreaStartIndex(isResident: boolean, arrowViewData?: DockArrowViewData): void {
    const scroller: Scroller | null = isResident ? this.mResidentScroller : this.mRecentScroller;
    if (!scroller) {
      logger.showInfo('Scroller null');
      return;
    }
    const currentOffset: number = scroller.currentOffset()?.xOffset;
    const itemWidth: number = this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap;
    const index: number = Math.round(Math.floor(currentOffset) / itemWidth);
    if (isResident) {
      this.modelData.residentStartIndex = index;

      if (arrowViewData) {
        arrowViewData.residentStartIndex = index;
      }

      this.updateVisibleResidentList();
    } else {
      this.modelData.recentStartIndex = index;

      if (arrowViewData) {
        arrowViewData.recentStartIndex = index;
      }

      this.updateVisibleRecentList();
    }

    logger.showInfo('calculateAreaStartIndex, %{public}s, %{public}d, %{public}d, %{public}d',
      isResident, currentOffset, itemWidth, index);
  }

  private onAreaReachStart(isResident: boolean, arrowViewData?: DockArrowViewData): void {
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      return;
    }
    if (isResident) {
      this.modelData.arrowModel!.isResidentLeftArrowClickable = false;
      this.modelData.arrowModel!.isResidentRightArrowClickable = true;

      if (arrowViewData) {
        arrowViewData.isResidentLeftArrowClickable = false;
        arrowViewData.isResidentRightArrowClickable = true;
      }

      this.updateResidentArrowState(0, arrowViewData);
    } else {
      if (this.modelData.recentNum <= this.modelData.recentMaxNum) {
        return;
      }

      this.modelData.arrowModel!.isRecentLeftArrowClickable = false;
      this.modelData.arrowModel!.isRecentRightArrowClickable = true;

      if (arrowViewData) {
        arrowViewData.isRecentLeftArrowClickable = false;
        arrowViewData.isRecentRightArrowClickable = true;
      }

      this.updateRecentArrowState(0, arrowViewData);
    }
  }

  private doScroll(scroller: Scroller, xOffset: number): void {
    scroller?.scrollTo({
      xOffset: xOffset,
      yOffset: 0,
      animation: {
        duration: this.modelData.arrowModel!.scrollAnimDuration,
        curve: Curve.Friction
      }
    });
  }

  private updateRecentAreaWidth(): number {
    let width: number = 0;
    if (this.modelData.recentMaxNum >= 0) {
      width = (this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap) * this.modelData.recentMaxNum;
    }

    this.modelData.baseRecentListWidth = width;
    if (this.modelData.baseRecentListWidth) {
      width = width + this.modelData.additionRecentListWidth;
    }

    logger.showInfo(`recentWidth: ${width}, baseWidth: ${this.modelData.baseRecentListWidth}`);
    this.modelData.recentListAreaWidth = width;
    return width;
  }

  private updateResidentAreaWidth(): number {
    let width: number = 0;
    if (this.modelData.residentMaxNum >= 0) {
      width = (this.modelData.residentMaxNum + this.modelData.systemItemList.length) *
        (this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap);
    }
    if (this.isDividerShow()) {
      logger.showInfo(`residentWidth: ${width},DividerWidth: ${this.getDividerWidth()}`);
      width += this.getDividerWidth();
    }

    this.modelData.baseResidentListWidth = width;
    logger.showInfo(`residentWidth: ${width},baseWidth: ${this.modelData.baseResidentListWidth} gap:${this.mStyleConfig.mListItemGap} item:${this.mStyleConfig.mListItemWidth} count:${(this.modelData.residentMaxNum + this.modelData.systemItemList.length)}`);

    if (this.modelData.additionResidentListWidth) {
      width = width + this.modelData.additionResidentListWidth;
    }

    logger.showInfo(`residentWidth: ${width},addWidth: ${this.modelData.additionResidentListWidth} arrow:${this.mStyleConfig.mRecentArrowWidth}`);
    this.modelData.residentListAreaWidth = width;
    return width;
  }

  private updateDockArrowState(): void {
    let fixedMaxNum: number = this.calculateFixedMaxNumWithoutArrow();
    this.calculateIfArrowShow(fixedMaxNum);
    this.recalculateDockAppMaxCount();

    if (this.modelData.arrowModel!.isResidentArrowShow) {
      this.updateResidentArrowState(0);
    }

    this.mDockAnimationMgr.setIsResidentArrowShow(this.modelData.arrowModel!.isResidentArrowShow);
  }

  private initArrowState(arrowViewData?: DockArrowViewData): void {
    this.modelData.arrowModel!.isResidentLeftArrowClickable = false;
    this.modelData.arrowModel!.isResidentRightArrowClickable = true;
    if (arrowViewData) {
      arrowViewData.isResidentLeftArrowClickable = this.modelData.arrowModel!.isResidentLeftArrowClickable;
      arrowViewData.isResidentRightArrowClickable = this.modelData.arrowModel!.isResidentRightArrowClickable;
    }

    this.refreshResidentArrowBgColor(arrowViewData);
  }

  public updateResidentArrowState(offsetX: number, arrowViewData?: DockArrowViewData): void {
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      return;
    }

    if (!this.mResidentScroller) {
      logger.showWarn('mResidentScroller null');
      return;
    }

    if (CheckEmptyUtils.isEmpty(this.mResidentScroller.currentOffset())) {
      this.initArrowState(arrowViewData);
      return;
    }
    const currentOffset: number = this.mResidentScroller.currentOffset().xOffset;
    const itemWidth: number = this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap;
    let dividerWidth: number = 0;
    if (this.isDividerShow() && !this.isDividerVisable()) {
      dividerWidth = this.mStyleConfig.mResidentSplitLineWidth;
    }
    const index: number = Math.round(Math.floor(currentOffset - dividerWidth) / itemWidth);
    this.modelData.arrowModel!.isResidentLeftArrowClickable = true;
    this.modelData.arrowModel!.isResidentRightArrowClickable = true;
    logger.showInfo(`updateResidentArrowState currentOffset:${currentOffset}, index:${index},` +
      `dividerWidth:${dividerWidth}, itemWidth: ${itemWidth}, residentMaxNum: ${this.modelData.residentMaxNum}` +
      `${this.modelData.residentNum},${this.modelData.recentNum}`);
    if (index <= 0) {
      this.modelData.arrowModel!.isResidentLeftArrowClickable = false;
    } else if ((index + this.modelData.residentMaxNum) >= (this.modelData.residentNum + this.modelData.recentNum -
      this.modelData.systemItemList.length)) {
      this.modelData.arrowModel!.isResidentRightArrowClickable = false;
    }

    if (arrowViewData) {
      arrowViewData.isResidentLeftArrowClickable = this.modelData.arrowModel!.isResidentLeftArrowClickable;
      arrowViewData.isResidentRightArrowClickable = this.modelData.arrowModel!.isResidentRightArrowClickable;
    }

    this.refreshResidentArrowBgColor(arrowViewData);
  }

  private isDarkMode(): boolean {
    return this.currColorMode === 0;
  }

  private refreshResidentArrowBgColor(arrowViewData?: DockArrowViewData): void {
    if (this.modelData.arrowModel!.isResidentLeftArrowClickable) {
      this.modelData.arrowModel!.residentLeftArrowBgColor =
        this.modelData.arrowModel!.isResidentLeftArrowHover ? (this.isDarkMode() ?
        FixedDockResource.ARROW_HOVER_DARK_COLOR : FixedDockResource.ARROW_HOVER_LIGHT_COLOR) : null;
      this.modelData.arrowModel!.residentLeftArrowOpacity = 1;
    } else {
      this.modelData.arrowModel!.residentLeftArrowBgColor = null;
      this.modelData.arrowModel!.residentLeftArrowOpacity = $r('sys.float.ohos_id_alpha_disabled');
    }

    if (arrowViewData) {
      arrowViewData.residentLeftArrowBgColor = this.modelData.arrowModel!.residentLeftArrowBgColor;
      arrowViewData.residentLeftArrowOpacity = this.modelData.arrowModel!.residentLeftArrowOpacity;
    }

    if (this.modelData.arrowModel!.isResidentRightArrowClickable) {
      this.modelData.arrowModel!.residentRightArrowBgColor =
        this.modelData.arrowModel!.isResidentRightArrowHover ? (this.isDarkMode() ?
        FixedDockResource.ARROW_HOVER_DARK_COLOR : FixedDockResource.ARROW_HOVER_LIGHT_COLOR) : null;
      this.modelData.arrowModel!.residentRightArrowOpacity = 1;
    } else {
      this.modelData.arrowModel!.residentRightArrowBgColor = null;
      this.modelData.arrowModel!.residentRightArrowOpacity = $r('sys.float.ohos_id_alpha_disabled');
    }

    if (arrowViewData) {
      arrowViewData.residentRightArrowBgColor = this.modelData.arrowModel!.residentRightArrowBgColor;
      arrowViewData.residentRightArrowOpacity = this.modelData.arrowModel!.residentRightArrowOpacity;
    }

    this.mEventManager.doArrowChangeCallback();
  }

  public updateRecentArrowState(offsetX: number, arrowViewData?: DockArrowViewData): void {
    if (this.modelData.recentNum <= this.modelData.recentMaxNum) {
      this.modelData.arrowModel!.isRecentArrowShow = false;

      if (arrowViewData) {
        arrowViewData.isRecentArrowShow = false;
      }

      this.mDockAnimationMgr.setIsRecentArrowShow(this.modelData.arrowModel!.isRecentArrowShow);
      return;
    }

    if (!this.mRecentScroller) {
      logger.showWarn('mRecentScroller null');
      return;
    }

    let currentOffset: OffsetResult = this.mRecentScroller.currentOffset();
    if (!currentOffset) {
      return;
    }
    let finalOffSetX: number = (currentOffset.xOffset) + offsetX;
    let scrollDelta: number = 2;
    let start: number = scrollDelta;
    let end: number = this.getRecentScrollMaxWidth() - scrollDelta;
    this.modelData.arrowModel!.isRecentLeftArrowClickable = true;
    this.modelData.arrowModel!.isRecentRightArrowClickable = true;
    if (finalOffSetX <= start) {
      this.modelData.arrowModel!.isRecentLeftArrowClickable = false;
    } else if (finalOffSetX >= end) {
      this.modelData.arrowModel!.isRecentRightArrowClickable = false;
    }

    if (arrowViewData) {
      arrowViewData.isRecentLeftArrowClickable = this.modelData.arrowModel!.isRecentLeftArrowClickable;
      arrowViewData.isRecentRightArrowClickable = this.modelData.arrowModel!.isRecentRightArrowClickable;
    }

    this.refreshRecentArrowBgColor(arrowViewData);
  }

  private isDividerShow(): boolean {
    if (this.modelData.arrowModel!.isResidentArrowShow) {
      return (!CheckEmptyUtils.isEmptyArr(this.modelData.localResidentList) &&
        !CheckEmptyUtils.isEmptyArr(this.modelData.localRecentList));
    } else {
      return (!CheckEmptyUtils.isEmptyArr(this.modelData.localRecentList));
    }
  }

  private getResidentScrollMaxWidth(): number {
    let width: number = 0;
    let scrollNum: number = this.modelData.residentNum + this.modelData.recentNum -
      this.modelData.systemItemList.length - this.modelData.residentMaxNum;
    width = scrollNum * (this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap);
    if (this.isDividerShow()) {
      width += this.mStyleConfig.mResidentSplitLineWidth;
    }
    return width;
  }

  private getRecentScrollMaxWidth(): number {
    let width: number = 0;
    let scrollNum: number = this.modelData.recentNum - this.modelData.recentMaxNum;
    width = scrollNum * (this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap);
    return width;
  }

  private refreshRecentArrowBgColor(arrowViewData?: DockArrowViewData): void {
    if (this.modelData.arrowModel!.isRecentLeftArrowClickable) {
      this.modelData.arrowModel!.recentLeftArrowBgColor =
        this.modelData.arrowModel!.isRecentLeftArrowHover ? $r('sys.color.ohos_id_color_hover') : null;
      this.modelData.arrowModel!.recentLeftArrowOpacity = 1;
    } else {
      this.modelData.arrowModel!.recentLeftArrowBgColor = null;
      this.modelData.arrowModel!.recentLeftArrowOpacity = $r('sys.float.ohos_id_alpha_disabled');
    }

    if (arrowViewData) {
      arrowViewData.recentLeftArrowBgColor = this.modelData.arrowModel!.recentLeftArrowBgColor;
      arrowViewData.recentLeftArrowOpacity = this.modelData.arrowModel!.recentLeftArrowOpacity;
    }

    if (this.modelData.arrowModel!.isRecentRightArrowClickable) {
      this.modelData.arrowModel!.recentRightArrowBgColor =
        this.modelData.arrowModel!.isRecentRightArrowHover ? $r('sys.color.ohos_id_color_hover') : null;
      this.modelData.arrowModel!.recentRightArrowOpacity = 1;
    } else {
      this.modelData.arrowModel!.recentRightArrowBgColor = null;
      this.modelData.arrowModel!.recentRightArrowOpacity = $r('sys.float.ohos_id_alpha_disabled');
    }

    if (arrowViewData) {
      arrowViewData.recentRightArrowBgColor = this.modelData.arrowModel!.recentRightArrowBgColor;
      arrowViewData.recentRightArrowOpacity = this.modelData.arrowModel!.recentRightArrowOpacity;
    }

    this.mEventManager.doArrowChangeCallback();
  }

  private calculateIfArrowShow(fixedMaxNum: number) {
    if ((this.modelData.residentNum + this.modelData.recentNum) <= fixedMaxNum) {
      this.modelData.arrowModel!.isResidentArrowShow = false;
      this.modelData.arrowModel!.isResidentLeftArrowClickable = false;
      this.modelData.arrowModel!.isResidentRightArrowClickable = false;
    } else {
      this.modelData.arrowModel!.isResidentArrowShow = true;
      this.modelData.arrowModel!.isResidentLeftArrowClickable = true;
      this.modelData.arrowModel!.isResidentRightArrowClickable = true;
    }
    logger.showInfo(`calculateIfArrowShow ${this.modelData.residentNum}, ${this.modelData.recentNum}, ${fixedMaxNum}, ${this.modelData.arrowModel!.isResidentArrowShow}`);
  }

  private updateVisibleRecentList(): void {
    logger.showInfo(`recentVisibleListUpdate ${this.modelData.recentStartIndex}, ${this.modelData.recentMaxNum}`);

    const endIndex: number = this.modelData.recentStartIndex + this.modelData.recentMaxNum;
    const visibleArea = this.modelData.localRecentList.slice(this.modelData.recentStartIndex, endIndex);
    this.mDockAnimationMgr.setRecentVisibleList(visibleArea);

    if (this.modelData.recentStartIndex > 0) {
      this.mDockAnimationMgr.resetItemEffect(this.modelData.localRecentList[this.modelData.recentStartIndex - 1]);
    }

    if (endIndex < this.modelData.localRecentList.length) {
      this.mDockAnimationMgr.resetItemEffect(this.modelData.localRecentList[endIndex]);
    } else {
      this.mDockAnimationMgr.resetItemEffect(this.modelData.deviceInfo as DockItemInfo, true);
    }
  }

  private updateVisibleResidentList(): void {
    logger.showInfo(`updateVisibleResidentList ${this.modelData.residentStartIndex}, ${this.modelData.residentMaxNum}, ` +
      `${this.modelData.localResidentList.length}, ${this.modelData.localRecentList.length},` +
      `${this.modelData.arrowModel!.isResidentArrowShow}`);
    let commonItemList = [...this.modelData.localResidentList, ...this.modelData.localRecentList];
    if (!this.modelData.arrowModel!.isResidentArrowShow) {
      this.mDockAnimationMgr.setCommonVisibleList(commonItemList);
      return;
    }
    const endIndex: number = this.modelData.residentStartIndex + this.modelData.residentMaxNum;
    const visibleArea: DockItemInfo[] = commonItemList.slice(this.modelData.residentStartIndex, endIndex);
    this.mDockAnimationMgr.setCommonVisibleList(visibleArea);
    if (this.modelData.residentStartIndex > 0) {
      this.mDockAnimationMgr.resetItemEffect(commonItemList[this.modelData.residentStartIndex - 1])
    }
    if (endIndex < commonItemList.length) {
      this.mDockAnimationMgr.resetItemEffect(commonItemList[endIndex]);
    }
  }

  private recalculateDockAppMaxCount(): void {
    const fixedMaxNum: number = this.calculateFixedMaxNum();
    if (this.modelData.residentNum + this.modelData.recentNum <= fixedMaxNum) {
      this.modelData.residentMaxNum = this.modelData.residentNum + this.modelData.recentNum -
      this.modelData.systemItemList.length;
    } else {
      this.modelData.residentMaxNum = fixedMaxNum - this.modelData.systemItemList.length;
    }
    logger.showInfo(`recalculateDockAppMaxCount ${this.modelData.residentMaxNum}, ${fixedMaxNum}`);
  }

  private getDividerWidth(): number {
    if (this.modelData.arrowModel!.isResidentArrowShow) {
      return this.mStyleConfig.mResidentSplitLineWidth;
    } else {
      return (this.mStyleConfig.mResidentSplitLineWidth + this.mStyleConfig.mListItemGap / 2 +
        this.mStyleConfig.mListItemGap / 2);
    }
  }

  private calculateFixedMaxNumWithoutArrow(): number {
    let maxIconListWidth: number = this.modelData.screenWidth - 48;
    if (this.isDividerShow()) {
      maxIconListWidth -= this.getDividerWidth();
    }
    let fixedMaxNum = Math.floor(maxIconListWidth /
      (this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap));
    logger.showInfo(`calculateFixedMaxNumWithoutArrow: ${fixedMaxNum}`);
    return fixedMaxNum;
  }

  private calculateFixedMaxNum(): number {
    // 常驻区+最近区同时显示图标的最大数量
    let maxIconListWidth: number = this.modelData.screenWidth - 48;
    if (this.isDividerShow()) {
      maxIconListWidth -= this.getDividerWidth();
    }
    if (this.modelData.arrowModel!.isResidentArrowShow) {
      maxIconListWidth -= (2 * this.mStyleConfig.mRecentArrowWidth);
    }
    let fixedMaxNum = Math.floor(maxIconListWidth /
      (this.mStyleConfig.mListItemWidth + this.mStyleConfig.mListItemGap));
    let maxNum: number = fixedMaxNum;
    logger.showInfo(`FixedMaxNum: ${maxNum}`);
    return maxNum;
  }

  private existContinuableItem(): boolean {
    return ObjUtil.isValid(this.modelData.deviceInfo) && ObjUtil.isValid(this.modelData.deviceInfo.bundleName) &&
    ObjUtil.isValid(this.modelData.deviceInfo.sourceDeviceName);
  }
}