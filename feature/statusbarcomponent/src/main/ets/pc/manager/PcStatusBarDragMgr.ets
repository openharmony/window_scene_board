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
  StartType,
  LogDomain,
  LogHelper,
  Trace,
  CheckEmptyUtils,
  CompanionIconInfo
} from '@ohos/basicutils';
import { DragConstants } from '@ohos/commonconstants';
import { DragItemPosition, DragEventCallback } from '@ohos/componentdrag';
import { dragSnapshotHelper, RTLUtil, SnapshotType } from '@ohos/componenthelper';
import { DragControllerParams } from '@ohos/componenthelper/Index';
import { DropAnimationParam } from '@ohos/componentanimator';
import { GlobalContext, PluginSlot, PluginInfo } from '@ohos/frameworkwrapper';
import { windowMgr, SCBTransitionManager, ResUtils } from '@ohos/windowscene';
import { SCBCompanionManager } from '@ohos/windowscene/Index';
import { AppModel } from '@ohos/launchercommon/src/main/ets/model/AppModel';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { PageDesktopModel } from '@ohos/launchercommon/src/main/ets/pagedesktop/model/PageDesktopModel';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import type ctx from '@ohos.app.ability.common';
import HashMap from '@ohos.util.HashMap';
import { dragTriggerUtil } from '@ohos/launchercommon/src/main/ets/utils/DragTriggerUtil';
import image from '@ohos.multimedia.image';
import { PluginProperty } from '../viewdata/PluginProperty';
import StatusBarManager from './StatusBarManager';
import { Constants } from '../common/Constants';
import PcTrayGridLayoutUtil from './PcTrayGridLayoutUtil';
import PcStatusBarVM from '../viewmodel/PcStatusBarVM';
import { StateManager } from './StateManager';
import { HiSysUtil } from '../utils/HiSysUtil';
import { PluginGroupingManager } from '../plugingroup/PluginGroupingManager';
import { PluginGroupType, PluginPositionType } from '../common/PluginConstants';
import { GroupProperty } from '../plugingroup/viewdata/GroupProperty';
import { StyleFactory } from '../pluginstyle/StyleFactory';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import { PositionProperty } from '../plugingroup/viewdata/PositionProperty';
import { PluginNotifyBase } from '../pluginData/PluginNotifyBase';
import { LocalGroupProperty } from '../viewdata/LocalGroupProperty';
import { HashSet } from '@kit.ArkTS';
import { ListenerPriority } from '../pluginData/StatusBarPluginEventListener';
import { PluginUtils } from '../utils/PluginUtils';

const TAG = 'PcStatusBarDragMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MIN_INTERNAL: number = 10;
const CONTAINER_WIDTH: number = 32;
const SPACE_WIDTH: number = 2;
const MAX_COLUMNS = 6;
const RESTORE_DYNAMIC_INTERNAL: number = 30;
const INVALID_INDEX: number = -1;
const HALF_NUM: number = 2.0;
const ARROW_PERCENT_THRESHOLD = 0.25;
const INPUT_PERCENT_THRESHOLD = 0.75;

const LEFT_MIDDLE_THRESHOLD = 0.25
const RIGHT_MIDDLE_THRESHOLD = 0.75;

export class PcStatusBarDragMgr extends PluginNotifyBase {
  public isStatusBarDragging: boolean = false;
  public residentNumCache: number = 0;
  public recentNumCache: number = 0;
  public snapshotId: string = '';
  public snapshotKey: string = '';
  public isDragStartDropFrameShow: boolean = false;
  public dragItemStatusBarType: number = -1;
  /**
   * 自动隐藏落位框TimerId
   */
  private cancelSqueezedInStatusBarTimerId: number = 0;
  private static instance: PcStatusBarDragMgr;
  private dropFrameStatusBarType: number = -1;
  /**
   * 落位框位置
   */
  private dropFrameRect: Rectangle | undefined = undefined;
  private dropFrameRectBundleName: string = '';
  private dragItem: PluginInfo | undefined = undefined;
  private dragItemIsTray: boolean = false;
  private dropItem: PluginInfo | undefined = undefined;
  /**
   * 鼠标在拖动截图的相对位置
   */
  private dragSnapshotRelativeRect: Rectangle | undefined = undefined;
  private onDynamicListNumChangeInDragSet: HashSet<((addDynamicPlugNum: number, hasAnim: boolean,
    dynamicChanged?: boolean) => void)> = new HashSet();
  private onTrayListNumChangeInDrag: ((addTrayPlugNum: number) => void) | undefined = undefined;
  private onDynamicListNumChangeSet: HashSet<(() => void)> = new HashSet();
  private isShowDropFrame: boolean = false;
  private isDropAnimating: boolean = false;
  private lastDragMoveX: number = 0;
  private lastDragMoveY: number = 0;
  private dragParams: DragControllerParams = {};
  public statusBarRightWidth: number = -1;
  public groupWrapperWidth: number = -1;
  public fixedAreaWidth: number = -1;
  public assistantVoiceWidth: number = -1;
  public mStartPosition: DragItemPosition | undefined;
  public mLastPosOnMoving: DragItemPosition | undefined;
  private mEndPosition: DragItemPosition | undefined;
  // 暂存endPosition, 因mEndPosition会在拖拽到尾部等情况做调整
  private mCurrEndPosition: DragItemPosition | undefined;
  private isSqueezing: boolean = false;
  private mTranslateItemList: TranslateItem[] = [];
  private mLastTranslateItemList: TranslateItem[] = [];
  private hasCancelSqueezeAnimation: boolean = true;
  private movingItemMap: Map<string, TranslateItem> = new Map<string, TranslateItem>();
  // 向托盘区拖拽过程中的图标缓存数据
  private trayAreaPlugins: LocalGroupProperty = new LocalGroupProperty();
  private isTrayAreaInit: boolean = false;
  public isTrayAreaAnimateFinish: boolean = false;
  private dragPlugin: PluginProperty | undefined = undefined;
  public static isDragCompleted = false;

  private inputItemRect: Rectangle = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  };
  private arrowRect: Rectangle = {
    x: 0,
    y: 0,
    width: 0,
    height: 0
  };
  private showDropFrameIcon: boolean = false;

  private restoreDynamicTimerId: number = 0;

  private onShowArrowButton: ((showArrowButton: boolean) => void) | undefined = undefined;

  private constructor() {
    super();
    AppStorage.setOrCreate<boolean>('isDropAnimationGoing', false);
  }

  public setTrayAreaPlugins(trayArea: GroupProperty): void {
    this.trayAreaPlugins.splice(0, this.trayAreaPlugins.length);

    trayArea.getVisualPluginList().forEach(plugin => {
      this.trayAreaPlugins.push(plugin);
    });
  }

  public setFixedAreaWidth(width: number): void {
    this.fixedAreaWidth = width;
    this.calGroupWrapperWidth();
  }

  public getFixedAreaWidth(): number {
    return this.fixedAreaWidth;
  }

  public setAssistantVoiceWidth(width: number): void {
    this.assistantVoiceWidth = width;
    this.calGroupWrapperWidth();
  }

  public getAssistantVoiceWidth(): number {
    return this.assistantVoiceWidth;
  }

  private calGroupWrapperWidth(): void {
    this.groupWrapperWidth = this.fixedAreaWidth + this.assistantVoiceWidth;
    log.showInfo('calGroupWrapperWidth, fixedAreaWidth:' + this.fixedAreaWidth + ' assistantVoiceWidth:' +
      this.assistantVoiceWidth + ' groupWrapperWidth:' + this.groupWrapperWidth);
  }

  public setInputItemRect(newArea: Area): void {
    this.inputItemRect = {
      x: newArea.globalPosition.x,
      y: newArea.globalPosition.y,
      width: newArea.width,
      height: newArea.height
    };
  }

  public setArrowRect(newArea: Area): void {
    this.arrowRect = {
      x: newArea.globalPosition.x,
      y: newArea.globalPosition.y,
      width: newArea.width,
      height: newArea.height
    };
  }

  public removeDragPlugin(info: PluginProperty): void {
    const index = this.trayAreaPlugins.findIndex((findProperty: PluginProperty) => {
      return findProperty.getSlot() === info.getSlot();
    });
    if (index > -1) {
      this.trayAreaPlugins[index].pluginInfo?.onDestroy();
      this.trayAreaPlugins.splice(index, 1);
    }
  }

  public getDragItemIsTray(): boolean {
    return this.dragItemIsTray;
  }

  public getShowDropFrameIcon(): boolean {
    return this.showDropFrameIcon;
  }

  public getTrayAreaPlugins(): LocalGroupProperty {
    return this.trayAreaPlugins;
  }

  public getTrayGridColum(): number {
    let visibleNum: number = this.trayAreaPlugins.length;
    let tayNum: number = (visibleNum < MAX_COLUMNS) ? visibleNum : MAX_COLUMNS;
    return tayNum;
  }

  public isTrayAreaPluginProperty(pluginSlot: string): boolean {
    const trayAreaPlugins = PluginGroupingManager.getInstance()
      .getPluginGroup(PluginPositionType.BOTTOM_RIGHT, PluginGroupType.TRAY);
    return trayAreaPlugins?.hasPlugin(pluginSlot) ?? false;
  }

  public isDynamicPluginProperty(pluginSlot: string): boolean {
    let dynamicProperty = PluginGroupingManager.getInstance()
      .getPluginGroup(PluginPositionType.BOTTOM_RIGHT, PluginGroupType.DYNAMIC_LEFT);
    return dynamicProperty?.hasPlugin(pluginSlot) ?? false;
  }

  //状态栏动态最大区域宽度
  public DynamicExceedMaxWidth(): boolean {
    log.showInfo(`DynamicExceedMaxWidth statusBarRightWidth ${this.statusBarRightWidth},` +
      `groupWrapperWidth: ${this.groupWrapperWidth}`);
    if (this.statusBarRightWidth < 0 || this.groupWrapperWidth < 0) {
      return false;
    }
    let dynamicProperty = PluginGroupingManager.getInstance()
      .getPluginGroup(PluginPositionType.BOTTOM_RIGHT, PluginGroupType.DYNAMIC_LEFT);
    let visibleNum: number = dynamicProperty.getVisualPluginNum();
    let isPrivacyOrLocationVisiable: boolean = false;
    dynamicProperty?.getVisualPluginList().forEach((plug: PluginProperty) => {
      log.showInfo(`DynamicExceedMaxWidth plug:${plug?.getSlot()}`);
      if ((plug?.getSlot() === PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE ||
        plug?.getSlot() === PluginSlot.SLOT_STATUS_LOCATION ||
        plug?.getSlot() === PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT)) {
        isPrivacyOrLocationVisiable = true;
      }
    })
    log.showInfo(`DynamicExceedMaxWidth visibleNum: ${visibleNum},
     'PrivacyLocationVisiable:${isPrivacyOrLocationVisiable}`);
    visibleNum = isPrivacyOrLocationVisiable ? visibleNum : (visibleNum + 1);
    let occupyWidth = visibleNum * (CONTAINER_WIDTH + SPACE_WIDTH);
    log.showInfo(`DynamicExceedMaxWidth occupyWidth:${occupyWidth} groupWrapperWidth: ${this.groupWrapperWidth} statusBarRightWidth: ${this.statusBarRightWidth}`);
    if ((this.groupWrapperWidth + occupyWidth) > this.statusBarRightWidth) {
      log.showInfo('DynamicExceedMaxWidth exceed statusBar right width!');
      return true;
    }
    return false;
  }

  public getCurrentGridPos(pluginSlot: string): DragItemPosition | undefined {
    let index: number = this.trayAreaPlugins.getPluginIndex(pluginSlot);
    let tayNum: number = this.getTrayGridColum();
    if (tayNum <= 0) {
      log.showInfo(`getCurrentGridPos invaild tayNum: ${tayNum}}`);
      return undefined;
    }
    let slotColumn: number = Math.floor(index % tayNum);
    let slotRow: number = Math.floor(index / tayNum);
    let dragItemPos: DragItemPosition = {
      column: slotColumn,
      row: slotRow,
      page: 0,
      x: 0,
      y:0
    }
    log.showInfo(`getCurrentGridPos slotColumn: ${slotColumn}, slotRow: ${slotRow} slot:${pluginSlot}`);
    return dragItemPos;
  }

  public getStartDragPos(): number[] {
    if (!this.mStartPosition) {
      return [0, 0];
    }
    log.showInfo(`getStartDragPos slotColum: ${this.mStartPosition?.column}, slotRow: ${this.mStartPosition?.row}`);
    return PcTrayGridLayoutUtil.getGridItemPosition(this.mStartPosition?.row, this.mStartPosition?.column);
  }

  registerShowArrowButtonCallback(callback: (showArrowButton: boolean) => void): void {
    this.onShowArrowButton = callback;
  }

  unregisterShowArrowButtonCallback(): void {
    this.onShowArrowButton = undefined;
  }

  notifyShowArrowButton(showArrowButton: boolean): void {
    this.onShowArrowButton?.(showArrowButton);
  }

  registerDynamicListNumChangeCallback(callback: () => void): void {
    if (!this.onDynamicListNumChangeSet.has(callback)) {
      this.onDynamicListNumChangeSet.add(callback);
    }
  }

  unregisterDynamicListNumChangeCallback(callback: () => void): void {
    if (this.onDynamicListNumChangeSet.has(callback)) {
      this.onDynamicListNumChangeSet.remove(callback);
    }
  }

  notifyAccessPlugChange(info: string, isAdd: boolean = true): void {
    log.showInfo('notifyAccessPlugChange info:' + info + ', isAdd: ' + isAdd);
    this.onDynamicListNumChangeCallBack();
  }

  registerDynamicListNumChangeInDragCallback(callback: (addDynamicPlugNum: number,
    hasAnim: boolean, dockChanged?: boolean) => void): void {
    if (!this.onDynamicListNumChangeInDragSet.has(callback)) {
      this.onDynamicListNumChangeInDragSet?.add(callback);
    }
  }

  unregisterDynamicListNumChangeInDragCallback(callback: (addDynamicPlugNum: number,
    hasAnim: boolean, dockChanged?: boolean) => void): void {
    if (this.onDynamicListNumChangeInDragSet.has(callback)) {
      this.onDynamicListNumChangeInDragSet?.remove(callback);
    }
  }

  registerTrayListNumChangeInDragCallback(callback: (addTrayPlugNum: number) => void): void {
    this.onTrayListNumChangeInDrag = callback;
  }

  unregisterTrayListNumChangeInDragCallback(): void {
    this.onTrayListNumChangeInDrag = undefined;
  }

  setDropFrameRect(rect: Rectangle, bundleName: string): void {
    this.dropFrameRect = rect;
  }

  dumpDynamicProperty(extra: string): void {
    let dynamicProperty = PluginGroupingManager.getInstance()
      .getPluginGroup(PluginPositionType.BOTTOM_RIGHT, PluginGroupType.DYNAMIC_LEFT);
    dynamicProperty?.getPluginList().forEach((plug: PluginProperty) => {
      log.showInfo(extra + ' plug:' + plug?.getSlot() + ' visible:' + plug?.isVisible());
    })
  }

  /**
   * 获取下一个item, 若没有下一个图标，返回自身，如目标图标不在list中，返回Undefined
   * @param info 要查询的图标
   */
  private getNextLocalItem(info: string): PluginInfo | undefined {
    if (this.isDynamicPluginProperty(info)) {
      let dynamicProperty = PluginGroupingManager.getInstance()
        .getPluginGroup(PluginPositionType.BOTTOM_RIGHT, PluginGroupType.DYNAMIC_LEFT);
      let index = dynamicProperty?.getPluginIndex(info);
      let dynamicLeftIndex = this.calDynamicLeftIndex(dynamicProperty);
      log.showInfo(`getNextLocalItem start index:${index}, info:${info}, dynamicLeftIndex:${dynamicLeftIndex}`);

      index = index + 1 <= dynamicLeftIndex ? index + 1 : index;
      index = index + 1 <= dynamicLeftIndex && dynamicProperty.getPluginList()[index].getSlot() === (this.dragItem ?? '') ?
        index + 1 : index;
      index = index >= dynamicLeftIndex ? dynamicLeftIndex : index;
      log.showInfo(`getNextLocalItem end index:${index}, slot:${dynamicProperty.getPluginList()[index].getSlot()}`);
      return dynamicProperty.getPluginList()[index].pluginInfo ?? undefined;
    } else {
      log.showInfo('getNextLocalItem pluginSlot invalid');
      return undefined;
    }
  }

  private calDynamicLeftIndex(dynamicProperty: GroupProperty): number {
    let dynamicLeftIndex = Number.MAX_VALUE;
    let rightMap = StyleFactory.getInstance()
      .getStyleManager()?.getPluginSlotMapping()?.getSlotInWhereMap()?.get(PluginPositionType.BOTTOM_RIGHT);
    rightMap?.forEach((group: PluginGroupType, slot: string) => {
      if (group === PluginGroupType.DYNAMIC_LEFT) {
        let indexTmp = dynamicProperty.getPluginIndex(slot);
        indexTmp = indexTmp >= 0 ? indexTmp : dynamicLeftIndex;
        dynamicLeftIndex = dynamicLeftIndex > indexTmp ? indexTmp : dynamicLeftIndex;
      }
    });
    return dynamicLeftIndex;
  }

  public static getInstance(): PcStatusBarDragMgr {
    if (!PcStatusBarDragMgr.instance) {
      PcStatusBarDragMgr.instance = new PcStatusBarDragMgr();
    }
    return PcStatusBarDragMgr.instance;
  }

  onDragStart(info: PluginInfo | undefined, isTray: boolean): void {
    log.showInfo(`onDragStart pluginSlot: ${info?.getSlot()}` +
      ` bundleName: ${info?.pluginParseInfo.bundleName}`);
    if (this.isStatusBarDragging) {
      log.showInfo(`onDragStart directly return`);
      return;
    }
    Trace.start(Trace.CORE_METHOD_DRAG_START);
    this.isStatusBarDragging = true;
    AppStorage.setOrCreate('pc_status_bar_dragging', true);
    let trayArea = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    this.setTrayAreaPlugins(trayArea);
    PcStatusBarDragMgr.isDragCompleted = false;
    if (isTray) {
      this.dragItem = info;
      this.dragItemIsTray = isTray;
      this.showDropFrameIcon = true;
      this.dropItem = info;
      this.mStartPosition = this.getCurrentGridPos(info?.getSlot() ?? '');
      this.mLastPosOnMoving = this.getCurrentGridPos(info?.getSlot() ?? '');
      if (!this.mStartPosition || !this.mLastPosOnMoving) {
        log.showWarn('onDragStart mStartPosition or mLastPosOnMoving is undefined');
        return;
      }
      this.getContext()?.eventHub.emit(
        this.getDragStartInStatusBarEvent(this.dragItem?.getSlot() ?? ''));
      this.getContext()?.eventHub.emit(this.getDragStartInStatusBarEvent(Constants.PC_TRAY_DROP_FRAME_KEY));
    } else {
      this.dumpDynamicProperty('onDragStart dynamic');
      // 落位框出现
      const nextItem = this.getNextLocalItem(info?.getSlot() ?? '');
      if (nextItem) {
        this.dragItem = info;
        this.getContext()?.eventHub.emit(
          this.getDragStartInStatusBarEvent(this.dragItem?.getSlot() ?? ''));
        this.isDragStartDropFrameShow = true;
        this.showDropFrameIcon = true;
        this.startSqueezedInStatusBar(nextItem?.getSlot() ?? '');
        this.isDragStartDropFrameShow = false;
        this.dropItem = nextItem;
      }
      this.onShowArrowButton?.(true);
    }
    Trace.end(Trace.CORE_METHOD_DRAG_START);
  }

  private cancelSqueezedInStatusBarWithDelay(addDynamicPlugNum: number = 0): void {
    if (this.cancelSqueezedInStatusBarTimerId > 0) {
      return;
    }
    log.showInfo(`cancelSqueezedInStatusBarWithDelay dropItem: ${this.dropItem?.getSlot() ?? ''}`);
    this.cancelSqueezedInStatusBarTimerId = setTimeout(() => {
      if (!this.dropItem) {
        return;
      }
      this.onDynamicListNumChangeInDragCallBack(addDynamicPlugNum, true);
      this.cancelSqueezedInStatusBar(this.dropItem?.getSlot() ?? '');
      this.cancelSqueezedInStatusBarTimerId = 0;
    }, MIN_INTERNAL)
  }

  private onDynamicListNumChangeInDragCallBack(addDynamicPlugNum: number, hasAnim: boolean,
    dynamicChanged: boolean = false) {
    this.onDynamicListNumChangeInDragSet?.forEach((onDynamicListNumChangeInDrag: ((addDynamicPlugNum: number,
      hasAnim: boolean,
      dynamicChanged?: boolean) => void)) => {
      onDynamicListNumChangeInDrag?.(addDynamicPlugNum, hasAnim, dynamicChanged);
    })
  }

  private onDynamicListNumChangeCallBack() {
    this.onDynamicListNumChangeSet?.forEach((onDynamicListNumChange: (() => void))=>{
      onDynamicListNumChange?.();
    })
  }

  cancelSqueezeItemWithDelay(squeezeItem: string = '', delay: number = MIN_INTERNAL): void {
    log.showInfo(`cancelSqueezeItemWithDelay enter squeezeItem: ${squeezeItem}`);
    if (this.cancelSqueezedInStatusBarTimerId > 0) {
      return;
    }
    this.cancelSqueezedInStatusBarTimerId = setTimeout(() => {
      log.showInfo(`cancelSqueezeItemWithDelay deal cancel squeezeItem: ${squeezeItem}`);
      if (squeezeItem === '') {
        return;
      }
      this.onDynamicListNumChangeInDragCallBack(0, true);
      this.cancelSqueezedInStatusBar(squeezeItem);
      this.cancelSqueezedInStatusBarTimerId = 0;
    }, delay)
  }

  cancelSqueezedInStatusBar(squeezeItem: string | undefined, hasAnimation: boolean = true): void {
    if (squeezeItem) {
      this.getContext()?.eventHub.emit(this.getItemSqueezedCancelEvent(squeezeItem),
        hasAnimation);
    }
    this.isShowDropFrame = false;
  }

  startSqueezedInStatusBar(squeezeItem: string | undefined): void {
    if (squeezeItem) {
      this.getContext()?.eventHub.emit(this.getItemSqueezedStartEvent(squeezeItem));
    }
    this.isShowDropFrame = true;
  }


  clearCancelSqueezedInStatusBarTimer(): void {
    if (this.cancelSqueezedInStatusBarTimerId > 0) {
      clearTimeout(this.cancelSqueezedInStatusBarTimerId);
      this.cancelSqueezedInStatusBarTimerId = 0;
    }
  }

  private setDragMovePos(dragMouseX: number, dragMouseY: number): void {
    if (!this.isDropAnimating) {
      this.lastDragMoveX = dragMouseX;
      this.lastDragMoveY = dragMouseY;
    }
  }

  private getTranslateItemByIndex(index: number): TranslateItem | undefined {
    let tayNum: number = this.getTrayGridColum();
    if (tayNum <= 0) {
      log.showInfo(`getTranslateItemByIndex invalid tayNum ${tayNum}`);
      return undefined;
    }
    let slotColumn: number = Math.floor(index % tayNum);
    let slotRow: number = Math.floor(index / tayNum);
    log.showInfo(`getTranslateItemByIndex, ready to find grid location row ${slotRow}, column ${slotColumn}`);

    let translateItem: TranslateItem = {
      slot: this.trayAreaPlugins[index]?.getSlot(),
      row: slotRow,
      column: slotColumn,
      isRepeatItem: false,
      position: [],
      newColumn: 0,
      newRow: 0,
    }

    return translateItem;
  }

  /**
   * 获取图标位移的下一个位置
   * @param isSqueezeBack 是否向后挤位
   * @param row 图标当前所在行
   * @param column 图标当前所在列
   * @returns 能找到下一个合法位置，则返回对应位置，否则返回undefined
   */
  public getNextPosition(isSqueezeBack: boolean, row: number | undefined,
    column: number | undefined): number[] | undefined {
    if (row === undefined || column === undefined) {
      log.showWarn('getNextPosition, param undefined!');
      return undefined;
    }
    let tayNum: number = this.getTrayGridColum();
    let nextPosRow: number = row;
    let nextPosColumn: number = column;
    nextPosColumn = isSqueezeBack ? column - 1 : column + 1;
    if (nextPosColumn === tayNum) {
      //过右边界
      nextPosColumn = 0;
      nextPosRow++;
    }
    if (nextPosColumn === -1) {
      //过左边界
      nextPosColumn = tayNum - 1;
      nextPosRow--;
      if (nextPosRow === -1) {
        // 过下边界，无效
        log.showWarn('getNextPosition, next position exceed top!');
        return undefined;
      }
    }
    return [nextPosRow, nextPosColumn];
  }

  private getGridPositionByIndex(index: number): number[] {
    let tayNum: number = this.getTrayGridColum();
    let row: number = Math.floor(index / tayNum);
    let column: number = Math.floor(index % tayNum);
    return [row, column];
  }

  private startSqueeze(startItemPos: DragItemPosition, endItemPos: DragItemPosition): boolean {
    if (!startItemPos || !endItemPos) {
      log.showWarn('startSqueeze ilegal input params');
      return false;
    }
    log.showInfo(`startSqueeze startItemPos: ${startItemPos.column}-${startItemPos.row},` +
      `endItemPos: ${endItemPos.column}-${endItemPos.row}`);

    // 获取待移动的元素
    // 计算移动位置列表
    // 遍历列表，发送动画事件
    // 更新布局信息
    let tayNum: number = this.getTrayGridColum();
    let startIndex: number = startItemPos.column + startItemPos.row * tayNum;
    let endIndex: number = endItemPos.column + endItemPos.row * tayNum;
    let isSqueezeBack: boolean = startIndex < endIndex;
    if (startIndex === endIndex) {
      log.showWarn('startSqueeze startIndex is same to endIndex');
      // 没挤位但在有效区，落位框放在下一个位置
      const grid: number[] = this.getGridPositionByIndex(endIndex);
      const position: number[] = PcTrayGridLayoutUtil.getGridItemPosition(grid[0], grid[1]);
      this.getContext()?.eventHub.emit(
        this.getItemSqueezedStartEvent(Constants.PC_TRAY_DROP_FRAME_KEY), [[], position]);
      return false;
    }
    log.showInfo(`startSqueeze startIndex, ${startIndex}, endIndex, ${endIndex}, isSqueezeBack ${isSqueezeBack}`);
    this.mTranslateItemList = [];
    for (let i = isSqueezeBack ? startIndex + 1 : startIndex - 1; isSqueezeBack ? i <= endIndex : i >= endIndex;
      isSqueezeBack ? i++ : i--) {
      let translateItem: TranslateItem | undefined = this.getTranslateItemByIndex(i);
      log.showInfo('startSqueeze, slot:' + this.trayAreaPlugins[i]?.getSlot());
      if (!translateItem) {
        log.showWarn(`startSqueeze getTranslateItemByIndex failed at index ${i}`);
        continue;
      }
      let translatePosition: number[][] = [];
      // 按x,y这样的顺序, 坐标应当为宫格左上角
      let oldPosition: number[] = PcTrayGridLayoutUtil.getGridItemPosition(translateItem.row, translateItem.column);
      log.showInfo(`startSqueeze oldPosition: ${oldPosition}`);

      // 新位置
      let nextGridPos: number[] | undefined =
        this.getNextPosition(isSqueezeBack, translateItem.row, translateItem.column);
      log.showInfo(`startSqueeze nextGridPos: ${nextGridPos}`);
      if (!nextGridPos) {
        log.showInfo('startSqueeze find nextGridPos failed');
        return false;
      }
      let newPosition: number[] = PcTrayGridLayoutUtil.getGridItemPosition(nextGridPos[0], nextGridPos[1]);
      log.showInfo(`startSqueeze newPosition: ${newPosition}`);

      translatePosition[0] = oldPosition;
      translatePosition[1] = newPosition;
      translateItem.newColumn = nextGridPos[1];
      translateItem.newRow = nextGridPos[0];
      // 计算偏移位置
      translateItem.position = translatePosition;
      this.mTranslateItemList.push(translateItem);
    }
    // 被拖拽元素也要位移动，可以不用动画
    let translateDragItem: TranslateItem = {
      slot: this.dragItem?.getSlot() ?? '',
      row: startItemPos?.row ?? 0,
      column: startItemPos?.column ?? 0,
      isRepeatItem: false,
      position: [],
      newColumn: 0,
      newRow: 0,
    }
    let translatePosition: number[][] = [];
    let oldPosition: number[] =
      PcTrayGridLayoutUtil.getGridItemPosition(this.mLastPosOnMoving?.row!, this.mLastPosOnMoving?.column!);
    let newPosition: number[] = PcTrayGridLayoutUtil.getGridItemPosition(endItemPos.row, endItemPos.column);
    log.showInfo(`startSqueeze: dragItem oldPosition:` +
      `${PcTrayGridLayoutUtil.appGridPosToString(startItemPos)} | ${oldPosition},` +
      `newPosition: ${PcTrayGridLayoutUtil.appGridPosToString(endItemPos)} | ${newPosition}`);
    translatePosition[0] = oldPosition;
    translatePosition[1] = newPosition;
    translateDragItem.newColumn = endItemPos.column;
    translateDragItem.newRow = endItemPos.row;
    translateDragItem.position = translatePosition;

    this.mTranslateItemList.push(translateDragItem);
    this.backupMovedItemList();
    this.mTranslateItemList.forEach((item: TranslateItem) => {
      if (!item.isRepeatItem) {
        if (!this.isDynamicPluginProperty(item.slot)) {
          this.getContext()?.eventHub.emit(this.getItemSqueezedStartEvent(item.slot), item.position);
        }
        this.showDropFrameIcon = false;
        this.getContext()?.eventHub.emit(
          this.getItemSqueezedStartEvent(Constants.PC_TRAY_DROP_FRAME_KEY), item.position);
      }
    });
    return true;
  }

  private backupMovedItemList(): void {
    log.showInfo(`backupMovedItemList: ${this.mTranslateItemList?.length}`);
    if (CheckEmptyUtils.isEmptyArr(this.mTranslateItemList)) {
      return;
    }
    for (let index = 0; index < this.mTranslateItemList.length; index++) {
      const key: string = this.mTranslateItemList[index].slot;
      if (!this.movingItemMap.has(key)) {
        this.movingItemMap.set(key, this.mTranslateItemList[index]);
        this.mLastTranslateItemList.push(this.mTranslateItemList[index]);
      } else {
        // 已经存在，更新元素
        let item = this.movingItemMap.get(key) as TranslateItem;
        item.column = this.mTranslateItemList[index].column;
        item.row = this.mTranslateItemList[index].row;
        item.newColumn = this.mTranslateItemList[index].newColumn;
        item.newRow = this.mTranslateItemList[index].newRow;
      }
    }
    log.showInfo(`backupMovedItemList after backup: ${this.mLastTranslateItemList?.length}`);
  }

  private resetLastItemList(showIcon: boolean): void {
    let property: PositionProperty = PluginGroupingManager.getInstance()
      .getPluginPosition(PluginPositionType.BOTTOM_RIGHT);
    HiSysUtil.getInstance().hiSysOnIconItemsNumberChange(property);
    log.showInfo(`resetLastItemList: ${this.mLastTranslateItemList?.length}`);
    this.mLastTranslateItemList?.forEach((item: TranslateItem) => {
      log.showInfo(`resetLastItemList item: , ${item?.slot}`);
      this.getContext()?.eventHub.emit(this.getItemSqueezedCancelEvent(item.slot), this.hasCancelSqueezeAnimation);
      this.showDropFrameIcon = showIcon;
      this.getContext()?.eventHub.emit(this.getItemSqueezedCancelEvent(Constants.PC_TRAY_DROP_FRAME_KEY),
        this.hasCancelSqueezeAnimation);
    });
    this.mLastTranslateItemList = [];
    this.movingItemMap.clear();
  }

  public onDragLeaveTray(event: DragEvent, extraParams?: string): void {
    log.showInfo('onDragLeaveTray');
    if (!this.isStatusBarDragging || CheckEmptyUtils.isEmpty(extraParams)) {
      return;
    }
    const jsonString: object = JSON.parse(extraParams as string);
    const pluginSlot: string = jsonString['extraInfo'] as string;
    let isTrayDrag: boolean = true;
    if (this.isDynamicPluginProperty(pluginSlot)) {
      isTrayDrag = false;
    }

    let trayArea = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    if (isTrayDrag) {
      this.setTrayAreaPlugins(trayArea);
    }
    this.resetLastItemList(isTrayDrag);
    this.mLastPosOnMoving = this.mStartPosition;

    if (!isTrayDrag && this.isTrayAreaInit) {
      this.setTrayAreaPlugins(trayArea);
      this.isTrayAreaInit = false;
      this.isTrayAreaAnimateFinish = false;
      this.onTrayListNumChangeInDrag?.(0);
    }
  }

  private updateTrayAreaPlugins() : void {
    this.mLastTranslateItemList?.forEach((item: TranslateItem) => {
      let trayNum = this.getTrayGridColum();
      let newIndex = item.newRow * trayNum + item.newColumn;
      let oldIndex = this.trayAreaPlugins.getPluginIndex(item.slot);
      if (newIndex !== oldIndex) {
        this.trayAreaPlugins.swapPluginElements(newIndex, oldIndex);
      }
    })
  }

  onDragEnter(pluginSlot: string, isTray: boolean, event: DragEvent, extraParams?: string): void {
    log.showInfo(`onDragEnter ${pluginSlot}`);
    if (!this.isStatusBarDragging || CheckEmptyUtils.isEmpty(extraParams)) {
      log.showInfo('onDragEnter isStatusBarDragging:' + this.isStatusBarDragging);
      return;
    }

    if (isTray) {
      const jsonString: object = JSON.parse(extraParams as string);
      const dragPluginSlot: string = jsonString['extraInfo'] as string;
      if (this.isDynamicPluginProperty(dragPluginSlot) && (this.trayAreaPlugins?.getPlugin(dragPluginSlot) === null) &&
        !this.isTrayAreaInit) {
        let dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
          PluginGroupType.DYNAMIC_LEFT);

        let plug: PluginProperty = dynamicProperty.getSpecificPluginBySlot(dragPluginSlot) as PluginProperty;
        this.trayAreaPlugins.addPlugin(plug, this.trayAreaPlugins.length);
        this.isTrayAreaInit = true;

        this.onTrayListNumChangeInDrag?.(1);
        let trayArea = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
          PluginGroupType.TRAY);
        let size = trayArea?.getVisualPluginNum();
        let tayNum: number = size + 1 >= MAX_COLUMNS ? MAX_COLUMNS : size + 1;
        let slotColum: number = Math.floor((size) % tayNum);
        let slotRow: number = Math.floor((size) / tayNum);
        let dragItemPos: DragItemPosition = {
          column: slotColum,
          row: slotRow,
          page: 0,
          x: 0,
          y:0
        }

        this.mStartPosition = dragItemPos;
        this.mLastPosOnMoving = dragItemPos;
        this.showDropFrameIcon = false;
        this.getContext()?.eventHub.emit(this.getDragStartInStatusBarEvent(Constants.PC_TRAY_DROP_FRAME_KEY));
        return;
      }
    }

    this.clearCancelSqueezedInStatusBarTimer();
    this.dragSnapshotRelativeRect = event?.getPreviewRect();
    this.dragParams = {};
  }

  onDragLeave(pluginSlot: string, isTray: boolean, extraParams?: string): void {
    log.showInfo(`onDragLeave ${pluginSlot}`);
    if (!this.isStatusBarDragging || isTray || CheckEmptyUtils.isEmpty(extraParams)) {
      return;
    }
    if (pluginSlot === (this.dragItem?.getSlot() ?? '')) {
      return;
    }

    const jsonString: object = JSON.parse(extraParams as string);
    const dragSlot: string = jsonString['extraInfo'] as string;
    if (this.isTrayAreaPluginProperty(dragSlot)) {
      this.cancelSqueezedInStatusBarWithDelay(0);
      return;
    } else if (this.isDynamicPluginProperty(dragSlot)) {
      this.restoreDynamic(dragSlot);
    } else {
      log.showInfo(`onDragLeave invalid extraParams`);
    }
  }

  restoreDynamic(pluginSlot: string): void {
    if (this.restoreDynamicTimerId > 0) {
      return;
    }
    log.showInfo(`restoreDynamic dropItem: ${this.dropItem?.getSlot() ?? ''}`);
    this.restoreDynamicTimerId = setTimeout(() => {
      const nextItem = this.getNextLocalItem(pluginSlot);
      log.showInfo(`restoreDynamic nextItem: ${nextItem?.getSlot() ?? ''}`);
      if (nextItem) {
        if (nextItem.getSlot() === (this.dropItem?.getSlot() ?? '')) {
          this.isDragStartDropFrameShow = true;
          this.showDropFrameIcon = true;
          this.startSqueezedInStatusBar(this.dropItem?.getSlot() ?? '');
          this.isDragStartDropFrameShow = false;
        } else {
          this.showDropFrameIcon = false;
          this.cancelSqueezedInStatusBar(this.dropItem?.getSlot() ?? '');
          this.dropItem = nextItem;
          this.showDropFrameIcon = true;
          this.startSqueezedInStatusBar(this.dropItem?.getSlot() ?? '');
        }
        this.restoreDynamicTimerId = 0;
      }
    }, RESTORE_DYNAMIC_INTERNAL)
  }

  clearRestoreDynamicTimer(): void {
    if (this.restoreDynamicTimerId > 0) {
      clearTimeout(this.restoreDynamicTimerId);
      this.restoreDynamicTimerId = 0;
    }
  }

  onDragMove(info: PluginInfo | undefined, moveItemRect: Rectangle, event: DragEvent, extraParams?: string): void {
    if (!this.isStatusBarDragging || CheckEmptyUtils.isEmpty(extraParams)) {
      return;
    }
    log.showInfo(`onDragMove ${info?.getSlot() ?? ''}`);
    const jsonString: object = JSON.parse(extraParams as string);
    const dragSlot: string = jsonString['extraInfo'] as string;
    if (this.isDynamicPluginProperty(info?.getSlot() ?? '')) {
      this.onDragMoveInDynamic(info, dragSlot, moveItemRect, event);
      return;
    }
    if (this.isTrayAreaPluginProperty(info?.getSlot() ?? '')) {
      this.onDragMoveInTray(info?.getSlot() ?? '', dragSlot, moveItemRect, event);
      return;
    }
  }

  onDragMoveInDynamic(info: PluginInfo | undefined, dragSlot: string, moveItemRect: Rectangle, event: DragEvent): void {
    let previewRect: Rectangle = event?.getPreviewRect();
    log.showDebug(`onDragMoveInDynamic ${info?.getSlot() ?? ''}` + ' moveItemRect : ' +
    JSON.stringify(moveItemRect) + ' previewRect : ' + JSON.stringify(previewRect));
    const moveToRight = event.getWindowX() > this.lastDragMoveX;
    this.setDragMovePos(event.getWindowX(), event.getWindowY());

    this.isStatusBarDragging = true;
    if (this.cancelSqueezedInStatusBarTimerId > 0) {
      this.clearCancelSqueezedInStatusBarTimer();
    }
    if (this.restoreDynamicTimerId > 0) {
      this.clearRestoreDynamicTimer();
    }
    // 计算落位框位置
    const leftSnapshotEdgeX = ResUtils.getNumberFromLength(previewRect.x);
    const rightSnapshotEdgeX = RTLUtil.isRTL() ? leftSnapshotEdgeX - ResUtils.getNumberFromLength(previewRect.width) :
      leftSnapshotEdgeX + ResUtils.getNumberFromLength(previewRect.width);
    const leftMiddleLineX = RTLUtil.isRTL() ? ResUtils.getNumberFromLength(moveItemRect.x) -
      ResUtils.getNumberFromLength(moveItemRect.width) * LEFT_MIDDLE_THRESHOLD :
      ResUtils.getNumberFromLength(moveItemRect.x) +
        ResUtils.getNumberFromLength(moveItemRect.width) * LEFT_MIDDLE_THRESHOLD;
    const rightMiddleLineX = RTLUtil.isRTL() ? ResUtils.getNumberFromLength(moveItemRect.x) -
      ResUtils.getNumberFromLength(moveItemRect.width) * RIGHT_MIDDLE_THRESHOLD :
      ResUtils.getNumberFromLength(moveItemRect.x) +
        ResUtils.getNumberFromLength(moveItemRect.width) * RIGHT_MIDDLE_THRESHOLD;
    log.showDebug(`onDragMoveInDynamic leftEdgeX:${leftSnapshotEdgeX}, rightSnapshotEdgeX:${rightSnapshotEdgeX},` +
      ` leftMiddleLineX:${leftMiddleLineX}, rightMiddleLineX:${rightMiddleLineX}`);
    let isLeft: boolean = true;
    if (moveToRight) {
      isLeft = rightSnapshotEdgeX < leftMiddleLineX;
    } else {
      isLeft = leftSnapshotEdgeX < rightMiddleLineX;
    }
    log.showInfo(`onDragMoveInDynamic ${info?.getSlot() ?? ''} moveToRight:${moveToRight} isLeft:${isLeft}`);
    this.updateDropFrame(info, isLeft);
  }

  /**
   * 更新落位框到落位图标的左边或者落位图标下一个图标的左边
   * @param info 图标信息
   * @param isLeft 是否更新落位框到当前图标/或者下一图标, 默认true
   * @param isDragStart 是否是起拖图标背景框
   */
  private updateDropFrame(info: PluginInfo | undefined, isLeft: boolean = true): void {
    let dropFrameItem: PluginInfo | undefined = info;
    const rightMap = StyleFactory.getInstance()
      .getStyleManager()?.getPluginSlotMapping()?.getSlotInWhereMap()?.get(PluginPositionType.BOTTOM_RIGHT);
    if (dropFrameItem !== undefined && rightMap?.get(dropFrameItem?.getSlot()) == PluginGroupType.DYNAMIC_LEFT) {
      let dynamicProperty = PluginGroupingManager.getInstance()
        .getPluginGroup(PluginPositionType.BOTTOM_RIGHT, PluginGroupType.DYNAMIC_LEFT);
      let dynamicLeftIndex = this.calDynamicLeftIndex(dynamicProperty);
      log.showInfo(`dropFrameItem info:${info}, dynamicLeftIndex:${dynamicLeftIndex}`);
      dropFrameItem = dynamicProperty.getPluginList()[dynamicLeftIndex].pluginInfo ?? undefined;
    }
    if (!isLeft) {
      dropFrameItem = this.getNextLocalItem(info?.getSlot() ?? '');
    }
    if (!dropFrameItem) {
      log.showInfo('no drop item');
      return;
    }
    if (this.dropItem && this.dropItem === dropFrameItem && this.isShowDropFrame) {
      return;
    }
    log.showInfo('updateDropFrame old dropItem:' + this.dropItem?.getSlot() ?? '' +
      ' new dropItem:' + dropFrameItem?.getSlot());
    // 更新落位框
    let addDynamicPlugNum = this.dragItemIsTray ? 1 : 0;
    this.onDynamicListNumChangeInDragCallBack(addDynamicPlugNum, true);

    this.showDropFrameIcon = false;
    this.cancelSqueezedInStatusBar(this.dropItem?.getSlot() ?? '');
    this.dropItem = dropFrameItem;
    this.startSqueezedInStatusBar(this.dropItem?.getSlot() ?? '');
  }

  onDragMoveInTray(info: string, dragSlot: string, moveItemRect: Rectangle, event?: DragEvent): void {
    if (!this.isTrayAreaAnimateFinish && this.isDynamicPluginProperty(dragSlot)) {
      log.showWarn('onDragMoveInTray TrayArea Init not Finish');
      return;
    }
    this.mEndPosition = this.getCurrentGridPos(info);
    this.mCurrEndPosition = this.getCurrentGridPos(info);
    if (!this.mEndPosition || !this.mLastPosOnMoving) {
      log.showWarn('onDragMoveInTray mEndPosition or mLastPosOnMoving is undefined');
      return;
    }
    if (!this.isSqueezing) {
      if (!this.mLastPosOnMoving) {
        return;
      }
      this.isSqueezing = true;
      this.trayAreaPlugins?.forEach((plug: PluginProperty) => {
        log.showInfo('onDragMoveInTray before trayArea plug:' + plug?.getSlot());
      })

      let ret: boolean = this.startSqueeze(this.mLastPosOnMoving, this.mEndPosition);
      log.showInfo('onDragMoveInTray squeeze result: ' + ret);
      if (ret) {
        this.updateTrayAreaPlugins();
      }

      this.trayAreaPlugins?.forEach((plug: PluginProperty) => {
        log.showInfo('onDragMoveInTray after trayArea plug:' + plug?.getSlot());
      })
      if (this.mCurrEndPosition) {
        this.mLastPosOnMoving = {
          column: this.mCurrEndPosition.column as number,
          row: this.mCurrEndPosition.row as number,
          page: this.mCurrEndPosition.page as number,
          x: this.mCurrEndPosition.x as number,
          y: this.mCurrEndPosition.y as number
        }
      }
      this.isSqueezing = false;
      log.showInfo(`onDragMoveInTray mLastPosOnMoving update row: ${this.mLastPosOnMoving.row},` +
        `column:${this.mLastPosOnMoving.column}`);
    }

  }

  isNoNeedDealOnDrop(isTray: boolean, info: PluginInfo | undefined): boolean {
    if (!this.isStatusBarDragging || isTray) {
      return true;
    }
    let dynamicVisableNum: number = 0;
    let dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.DYNAMIC_LEFT);
    dynamicProperty.getVisualPluginList().forEach((plug: PluginProperty) => {
      if (!this.isDefaultDynamicPlug(plug?.getSlot())) {
        dynamicVisableNum++;
      }
    })
    let dragPluginSlot = this.dragItem?.getSlot() ?? '';
    let dropPluginSlot = this.dropItem?.getSlot() ?? '';
    let currentDropPluginSlot = info?.getSlot() ?? '';
    if (this.isTrayAreaPluginProperty(dragPluginSlot) &&
    this.isDynamicPluginProperty(currentDropPluginSlot) && dropPluginSlot !== currentDropPluginSlot) {
      log.showWarn('abnormal dropPluginSlot:' + dropPluginSlot +
        ', currentDropPluginSlot' + currentDropPluginSlot);
      dropPluginSlot = currentDropPluginSlot;
      let rightMap = StyleFactory.getInstance()
        .getStyleManager()?.getPluginSlotMapping()?.getSlotInWhereMap()?.get(PluginPositionType.BOTTOM_RIGHT);
      if (rightMap?.get(currentDropPluginSlot) === PluginGroupType.DYNAMIC_LEFT) {
        const index: number = this.calDynamicLeftIndex(dynamicProperty);
        let pluginProperties = dynamicProperty.getPluginList();
        if (index >= 0 && index < pluginProperties.length) {
          this.dropItem = pluginProperties[index].pluginInfo!;
        }
      } else {
        this.dropItem = info;
      }
      log.showInfo(`onDrop, dropItem: ${this.dropItem?.getSlot()}`);
    }
    if (this.isDynamicPluginProperty(dragPluginSlot) &&
      dropPluginSlot === PluginSlot.SLOT_CAPSULE_KEY_MOUSE && dynamicVisableNum === 1) {
      log.showInfo('only one visable dynamic plug drop in dynamic, no need Deal drop!');
      return true;
    }
    return false;
  }

  private getCompanionIconInfo(): CompanionIconInfo {
    return {
      iconId: '',
      bundleName: this.dragItem?.pluginParseInfo.bundleName ?? '',
      abilityName: '',
      moduleName: this.dragItem?.pluginParseInfo.moduleName as string,
      iconNumber: 0,
      iconRadius: 0,
      startAppType: StartType.STATUS_BAR_TRAY,
      cardId: '',
      extraId: ''
    }
  }

  /**
   * 生成落位动画
   */
  onDrop(isTray: boolean, event: DragEvent, info: PluginInfo | undefined, extraParams?: string): void {
    if (this.isNoNeedDealOnDrop(isTray, info)) {
      return;
    }
    let previewRect: Rectangle = event?.getPreviewRect();
    if (!this.isShowDropFrame) {
      // 如果落位框没有显示，或者落位框位置数据没有准备好, 不处理
      log.showInfo(`onDrop params: ${this.isShowDropFrame}`);
      return;
    }
    log.showInfo('onDrop end, dropFrameRect: ' + JSON.stringify(this.dropFrameRect) +
      ' previewRect: ' + JSON.stringify(previewRect) + ' dragItem:' + (this.dragItem?.getSlot() ?? ''));
    Trace.start(Trace.CORE_METHOD_DRAG_DROP);
    this.isDropAnimating = true;
    AppStorage.setOrCreate<boolean>('isDropAnimationGoing', true);
    SCBCompanionManager.getInstance().getController()?.update(this.getCompanionIconInfo());
    const compViewController = SCBTransitionManager.getInstance().findTransitionController('SCBCompanionView', () => {
      return PageDesktopModel.getInstance().getCloseAppData('SCBCompanionView', '', StartType.APP);
    });
    const want: HashMap<string, number | string> = new HashMap();
    want.set('width', ResUtils.getNumberFromLength(previewRect?.width));
    want.set('height', ResUtils.getNumberFromLength(previewRect?.height));
    let posX: number = ResUtils.getNumberFromLength(this.dropFrameRect?.x) +
      (ResUtils.getNumberFromLength(this.dropFrameRect?.width) - Constants.PC_CAPSULE_PLUG_MARGIN -
      ResUtils.getNumberFromLength(previewRect?.width)) / HALF_NUM;
    let posY: number = ResUtils.getNumberFromLength(this.dropFrameRect?.y) +
      (ResUtils.getNumberFromLength(this.dropFrameRect?.height) -
      ResUtils.getNumberFromLength(previewRect?.height)) / HALF_NUM;
    want.set('posX', posX);
    want.set('posY', posY);
    let translateX: number = ResUtils.getNumberFromLength(previewRect?.x) - posX;
    let translateY: number = ResUtils.getNumberFromLength(previewRect?.y) - posY;
    want.set('translateX', translateX);
    want.set('translateY', translateY);
    want.set('bundleName', this.dragItem?.pluginParseInfo.bundleName);
    want.set('abilityName', '');
    want.set('containerId', '');
    want.set('scaleX', 1);
    want.set('scaleY', 1);
    want.set('targetIconRadius', StyleConstants.DEFAULT_8);
    const getIcon: Function = StatusBarManager.getInstance().getRemotePluginIconCallback?.();
    const isLocalized = getIcon?.(this.dragItem?.getSlot()) !== undefined;
    const isRemotePlugin =
      !this.dragItem?.pluginParseInfo.isLocalPlugin && !this.dragItem?.pluginParseInfo.isAccessPlugin && !isLocalized;
    want.set('delayRemove', isRemotePlugin ? 1 : 0);
    log.showInfo('generateDropAnim end, drop to area: ' + want.get('posX') + ' y: ' + want.get('posY') +
      ' width: ' + want.get('width') + ' height: ' + want.get('height') + ' delayRemove: ' + want.get('delayRemove'));
    compViewController?.backward?.(want);

    let pluginSlot = this.dragItem?.getSlot() ?? '';
    if (this.isTrayAreaPluginProperty(pluginSlot)) {
      let trayAreaPlugins = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
        PluginGroupType.TRAY);
      this.dragPlugin = trayAreaPlugins?.getSpecificPluginBySlot(pluginSlot, -1) as PluginProperty;
      log.showInfo('onDrop trayArea dragPlugin:' + this.dragPlugin?.getSlot());
      this.resetState(pluginSlot);
      trayAreaPlugins.removePlugin(this.dragPlugin);
      this.onTrayListNumChangeInDrag?.(0);
      if (trayAreaPlugins.getVisualPluginNum() === 0) {
        this.onShowArrowButton?.(false);
      }
      this.saveTrayPlugsDel(trayAreaPlugins, this.dragPlugin);
    }
  }

  public pluginComponentOnComplete(slot: string) {
    if (!this.isStatusBarDragging || this.dragItem?.getSlot() !== slot) {
      log.info('pluginComponentOnComplete no need to deal');
      return;
    }
    SCBCompanionManager.getInstance().getController()?.delete?.(this.getCompanionIconInfo());
  }

  private resetState(pluginSlot: string) {
    StateManager.getInstance().updateHoveredState(pluginSlot, false);
    StateManager.getInstance().updateClickedState(pluginSlot, false);
    StateManager.getInstance().updateSelectedState(pluginSlot, false);
  }

  public onDynamicAnimateFinish(): void {
    log.showInfo('dynamicAnimateFinish');
  }

  public onDropAnimationEnd = (isCancel?: boolean, param?: DropAnimationParam): void => {
    log.showInfo('onDropAnimationEnd');
    if (!this.isStatusBarDragging) {
      return;
    }
    log.showInfo('onDropAnimationEnd dragPlugin: ' + this.dragPlugin?.getSlot());
    this.changeStatusBarList();
    Trace.end(Trace.CORE_METHOD_DRAG_DROP);
    this.handleStatusBarDragEnd(true, true);
  }

  private changeStatusBarList(): void {
    let dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.DYNAMIC_LEFT);
    let dropPluginSlot = this.dropItem?.getSlot() ?? '';
    if (this.dragItemIsTray) {
      this.dumpDynamicProperty('changeStatusBarList from tray before');
      this.saveDynamicPlugsAdd(dynamicProperty, this.dragPlugin as PluginProperty,
        dynamicProperty?.getSpecificPluginBySlot(dropPluginSlot) as PluginProperty);
      PluginGroupingManager.getInstance()
        .updatePluginTo(this.dragPlugin as PluginProperty, PluginPositionType.BOTTOM_RIGHT,
          PluginGroupType.DYNAMIC_LEFT);
      let dropIndex = dynamicProperty?.getIndexOnVisualPlugins(this.dragPlugin?.getSlot());
      log.showInfo('dropIndex:' + this.dragPlugin?.getSlot());
      if (this.DynamicExceedMaxWidth()) {
        let plug = this.addToTray(dynamicProperty, dropIndex);
        if (!plug) {
          return;
        }
        windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL, true);
      }
      this.dumpDynamicProperty('changeStatusBarList from tray after');
      return;
    }
    this.changeStatusBarListEx();
  }
  // 状态栏动态区域的插件移动到托盘区域。当状态栏动态区域宽度超过最大限制时，会调用此方法将多余的插件转移到托盘
  addToTray(dynamicProperty: GroupProperty,
    dropIndex?: number): PluginProperty | undefined {
    const rightMap = StyleFactory.getInstance()
      .getStyleManager()?.getPluginSlotMapping()?.getSlotInWhereMap()?.get(PluginPositionType.BOTTOM_RIGHT);
    if (dynamicProperty.getVisualPluginNum() <= 0) {
      log.showWarn('no plugin can move');
      return undefined;
    }

    let plug: PluginProperty = dynamicProperty.getVisualPluginList()[0];
    // 托盘拖拽到首眼区最左边，挤占顺位最左的那个
    let index: number = 0;
    while (index < dynamicProperty.getVisualPluginList().length) {
      if (index !== dropIndex && !rightMap?.has(dynamicProperty.getVisualPluginList()[index].getSlot())) {
        plug = dynamicProperty.getVisualPluginList()[index];
        break;
      }
      index++;
    }
    if (plug === undefined) {
      log.showError('not find plugin can move');
      return undefined;
    }
    let trayAreaPlugins = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    let dropPlug = trayAreaPlugins.getPluginList()[trayAreaPlugins.getVisualPluginNum()];
    let isDropFront: boolean = true;
    if (trayAreaPlugins.getVisualPluginNum() > 0) {
      dropPlug = trayAreaPlugins.getVisualPluginList()[trayAreaPlugins.getVisualPluginNum() - 1];
      isDropFront = false;
    }
    this.onShowArrowButton?.(true);
    log.showInfo('addToTray, dropPlug:' + dropPlug?.getSlot() + ' isDropFront:' + isDropFront)
    this.saveTrayPlugsAdd(trayAreaPlugins, plug, dropPlug, isDropFront);
    this.saveDynamicPlugsDel(dynamicProperty, plug);
    PluginGroupingManager.getInstance().updatePluginTo(plug, PluginPositionType.BOTTOM_RIGHT, PluginGroupType.TRAY);
    return plug;
  }

  slotToTray(): void {
    let dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.DYNAMIC_LEFT);
    while (this.DynamicExceedMaxWidth()) {
      let plug = this.addToTray(dynamicProperty);
      if (!plug) {
        break;
      }
    }
    this.dumpDynamicProperty('changeStatusBarList from tray after');
    // 清除挤位后的空位
    this.onDynamicListNumChangeCallBack();
  }

  private changeStatusBarListEx(): void {
    this.dumpDynamicProperty('changeStatusBarList from dynamic before');
    let dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.DYNAMIC_LEFT);
    let dropPluginSlot = this.dropItem?.getSlot() ?? '';
    let pluginSlot = this.dragItem?.getSlot() ?? '';
    log.showInfo('changeStatusBarListEx, pluginSlot:' + pluginSlot + ' dropPluginSlot:' + dropPluginSlot);
    if (this.isDynamicPluginProperty(pluginSlot)) {
      let dragPlugin: PluginProperty = dynamicProperty?.getSpecificPluginBySlot(pluginSlot, -1) as PluginProperty;
      this.resetState(pluginSlot);
      this.saveDynamicPlugsChange(dynamicProperty, dragPlugin,
        dynamicProperty?.getSpecificPluginBySlot(dropPluginSlot) as PluginProperty);
      StyleFactory.getInstance().getStyleManager()?.getSortControl()?.sortPluginGroup(dynamicProperty);
      dynamicProperty.updateIndex();
      this.dumpDynamicProperty('changeStatusBarList from dynamic after');
    }
  }

  saveDynamicPlugs(dynamicProperty: GroupProperty): boolean {
    let dynamicPlugs: string[] = PcStatusBarVM.getInstance().getDynamicPlugs();
    if (dynamicPlugs.length === 0) {
      let newDynamicPlugs: string[] = [];
      dynamicProperty.getPluginList().forEach((plug: PluginProperty) => {
        log.showInfo('saveDynamicPlugs plug:' + plug?.getSlot() +
          ' bundleName:' + plug?.pluginInfo?.pluginParseInfo.bundleName +
          ', visible:' + plug?.isVisible());
        if (!plug?.isPluginTypeAccess()) {
          newDynamicPlugs.push(plug?.getSlot());
        } else {
          newDynamicPlugs.push(PluginUtils.getAccessPluginKey(plug) ?? '');
        }
      })
      log.showInfo('saveDynamicPlugs : ' + JSON.stringify(newDynamicPlugs));
      PcStatusBarVM.getInstance().saveDynamicPlugs(newDynamicPlugs);
      return true;
    }
    return false;
  }

  saveDynamicPlugsAdd(dynamicProperty: GroupProperty, addPlugin: PluginProperty,
    dropPlugin: PluginProperty): void {
    this.saveDynamicPlugs(dynamicProperty)
    let dynamicPlugs: string[] = PcStatusBarVM.getInstance().getDynamicPlugs();
    log.showInfo('saveDynamicPlugsAdd: ' + JSON.stringify(dynamicPlugs));
    let newDynamicPlugs: string[] = [...dynamicPlugs];
    let addStr: string = this.getSaveStr(addPlugin);
    let dropStr: string = this.getSaveStr(dropPlugin);
    let dropIndex = newDynamicPlugs.indexOf(dropStr);
    newDynamicPlugs.splice(dropIndex, 0, addStr);
    log.showInfo('saveDynamicPlugsAdd: ' + JSON.stringify(newDynamicPlugs) + ', addStr:' + addStr +
      ', dropStr:' + dropStr);
    PcStatusBarVM.getInstance().saveDynamicPlugs(newDynamicPlugs);
  }

  saveDynamicPlugsDel(dynamicProperty: GroupProperty, delPlugin: PluginProperty): void {
    this.saveDynamicPlugs(dynamicProperty)
    let dynamicPlugs: string[] = PcStatusBarVM.getInstance().getDynamicPlugs();
    log.showInfo('saveDynamicPlugsDel: ' + JSON.stringify(dynamicPlugs));
    let delStr: string = this.getSaveStr(delPlugin);
    let newDynamicPlugs: string[] = dynamicPlugs.filter(item => item !== delStr);
    log.showInfo('saveDynamicPlugsDel: ' + JSON.stringify(newDynamicPlugs) + ', delStr:' + delStr);
    PcStatusBarVM.getInstance().saveDynamicPlugs(newDynamicPlugs);
  }

  saveDynamicPlugsChange(dynamicProperty: GroupProperty, fromPlugin: PluginProperty,
    toPlugin: PluginProperty): void {
    this.saveDynamicPlugs(dynamicProperty)
    let dynamicPlugs: string[] = PcStatusBarVM.getInstance().getDynamicPlugs();
    log.showInfo('saveDynamicPlugsChange: ' + JSON.stringify(dynamicPlugs));
    let newDynamicPlugs: string[] = [...dynamicPlugs];
    let fromStr: string = this.getSaveStr(fromPlugin);
    let fromStrIndex: number = newDynamicPlugs.indexOf(fromStr);
    let toStr: string = this.getSaveStr(toPlugin);
    let toStrIndex: number = newDynamicPlugs.indexOf(toStr);
    log.showInfo('fromStr:' + fromStr + ' fromStrIndex:' + fromStrIndex + ' toStr:' + toStr + ' toStrIndex:' + toStrIndex);
    if (fromStrIndex === toStrIndex) {
      return;
    }
    newDynamicPlugs.splice(fromStrIndex, 1)[0];
    if (fromStrIndex > toStrIndex) {
      newDynamicPlugs.splice(toStrIndex, 0, fromStr);
    } else {
      newDynamicPlugs.splice(toStrIndex - 1, 0, fromStr);
    }
    log.showInfo('saveDynamicPlugsChange: ' + JSON.stringify(newDynamicPlugs) +
      ', fromStr:' + fromStr + ', toStr:' + toStr);
    PcStatusBarVM.getInstance().saveDynamicPlugs(newDynamicPlugs);
  }

  getSaveStr(plugin: PluginProperty | null): string {
    if (plugin == null) {
      return '';
    }
    let saveStr: string = PluginUtils.getAccessPluginKey(plugin) ?? '';
    if (!plugin?.isPluginTypeAccess()) {
      saveStr = plugin?.getSlot();
    }
    return saveStr;
  }

  saveTrayPlugs(trayAreaPlugins: GroupProperty): boolean {
    let trayPlugs: string[] = PcStatusBarVM.getInstance().getTrayPlugs();
    if (trayPlugs.length === 0) {
      let newTrayPlugs: string[] = [];
      trayAreaPlugins.getPluginList().forEach((plug: PluginProperty) => {
        log.showInfo('saveTrayPlugs plug:' + plug?.getSlot() +
          ' bundleName:' + plug?.pluginInfo?.pluginParseInfo.bundleName + ', visible:' + plug?.isVisible());
        if (!plug?.isPluginTypeAccess()) {
          newTrayPlugs.push(plug?.getSlot());
        } else {
          newTrayPlugs.push(PluginUtils.getAccessPluginKey(plug) ?? '');
        }
      })
      PcStatusBarVM.getInstance().saveTrayPlugs(newTrayPlugs);
      return true;
    }
    return false;
  }

  saveTrayPlugsAdd(trayAreaPlugins: GroupProperty, addPlugin: PluginProperty,
    dropPlugin: PluginProperty | null, isDropFront: boolean = true): void {
    this.saveTrayPlugs(trayAreaPlugins)
    let addStr: string = this.getSaveStr(addPlugin);
    let dropStr: string = this.getSaveStr(dropPlugin);
    this.saveTrayPlugsStrAdd(addStr, dropStr, isDropFront);
  }

  saveTrayPlugsStrAdd(addStr: string, dropStr: string, isDropFront: boolean) {
    let trayPlugs: string[] = PcStatusBarVM.getInstance().getTrayPlugs();
    log.showInfo('saveTrayPlugsAdd: ' + JSON.stringify(trayPlugs));
    let newTrayPlugs: string[] = [...trayPlugs];
    let dropIndex = newTrayPlugs.indexOf(dropStr);
    if (isDropFront) {
      newTrayPlugs.splice(dropIndex, 0, addStr);
    } else {
      newTrayPlugs.splice(dropIndex + 1, 0, addStr);
    }
    log.showInfo('saveTrayPlugsAdd: ' + JSON.stringify(newTrayPlugs) + ', addStr:' + addStr +
      ', dropStr:' + dropStr + ', isDropFront:' + isDropFront);
    PcStatusBarVM.getInstance().saveTrayPlugs(newTrayPlugs);
  }

  saveTrayPlugsDel(trayAreaPlugins: GroupProperty, delPlugin: PluginProperty): void {
    this.saveTrayPlugs(trayAreaPlugins)
    let trayPlugs: string[] = PcStatusBarVM.getInstance().getTrayPlugs();
    log.showInfo('saveTrayPlugsDel: ' + JSON.stringify(trayPlugs));
    let delStr: string = this.getSaveStr(delPlugin);
    let newTrayPlugs: string[] = trayPlugs.filter(item => item !== delStr);
    log.showInfo('saveTrayPlugsDel: ' + JSON.stringify(newTrayPlugs) + ', delStr:' + delStr);
    PcStatusBarVM.getInstance().saveTrayPlugs(newTrayPlugs);
  }

  saveTrayPlugsChange(trayAreaPlugins: GroupProperty, fromPlugin: PluginProperty,
    toPlugin: PluginProperty, isFront: boolean = true): void {
    this.saveTrayPlugs(trayAreaPlugins)
    let trayPlugs: string[] = PcStatusBarVM.getInstance().getTrayPlugs();
    log.showInfo('saveTrayPlugsChange: ' + JSON.stringify(trayPlugs));
    let newTrayPlugs: string[] = [...trayPlugs];
    let fromStr: string = this.getSaveStr(fromPlugin);
    let fromStrIndex: number = newTrayPlugs.indexOf(fromStr);
    let toStr: string = this.getSaveStr(toPlugin);
    newTrayPlugs.splice(fromStrIndex, 1)[0];
    let toStrIndex: number = newTrayPlugs.indexOf(toStr);
    if (isFront) {
      newTrayPlugs.splice(toStrIndex, 0, fromStr);
    } else {
      newTrayPlugs.splice(toStrIndex + 1, 0, fromStr);
    }
    log.showInfo('saveTrayPlugsChange: ' + JSON.stringify(newTrayPlugs) + ', fromStr:' + fromStr +
      ', toStr:' + toStr + ', fromStrIndex:' + fromStrIndex + ', toStrIndex:' + toStrIndex);
    PcStatusBarVM.getInstance().saveTrayPlugs(newTrayPlugs);
  }

  checkDynamicExceedMaxWidth(): void {
    while (this.DynamicExceedMaxWidth()) {
      let dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
        PluginGroupType.DYNAMIC_LEFT);
      this.addToTray(dynamicProperty);
      this.onDynamicListNumChangeInDragCallBack(0, true, false);
    }
  }

  private handleStatusBarDragEnd(hasAnim: boolean, dynamicChanged: boolean = false): void {
    if (this.dragItem) {
      this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(this.dragItem?.getSlot() ?? ''));
    }

    log.showInfo(`handleStatusBarDragEnd hasAnim: ${hasAnim}`);
    this.onDynamicListNumChangeInDragCallBack(0, hasAnim, dynamicChanged);
    this.onTrayListNumChangeInDrag?.(0);
    this.clearCancelSqueezedInStatusBarTimer();
    this.cancelSqueezedInStatusBar(this.dropItem?.getSlot() ?? '', false);
    this.cancelSqueezedInStatusBar(PluginSlot.SLOT_CAPSULE_KEY_MOUSE, false);
    this.clearRestoreDynamicTimer();

    this.resetLastItemList(false);
    this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(Constants.PC_TRAY_DROP_FRAME_KEY));

    setTimeout(() => {
      this.dragItem = undefined;
      this.dragItemIsTray = false;
      this.dragPlugin = undefined;
      this.dropItem = undefined;
      this.isDragStartDropFrameShow = false;
      this.dragItemStatusBarType = -1;
      this.dropFrameStatusBarType = -1;
      this.dragSnapshotRelativeRect = undefined;
      this.dropFrameRect = undefined;
      this.dropFrameRectBundleName = '';
      this.snapshotId = '';
      this.snapshotKey = '';
      this.dragParams = {};
      this.isDropAnimating = false;
      AppStorage.set<boolean>('isDropAnimationGoing', false)
      this.isStatusBarDragging = false;
      AppStorage.setOrCreate('pc_status_bar_dragging', false);
    }, 50); // 直接重置状态会导致pluginComponentOnComplete参数校验失败，因此做个延时，用户两次拖拽之间的间隔肯定会超过50ms
  }

  onDragEnd(): void {
    this.isTrayAreaInit = false;
    PcStatusBarDragMgr.isDragCompleted = true;
    if (!this.isStatusBarDragging) {
      log.showWarn('onDragEnd, isStatusBarDragging:' + this.isStatusBarDragging);
      return;
    }
    let trayAreaPlugins = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    if (trayAreaPlugins.getVisualPluginNum() === 0) {
      this.onShowArrowButton?.(false);
    }
    log.showInfo(`onDragEnd isDropAnimating: ${this.isDropAnimating}`);
    if (!this.isDropAnimating) {
      this.handleStatusBarDragEnd(false);
    }
    this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(Constants.PC_TRAY_DROP_FRAME_KEY));
  }

  protected initDiff(): void {
    PcStatusBarVM.getInstance().init();
    this.getContext()?.eventHub.on(DragConstants.DRAG_PREPARE_STATUS_CHANGE_EVENT,
      (isPreparing: boolean): void => {
        if (isPreparing) {
        }
      });
    this.getContext()?.eventHub.on(CommonConstants.EVENTHUB_ICON_OR_CARD_DROP, () => {
      this.onDragEnd();
    });
  }

  protected deInitDiff(): void {
    this.getContext()?.eventHub.off(DragConstants.DRAG_PREPARE_STATUS_CHANGE_EVENT);
    this.getContext()?.eventHub.off(CommonConstants.EVENTHUB_ICON_OR_CARD_DROP);
  }

  registerDragEvent(eventCallback: DragEventCallback, pluginSlot: string): void {
    if (eventCallback?.onItemDragStartEvent) {
      this.getContext()?.eventHub.on(this.getDragStartInStatusBarEvent(pluginSlot),
        eventCallback.onItemDragStartEvent);
    }
    if (eventCallback?.onCancelSqueezedEvent) {
      this.getContext()?.eventHub.on(this.getItemSqueezedCancelEvent(pluginSlot),
        eventCallback.onCancelSqueezedEvent);
    }
    if (eventCallback?.onStartSqueezedEvent) {
      this.getContext()?.eventHub.on(this.getItemSqueezedStartEvent(pluginSlot),
        eventCallback.onStartSqueezedEvent);
    }
    if (eventCallback?.onItemDropEndEvent) {
      this.getContext()?.eventHub.on(this.getDropAnimationEndEvent(pluginSlot),
        eventCallback.onItemDropEndEvent);
    }
  }

  unRegisterDragEvent(eventCallback: DragEventCallback, bundleName: string): void {
    if (eventCallback?.onItemDragStartEvent) {
      this.getContext()?.eventHub.off(this.getDragStartInStatusBarEvent(bundleName),
        eventCallback.onItemDragStartEvent);
    }
    if (eventCallback?.onCancelSqueezedEvent) {
      this.getContext()?.eventHub.off(this.getItemSqueezedCancelEvent(bundleName),
        eventCallback.onCancelSqueezedEvent);
    }
    if (eventCallback?.onStartSqueezedEvent) {
      this.getContext()?.eventHub.off(this.getItemSqueezedStartEvent(bundleName),
        eventCallback.onStartSqueezedEvent);
    }
    if (eventCallback?.onItemDropEndEvent) {
      this.getContext()?.eventHub.off(this.getDropAnimationEndEvent(bundleName),
        eventCallback.onItemDropEndEvent);
    }
  }

  private getDragStartInStatusBarEvent(pluginSlot: string): string {
    return `${DragConstants.DRAG_START_EVENT}${pluginSlot}_FromPcCapsule`;
  }

  private getItemSqueezedCancelEvent(pluginSlot: string): string {
    return `${DragConstants.ITEM_SQUEEZED_CANCEL_EVENT}${pluginSlot}_FromPcCapsule`;
  }

  private getItemSqueezedStartEvent(pluginSlot: string): string {
    return `${DragConstants.ITEM_SQUEEZED_START_EVENT}${pluginSlot}_FromPcCapsule`;
  }

  private getDropAnimationEndEvent(pluginSlot: string): string {
    return `${DragConstants.DROP_ANIMATION_END_EVENT}${pluginSlot}_FromPcCapsule`;
  }

  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  getSnapshot(): image.PixelMap | undefined {
    log.showInfo('getSnapshot: ' + this.snapshotKey);
    const snapshot: image.PixelMap | undefined = dragSnapshotHelper.getSnapshot(SnapshotType.DRAG,
      this.snapshotKey);
    return snapshot;
  }

  dumpTrayArea(extra: string): number {
    let visibleNum: number = 0;
    let trayAreaPlugins = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    trayAreaPlugins.getPluginList().forEach((plug: PluginProperty) => {
      log.showInfo(extra + ' plug:' + plug?.getSlot() + ',visible:' + plug?.isVisible());
      if (plug?.isVisible()) {
        visibleNum++;
      }
    })
    return visibleNum;
  }

  checkCanDrop(extraParams?: string): boolean {
    if (CheckEmptyUtils.isEmpty(extraParams)) {
      return false;
    }
    try {
      const jsonString: object = JSON.parse(extraParams as string);
      const pluginSlot: string = jsonString['extraInfo'] as string;
      if (this.isTrayAreaPluginProperty(pluginSlot) || this.isDynamicPluginProperty(pluginSlot)) {
        return true;
      }
    } catch (e) {
      log.error(`checkCanDrop failed: ${e}`);
    }
    return false;
  }

  onDropInTrayFrame(extraParams?: string): void {
    log.showInfo(`onDropInTrayFrame ${extraParams}`);
    if (CheckEmptyUtils.isEmpty(extraParams)) {
      return;
    }
    const jsonString: object = JSON.parse(extraParams as string);
    const pluginSlot: string = jsonString['extraInfo'] as string;

    let trayAreaPlugins = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    PcStatusBarDragMgr.isDragCompleted = true
    if (this.isTrayAreaPluginProperty(pluginSlot)) {
      this.dumpTrayArea('onDropInTrayFrameFromTray before trayArea');
      this.resetState(pluginSlot);
      let fromPlug = trayAreaPlugins.getSpecificPluginBySlot(pluginSlot) as PluginProperty;
      this.dumpTrayArea('onDropInTrayFrameFromTray after trayArea');
      this.mLastTranslateItemList?.forEach((item: TranslateItem) => {
        this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(item.slot));
        this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(Constants.PC_TRAY_DROP_FRAME_KEY));
      });
      let currentIndex = this.trayAreaPlugins.getPluginIndex(pluginSlot);
      log.showInfo('onDropInTrayFrame, drop pluginSlot:' + pluginSlot + ' currentIndex:' +
        currentIndex + ' fromPlug:' + fromPlug.getSlot());
      if (currentIndex === 0) {
        this.saveTrayPlugsChange(trayAreaPlugins, fromPlug, this.trayAreaPlugins[currentIndex + 1]);
      } else {
        this.saveTrayPlugsChange(trayAreaPlugins, fromPlug, this.trayAreaPlugins[currentIndex - 1], false);
      }
      StyleFactory.getInstance().getStyleManager()?.getSortControl()?.sortPluginGroup(trayAreaPlugins);
      trayAreaPlugins.updateIndex();
      this.mLastTranslateItemList = [];
      this.movingItemMap.clear();
    } else if (this.isDynamicPluginProperty(pluginSlot)) {
      this.onDropInTrayFrameFromDynamic(pluginSlot);
    } else {
      log.showError('onDropInTrayFrame invalid extraParams');
    }
  }

  onDropInTrayFrameFromDynamic(pluginSlot: string): void {
    let trayAreaPlugins = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    let plug: PluginProperty = PluginListAdapter.getInstance().getPluginPropertyBySlot(pluginSlot) as PluginProperty;

    this.resetState(pluginSlot);
    this.mLastTranslateItemList?.forEach((item: TranslateItem) => {
      log.showInfo(`onDropInTrayFrameFromDynamic item: ${item.slot}`);
      this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(item.slot));
      this.getContext()?.eventHub.emit(this.getDropAnimationEndEvent(Constants.PC_TRAY_DROP_FRAME_KEY));
    });
    this.dumpTrayArea('onDropInTrayFrameFromDynamic after trayArea');
    let index = this.trayAreaPlugins.getPluginIndex(pluginSlot);
    let dropPlug: PluginProperty;

    let isDropFront = true;
    if (index === 0) {
      dropPlug = this.trayAreaPlugins[index + 1];
    } else {
      dropPlug = this.trayAreaPlugins[index - 1];
      isDropFront = false;
    }

    this.saveTrayPlugsAdd(trayAreaPlugins, plug, dropPlug, isDropFront);
    this.onTrayListNumChangeInDrag?.(0);
    this.mLastTranslateItemList = [];
    this.movingItemMap.clear();
    let dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.DYNAMIC_LEFT);
    this.saveDynamicPlugsDel(dynamicProperty, plug);
    PluginGroupingManager.getInstance().updatePluginTo(plug, PluginPositionType.BOTTOM_RIGHT, PluginGroupType.TRAY);
  }

  isTrayAreaVisableEmpty(): boolean {
    let trayAreaPlugins = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    const visibleNum = trayAreaPlugins.getVisualPluginNum();
    log.showInfo(`isTrayAreaVisableEmpty visible plug num: ${visibleNum}`);
    return visibleNum === 0;
  }

  onDragEnterArrow(event: DragEvent, extraParams?: string): void {
    if (CheckEmptyUtils.isEmpty(extraParams) || !this.isStatusBarDragging) {
      return;
    }
    const jsonString: object = JSON.parse(extraParams as string);
    const pluginSlot: string = jsonString['extraInfo'] as string;
    log.showInfo(`onDragEnterArrow  ${pluginSlot}`);

    const dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.DYNAMIC_LEFT);
    const privacyPlugin: PluginProperty | null =
      dynamicProperty.getSpecificPluginBySlot(PluginSlot.SLOT_CAPSULE_KEY_MOUSE);
    log.showInfo(`onDragEnterArrow ${event.getWindowX()}` + ' arrowRect : ' + JSON.stringify(this.arrowRect));
    let isEnterHotArea: boolean = ((event.getWindowX() < (ResUtils.getNumberFromLength(this.arrowRect.x) +
    ResUtils.getNumberFromLength(this.arrowRect.width))) &&
      (event.getWindowX() >= (ResUtils.getNumberFromLength(this.arrowRect.x) +
        ResUtils.getNumberFromLength(this.arrowRect.width) * ARROW_PERCENT_THRESHOLD)));
    if (this.isTrayAreaPluginProperty(pluginSlot) && dynamicProperty.getPluginList()?.length !== 0 && isEnterHotArea) {
      let dynamicLeftIndex = this.calDynamicLeftIndex(dynamicProperty);
      const rightMap = StyleFactory.getInstance()
        .getStyleManager()?.getPluginSlotMapping()?.getSlotInWhereMap()?.get(PluginPositionType.BOTTOM_RIGHT);
      let index: number = 0;
      let slot: string = dynamicProperty.getPluginList()[dynamicLeftIndex].getSlot();
      // 找到可拖拽区第一个显示的图标
      while (index < dynamicProperty.getVisualPluginList().length) {
        if (!rightMap?.has(dynamicProperty.getVisualPluginList()[index].getSlot())) {
          slot = dynamicProperty.getVisualPluginList()[index].getSlot();
          break;
        }
        index++;
      }
      log.showInfo(`onDragEnterArrow startSqueezedInStatusBar, this slot: ${slot}`);
      this.clearCancelSqueezedInStatusBarTimer();
      this.showDropFrameIcon = false;
      this.startSqueezedInStatusBar(slot);
      this.onDynamicListNumChangeInDragCallBack(1, true);
    }
  }

  getDefaultDynamicNum(): number {
    const rightMap = StyleFactory.getInstance()
      .getStyleManager()?.getPluginSlotMapping()?.getSlotInWhereMap()?.get(PluginPositionType.BOTTOM_RIGHT);
    let defaultDynamicNum: number = 0;
    rightMap?.forEach((value, key) => {
      if (value === PluginGroupType.DYNAMIC_LEFT) {
        defaultDynamicNum++;
      }
    });
    return defaultDynamicNum;
  }

  OnDropInArrow(event: DragEvent, extraParams?: string | undefined): void {
    if (!this.isStatusBarDragging || CheckEmptyUtils.isEmpty(extraParams)) {
      return;
    }
    log.showInfo('OnDropInArrow ' + extraParams);
    let trayAreaPlugins = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY);
    this.dumpTrayArea('OnDropInArrow before trayArea');
    const jsonString: object = JSON.parse(extraParams as string);
    const pluginSlot: string = jsonString['extraInfo'] as string;
    if (this.isTrayAreaPluginProperty(pluginSlot)) {
      return;
    }

    let dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.DYNAMIC_LEFT);
    let dragPlugin: PluginProperty = dynamicProperty?.getSpecificPluginBySlot(pluginSlot, -1) as PluginProperty;
    log.showInfo('dragPlugin:' + dragPlugin?.getSlot() + ', visible:' + dragPlugin?.isVisible());
    PcStatusBarDragMgr.isDragCompleted = true;
    this.resetState(pluginSlot);

    let dropPlug = trayAreaPlugins.getPluginList()[trayAreaPlugins.getVisualPluginNum()];
    let isDropFront: boolean = true;
    if (trayAreaPlugins.getVisualPluginNum() > 0) {
      dropPlug = trayAreaPlugins.getVisualPluginList()[trayAreaPlugins.getVisualPluginNum() - 1];
      isDropFront = false;
    }
    windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL, true);
    this.dumpTrayArea('OnDropInArrow after trayArea');
    this.saveTrayPlugsAdd(trayAreaPlugins, dragPlugin, dropPlug, isDropFront);
    PluginGroupingManager.getInstance()
      .updatePluginTo(dragPlugin, PluginPositionType.BOTTOM_RIGHT, PluginGroupType.TRAY);
    this.saveDynamicPlugsDel(dynamicProperty, dragPlugin);
  }

  onDragEnterLocalGroup(event: DragEvent, extraParams?: string): void {
    if (CheckEmptyUtils.isEmpty(extraParams)) {
      log.showInfo('onDragEnterLocalGroup extraParams invalid');
      return;
    }
    const jsonString: object = JSON.parse(extraParams as string);
    const pluginSlot: string = jsonString['extraInfo'] as string;
    const dynamicProperty = PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.DYNAMIC_LEFT);
    const privacyPlugin: PluginProperty | null =
      dynamicProperty?.getSpecificPluginBySlot(PluginSlot.SLOT_CAPSULE_KEY_MOUSE);
    const locationPlugin: PluginProperty | null =
      dynamicProperty?.getSpecificPluginBySlot(PluginSlot.SLOT_STATUS_LOCATION);
    if (locationPlugin === null) {
      log.showError('status_bar_location not exist');
      return;
    }
    const privacySoftPlugin: PluginProperty | null =
      dynamicProperty?.getSpecificPluginBySlot(PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT);
    if (privacySoftPlugin === null) {
      log.showError('SLOT_STATUS_SUPER_PRIVACY_PC_SOFT not exist');
      return;
    }
    log.showInfo(`windowX: ${event.getWindowX()}` + ' inputItemRect : ' + JSON.stringify(this.inputItemRect));
    let isEnterHotArea: boolean = (event.getWindowX() > ResUtils.getNumberFromLength(this.inputItemRect.x) &&
      event.getWindowX() <= (ResUtils.getNumberFromLength(this.inputItemRect.x) +
        ResUtils.getNumberFromLength(this.inputItemRect.width) * INPUT_PERCENT_THRESHOLD));
    if (this.isTrayAreaPluginProperty(pluginSlot) && !privacyPlugin?.isVisible() && !locationPlugin?.isVisible() &&
      !privacySoftPlugin?.isVisible() && isEnterHotArea) {
      this.clearCancelSqueezedInStatusBarTimer();
      this.showDropFrameIcon = false;
      this.startSqueezedInStatusBar(PluginSlot.SLOT_CAPSULE_KEY_MOUSE);
      this.onDynamicListNumChangeInDragCallBack(1, true);
    }
  }

  getIndexInDynamicSettingsData(property: PluginProperty): number {
    let dynamicPlugs: string[] = PcStatusBarVM.getInstance().getDynamicPlugs();
    if (dynamicPlugs.length === 0) {
      return INVALID_INDEX;
    }
    let index = INVALID_INDEX;
    if (!property.isPluginTypeAccess()) {
      index = dynamicPlugs.findIndex(item => item === property.getSlot());
    } else {
      let key = PluginUtils.getAccessPluginKey(property);
      index = dynamicPlugs.findIndex(item => item === key);
    }
    return index;
  }

  getIndexInTraySettingsData(property: PluginProperty): number {
    let trayPlugs: string[] = PcStatusBarVM.getInstance().getTrayPlugs();
    if (trayPlugs.length === 0) {
      return INVALID_INDEX;
    }
    let index = INVALID_INDEX;
    if (!property.isPluginTypeAccess()) {
      index = trayPlugs.findIndex(item => item === property.getSlot());
    } else {
      let key = PluginUtils.getAccessPluginKey(property);
      index = trayPlugs.findIndex(item => item === key);
    }
    return index;
  }

  isDefaultDynamicPlug(slot: string): boolean {
    const rightMap = StyleFactory.getInstance()
      .getStyleManager()?.getPluginSlotMapping()?.getSlotInWhereMap()?.get(PluginPositionType.BOTTOM_RIGHT);
    return rightMap?.has(slot) ?? false;
  }

  protected addPlugin(pluginInfos: PluginProperty[]): void {
    pluginInfos.filter(plugin => plugin.isPluginTypeAccess()).forEach(plugin => {
      let trayPlugs = PcStatusBarVM.getInstance().getTrayPlugs();
      let pluginSlot = PluginUtils.getAccessPluginKey(plugin);
      if (plugin.getPluginInGroup() === PluginGroupType.TRAY && trayPlugs.length > 0 &&
        trayPlugs.indexOf(pluginSlot) === -1) {
        let dropStr = trayPlugs[0];
        this.saveTrayPlugsStrAdd(pluginSlot, dropStr, true);
      }
    });
  }

  protected removePlugin(pluginInfos: PluginProperty[]): void {
    pluginInfos.filter(item => item.isPluginTypeAccess()).forEach(item => this
      .notifyAccessPlugChange(item.getSlot(), false));
  }

  protected updatePlugin(pluginInfos: PluginProperty[]): void {
  }

  getPriority(): ListenerPriority {
    return ListenerPriority.PLUGIN_DRAG;
  }
}

export interface TranslateItem {
  slot: string;
  row: number;
  column: number;
  isRepeatItem: boolean;
  position: number[][];
  newColumn: number;
  newRow: number;
}