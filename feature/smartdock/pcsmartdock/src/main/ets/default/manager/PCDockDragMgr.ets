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

import { StartType, CheckEmptyUtils, LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { DropAnimationParam } from '@ohos/componentanimator';
import { SCBConstants, DragConstants } from '@ohos/commonconstants';
import { DragEventCallback } from '@ohos/componentdrag';
import { dragSnapshotHelper, SnapshotType } from '@ohos/componenthelper';
import { DragControllerParams } from '@ohos/componenthelper/Index';
import {
  localEventManager,
  GlobalContext,
  SCBWindowSceneConfig,
  IconResourceManager,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { ResUtils, SCBTransitionManager } from '@ohos/windowscene';
import { SCBCompanionManager } from '@ohos/windowscene/Index';
import {
  AppIconModel,
  AppModel,
  CommonConstants,
  DockItemInfo,
  EventConstants,
  GridLayoutItemInfo,
  ResidentLayoutCacheMgr
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  LayoutViewModel,
  AppItemInfo,
  PageDesktopModel,
  GridLayoutUtil,
  StyleConstants
} from '@ohos/launchercommon';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import type ctx from '@ohos.app.ability.common';
import HashMap from '@ohos.util.HashMap';
import { dragTriggerUtil } from '@ohos/launchercommon/src/main/ets/utils/DragTriggerUtil';
import image from '@ohos.multimedia.image';
import HoverEffectConstants from '../common/constants/HoverEffectConstants';
import { FixedDockResource } from '../common/constants/FixedDockConstants';
import { PcModeDockUtils } from '@ohos/smartdock/src/main/ets/default/utils/PcModeDockUtils';
import { PCDockUtils } from '../utils/PCDockUtils';

const TAG = 'PCDockDragMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MIN_INTERNAL: number = 10;

/**
 * 处理(桌面app图标拖动到dock栏添加图标、)dock栏图标直接拖拽移动和添加
 */
export class PCDockDragMgr {
  public isDockDragging: boolean = false;
  public residentNumCache: number = 0; // system + resident
  public recentNumCache: number = 0;
  public isDragStartDropFrameShow: boolean = false;
  public dragItemDockType: number = -1;
  /**
   * 自动隐藏落位框TimerId
   */
  private cancelSqueezedInDockTimerId: number = 0;
  private globalResidentList: DockItemInfo[] = [];
  private localResidentList: Array<DockItemInfo> = [];
  private systemResidentList: Array<DockItemInfo> = [];
  private localRecentList: Array<DockItemInfo> = [];
  private mSmartDockModel: SmartDockModel = SmartDockModel.getInstance();
  private mAppModel = AppModel.getInstance();
  private static instance: PCDockDragMgr;
  private dropFrameDockType: number = -1;
  /**
   * 落位框位置
   */
  private dropFrameRect: Rectangle | undefined = undefined;
  private dropFrameRectBundleName: string = '';
  private dragItem: DockItemInfo | AppItemInfo | undefined = undefined;
  private dropItem: DockItemInfo | undefined = undefined;
  /**
   * 鼠标在拖动截图的相对位置
   */
  private dragSnapshotRelativeRect: Rectangle | undefined = undefined;
  private onDockListNumChangeInDrag: ((addResidentNum: number, addRecentNum: number,
    hasAnim: boolean, dockChanged?: boolean) => void) | undefined = undefined;
  private isShowDropFrame: boolean = false;
  private isShowRightDropFrame: boolean = false;
  private isDropAnimating: boolean = false;
  private lastDragMoveX: number = 0;
  private lastDragMoveY: number = 0;
  private dragParams: DragControllerParams = {};
  public foldHappen: boolean = false;
  public dropFrameDockItem: DockItemInfo | undefined = undefined;

  private constructor() {
    AppStorage.setOrCreate<boolean>('isDropAnimationGoing', false);
  }

  registerDockListNumChangeCallback(callback: (addResidentNum: number, addRecentNum: number,
    hasAnim: boolean, dockChanged?: boolean) => void) {
    this.onDockListNumChangeInDrag = callback;
  }

  unregisterDockListNumChangeCallback() {
    this.onDockListNumChangeInDrag = undefined;
  }

  public setLocalResidentList(systemList: Array<DockItemInfo>, residentList: Array<DockItemInfo>) {
    log.showInfo(`setLocalResidentList: ${systemList?.length},  ${residentList?.length}`)
    this.systemResidentList = systemList;
    this.localResidentList = residentList;
    this.globalResidentList = this.systemResidentList.concat(this.localResidentList);
  }

  public setLocalRecentList(list: Array<DockItemInfo>) {
    this.localRecentList = list;
  }

  public setDropFrameRect(rect: Rectangle, bundleName: string) {
    this.dropFrameRect = rect;
    this.dropFrameRectBundleName = bundleName;
  }

  /**
   * 获取下一个dock栏item, 若没有下一个图标，返回自身，如目标图标不在list中，返回Undefined
   * @param info 要查询的图标
   */
  private getNextLocalItem(info: DockItemInfo, dockType: number, isShowRight: boolean): DockItemInfo | undefined {
    let localList = this.localResidentList;
    if (dockType === SmartDockConstants.RECENT_DOCK_TYPE) {
      localList = this.localRecentList;
    }
    if (localList.length === 0) {
      log.showWarn('localList null');
      localList = this.systemResidentList;
    }
    let index = localList.findIndex((item) => {
      return this.isSameItem(item, info);
    })
    if (isShowRight) {
      log.showInfo(`getNextLocalItem isShowRight index:${index}`);
      return localList[index];
    }
    if (index >= 0) {
      index = index + 1 < localList.length ? index + 1 : index;
      const target = localList[index];
      const onSelf = this.isSameItem(target, this.dragItem);
      index = index + 1 < localList.length && onSelf ? index + 1 : index;
      log.showInfo(`getNextLocalItem: targetIndex: ${index}`)
      let result: DockItemInfo = localList[index];
      return result;
    } else {
      log.showInfo(`getNextLocalItem error, no item ${info.bundleName}. localList.length: ${localList.length}`);
      return undefined;
    }
  }

  public static getInstance(): PCDockDragMgr {
    if (!PCDockDragMgr.instance) {
      PCDockDragMgr.instance = new PCDockDragMgr();
    }
    return PCDockDragMgr.instance;
  }

  /**
   * 控制起拖落位框出现
   * @param info
   * @param dockType
   */
  public onDragStart(info: DockItemInfo, dockType: number, event: DragEvent): void {
    log.showInfo(`onDragStart ${info.bundleName} event:${event.getWindowX()} ${event.getWindowY()}`);
    if (this.isDockDragging) {
      log.showInfo(`onDragStart directly return`);
      return;
    }
    Trace.start(Trace.CORE_METHOD_DRAG_START);
    this.isDockDragging = true;
    AppStorage.setOrCreate<boolean>('isDrag', true);
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_DRAG_CHANGE, 'true');
    // 落位框出现
    const isLastResidentItem: boolean = this.isLastResidentItem(info);
    const nextItem = this.getNextLocalItem(info, dockType, isLastResidentItem);
    if (nextItem) {
      this.dragItem = info;
      this.getContext()?.eventHub.emit(this.getDragStartInDockEvent(this.dragItem));
      this.isDragStartDropFrameShow = true;
      this.startSqueezedInDock(nextItem, isLastResidentItem);
      this.isDragStartDropFrameShow = false;
      this.dragItemDockType = dockType;
      this.dropItem = nextItem;
      this.dropFrameDockType = dockType;
      // 不要在拖拽开始后立即取消落位框，只有当拖拽真正结束时才取消
      // this.cancelSqueezedInDockWithDelay();
    }
    this.setDragMovePos(event.getWindowX(), event.getWindowY());
    Trace.end(Trace.CORE_METHOD_DRAG_START);
  }

  private cancelSqueezedInDockWithDelay(): void {
    if (this.cancelSqueezedInDockTimerId > 0) {
      return;
    }
    this.cancelSqueezedInDockTimerId = setTimeout(() => {
      if (!this.dropItem) {
        return;
      }
      // 落位框消失的时候，移动的时候dock长度减小，添加的时候，恢复长度
      let addResident = 0;
      let addRecent = 0;
      if (this.dropFrameDockType === SmartDockConstants.RESIDENT_DOCK_TYPE &&
        this.dragItemDockType === SmartDockConstants.RESIDENT_DOCK_TYPE) {
        // 常驻区到常驻区的落位框消失，
        addResident = -1;
      } else if (this.dragItemDockType === SmartDockConstants.RECENT_DOCK_TYPE) {
        // 运行区（桌面）到常驻区的落位框消失，运行区到运行区的落位框消失，
        addRecent = -1
      }
      log.showInfo(`delayCancelSqueezedInDock onDockListNumChangeInDrag addResident: ${addResident}, addRecent: ${addRecent}`);
      this.onDockListNumChangeInDrag?.(addResident, addRecent, true);
      this.cancelSqueezedInDock(this.dropItem);
      this.cancelSqueezedInDockTimerId = 0;
    }, MIN_INTERNAL)
  }

  private cancelSqueezedInDock(squeezeItem: DockItemInfo | undefined, hasAnimation: boolean = true): void {
    if (squeezeItem) {
      this.getContext()?.eventHub.emit(this.getItemSqueezedCancelEvent(squeezeItem),
        hasAnimation);
    }
    this.isShowDropFrame = false;
  }

  private startSqueezedInDock(squeezeItem: DockItemInfo | undefined, isShowRight: boolean): void {
    if (squeezeItem) {
      this.getContext()?.eventHub.emit(this.getItemSqueezedStartEvent(squeezeItem), null, {
        'options': isShowRight
      });
    }
    this.isShowDropFrame = true;
    this.isShowRightDropFrame = isShowRight;
  }

  private clearCancelSqueezedInDockTimer(): void {
    if (this.cancelSqueezedInDockTimerId > 0) {
      clearTimeout(this.cancelSqueezedInDockTimerId);
      this.cancelSqueezedInDockTimerId = 0;
    }
  }

  public getDockDragMoveOrDropEnable(info: DockItemInfo, isResident: boolean): boolean {
    if (!isResident) {
      // 在运行区移动时不处理
      return false;
    }
    if (this.shouldOnlyDropAfterSystemItems(SmartDockConstants.RESIDENT_DOCK_TYPE)) {
      // 常驻可删除区为空时，需要允许在系统尾部图标上触发落位框
      return true;
    }
    // 文件管理图标不允许作为落位目标；双中心仅禁止起拖，允许作为落位锚点
    // 避免在常驻区仅剩系统图标时，外部图标拖入没有可触发的添加框
    if (PCDockUtils.isPcFileManager(info.bundleName)) {
      return false;
    }
    return true;
  }

  /**
   * 图标是否可以拖拽
   * @param info
   * @param isContinueItem
   * @returns
   */
  public getDockDragStartEnable(info: DockItemInfo, isContinueItem: boolean): boolean {
    if (PCDockUtils.isPcFileManager(info.bundleName) ||
      info.bundleName === CommonConstants.LAUNCHER_BUNDLE || isContinueItem) {
      // 文件管理、回收站、双中心、接续图标不可拖动
      return false;
    }
    if (!this.canAddToDock(info)) {
      return false;
    }
    return true;
  }

  isDragFromDock(): boolean {
    return this.dragItemDockType === SmartDockConstants.RESIDENT_DOCK_TYPE ||
      this.dragItemDockType === SmartDockConstants.RECENT_DOCK_TYPE;
  }

  /**
   * 是否可以添加到快捷栏
   * @param info
   * @returns
   */
  private canAddToDock(info: DockItemInfo): boolean {
    let noAppDesktopIconList: string[] = AppStorage.get('noAppDesktopIconList') ?? [];
    return (info.itemType !== CommonConstants.TYPE_FUNCTION && !noAppDesktopIconList.includes(info.bundleName) &&
    CheckEmptyUtils.isEmpty(info.persistentId));
  }

  private checkDragMoveParams(info: DockItemInfo, moveItemRect: Rectangle): boolean {
    if (!this.dragItem) {
      log.showInfo('checkDragMoveParams no dragItem');
      return false;
    }
    if (this.isSameItem(info, this.dragItem)) {
      // 在起拖图标上移动时不处理
      return false;
    }

    if (!this.isDragFromDock() && this.foldHappen) {
      return false;
    }

    if (!this.isDragFromDock()) {
      if (this.isExisting()) {
        return false;
      }
      const disY: number = ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.height) -
      ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.y);
      const bottomEdge = this.lastDragMoveY + disY;
      if (bottomEdge < ResUtils.getNumberFromLength(moveItemRect.y) +
        ResUtils.getNumberFromLength(moveItemRect.height) * (1 / 2)) {
        // 从桌面拖动到dock时, 桌面图标下边缘移动到50%后才触发落位框
        return false;
      }
    }
    return true;
  }

  private isLastResidentItem(info: AppItemInfo | undefined): boolean {
    if (info === undefined) {
      return false;
    }
    let len: number = this.localResidentList.length;
    if (SmartDockModel.getInstance().checkSameDockItem(this.localResidentList[len - 1], this.dragItem)) {
      len--;
    }
    if (len === 0) {
      return true;
    }
    return SmartDockModel.getInstance().checkSameDockItem(this.localResidentList[len - 1], info);
  }

  /**
   * 常驻可删除区为空时，仅允许落位在不可删除系统图标尾部
   */
  private shouldOnlyDropAfterSystemItems(dockType: number): boolean {
    return dockType === SmartDockConstants.RESIDENT_DOCK_TYPE &&
      !this.isDragFromDock() &&
      this.localResidentList.length === 0 &&
      this.systemResidentList.length > 0;
  }

  public setDragMovePos(dragMouseX: number, dragMouseY: number): void {
    if (!this.isDropAnimating) {
      this.lastDragMoveX = dragMouseX;
      this.lastDragMoveY = dragMouseY;
    }
  }

  /**
   * 在图标info上移动时触发， 控制落位框出现
   * @param info 图标信息
   * @param dockType 图标类型
   * @param moveItemRect, 移动所在图标位置
   */
  public onDragMove(info: DockItemInfo, dockType: number, moveItemRect: Rectangle, event: DragEvent): void {
    log.debug(`onDragMove ${info.bundleName}  ${info.abilityName}`);

    let dragItemInfo = GridLayoutUtil.getSingleDragItemInfo();
    if (this.isShortcut(dragItemInfo)) {
      log.showInfo(`onDragMove, isShortCut, return`);
      return;
    }

    if (Math.abs(event.getWindowX() - this.lastDragMoveX) < 2) {
      return;
    }
    const moveToRight = event.getWindowX() > this.lastDragMoveX;
    this.setDragMovePos(event.getWindowX(), event.getWindowY());

    if (!this.checkDragMoveParams(info, moveItemRect)) {
      return;
    }
    if (this.shouldOnlyDropAfterSystemItems(dockType)) {
      this.isDockDragging = true;
      localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_DRAG_CHANGE, 'true');
      const lastSystemItem = this.systemResidentList[this.systemResidentList.length - 1];
      if (lastSystemItem && this.isSameItem(info, lastSystemItem)) {
        this.updateDropFrame(lastSystemItem, dockType, true, true);
      } else if (this.isShowDropFrame) {
        // 仅允许在系统尾部显示落位框，其他位置隐藏
        this.cancelSqueezedInDock(this.dropItem);
        this.dropItem = undefined;
      }
      return;
    }
    this.isDockDragging = true;
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_DRAG_CHANGE, 'true');
    if (this.cancelSqueezedInDockTimerId > 0) {
      this.clearCancelSqueezedInDockTimer();
    }
    const isLastResidentItem: boolean = this.isLastResidentItem(info);
    // 计算落位框位置
    const itemWidth = ResUtils.getNumberFromLength(moveItemRect.width); // dock图标宽度
    const dropSnapshotWidth = ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.width); // 拖拽图标宽度
    let dropSnapshotX: number = ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.x);
    if (dropSnapshotWidth > 0) {
      dropSnapshotX += (dropSnapshotWidth - itemWidth) / 2; // 拖拽图标太大了，会导致条件判断区域有重叠
    }
    const leftSnapshotEdgeX = event.getWindowX() - dropSnapshotX; // 拖拽图标左边缘
    const rightSnapshotEdgeX = leftSnapshotEdgeX + itemWidth; // 拖拽图标右边缘，缩小至itemWidth
    const leftMiddleLineX = ResUtils.getNumberFromLength(moveItemRect.x) + itemWidth * (1 / 4);
    const rightMiddleLineX = ResUtils.getNumberFromLength(moveItemRect.x) + itemWidth * (3 / 4);
    let isCurr: boolean = true;
    if (moveToRight) {
      isCurr = rightSnapshotEdgeX < leftMiddleLineX;
    } else {
      isCurr = leftSnapshotEdgeX < rightMiddleLineX;
    }
    log.showInfo(`edgeX:[${leftSnapshotEdgeX},${rightSnapshotEdgeX}] area:[${leftMiddleLineX}, ${rightMiddleLineX}] ${info?.abilityName} ${isLastResidentItem}`);
    if (info?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      if (isLastResidentItem && rightSnapshotEdgeX > leftMiddleLineX) {
        this.updateDropFrame(info, dockType, true, true); // 垃圾桶落位图标在最右边
      } else {
        this.updateDropFrame(info, dockType, false);
      }
    } else if (isLastResidentItem) {
      const isShowRight: boolean = this.isShowDropFrame ? !isCurr : rightSnapshotEdgeX > leftMiddleLineX;
      this.updateDropFrame(info, dockType, true, isShowRight);
    } else {
      this.updateDropFrame(info, dockType, isCurr);
    }
  }

  /**
   * 在dock拖拽期间是否允许tips
   * @returns true 允许; false 不允许
   */
  getDockTipsEnable(): boolean {
    if (this.isDockDragging) {
      if (this.dragItemDockType >= 0) {
        return false;
      } else {
        return !this.isShowDropFrame;
      }
    } else {
      return true;
    }
  }

  /**
   * 更新落位框到落位图标的左边或者落位图标下一个图标的左边
   * @param info 图标信息
   * @param isCurr 是否更新落位框到当前图标/或者下一图标, 默认true
   * @param isShowRight 落位框是否显示在右边
   * @param isDragStart 是否是起拖图标背景框
   */
  private updateDropFrame(info: DockItemInfo, dockType: number,
    isCurr: boolean = true, isShowRight: boolean = false): void {
    let dropFrameItem: DockItemInfo | undefined = info;
    if (!isCurr) {
      if (info.bundleName === CommonConstants.LAUNCHER_BUNDLE || PCDockUtils.isPcFileManager(info.bundleName)) {
        return;
      }
      dropFrameItem = this.getNextLocalItem(info, dockType, isShowRight);
    }
    if (!dropFrameItem) {
      log.showInfo('no dock item');
      return;
    }
    // 不可删除快捷方式区(systemResidentList)前/中间不允许出现落位框：
    // 只允许落在不可删除区之后，也就是系统区最后一个图标的右侧。
    if (dockType === SmartDockConstants.RESIDENT_DOCK_TYPE && this.systemResidentList.length > 0) {
      const sysIndex: number = this.systemResidentList.findIndex((sysItem: DockItemInfo) => {
        return SmartDockModel.getInstance().checkSameDockItem(sysItem, dropFrameItem);
      });
      if (sysIndex >= 0) {
        dropFrameItem = this.systemResidentList[this.systemResidentList.length - 1];
        isShowRight = true;
      }
    }
    if (this.dropItem && this.dropItem === dropFrameItem &&
    this.isShowDropFrame && (this.isShowRightDropFrame == isShowRight)) {
      log.showInfo(`isShowRight:${isShowRight} isShowRightDropFrame:${this.isShowRightDropFrame}`)
      return;
    }

    log.showInfo(`updateDropFrame ${dropFrameItem.bundleName}: isShowRight:${isShowRight} `);

    // 更新落位框
    let isMove: boolean = dockType === this.dragItemDockType;
    let addResidentNum = isMove ? 0 : 1;
    let addRecentNum = !isMove && this.dragItemDockType === SmartDockConstants.RECENT_DOCK_TYPE ? -1 : 0;
    log.showInfo(`updateDropFrame ${dropFrameItem.bundleName}: onDockListNumChangeInDrag addResidentNum: ${addResidentNum}, addRecentNum: ${addRecentNum}, ${this.dragItemDockType}`);
    this.dropFrameDockItem = dropFrameItem;
    this.onDockListNumChangeInDrag?.(addResidentNum, addRecentNum, true);

    if (dropFrameItem !== this.dropItem) {
      log.showInfo(`cancelSqueezedInDock ${dropFrameItem.bundleName}`);
      this.cancelSqueezedInDock(this.dropItem);
    }
    this.dropItem = dropFrameItem;
    this.dropFrameDockType = dockType;
    this.startSqueezedInDock(this.dropItem, isShowRight);
  }

  init(): void {
    log.showDebug('init register Drag Event');
    this.getContext()?.eventHub.on(DragConstants.DRAG_PREPARE_STATUS_CHANGE_EVENT,
      (isPreparing: boolean): void => {
        if (isPreparing) {
          this.dragParams = dragTriggerUtil.getDragParams();
        }
      });
    this.getContext()?.eventHub.on(CommonConstants.EVENTHUB_ICON_OR_CARD_DROP, () => {
      this.onDragEnd();
    });
    this.getContext()?.eventHub.on(DragConstants.DRAG_START_PREPARE_STATUS_CHANGE_EVENT, (rect?: Rectangle) => {
      if (rect) {
        this.setDragSnapshotRelativeRect(rect);
      }
    });
  }

  unInit(): void {
    log.showDebug('unInit unregister Drag Event');
    this.getContext()?.eventHub.off(DragConstants.DRAG_PREPARE_STATUS_CHANGE_EVENT);
    this.getContext()?.eventHub.off(CommonConstants.EVENTHUB_ICON_OR_CARD_DROP);
    this.getContext()?.eventHub.off(DragConstants.DRAG_START_PREPARE_STATUS_CHANGE_EVENT);
  }

  registerDragEvent(eventCallback: DragEventCallback, appInfo: DockItemInfo | AppItemInfo): void {
    log.showDebug(`registerDragEvent ${appInfo.bundleName},${appInfo.appIndex},${appInfo.persistentId}`);
    if (eventCallback?.onItemDragStartEvent) {
      this.getContext()?.eventHub.on(this.getDragStartInDockEvent(appInfo),
        eventCallback.onItemDragStartEvent);
    }
    if (eventCallback?.onCancelSqueezedEvent) {
      this.getContext()?.eventHub.on(this.getItemSqueezedCancelEvent(appInfo),
        eventCallback.onCancelSqueezedEvent);
    }
    if (eventCallback?.onStartSqueezedEvent) {
      this.getContext()?.eventHub.on(this.getItemSqueezedStartEvent(appInfo),
        eventCallback.onStartSqueezedEvent);
    }
    if (eventCallback?.onItemDropEndEvent) {
      this.getContext()?.eventHub.on(this.getDropAnimationEndEvent(appInfo),
        eventCallback.onItemDropEndEvent);
    }
  }

  unRegisterDragEvent(eventCallback: DragEventCallback, appInfo: DockItemInfo | AppItemInfo): void {
    log.showDebug(`unRegisterDragEvent ${appInfo?.bundleName},${appInfo?.appIndex},${appInfo?.persistentId}`);
    if (eventCallback?.onItemDragStartEvent) {
      this.getContext()?.eventHub.off(this.getDragStartInDockEvent(appInfo),
        eventCallback.onItemDragStartEvent);
    }
    if (eventCallback?.onCancelSqueezedEvent) {
      this.getContext()?.eventHub.off(this.getItemSqueezedCancelEvent(appInfo),
        eventCallback.onCancelSqueezedEvent);
    }
    if (eventCallback?.onStartSqueezedEvent) {
      this.getContext()?.eventHub.off(this.getItemSqueezedStartEvent(appInfo),
        eventCallback.onStartSqueezedEvent);
    }
    if (eventCallback?.onItemDropEndEvent) {
      this.getContext()?.eventHub.off(this.getDropAnimationEndEvent(appInfo),
        eventCallback.onItemDropEndEvent);
    }
  }

  private getDragStartInDockEvent(appInfo: DockItemInfo | AppItemInfo): string {
    return `${DragConstants.DRAG_START_EVENT}${appInfo.bundleName}_${appInfo.abilityName}_${appInfo.appIndex}_${appInfo?.shortcutId ||
      ''}_${appInfo.persistentId || ''}_${appInfo.appInstanceKey}_FromDock`;
  }

  private getItemSqueezedCancelEvent(appInfo: DockItemInfo | AppItemInfo): string {
    return `${DragConstants.ITEM_SQUEEZED_CANCEL_EVENT}${appInfo.bundleName}_${appInfo.abilityName}_${appInfo.appIndex}_${appInfo?.shortcutId ||
      ''}_${appInfo.persistentId || ''}_${appInfo.appInstanceKey}_FromDock`;
  }

  private getItemSqueezedStartEvent(appInfo: DockItemInfo | AppItemInfo): string {
    return `${DragConstants.ITEM_SQUEEZED_START_EVENT}${appInfo.bundleName}_${appInfo.abilityName}_${appInfo.appIndex}_${appInfo?.shortcutId ||
      ''}_${appInfo.persistentId || ''}_${appInfo.appInstanceKey}_FromDock`;
  }

  private getDropAnimationEndEvent(appInfo: DockItemInfo | AppItemInfo): string {
    return `${DragConstants.DROP_ANIMATION_END_EVENT}${appInfo.bundleName}_${appInfo.abilityName}_${appInfo.appIndex}_${appInfo?.shortcutId ||
      ''}_${appInfo.persistentId || ''}_${appInfo.appInstanceKey}_FromDock`;
  }

  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  /**
   * 控制落位框消失
   * @param info c
   */
  public onDragLeave(info: DockItemInfo): void {
    log.showInfo(`onDragLeave ${info.bundleName},${info.appIndex}`);
    // 不要在拖拽过程中取消落位框，只有当拖拽真正结束时才取消
    // this.cancelSqueezedInDockWithDelay();
  }

  /**
   * 更新dock栏
   */
  private changeDockList(): void {
    log.showInfo('changeDockList');
    if (this.dragItemDockType === SmartDockConstants.RESIDENT_DOCK_TYPE) {
      // 移动到落位框
      this.moveResidentItem();
    } else if (this.dragItem) {
      // 添加到落位框
      this.addResidentItem();
    }
  }

  judgeIsCard(area?: number[]): boolean {
    if (CheckEmptyUtils.isEmptyArr(area)) {
      return false;
    }
    if (area?.[0] === 1 && area?.[1] === 1) {
      return false;
    }
    return true;
  }

  setDragSnapshotRelativeRect(rect: Rectangle): void {
    log.showInfo(`setDragSnapshotRelativeRect x: ${rect?.x}, width: ${rect?.width}`);
    this.dragSnapshotRelativeRect = rect;
  }

  /**
   * 在拖拽落位动效期间获取三级缓存图标，避免AppItem创建期间再去获取图标，图标异步去获取，无法及时刷新和闪烁
   */
  public updateDragItemIconCache(iconSize: number): void {
    IconResourceManager.getInstance().getIconResourceBySize(
      this.dragItem?.bundleName, this.dragItem?.moduleName, this.dragItem?.abilityName, iconSize);
  }

  public onDragEnter(itemInfo: DockItemInfo): void {
    log.showInfo(`onDragEnter isDropAnimating: ${this.isDropAnimating}`);
    if (this.isDropAnimating) {
      return;
    }
    this.clearCancelSqueezedInDockTimer();
    // 当添加图标时, 准备拖拽图标数据
    let bundleName: string | undefined = undefined;
    let dragItemInfo: GridLayoutItemInfo | undefined = undefined;
    let appIndex: number | undefined = undefined;
    let appInstanceKey: string | undefined;
    let isCard: boolean = false;
    if (this.dragItemDockType === SmartDockConstants.RECENT_DOCK_TYPE) {
      bundleName = this.dragItem?.bundleName;
      appIndex = this.dragItem?.appIndex;
      appInstanceKey = this.dragItem?.appInstanceKey;
    } else if (this.dragItemDockType !== SmartDockConstants.RESIDENT_DOCK_TYPE) {
      // 从dock外拖拽到dock,默认添加图标
      dragItemInfo = GridLayoutUtil.getSingleDragItemInfo();
      bundleName = dragItemInfo?.bundleName;
      appIndex = GridLayoutUtil.getSingleDragItemInfo()?.appIndex;
      isCard = this.judgeIsCard(GridLayoutUtil.getSingleDragItemInfo()?.area);
    }
    if (this.isShortcut(dragItemInfo)) {
      log.showInfo(`onDragEnter, isShortCut, return`);
      return;
    }
    if (isCard) {
      log.showInfo('onDragEnter, not app, return');
      return;
    }
    if (bundleName) {
      let appInfo: AppItemInfo | undefined = this.mAppModel.getAppInfoByBundleName(bundleName);
      if (!appInfo) {
        log.showWarn(`dealDragParams: find no appInfo by ${bundleName}`);
        return;
      }
      if (typeof (appInfo.typeId) === 'undefined') {
        // 应用中心typeId的默认为app
        appInfo.typeId = CommonConstants.TYPE_APP;
      }
      // 1. 从桌面起拖，dragItem 重新构造
      // 2. 从dock栏起拖，dragItem在onDragStart已经赋值，有值，不需要再次赋值。这里只对shortcut场景进行处理
      if (!this.dragItem?.shortcutId) {
        if (typeof (appIndex) !== 'undefined') {
          // 应用中心typeId的默认为app
          appInfo.appIndex = appIndex;
        }
        appInfo.iconResource = dragItemInfo?.iconResource;
        appInfo.keyName = DockItemInfo.getKeyName(appInfo);
        appInfo.appInstanceKey = this.dragItem?.appInstanceKey;
        this.dragItem = appInfo;
      }
    }
    // 当使用dragController时，准备截图位置数据
    if (this.dragParams?.key?.length === 1 && !this.dragSnapshotRelativeRect) {
      const snapshot: image.PixelMap | undefined = dragSnapshotHelper.getSnapshot(SnapshotType.DRAG,
        this.dragParams.key[0]);
      if (!snapshot) {
        log.error(`dealDragParams: unready snapshot ${this.dragParams.key[0]}`);
        return;
      }
      const iconSize: Size = snapshot.getImageInfoSync().size;
      this.setDragSnapshotRelativeRect({
        x: this.dragParams?.dragInfo?.touchPoint?.x,
        y: this.dragParams?.dragInfo?.touchPoint?.y,
        width: px2vp(iconSize.width),
        height: px2vp(iconSize.height)
      });
      this.dragParams = {};
    } else if (!this.dragSnapshotRelativeRect && this.dragItemDockType !== SmartDockConstants.RESIDENT_DOCK_TYPE &&
      this.dragItemDockType !== SmartDockConstants.RECENT_DOCK_TYPE) {
      // 只对从dock外拖拽的情况进行getDragItemRect检查，从dock内部拖拽时跳过
      const rect = dragTriggerUtil.getDragItemRect();
      if (!rect) {
        log.error('getDragItemRect undefined');
        return;
      }
      this.setDragSnapshotRelativeRect(rect);
    }
    log.showInfo(`onDragEnter, dragItem: ${this.dragItem?.bundleName}, ${this.dragItem?.moduleName}, ` +
      `${this.dragItem?.abilityName}, ${this.dragItem?.shortcutId}`);
  }

  public onDockListNumChange(residentNum: number, recentNum: number): void {
    log.showInfo(`residentNum:${residentNum} recentNum:${recentNum}`);
    this.residentNumCache = residentNum;
    this.recentNumCache = recentNum;
  }

  private isShortcut(dragItemInfo: GridLayoutItemInfo | undefined): boolean {
    const isShortcut: boolean =
      dragItemInfo?.typeId === CommonConstants.TYPE_SHORTCUT_ICON ||
        !CheckEmptyUtils.checkStrIsEmpty(dragItemInfo?.shortcutId);
    log.showInfo(`isShortcut:${isShortcut}`);
    return isShortcut;
  }

  public getDragItemIndex(itemList: DockItemInfo[]) {
    const itemIndex: number = itemList.findIndex((info: DockItemInfo) => {
      return this.isSameItem(info, this.dragItem);
    });
    return itemIndex;
  }

  /**
   * 处理dock拖拽结束
   */
  private handleDockDragEnd(hasAnim: boolean, dockChanged: boolean = false) {
    if (this.dragItem) {
      this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(this.dragItem));
    }
    log.showInfo(`handleDragEnd onDockListNumChangeInDrag. 0, 0, hasAnim: ${hasAnim}`);
    this.clearCancelSqueezedInDockTimer();
    this.cancelSqueezedInDock(this.dropItem, false);
    this.onDockListNumChangeInDrag?.(0, 0, hasAnim, dockChanged);

    this.dragItem = undefined;
    this.dropItem = undefined;
    this.isDragStartDropFrameShow = false;
    this.isShowRightDropFrame = false;
    this.dragItemDockType = -1;
    this.dropFrameDockType = -1;
    this.dragSnapshotRelativeRect = undefined;
    this.dropFrameRect = undefined;
    this.dropFrameRectBundleName = '';
    this.dragParams = {};
    this.isDropAnimating = false;
    AppStorage.set<boolean>('isDropAnimationGoing', false)
    this.isDockDragging = false;
    AppStorage.setOrCreate<boolean>('isDrag', false);
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_DRAG_CHANGE, 'true');
    PcModeDockUtils.callHideDock();
  }

  public onDragEnd(): void {
    log.showInfo(`onDragEnd isDropAnimating: ${this.isDropAnimating} isDockDragging:${this.isDockDragging}`);
    if (!this.isDropAnimating) {
      // 如果没有落位成功，重置数据
      this.handleDockDragEnd(false);
    }
  }

  /**
   * 生成落位动画
   */
  public onDrop(dockIconRadius: number): void {
    log.showInfo('onDrop start');
    if (!this.isShowDropFrame || this.dropFrameRectBundleName !== this.dropItem?.bundleName ||
      !this.dragSnapshotRelativeRect) {
      // 如果落位框没有显示，或者落位框位置数据没有准备好, 不处理
      log.showInfo('onDrop params invalid: isShowDropFrame = ' + this.isShowDropFrame + ', dropFrameRectBundleName = ' +
      this.dropFrameRectBundleName + ', dropItem.bundleName = ' + this.dropItem?.bundleName +
        ', dragSnapshotRelativeRect = ' + this.dragSnapshotRelativeRect);
      return;
    }
    if (this.shouldOnlyDropAfterSystemItems(this.dropFrameDockType)) {
      // 仅系统图标场景下直接落位，避免动画回调链导致不入dock
      this.changeDockList();
      this.handleDockDragEnd(false, true);
      return;
    }
    Trace.start(Trace.CORE_METHOD_DRAG_DROP);
    this.isDropAnimating = true;
    AppStorage.setOrCreate<boolean>('isDropAnimationGoing', true);

    const extraId: string = this.dragItem?.bundleName ?? '';
    SCBCompanionManager.getInstance().getController()?.update({
      iconId: '',
      bundleName: this.dragItem?.bundleName ?? '',
      abilityName: this.dragItem?.abilityName ?? '',
      moduleName: this.dragItem?.moduleName as string,
      iconNumber: this.dragItem?.appIconId ?? 0,
      appIndex: this.dragItem?.appIndex as number,
      shortcutId: this.dragItem?.shortcutId ?? '',
      appInstanceKey: this.dragItem?.appInstanceKey as string,
      iconRadius: 0,
      startAppType: StartType.APP,
      cardId: '',
      extraId: extraId,
      needBadge: false,
    });
    const compViewController = SCBTransitionManager.getInstance().findTransitionController('SCBCompanionView', () => {
      return PageDesktopModel.getInstance().getCloseAppData('SCBCompanionView', '', StartType.APP);
    });
    let translateX: number = this.lastDragMoveX - ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.x) +
      ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.width) / 2 -
    ResUtils.getNumberFromLength(this.dropFrameRect?.x) - ResUtils.getNumberFromLength(this.dropFrameRect?.width) / 2;
    let translateY: number = this.lastDragMoveY - ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.y) +
      ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.height) / 2 -
    ResUtils.getNumberFromLength(this.dropFrameRect?.y) - ResUtils.getNumberFromLength(this.dropFrameRect?.height) / 2;
    const want: HashMap<string, number | string> = new HashMap();
    want.set('width', ResUtils.getNumberFromLength(this.dropFrameRect?.width));
    want.set('height', ResUtils.getNumberFromLength(this.dropFrameRect?.height));
    want.set('posX', ResUtils.getNumberFromLength(this.dropFrameRect?.x));
    want.set('posY', ResUtils.getNumberFromLength(this.dropFrameRect?.y));
    want.set('translateX', translateX);
    want.set('translateY', translateY);
    want.set('bundleName', this.dragItem?.bundleName);
    want.set('abilityName', this.dragItem?.abilityName);
    want.set('containerId', extraId);
    want.set('appIndex', this.dragItem?.appIndex);
    want.set('appInstanceKey', this.dragItem?.appInstanceKey);
    if (ResUtils.getNumberFromLength(this.dropFrameRect?.width) > 0 &&
      ResUtils.getNumberFromLength(this.dropFrameRect?.height) > 0) {
      const scaleX = ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.width) /
      ResUtils.getNumberFromLength(this.dropFrameRect?.width);
      const scaleY = ResUtils.getNumberFromLength(this.dragSnapshotRelativeRect?.height) /
      ResUtils.getNumberFromLength(this.dropFrameRect?.height);
      want.set('scaleX', scaleX * HoverEffectConstants.FIXED_HOVER_MASTER_SCALE);
      want.set('scaleY', scaleY * HoverEffectConstants.FIXED_HOVER_MASTER_SCALE);
    }
    if (this.isDragFromDock()) {
      want.set('iconRadius', dockIconRadius);
    }
    want.set('targetIconRadius', dockIconRadius);
    // 快捷方式拖拽到dock生成落位动效时需要根据resource获取对应的快捷方式图标资源, 不然落位动效会跳变为主应用图标资源
    if (this.dragItem?.typeId === CommonConstants.TYPE_SHORTCUT_ICON && (!!this.dragItem?.shortcutId)) {
      want.set('typeId', this.dragItem?.typeId);
      want.set('iconResource', this.dragItem?.iconResource);
    }
    want.set('startType', StartType.DOCK_APP);
    log.showInfo('generateDropAnim end, drop to area: ' + want.get('posX') + ' y: ' + want.get('posY') + ' width: ' +
    want.get('width') + ' height: ' + want.get('height') + ' scaleX: ' + want.get('scaleX'));
    compViewController?.backward?.(want);
  }

  public isDropping(): boolean {
    return this.isDropAnimating;
  }

  public onDropAnimationEnd(): void {
    log.showInfo(`onDropAnimationEnd ${this.isDockDragging}`);
    if (this.isDockDragging) {
      this.changeDockList();
      this.handleDockDragEnd(true, true);
    }
    Trace.end(Trace.CORE_METHOD_DRAG_DROP);
    this.isDropAnimating = false;
  }

  /**
   * 向落位框位置添加图标
   */
  private addResidentItem(): void {
    if (!this.dropItem) {
      return;
    }
    let targetIndex: number = this.globalResidentList.findIndex((info: DockItemInfo) => {
      return this.isSameItem(this.dropItem, info);
    });
    if (targetIndex < 0) {
      log.showInfo(`addResidentItem dropFrame invalid`);
      return;
    }
    // 添加图标
    log.showInfo(`addResidentItem ${this.dragItem?.bundleName} ${this.dragItem?.appIndex} before ${this.dropItem?.bundleName}`);
    if (this.isShowRightDropFrame) {
      ++targetIndex;
    }
    log.showInfo(`dragToAddToSmartDock, bundle:${this.dragItem?.bundleName}, shortcutId:${this.dragItem?.shortcutId} targetIndex:${targetIndex} ${this.isShowRightDropFrame}`);
    if (this.dragItem) {
      this.mSmartDockModel.addToSmartDock(this.dragItem, targetIndex);
    }
  }

  /**
   * 移动常驻区图标到落位框位置
   */
  private moveResidentItem(): void {
    if (!this.dragItem || !this.dropItem) {
      return;
    }
    if (this.dragItem === this.dropItem) {
      log.showInfo(`moveResidentItem move to self`);
      return;
    }
    let insertIndex: number = this.globalResidentList.findIndex((info: DockItemInfo) => {
      return this.isSameItem(info, this.dropItem);
    });
    const itemIndex: number = this.globalResidentList.findIndex((info: DockItemInfo) => {
      return this.isSameItem(info, this.dragItem);
    });
    if (insertIndex < 0 || itemIndex < 0) {
      log.showInfo(`moveResidentItem input invalid, insertIndex:${insertIndex}, itemIndex:${itemIndex}`);
      return;
    }
    log.showInfo(`moveResidentItem ${this.dragItem?.bundleName} before ${this.dropItem?.bundleName}, from ` +
      `${itemIndex} to ${insertIndex}, ${this.isShowRightDropFrame}, ${this.globalResidentList.length}`);
    if (this.isShowRightDropFrame) {
      this.moveResidentItemToBack(itemIndex);
    } else {
      let mResidentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      if (insertIndex >= mResidentList.length || itemIndex >= mResidentList.length) {
        log.showError(`moveResidentItem invaild index, len: ${mResidentList.length}`);
        return;
      }
      this.mSmartDockModel.insertItemToIndex(insertIndex, itemIndex);
    }
  }

  /**
   * 移动常驻区图标到dock回收站之前
   * 由于residentList和localResidentList的排序差异(回收站在residentList中间),
   * 拖动到回收站前, 在localResidentList意味着拖动最后，而在residentList位置可能不变，需要单独处理
   * @param itemIndex 被移动的图标index
   */
  private moveResidentItemToBack(itemIndex: number): void {
    if (itemIndex < 0 || itemIndex >= this.globalResidentList.length) {
      log.showInfo('moveResidentItemToBack: index illegal');
      return;
    }
    const selectItem = this.globalResidentList[itemIndex];
    this.globalResidentList.splice(itemIndex, 1);
    this.globalResidentList.push(selectItem);
    log.showInfo(`move residentItem ${selectItem.bundleName} to back`);
    ResidentLayoutCacheMgr.getInstance().updateAllDockItems(TAG.concat('_move'), this.globalResidentList, true);
  }

  /**
   * 图标是否在常驻区已经存在
   * @param bundleName 目标图标
   * @returns true 已经存在；false 不存在
   */
  private isExisting(): boolean {
    const existed = this.globalResidentList.some((dockItemInfo: DockItemInfo): boolean => {
      return this.isSameItem(dockItemInfo, this.dragItem);
    });
    log.showInfo(`dragItem[${this.dragItem?.bundleName}_${this.dragItem?.shortcutId}] already existed in dock ` +
      `resident area? ${existed}`);
    return existed;
  }

  private isSameItem(info: AppItemInfo | undefined, dropItem: AppItemInfo | undefined): boolean {
    return SmartDockModel.getInstance().isSameDockItem(info, dropItem) && info?.keyName === dropItem?.keyName;
  }
}