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

import ArrayList from '@ohos.util.ArrayList';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { AppItemInfo, AppModel, DockItemInfo, EventConstants, RecentBundleMissionInfo,
  ResidentLayoutCacheMgr,
  SmartDockStyleConfig } from '@ohos/launchercommon';
import HoverEffectConstants from '../common/constants/HoverEffectConstants';
import { ArrowType, FixedDockResource } from '../common/constants/FixedDockConstants';
import PcSmartDockViewModel from '../viewmodel/SmartDockViewModel';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import { PcSmartDockModel } from '../model/PcSmartDockModel';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import { UIContext } from '@kit.ArkUI';

/**
 * PC Dock 动效处理
 */

const TAG = 'PcDockAnimationMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);
// 普通应用图标
const COMMON_ICON_TYPE: string = 'CommonIcon';
// 接续图标
const CONTINUE_ICON_TYPE: string = 'ContinueIcon';

// 相邻三个元素放大倍数总和
const MAX_SCALE_SUM: number = HoverEffectConstants.MAX_SCALE +
  (HoverEffectConstants.MAX_SCALE - (HoverEffectConstants.MAX_SCALE - 1) / HoverEffectConstants.MAX_SCALE_REGION) * 2;

export class PcDockAnimationMgr {
  private static mDockAnimateManagers: Map<number, PcDockAnimationMgr> = new Map<number, PcDockAnimationMgr>();
  private companionEffectMap: Map<string, ArrayList<DockCompanionEffect>> =
    new Map<string, ArrayList<DockCompanionEffect>>();
  private appIconDataMap: Map<string, AppIconData> = new Map<string, AppIconData>();
  private isResidentArrowShow: boolean = false;
  private isRecentArrowShow: boolean = true;
  private systemVisibleList: DockItemInfo[] = [];
  private residentVisibleList: DockItemInfo[] = []; // 去掉应用中心、多任务,回收站调整到最后 的快捷区列表,
  private recentVisibleList: DockItemInfo[] = [];
  private commonVisibleList: DockItemInfo[] = [];
  private isHoveringDock: boolean = false;
  private mSmartDockViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  private prevIconShadowOffsetX: number = 0;
  private prevIconShadowOffsetY: number = 0;
  private curIconShadowOffsetX: number = 0;
  private curIconShadowOffsetY: number = 0;
  private nextIconShadowOffsetX: number = 0;
  private nextIconShadowOffsetY: number = 0;
  private prevItemScale: number = HoverEffectConstants.FIXED_HOVER_COMPANION_SCALE;
  private nextItemScale: number = HoverEffectConstants.FIXED_HOVER_COMPANION_SCALE;
  private curItemScale: number = HoverEffectConstants.FIXED_HOVER_MASTER_SCALE;
  public screenId: number = 0;
  private collaborationVisibleList: DockItemInfo[] = [];
  private mIsListScrolling: boolean = false;

  private lastItem: DockItemInfo | undefined;
  private hoverItemColumnId: string = '';

  private mDockIconSize: number = 0;

  private constructor(screenId: number) {
    log.showInfo('Launcher PcDockAnimationMgr constructor');
    this.screenId = screenId;
  }

  public static getInstance(screenId: number): PcDockAnimationMgr {
    let instance: PcDockAnimationMgr | undefined = PcDockAnimationMgr.mDockAnimateManagers.get(screenId);
    if (!instance) {
      log.showInfo(`initDockAnimationManager ${PcDockAnimationMgr.mDockAnimateManagers.size}-${screenId}`);
      instance = new PcDockAnimationMgr(screenId);
      PcDockAnimationMgr.mDockAnimateManagers.set(screenId, instance);
    }
    return instance;
  }

  public static release(screenId: number): void {
    PcDockAnimationMgr.mDockAnimateManagers.delete(screenId);
  }

  public setIconData(dockItemInfo: DockItemInfo, iconData: AppIconData): void {
    const keyName = this.getKeyName(dockItemInfo);
    this.appIconDataMap.set(keyName, iconData);
  }

  public deleteIconData(dockItemInfo: DockItemInfo): void {
    const keyName = this.getKeyName(dockItemInfo);
    this.appIconDataMap.delete(keyName);
  }

  public getIconData(keyName: string): AppIconData {
    const iconData = this.appIconDataMap.get(keyName);
    if (iconData === undefined) {
      return new AppIconData();
    }
    return iconData;
  }

  public setScrolling(isListScrolling: boolean): void {
    this.mIsListScrolling = isListScrolling;
  }

  public isListScrolling(): boolean {
    return this.mIsListScrolling;
  }

  public setIsResidentArrowShow(residentArrowShow: boolean): void {
    this.isResidentArrowShow = residentArrowShow;
  }

  public setIsRecentArrowShow(recentArrowShow: boolean): void {
    this.isRecentArrowShow = recentArrowShow;
  }

  public setResidentVisibleList(residentArray: Array<DockItemInfo>): void {
    log.showInfo(`setResidentVisibleList ${this.screenId}-${residentArray?.length}-${this.residentVisibleList?.length}`);
    this.residentVisibleList = residentArray;
    this.printListHilog(this.residentVisibleList, 'residentVisibleList');
  }

  public setRecentVisibleList(recentArray: Array<DockItemInfo>): void {
    this.recentVisibleList = recentArray;
    this.printListHilog(this.recentVisibleList, 'recentVisibleList');
  }

  public getResidentVisibleList(): Array<DockItemInfo> {
    return this.residentVisibleList;
  }

  public getRecentVisibleList(): Array<DockItemInfo> {
    return this.recentVisibleList;
  }

  public setCommonVisibleList(visibleList: DockItemInfo[]): void {
    log.showInfo(`setCommonVisibleList ${this.screenId}-${visibleList?.length}-${this.commonVisibleList?.length}`);
    this.commonVisibleList = visibleList;
    this.printListHilog(this.commonVisibleList, 'commonVisibleList');
  }

  public setSystemVisibleList(visibleList: DockItemInfo[]): void {
    log.showInfo(`setSystemVisibleList ${this.screenId}-${visibleList?.length}-${this.systemVisibleList?.length}`);
    this.systemVisibleList = visibleList;
    this.printListHilog(this.systemVisibleList, 'systemVisibleList');
  }

  public setCollaborationVisibleList(visibleList: DockItemInfo[]): void {
    log.showInfo(`setCollaborationVisibleList ${this.screenId}-${visibleList?.length}-` +
      `${this.collaborationVisibleList?.length}`);
    this.collaborationVisibleList = visibleList;
    this.printListHilog(this.collaborationVisibleList, 'collaborationVisibleList');
  }

  public getIsHoveringDock(): boolean {
    return this.isHoveringDock;
  }

  public setIsHoveringDock(isHoveringDock: boolean): void {
    this.isHoveringDock = isHoveringDock;
  }

  public getPrevItemScale(): number {
    return this.prevItemScale;
  }

  public getNextItemScale(): number {
    return this.nextItemScale;
  }

  public getCurrentItemScale(): number {
    return this.curItemScale;
  }

  public getCurrentIconShadowOffsetX(): number {
    return this.curIconShadowOffsetX;
  }

  public getCurrentIconShadowOffsetY(): number {
    return this.curIconShadowOffsetY;
  }
  private mSmartDockStyleConfig: SmartDockStyleConfig = PcSmartDockViewModel.getInstance().getStyleConfig();

  private getItemWidth(scale: number): number {
    return scale * this.mSmartDockStyleConfig.mListItemWidth + this.mSmartDockStyleConfig.mListItemGap;
  }

  public computeHoverScale(item: DockItemInfo, leftDistance: number, padding: number, itemWidth: number): void {
    if (item !== this.lastItem) {
      this.lastItem = item;
      this.prevItemScale = HoverEffectConstants.FIXED_HOVER_RESET;
      this.curItemScale = HoverEffectConstants.FIXED_HOVER_RESET;
      this.nextItemScale = HoverEffectConstants.FIXED_HOVER_RESET;
    }
    const maxWidth: number = HoverEffectConstants.MAX_SCALE_REGION * itemWidth;
    const preItemWidth = this.getItemWidth(this.prevItemScale);
    const nextItemWidth = this.getItemWidth(this.nextItemScale);
    const currDis = Math.abs(leftDistance - itemWidth / 2); // 鼠标与当前图标中心点距离
    const preDis = leftDistance + preItemWidth / 2; // 鼠标与前一图标中心点距离
    const nextDis = nextItemWidth / 2 + itemWidth - leftDistance; // 鼠标与后一图标中心点距离
    this.curItemScale = HoverEffectConstants.MAX_SCALE - (HoverEffectConstants.MAX_SCALE - 1) * currDis / maxWidth;
    this.prevItemScale = HoverEffectConstants.MAX_SCALE - (HoverEffectConstants.MAX_SCALE - 1) * preDis / maxWidth;
    this.nextItemScale = HoverEffectConstants.MAX_SCALE - (HoverEffectConstants.MAX_SCALE - 1) * nextDis / maxWidth;
    // 做scale补偿，始终让做缩放的三个图标的放大倍数=3.33，这样Hover时末端图标不抖动
    const div: number = MAX_SCALE_SUM / (this.curItemScale + this.prevItemScale + this.nextItemScale);
    this.curItemScale = this.adjustScale(this.curItemScale * div);
    this.prevItemScale = this.adjustScale(this.prevItemScale * div);
    this.nextItemScale = this.adjustScale(this.nextItemScale * div);
    log.showDebug(`scale: pre:${this.prevItemScale} cur:${this.curItemScale} next:${this.nextItemScale}`);
  }

  private adjustScale(scale: number): number {
    if (scale > HoverEffectConstants.MAX_SCALE) {
      return HoverEffectConstants.MAX_SCALE;
    } else if (scale < 1.0) {
      return 1.0;
    }
    return scale;
  }

  public computeIconShadow(leftDistance: number, topDistance: number, itemWidth: number, dockHeight: number): void {
    log.showDebug(`leftDistance: ${leftDistance}, topDistance: ${topDistance}`);
    if (leftDistance > itemWidth * 2 || topDistance > itemWidth * 2) {
      return;
    }
    const baseOffsetX: number = HoverEffectConstants.HALF_SHADOW_OFFSET -
      leftDistance / (itemWidth / 2) * HoverEffectConstants.HALF_SHADOW_OFFSET;
    this.curIconShadowOffsetX = baseOffsetX;
    this.prevIconShadowOffsetX = baseOffsetX / 2 - HoverEffectConstants.SHADOW_OFFSET;
    this.nextIconShadowOffsetX = HoverEffectConstants.SHADOW_OFFSET + baseOffsetX / 2;

    const baseOffsetY: number = HoverEffectConstants.MAX_SHADOW_OFFSET -
      topDistance / (dockHeight / 2) * HoverEffectConstants.MAX_SHADOW_OFFSET;
    this.curIconShadowOffsetY = baseOffsetY;
    this.prevIconShadowOffsetY = baseOffsetY;
    this.nextIconShadowOffsetY = baseOffsetY;
  }

  public judgeEdgeItem(item: DockItemInfo, residentFlag: boolean, systemFlag: boolean = false): EdgeFlag {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError(`judgeEdgeItem error,item is empty`);
      return { index: -1, isInEdge: false };
    }
    let itemList: DockItemInfo[] = [];
    if (systemFlag) {
      itemList = this.systemVisibleList;
    } else {
      itemList = this.commonVisibleList;
    }
    const index: number = itemList.findIndex((listItem: DockItemInfo) => {
      return this.checkIsSameItem(listItem, item);
    });
    const isInEdge = (systemFlag && index === 0) || (!systemFlag && index === itemList.length - 1);
    log.showDebug(`judgeEdgeItem, bundleName: ${item.bundleName}, index: ${index}, isInEdge: ${isInEdge}, residentFlag: ${residentFlag}, systemFlag: ${systemFlag}`);
    return { index: index, isInEdge: isInEdge };
  }

  public registerCompanionEffect(item: DockItemInfo, companionEffect: DockCompanionEffect,
    isContinueItem: boolean = false): void {
    const key: string = this.getKeyName(item, isContinueItem);
    let companionEffects = this.companionEffectMap.get(key) ?? new ArrayList<DockCompanionEffect>();
    companionEffects.add(companionEffect);
    this.companionEffectMap.set(key, companionEffects);
  }

  public unRegisterCompanionEffect(item: DockItemInfo, companionEffect: DockCompanionEffect,
    isContinueItem: boolean = false): void {
    const key: string = this.getKeyName(item, isContinueItem);
    let companionEffects = this.companionEffectMap.get(key);
    companionEffects?.remove(companionEffect);
    if (companionEffects?.isEmpty()) {
      this.companionEffectMap.delete(key);
    }
  }

  public resetAllEffect(): void {
    log.showInfo(`resetAllEffect happen`);
    this.systemVisibleList.forEach((item: DockItemInfo) => {
      this.TriggerCompanionEffect(item, HoverEffectConstants.FIXED_HOVER_RESET,
        0, SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE);
    });
    this.commonVisibleList.forEach((item: DockItemInfo) => {
      this.TriggerCompanionEffect(item, HoverEffectConstants.FIXED_HOVER_RESET,
        0, SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE);
    });
  }

  /**
   * 还原箭头附近的图标缩放大小
   * @param arrowType
   */
  public resetItemNearArrowEffect(arrowType: ArrowType): void {
    if (arrowType === ArrowType.RESIDENT_LEFT) {
      this.resetItemNearLeftArrowEffect();
    } else if (arrowType === ArrowType.RESIDENT_RIGHT) {
      this.resetItemNearRightArrowEffect();
    }
  }

  // 还原左键头左右两个图标的大小
  public resetItemNearLeftArrowEffect(): void {
    if (this.systemVisibleList.length <= 0) {
      return;
    }
    for (let i = this.systemVisibleList.length - 1; i >= 0 && i >= (this.systemVisibleList.length - 2); i--) {
      this.TriggerCompanionEffect(this.systemVisibleList[i], HoverEffectConstants.FIXED_HOVER_RESET,
        0, SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE);
    }
    if (this.commonVisibleList.length <= 0) {
      return;
    }
    for (let i = 0; i < this.commonVisibleList.length && i < 2; i++) {
      this.TriggerCompanionEffect(this.commonVisibleList[i], HoverEffectConstants.FIXED_HOVER_RESET,
        0, SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE);
    }
  }

  // 还原右键头左边两个图标的大小
  public resetItemNearRightArrowEffect(): void {
    if (this.commonVisibleList.length <= 0) {
      return;
    }
    for (let i = this.commonVisibleList.length - 1; i >= 0 && i >= (this.commonVisibleList.length - 2); i--) {
      this.TriggerCompanionEffect(this.commonVisibleList[i], HoverEffectConstants.FIXED_HOVER_RESET,
        0, SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE);
    }
  }

  public resetItemEffect(item: DockItemInfo, isContinueItem: boolean = false): void {
    this.TriggerCompanionEffect(item, HoverEffectConstants.FIXED_HOVER_RESET, 0,
      SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE, isContinueItem);
    log.showInfo(`resetItemEffect, ${item?.bundleName}, ${isContinueItem},${item?.appIndex}`);
  }

  /**
   * 判断组件是否在可视区域
   * @param appInfo
   * @param isResident
   * @returns
   */
  public isInVisibleArea(appInfo: DockItemInfo, isResident: boolean, systemFlag: boolean): boolean {
    let itemList: DockItemInfo[] = systemFlag ? this.systemVisibleList : this.commonVisibleList;
    const index = itemList.findIndex((item: DockItemInfo) => {
      return this.checkIsSameItem(item, appInfo);
    });
    if (index >= 0) {
      this.printHilog(true, appInfo, 'DockVisibleList');
      return true;
    }
    log.showInfo(`not in VisibleArea, ${this.screenId}, ${appInfo.bundleName}, ${appInfo.abilityName}` +
      ` ${this.systemVisibleList?.length}-${this.commonVisibleList?.length}`);
    return false;
  }

  private printHilog(isIn: boolean, appInfo: DockItemInfo, listName: string): void {
    log.showInfo(`in VisibleArea, ${this.screenId}, ${listName}, ${appInfo?.bundleName}, ${appInfo?.abilityName}` +
      ` ${this.systemVisibleList?.length}- ${this.commonVisibleList?.length}`);
  }

  public isInDockVisibleList(item: AppItemInfo): boolean {
    let index = this.residentVisibleList.findIndex((dockItem: DockItemInfo) => {
      return this.checkIsSameItem(dockItem, item);
    });
    log.showInfo(`isInDockVisibleList, ${this.screenId}, ${item.bundleName}, ${item.abilityName}, ${index}, ` +
      `residentVisibleList: ${this.residentVisibleList?.length}`);
    if (index >= 0) {
      return true;
    }
    index = this.recentVisibleList.findIndex((dockItem: DockItemInfo) => {
      return this.checkIsSameItem(dockItem, item);
    });
    log.showInfo(`isInDockVisibleList, ${this.screenId}, ${item.bundleName}, ${item.abilityName}, ${index}, ` +
      `recentVisibleList: ${this.recentVisibleList?.length}`);
    if (index >= 0) {
      return true;
    }
    if (!CheckEmptyUtils.isEmptyArr(this.collaborationVisibleList)) {
      index = this.collaborationVisibleList.findIndex((dockItem: DockItemInfo) => {
        return this.checkIsSameItem(dockItem, item);
      });
      log.showInfo(`isInDockVisibleList, ${this.screenId}, ${item.bundleName}, ${item.abilityName}, ${index}, ` +
        `collaborationVisibleList: ${this.collaborationVisibleList?.length}`);
      if (index >= 0) {
        return true;
      }
    }
    return false;
  }

  /**
   * 常驻区和固定区无箭头，两区动效联动。否则不联动
   * @param bundleName
   * @param abilityName
   * @param hasEffect  true表示hover in放大动效，false表示hover out缩小动效
   * @param isContinueItem 是否接续图标
   */
  public doCompanionEffect(item: DockItemInfo, isContinueItem: boolean): void {
    log.showInfo(`doCompanionEffect,bundleName:${item.bundleName}, abilityName:${item.abilityName}, persistentId:${item.persistentId}, isContinueItem：${isContinueItem}, length: ${this.recentVisibleList.length}`);
    let dockList: DockItemInfo[] = [];
    dockList = [...this.systemVisibleList, ...this.commonVisibleList];
    this.doListItemEffect(dockList, true, item);
  }

  private checkIsSystemItem(appItem: AppItemInfo): boolean {
    const index = this.systemVisibleList.findIndex((item: DockItemInfo) => {
      return this.checkIsSameItem(item, appItem);
    });
    return index >= 0;
  }

  /**
   * dock最小化动效。 根据应用图标的位置和dock可视窗的位置，来确定落位动效和落位位置
   * @param appItem
   * @returns
   */
  public getIconRect(appItem: AppItemInfo, context?: UIContext): DockMinimizeItem {
    let isSystemItem: boolean = this.checkIsSystemItem(appItem);
    let visualAreaRect: RectInfo;
    let traceId: string = 'SmartDock_AppIcon';
    if (!CheckEmptyUtils.isEmpty(appItem?.persistentId)) {
      traceId = traceId + '_' + appItem?.persistentId;
      isSystemItem = false;
    }
    if (isSystemItem) {
      visualAreaRect = ItemUtils.getCmpRect(FixedDockResource.DOCK_SYSTEM_AREA_ID, this.screenId, context);
    } else {
      visualAreaRect = ItemUtils.getCmpRect(FixedDockResource.DOCK_COMMON_AREA_ID, this.screenId, context);
    }
    let itemRect = ItemUtils.getCmpRect(AppModel.getInstance().getAppIconContainerId(
      traceId, appItem.bundleName, appItem.abilityName, appItem.appIndex, appItem.appInstanceKey), this.screenId,
      context);
    // list 存在缓存机制，若添加的应用不在list里可视区里，会存在不创建listItem的情况，进入在可视区域才会创建,cachedCount默认为1
    const rectEmpty = this.checkRectEmpty(itemRect);
    if (!rectEmpty && itemRect.left >= visualAreaRect.left && itemRect.right <= visualAreaRect.right) {
      return {
        minimizeItemRect: itemRect,
        isHide: false
      };
    }
    const fallingArrowType: ArrowType = this.getFallingArrowType(rectEmpty, true, itemRect, visualAreaRect);
    itemRect = ItemUtils.getCmpRect(this.mSmartDockViewModel.getDockArrowId(true, fallingArrowType), this.screenId);
    log.showInfo(`bundleName: ${appItem.bundleName}, ${appItem.abilityName}, ${isSystemItem}, ${visualAreaRect.left}, ${fallingArrowType}, ${itemRect.left}`);
    return {
      minimizeItemRect: itemRect,
      isHide: true
    };
  }

  private getKeyName(item: DockItemInfo, isContinueItem: boolean = false): string {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError(`getkeyName item is null error`);
      return '';
    }
    const iconType: string = isContinueItem ? CONTINUE_ICON_TYPE : COMMON_ICON_TYPE;
    const key: string = item?.bundleName + '_' + item?.appIndex + '_' + item?.abilityName + '_' +
      iconType + '_' + (item?.persistentId ?? '') + '_' + (item?.appInstanceKey ?? '');
    log.showDebug(`getkeyName key: ${key}`);
    return key;
  }

  /**
   *
   * @param list  待遍历的列表
   * @param listType 是否为运行区列表，运行区列表是最后一个时，需检查是否有接续图标存在
   * @param item
   */
  private doListItemEffect(list: DockItemInfo[], listType: boolean, item: DockItemInfo): void {
    let index = -1;
    list.forEach((listItem: DockItemInfo, listIndex: number) => {
      if (this.checkIsSameItem(listItem, item)) {
        index = listIndex;
      }
    });
    log.showInfo(`doListItemEffect index: ${index}`);
    if (index !== -1) {
      this.doPreOrNextEffect(index, list);
    }
  }

  private doPreOrNextEffect(index: number, list: DockItemInfo[]): void {
    if (list[index - 1]) {
      this.TriggerCompanionEffect(list[index - 1], this.prevItemScale, this.prevIconShadowOffsetX,
        this.prevIconShadowOffsetY);
    }
    if (list[index + 1]) {
      this.TriggerCompanionEffect(list[index + 1], this.nextItemScale, this.nextIconShadowOffsetX,
        this.nextIconShadowOffsetY);
    }
    list.forEach((listItem: DockItemInfo, listIndex: number) => {
      if (listIndex < index - 1 || listIndex > index + 1) {
        this.TriggerCompanionEffect(listItem, HoverEffectConstants.FIXED_HOVER_RESET, 0,
          SmartDockConstants.DOCK_ITEM_SHADOW_OFFSETY_ONE);
      }
    });
    log.showInfo(`doPreOrNextEffect index ${index}`);
  }

  private TriggerCompanionEffect(item: DockItemInfo, scale: number, shadowOffsetX?: number, shadowOffsetY?: number,
    isContinueItem: boolean = false): void {
    const keyName = this.getKeyName(item, isContinueItem);
    const effectList: ArrayList<DockCompanionEffect> | undefined = this.companionEffectMap.get(keyName);
    effectList?.forEach(
      (effect) => {
        if (effect?.triggerCompanionEffect) {
          effect?.triggerCompanionEffect(scale, shadowOffsetX, shadowOffsetY);
        }
      }
    );
  }

  private checkIsResidentItem(appItem: AppItemInfo): boolean {
    let isResidentItem: boolean = false;
    let resistDockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    resistDockItems.find((item: DockItemInfo) => {
      if (this.checkIsSameItem(item, appItem)) {
        isResidentItem = true;
        return true;
      }
      return false;
    });
    let recentItems: RecentBundleMissionInfo[] = AppStorage.get('recentList') as RecentBundleMissionInfo[];
    recentItems.find((item: RecentBundleMissionInfo) => {
      if (this.checkIsSameItem(item, appItem)) {
        isResidentItem = false;
        return true;
      }
      return false;
    });
    log.showInfo(`checkIsResidentItem, isResidentItem: ${isResidentItem}`);
    return isResidentItem;
  }

  private checkRectEmpty(itemRect: RectInfo): boolean {
    let result: boolean = false;
    if (CheckEmptyUtils.isEmpty(itemRect)) {
      result = true;
    }
    if (itemRect.left === 0 && itemRect.right === 0 && itemRect.top === 0 && itemRect.bottom === 0) {
      result = true;
    }
    log.showInfo(`checkRectEmpty, result: ${result}`);
    return result;
  }

  private getFallingArrowType(rectEmpty: boolean, isResidentItem: boolean, itemRect: RectInfo,
      visualAreaRect: RectInfo): ArrowType {
    let fallingArrowType: ArrowType;
    if (!rectEmpty) {
      if (isResidentItem && itemRect.right < visualAreaRect.left) {
        fallingArrowType = ArrowType.RESIDENT_LEFT;
      } else if (isResidentItem && itemRect.left > visualAreaRect.right) {
        fallingArrowType = ArrowType.RESIDENT_RIGHT;
      } else if (!isResidentItem && itemRect.right <= visualAreaRect.left) {
        fallingArrowType = ArrowType.RECENT_LEFT;
      } else {
        fallingArrowType = ArrowType.RECENT_RIGHT;
      }
    } else {
      if (isResidentItem) {
        fallingArrowType = ArrowType.RESIDENT_RIGHT;
      } else {
        fallingArrowType = ArrowType.RECENT_RIGHT;
      }
    }
    log.showInfo('getFallingArrowType, %{public}s,%{public}d, %{public}d, %{public}d, %{public}d, %{public}d',
      isResidentItem, itemRect.left, itemRect.right, visualAreaRect.left, visualAreaRect.right, fallingArrowType);
    return fallingArrowType;
  }

  private printListHilog(array: Array<DockItemInfo>, listName: string): void {
    if (CheckEmptyUtils.isEmptyArr(array)) {
      log.showWarn(`array is empty`);
      return;
    }
    const size = array.length;
    log.showInfo(`${listName}: firstItem: ${array[0]?.bundleName}, lastItem: ${array[size - 1]?.bundleName}, ` +
      `size: ${size}`);
  }

  private checkIsSameItem(dockItem: DockItemInfo | RecentBundleMissionInfo,
    item: AppItemInfo | DockItemInfo): boolean {
    if (dockItem === undefined || item === undefined) {
      log.showWarn('dockItem or item empty!');
      return false;
    }
    return dockItem?.abilityName === item.abilityName &&
      (dockItem?.persistentId ?? '') === (item.persistentId ?? '') &&
    SmartDockModel.getInstance().checkSameDockItem(dockItem, item);
  }

  public setHoverItemColumnId(hoverItemColumnId: string): void {
    this.hoverItemColumnId = hoverItemColumnId;
  }

  public getHoverItemColumnId(): string {
    return this.hoverItemColumnId;
  }

  public setDockIconSize(iconSize: number): void {
    this.mDockIconSize = iconSize;
  }

  public getDockIconSize(): number {
    return this.mDockIconSize;
  }
}

export type TriggerCompanion = (companionScale: number, shadowOffsetX?: number, shadowOffsetY?: number) => void;

export class DockCompanionEffect {
  public triggerCompanionEffect: TriggerCompanion | null = null;
}

export class DockMinimizeItem {
  public minimizeItemRect: RectInfo = new RectInfo();
  public isHide: boolean = false;
}

export class EdgeFlag {
  public index: number = 0;
  public isInEdge: boolean = false;
}