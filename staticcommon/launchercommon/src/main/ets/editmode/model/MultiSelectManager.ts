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

import {
  LogDomain, LogHelper,
  Trace,
  AnimateToScheduleUtils,
  ArrayUtils,
} from '@ohos/basicutils';
import { ResUtils, launcherStatusUtil } from '@ohos/windowscene';
import { DeviceHelper, GlobalContext, AccessibilityManager, ResourceManager,
  localEventManager } from '@ohos/frameworkwrapper';
import { DragAccessibilityUtils, desktopUtil, RTLUtil } from '@ohos/componenthelper';
import { DragConstants } from '@ohos/commonconstants';
import {
    AnimationType,
    cancelAnimationType,
    type CheckboxInfoType,
    CheckboxParentEnum,
    doDropAnimateType,
    DoDropToFolderAnimateType,
    doGatherAnimateType,
    FolderInfo,
    GatherAnimateItem,
    GatherAnimateTarget,
    GridItemRect,
    MultiSelectDrag,
    type MultiSelectItemType,
    MultiSelectMode,
    MultiSelectStatus,
    MultiSelectStatusEnum,
    preLoadAnimationViewType,
    updateAnimationTargetType,
    hideAnimationItemType,
} from '../data/MultiSelectData';
import { ListenerItemType, multiSelectListenManager as multiSelectListenManger } from './MultiSelectListenerManager';
import { componentSnapshot, Frame, Position, Prompt, Size } from '@kit.ArkUI';
import {
  AppItemInfo,
  CommonConstants,
  DeliverUtil,
  DesktopManager,
  EditModeUtils,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  folderLayoutUtil,
  FolderLifeCyclePriority,
  FolderManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  HiEditModeEventUtils,
  LaunchLayoutCacheManager,
  layoutLockUtil,
  NotHarmonyUtil,
  StyleConstants,
  vibratorMgr,
  editModeManager,
  EditModeConstants,
  lockLayoutManager,
  EventConstants,
  FolderCommonConstants,
  FolderConstants,
} from '../../TsIndex';
import { image } from '@kit.ImageKit';
import { MultiSelectDebug } from '../debug/MultiSelectDebug';
import fs from '@ohos.file.fs';
import { TouchEvent } from 'touchEvent';
import { TouchEvent as multiInputTouchEvent } from '@ohos.multimodalInput.touchEvent';
import { MultiSelectStyleConfig } from '../data/MultiSelectStyleConfig';
import { FolderStatus } from '../../utils/FolderLayoutUtil';
import MultiSelectCheckboxManager from './MultiSelectCheckboxManager';
import { TouchMoveMonitor } from '../utils/TouchMoveMonitor';
import { PageInfoManager } from '../../cache/layout/PageInfoManager';
import { DesktopItemVibratorManager } from '../../manager/DesktopItemVibratorManager';

const TAG: string = 'MultiSelectManage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FOLDER_PAGE_IN_SCREEN = 2;

export class MultiSelectManager {
  private static instance: MultiSelectManager;
  public checkboxInfoMap: Map<string, CheckboxInfoType> = new Map();
  public multiSelectMap: Map<string, MultiSelectItemType> = new Map();
  /** 多选状态 */
  private status: MultiSelectStatus = new MultiSelectStatus();
  /** 多选模式 */
  private mode: MultiSelectMode = MultiSelectMode.INIT;
  /** 拖拽组件封装 */
  private multiSelectDrag: MultiSelectDrag | null = null;
  /** 截图调试 */
  public snapshotEnabled: boolean = false;
  /** 调试用 */
  private debug: MultiSelectDebug = new MultiSelectDebug();
  // 无障碍模式
  private isAccessibilityMode: boolean = false;
  /** 是否开放多选 */
  public debug_enabledMultiSelect: boolean = true;
  /** 是否保存icon截图便于调试 */
  public debug_saveSnapshot: boolean = false;
  /** 是否启用文件夹内多选 */
  public debug_enabledAppInFolder: boolean = true;
  // 多选框管理
  private checkboxManager: MultiSelectCheckboxManager = MultiSelectCheckboxManager.getInstance();
  private touchPointOffsetToCenter: Position = {x: 0, y: 0};
  // 记录当前被单选拖起的应用的parentId（仅单选）
  private singleDragParentId: string = '';
  // 当前起拖的应用数量
  public currentSelectedSize: number = 0;
  /** 动效中 */
  public inAnimation?: boolean;

  /** 预加载动效组件 */
  public preLoadAnimationView?: preLoadAnimationViewType;

  /** 执行汇聚动效 由multiSelectAnimateManager赋值 */
  public doGatherAnimate?: doGatherAnimateType;

  /** 执行汇聚动效 由multiSelectAnimateManager赋值 */
  public doDropAnimate?: doDropAnimateType;

  /** 执行落位至文件夹动效 由multiSelectAnimateManager赋值 */
  public doDropToFolderAnimate?: DoDropToFolderAnimateType;

  /** 执行汇聚动效 由multiSelectAnimateManager赋值 */
  public cancelAnimation?: cancelAnimationType;

  /** 执行汇聚动效 由multiSelectAnimateManager赋值 */
  public updateAnimationTarget?: updateAnimationTargetType;

  /** 清理汇聚元素 由multiSelectAnimateManager赋值 */
  public releaseAnimateItem?: () => void;

  /** 隐藏汇聚元素 由multiSelectAnimateManager赋值 */
  public hideAnimationItem?: hideAnimationItemType;

  /** 在多选进文件夹落位动效中将首页最后一个显示的图标zIndex置底 由multiSelectAnimateManager赋值 */
  public resetDropAnimationItemZIndex?: (key: string) => void;

  /** 在多选进文件夹落位动效中将显示的图标opacity设成1 由multiSelectAnimateManager赋值 */
  public resetDropAnimationItemOpacity?: (key: string, opacity: number) => void;

  /** 获取编辑模式下gridSwiper的margin 由multiSelectAnimateManager赋值 */
  public getGridSwiperMargin?: () => number;

  /** 最近一次汇聚动效的终点 */
  public lastActionTouchPosition: Position = {x: -1, y: -1};

  constructor() {
    this.status = new MultiSelectStatus();
    this.isAccessibilityMode = AppStorage.get<boolean>('isAccessibilityMode') || false;
  }

  public static getInstance(): MultiSelectManager {
    if (!(MultiSelectManager.instance instanceof MultiSelectManager)) {
      log.showInfo('create multiSelectManager instance');
      MultiSelectManager.instance = new MultiSelectManager();
    }
    return MultiSelectManager.instance;
  }

  public load():void {
    if (lockLayoutManager.isLockLayout()) {
      log.showWarn(`layout is locked`);
      return;
    }
    log.info('load');
    this.status.setStatus(MultiSelectStatusEnum.Entered);
    multiSelectListenManger.executeEnter();
    this.registerFolderCallback();
  }

  public unload():void {
    log.info('unload');
    this.clearAllSelect();
    this.checkboxInfoMap.clear();
    this.mode = MultiSelectMode.INIT;
    this.status.setStatus(MultiSelectStatusEnum.Exited);
    this.unregisterFolderCallback();
    multiSelectListenManger.executeExit();
  }

  public getStatus(): MultiSelectStatus {
    return this.status;
  }

  /**
   * 当前是否多选
   */
  public get isInMultiSelect(): boolean {
    return this.mode === MultiSelectMode.MULTI;
  }

  /**
   * 当前是否单选
   */
  public get isInSingleDrag(): boolean {
    return this.mode === MultiSelectMode.SINGLE;
  }

  /**
   * 当前是否扩展新形态小折叠产品外屏编辑模式下的多选
   */
  public get isInOuterMultiSelect(): boolean {
    return (launcherStatusUtil.getShowOutLauncherStatus() && this.mode === MultiSelectMode.MULTI);
  }

  /**
   * 屏幕朗读主动播报
   * @param isSelected
   */
  public sendAccessibility(isSelected: boolean): void {
    if (this.isAccessibilityMode) {
      const accessibilityManager = AccessibilityManager.getInstance();
      if (isSelected) {
        accessibilityManager.sendTextAnnouncedForAccessibility(ResUtils.getInnerString($r('app.string.selected')),
          'announceForAppIconSelected');
      } else {
        accessibilityManager.sendTextAnnouncedForAccessibility(ResUtils.getInnerString($r('app.string.unselected')),
          'announceForAppIconUnselected');
      }
    }
  }

  /**
   * 触发checkbox事件
   * @param parentId
   */
  public async onIconClick(parentId: string): Promise<boolean> {
    log.showInfo(`selectChange parentId:${parentId}`);
    if (!this.status.isSelectAble()) {
      log.showError(`status is not selectAble ${parentId}`);
      return false;
    }
    let checkboxInfo: CheckboxInfoType | undefined = this.checkboxInfoMap.get(parentId);
    if (!checkboxInfo) {
      log.showError(`without this parentId: %{public}s ${parentId}`);
      return false;
    }
    if (!this.canSelectWhenLayoutLocked(checkboxInfo)) {
      log.showError('cannot select when layout locked');
      return false;
    }
    if (checkboxInfo.parentType === CheckboxParentEnum.Folder || this.isDeliverApp(checkboxInfo)) {
      log.showError(`click folder of click app in deliverFolder ${parentId}`);
      return false;
    }
    if (this.multiSelectMap.size >= EditModeConstants.MULTI_SELECT_LIMIT && !checkboxInfo.checkState.isSelected()) {
      log.showWarn(`icons chosen are out of limit`);
      Prompt.showToast({
        message: ResourceManager.getInstance().getStringByName('icon_out_of_limit')
      });
      return false;
    }
    Trace.start(Trace.CORE_METHOD_MULTISELECT_SELECT);
    checkboxInfo.checkState.change();
    multiSelectListenManger.executeUpdateState([
      multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, parentId, launcherStatusUtil.getShowOutLauncherStatus())
    ]);
    let res: boolean = false;
    if (checkboxInfo.checkState.isSelected()) {
      res = await this.onCheckboxSelect(checkboxInfo);
    } else {
      res = await this.onCheckboxUnSelect(checkboxInfo);
    }
    if (!res) {
      checkboxInfo.checkState.change();
      multiSelectListenManger.executeUpdateState([
        multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, parentId, launcherStatusUtil.getShowOutLauncherStatus())
      ]);
    }
    this.sendAccessibility(checkboxInfo.checkState.isSelected());
    Trace.end(Trace.CORE_METHOD_MULTISELECT_SELECT);
    return true;
  }

  /** 清空选择 */
  public clearAllSelect(): void {
    log.showInfo('clear all select');
    this.multiSelectMap.forEach((item: MultiSelectItemType) => {
      item.image?.release();
    });
    this.multiSelectMap.clear();
    multiSelectListenManger.executeUpdatingMultiSelectMap();
    this.checkboxInfoMap.forEach(item => item.checkState.setSelectedStatus(false));
  }

  /**
   * 获取所有选中的应用
   * @returns
   */
  public getAllSelectedItem(): MultiSelectItemType[] {
    return Array.from(this.multiSelectMap.values());
  };

  /**
   * 获取所有选中的应用
   * @returns
   */
  public getAllSelectedGridItem(first: AppItemInfo): GridLayoutItemInfo[] {
    // 显示顺序: ⻓按拖拽的图标 > 第1个点选图标 > 第2个点选图标> 第3个点选图标 >第N个点选图标
    let res: GridLayoutItemInfo[] = [first as GridLayoutItemInfo];
    let firstKey: string = GridLayoutUtil.generateUniqueKey(res[0]);
    for (let item of this.multiSelectMap.values()) {
      let appItem: GridLayoutItemInfo = item.parentItemInfo as GridLayoutItemInfo;
      let uniKey: string = GridLayoutUtil.generateUniqueKey(appItem);
      if (firstKey === uniKey) {
        continue;
      }
      res.push(appItem);
    }
    log.showInfo(`batchUninstall>>>getAllSelectedGridItem ${res.length}`);
    return res;
  }

  /**
   * 获取所有选中的应用keyName
   * @returns
   */
  public getAllSelectedItemKeyNames(): string[] {
    try {
      let temp: string[] = [];
      Array.from(this.multiSelectMap.values()).forEach(selectedItem => {
        temp.push(selectedItem.parentItemInfo.keyName ?? '');
      });
      return temp;
    } catch (err) {
      log.showError(`getAllSelectedItemKeyNames error ${err.getMessage()}`);
    }
    return [];
  };

  /**
   * 获取被选中的文件夹内应用 map的key是文件夹的folderItemInfo, value是该文件夹内被被选中应用的AppItemInfo
   * @returns
   */
  public getSelectedItemSortByFolder(): Map<GridLayoutItemInfo, GridLayoutItemInfo[]> {
    let map: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
    this.multiSelectMap.forEach((item: MultiSelectItemType) => {
      if (typeof item.belongId === 'string') {
        const folderItemInfo: GridLayoutItemInfo =
          this.checkboxInfoMap.get(item.belongId)?.parentItemInfo as Object as GridLayoutItemInfo;
        if (!map.has(folderItemInfo)) {
          map.set(folderItemInfo, []);
        }
        map.get(folderItemInfo)?.push(item.parentItemInfo as Object as GridLayoutItemInfo);
      }
    });
    return map;
  }

  public enabledDefaultDrag(parentId: string): boolean {
    return this.multiSelectMap.has(parentId) ? this.multiSelectMap.size === 1 : this.multiSelectMap.size === 0;
  }

  /**
   * 图标touch.down 触发预加载 计算图标实际位置
   * @param parentId
   */
  public async preGather(parentId: string): Promise<boolean> {
    if (this.illegalsGather(parentId)) {
      return false;
    }
    log.showInfo(`preGather ${parentId}`);
    const folderInfo: FolderInfo = this.getCurrentFolderInfo();
    const gatherIcon: CheckboxInfoType | undefined = this.checkboxInfoMap.get(parentId);
    if (!gatherIcon) {
      return false;
    }
    const gatherItemInfo = this.getCacheItemInfoByCheckboxInfo(gatherIcon) as AppItemInfo;
    let gatherPage: number;
    let gatherPosition: Position;
    if (gatherIcon.parentType === CheckboxParentEnum.AppInFolder) {
      const folderCheckboxInfo = this.checkboxInfoMap.get(gatherIcon.belongFolderCheckboxId ?? '');
      if (!folderCheckboxInfo) {
        return false;
      }
      gatherPage = folderCheckboxInfo.parentItemInfo.page ?? -1;
      const rect: Frame = this.getItemPositionInFolder(
        gatherItemInfo, folderCheckboxInfo.parentItemInfo, gatherPage, folderInfo);
      gatherPosition = { x: rect.x, y: rect.y };
    } else {
      gatherPage = gatherItemInfo.page ?? -1;
      gatherPosition = this.getItemPositionInDesktop(gatherItemInfo, gatherPage);
    }

    const now = Date.now();
    this.multiSelectMap.forEach((selectItem: MultiSelectItemType) => {
      this.updateSelectItemPosition(selectItem, gatherPage, gatherPosition, folderInfo);
    });
    log.showInfo(`updateSelectItemPosition cost ${Date.now() - now}ms`);
    return true;
  }

  /**
   * 隐藏当前选中图标的appName和多选框
   * @returns
   */
  public notifyLongPressAnimation(): Promise<void> {
    let selectItemParentIdList = Array.from(this.multiSelectMap.keys());
    multiSelectListenManger.executeLongPress(selectItemParentIdList.reduce((arr: string[], itemParentId: string) => {
      arr.push(multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, itemParentId, launcherStatusUtil.getShowOutLauncherStatus()),
        multiSelectListenManger.getListenerId(ListenerItemType.APP_ICON, itemParentId, launcherStatusUtil.getShowOutLauncherStatus()));
      return arr;
    }, []));
    return sleep(MultiSelectStyleConfig.HIDE_CHECKBOX_DURING_GATHER_ANIMATE_DURATION);
  }

  /**
   * 开始单图标拖拽
   * @param parentId
   */
  public startSingleDrag(parentId: string): void {
    if (this.mode === MultiSelectMode.INIT) {
      this.singleDragParentId = parentId;
      this.mode = MultiSelectMode.SINGLE;
      // 单选拖拽通知checkbox隐藏
      this.hideCheckboxWithAnimation(parentId);
    }
  }

  private hideCheckboxWithAnimation(parentId: string): void {
    multiSelectListenManger.executeLongPress([
      multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, parentId, launcherStatusUtil.getShowOutLauncherStatus())
    ]);
  }

  /**
   * 单图标拖拽结束
   * @param parentId
   */
  public finishSingleDrag(): void {
    if (this.isInSingleDrag) {
      this.mode = MultiSelectMode.INIT;
      if (this.singleDragParentId === '') {
        return;
      }
      // 单选拖拽通知checkbox显示
      this.showCheckboxWithAnimation(this.singleDragParentId);
      this.syncAppItemInfoFormCacheAfterSingleDrag(this.singleDragParentId);
      this.singleDragParentId = '';
    }
  }

  private showCheckboxWithAnimation(parentId: string | string[]): void {
    let idList: string[] = [];
    if (Array.isArray(parentId)) {
      idList = parentId;
    } else {
      idList = [parentId];
    }
    multiSelectListenManger.executeItemDropped(idList
      .map(item => multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, item, launcherStatusUtil.getShowOutLauncherStatus())));
  }

  /**
   * 更新图标右上角勾选框的选中状态
   */
  public updateCheckboxSelectState(): void {
    const selectCheckboxList: Set<string> = new Set();
    this.multiSelectMap.forEach(selectItem => {
      // 更新文件夹的选中状态 防止汇聚后文件夹依然是选中状态
      if (selectItem.belongId && this.checkboxInfoMap.has(selectItem.belongId)) {
        this.checkboxInfoMap.get(selectItem.belongId)?.checkState.sub();
        selectCheckboxList.add(selectItem.belongId);
      }
      if (selectItem.parentId && this.checkboxInfoMap.has(selectItem.parentId)) {
        this.checkboxInfoMap.get(selectItem.parentId)?.checkState.setSelectedStatus(false);
      }
      selectCheckboxList.add(selectItem.parentId);
    });
    multiSelectListenManger.executeUpdateState(Array.from(selectCheckboxList.values())
      .map(item => multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, item, launcherStatusUtil.getShowOutLauncherStatus())));
  }

  /**
   * 图标长按触发汇聚
   */
  public async startGather(parentId: string, gestureEvent: GestureEvent): Promise<boolean> {
    // 已选MULTI_SELECT_LIMIT个图标，长按未被选中图标时提示“已达上限”
    let checkboxInfo: CheckboxInfoType | undefined = this.checkboxInfoMap.get(parentId);
    if (this.multiSelectMap.size >= EditModeConstants.MULTI_SELECT_LIMIT && !checkboxInfo?.checkState.isSelected()) {
      log.showWarn(`icons chosen are out of limit`);
      Prompt.showToast({
        message: ResourceManager.getInstance().getStringByName('icon_out_of_limit')
      });
      return false;
    }
    if (this.illegalsGather(parentId)) {
      return false;
    }

    this.updateCheckboxSelectState();
    // 没有选中直接长按
    const isTouchUnSelectIcon = !this.multiSelectMap.has(parentId);
    // 屏蔽单选场景
    if (this.multiSelectMap.size === 0 || (this.multiSelectMap.size === 1 && !isTouchUnSelectIcon)) {
      this.clearAllSelect();
      return false;
    }

    if (isTouchUnSelectIcon) {
      await this.handlerGatherByUnSelectItem(parentId);
    }

    Trace.start(Trace.CORE_METHOD_MULTISELECT_GATHER);
    this.mode = MultiSelectMode.MULTI;
    this.status.setStatus(MultiSelectStatusEnum.beforeGather);
    multiSelectListenManger.executeBeforeGather();

    // 定向发送beforeGather
    const selectItemSortByFolder: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = this.getSelectedItemSortByFolder();
    const folderIdList: Set<string> = new Set();
    selectItemSortByFolder.forEach((item, folder) => {
      folderIdList.add(this.getFolderUniqueId(folder));
    });
    multiSelectListenManger.executeBeforeGather(Array.from(folderIdList.values())
      .map(item => multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, item, launcherStatusUtil.getShowOutLauncherStatus())));

    let selectItemList: MultiSelectItemType[] = [];
    await Promise.all([this.notifyLongPressAnimation(), ((): void => {
      const gatherIcon: CheckboxInfoType | undefined = this.checkboxInfoMap.get(parentId);
      log.showInfo(`parentId ${gatherIcon.parentId}`);
      if (!gatherIcon) {
        return;
      }
      const mFingerInfo: FingerInfo = this.getTouchPositionByGestureEvent(gestureEvent);
      const localX = mFingerInfo.localX;
      const localY = mFingerInfo.localY;
      const globalX = mFingerInfo.globalX;
      const globalY = mFingerInfo.globalY;
      const pItemInfo = gatherIcon.parentItemInfo;
      const row = pItemInfo.row;
      const column = pItemInfo.column;
      const page = pItemInfo.page;
      log.showInfo(`startGather position: ${row}_${column}_${page}, touchPosition local: ${localX} ${localY} global: ${globalX} ${globalY}`);
      this.lastActionTouchPosition = { x: globalX, y: globalY };
      const editModeLocalX = EditModeUtils.convertWithDesktopScale(localX);
      const editModeLocalY = EditModeUtils.convertWithDesktopScale(localY);

      selectItemList = this.getSelectItemByGather(gatherIcon);
      this.recordTouchPointOffsetToCenter({ x: editModeLocalX, y: editModeLocalY }, gatherIcon);

      const offset = gatherIcon.iconSize * (StyleConstants.EDIT_MODE_LONG_PRESS_SCALE - 1) / 2;
      log.showInfo('touchPoint offset %{public}d', offset);
      const touchPoint: Position = { x: editModeLocalX + offset, y: editModeLocalY + offset };
      this.createDragAction(selectItemList, touchPoint);
      this.preLoadAnimationViewBySelectItemList(selectItemList);
    })()]);
    // 进入拖拽状态, 触发汇聚动效
    this.vibrator();
    this.status.setStatus(MultiSelectStatusEnum.Gathering);
    multiSelectListenManger.executeGather();
    await this.gatherAnimation(selectItemList);
    Trace.end(Trace.CORE_METHOD_MULTISELECT_GATHER);

    this.status.isEntered ? this.startDrag() : this.finishDrag();
    return true;
  }

  /**
   * 兼容长按未选中的图标触发多选
   */
  private async handlerGatherByUnSelectItem(parentId: string): Promise<void> {
      const checkboxInfo: CheckboxInfoType | undefined = this.checkboxInfoMap.get(parentId);
      if (!checkboxInfo) {
        return;
      }
      const multiSelectItem: MultiSelectItemType | undefined = await this.createMultiSelectItem(checkboxInfo);
      if (multiSelectItem) {
        multiSelectItem.zIndex = this.multiSelectMap.size + 1;
        const folderInfo: FolderInfo = this.getCurrentFolderInfo();
        const gatherIcon: CheckboxInfoType | undefined = this.checkboxInfoMap.get(parentId);
        if (!gatherIcon) {
          return;
        }
        let gatherPage: number;
        let gatherPosition: Position;
        if (gatherIcon.parentType === CheckboxParentEnum.AppInFolder) {
          const folderCheckboxInfo = this.checkboxInfoMap.get(gatherIcon.belongFolderCheckboxId ?? '');
          if (!folderCheckboxInfo) {
            return;
          }
          const folderItemInfo = this.getCacheItemInfoByCheckboxInfo(folderCheckboxInfo) as GridLayoutItemInfo;
          gatherPage = folderItemInfo.page ?? -1;
          const rect: Frame = this.getItemPositionInFolder(
            gatherIcon.parentItemInfo, folderItemInfo as Object as AppItemInfo, gatherPage, folderInfo);
          gatherPosition = { x: rect.x, y: rect.y };
        } else {
          gatherPage = gatherIcon.parentItemInfo.page ?? -1;
          gatherPosition = this.getItemPositionInDesktop(gatherIcon.parentItemInfo, gatherPage);
        }
        this.updateSelectItemPosition(multiSelectItem, gatherPage, gatherPosition, folderInfo);
        this.multiSelectMap.set(checkboxInfo.parentId, multiSelectItem);
      }
  }

  /**
   * 触发drag事件
   * @returns
   */
  public async startDrag(): Promise<void> {
    log.showInfo('startDrag');
    this.status.setStatus(MultiSelectStatusEnum.Dragging);
    HiEditModeEventUtils.reportMultiSelectDrag();
    multiSelectListenManger.executeDragging();
    this.multiSelectDrag?.executeDrag();
  }

  /**
   * 桌面落位后执行落位动效
   * @param dropX
   * @param dropY
   * @param dropPage
   * @returns
   */
  public async startDrop(dropX: number, dropY: number, dropPage:number): Promise<void> {
    // 触发drop事件
    this.status.setStatus(MultiSelectStatusEnum.Dropping);
    let gatherTargetList: GatherAnimateTarget[] = [];
    let pageCenterMap: Map<number, Position> = new Map();
    const layoutCacheManager = LaunchLayoutCacheManager.getInstance();
    this.multiSelectMap.forEach((item: MultiSelectItemType) => {
      item.defaultX = dropX;
      item.defaultY = dropY;
      const cacheItem: GridLayoutItemInfo | undefined = layoutCacheManager.selectGridLayoutItemByItem(
        item.parentItemInfo as GridLayoutItemInfo
      );
      if (!cacheItem) {
        log.showInfo(`cache without this itemInfo ${item.parentId}`);
        return;
      }
      const row = cacheItem.row ?? 0;
      const column = cacheItem.column ?? 0;
      const page = cacheItem.page ?? -1;
      const area = cacheItem.area;
      // 实际落位
      const dropPages: number[] = [dropPage - 1, dropPage, dropPage + 1];
      if (desktopUtil.isFoldExpandStatus()) {
        for (let i = 1; i <= FOLDER_PAGE_IN_SCREEN; i++) {
          dropPages.push(dropPages[dropPages.length - 1] + 1);
        }
      }
      if (dropPages.includes(page)) {
        let rect: GridItemRect = this.getSwiperPageGridByRowCol(row, column, page, area);
        let upDatePosition = this.updatePositionByPage(rect.centerX, rect.centerY, page, dropPage);
        item.targetX = upDatePosition.x;
        item.targetY = upDatePosition.y;
      } else {
        let centerPosition = pageCenterMap.get(page);
        if (!centerPosition) {
          centerPosition = this.getScreenCenterByPage(dropPage, page);
          pageCenterMap.set(page, centerPosition);
        }
        item.targetX = centerPosition.x;
        item.targetY = centerPosition.y;
      }
      const target = this.createGatherAnimateTarget(item);
      target.scale = 1;
      gatherTargetList.push(target);
    });

    const isCancel = await this.doDropAnimate?.(gatherTargetList, (parentId: string) => {
      multiSelectListenManger.executeItemDropped([
        multiSelectListenManger.getListenerId(ListenerItemType.DESKTOP_ITEM, parentId, launcherStatusUtil.getShowOutLauncherStatus()),
        multiSelectListenManger.getListenerId(ListenerItemType.OPENFOLDER_APP, parentId),
        multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, parentId, launcherStatusUtil.getShowOutLauncherStatus())
      ]);
    });

    // 落位动效结束后 触发事件finish
    this.finishDrag();
  }

  /**
   * 多选进文件夹落位时目标坐标计算获取
   * @param length 文件夹当前图标数
   * @param firstPageMaxShowLength 文件夹折叠态第一页最大显示图标数
   * @param folder 文件夹信息
   * @param dropIndex 落位进文件夹的哪一个图标位置
   * @returns 图标落位进文件夹后的目标位置
   */
  public getMultiIconToFolderTargetPos(
    length: number,
    firstPageMaxShowLength: number,
    folder: GridLayoutItemInfo,
    dropIndex: number
  ): number[] {
    let targetPos: number[] = [];
    if (length >= firstPageMaxShowLength && !GridLayoutUtil.isBigFolder(folder)) {
      // 小文件夹第一页满铺，落位去文件夹中心
      let rect: GridItemRect = this.getSwiperPageGridByRowCol(folder.row ?? 0, folder.column ?? 0,
        folder.page ?? -1, folder.area);
      targetPos = [rect.centerX, rect.centerY];
    } else {
      // 小文件夹第一页未铺满或大文件夹
      // 判断图标要去的是哪个位置，未满时依次落位，满后落位最后一个元素
      let folderCenterPos =
        folderLayoutUtil.getCurrentFolderCenterPosition(folder);
      let folderIconPos = folderLayoutUtil.getItemPostion(FolderStatus.CLOSE_FOLDER, folder, dropIndex);
      let pointInEdit = EditModeUtils.convertFolderCenterCoordinateToEditMode(folderIconPos, folder);
      let targetX = folderCenterPos[0] + pointInEdit.x;
      let targetY = folderCenterPos[1] + pointInEdit.y;
      targetPos = [targetX, targetY];
    }
    return targetPos;
  }

  /**
   * 多选进文件夹落位时动效延时时间计算
   * @param length 文件夹当前图标数
   * @param firstPageMaxShowLength 文件夹折叠态第一页最大显示图标数
   * @param folder 文件夹信息
   * @param zIndex 图标排序
   * @returns 图标落位进文件夹后的目标位置
   */
  public getMultiIconToFolderDelay(
    length: number,
    firstPageMaxShowLength: number,
    folder: GridLayoutItemInfo,
    zIndex: number
  ): number {
    let delayForEachIcon: number = 0;
    if (length >= firstPageMaxShowLength && !GridLayoutUtil.isBigFolder(folder)) {
      // 小文件夹第一页满铺时，从下向上依次落位
      delayForEachIcon = (zIndex - 1) * 50;
    } else {
      // 小文件夹第一页未铺满或大文件夹，从上向下依次落位
      delayForEachIcon = (this.multiSelectMap.size - zIndex) * 50;
    }
    if (length === 1) {
      // 新建文件夹时，需要额外等待第一个图标在SmallFolderComponent里的缩小落位
      delayForEachIcon += 50;
    }
    return delayForEachIcon;
  }

  /**
   * 多选进文件夹落位时最终大小计算
   * @param length 文件夹当前图标数
   * @param firstPageMaxShowLength 文件夹折叠态第一页最大显示图标数
   * @param folder 文件夹信息
   * @param dropIndex 落位进文件夹的哪一个图标位置
   * @returns 图标落位进文件夹后的大小
   */
  public getMultiIconToFolderTargetSize(
    folder: GridLayoutItemInfo,
    dropIndex: number
  ): number[] {
    // 小文件夹和大文件夹未落位至最后一个的，均可随意选取一个文件夹中的元素作为参考大小
    // 大文件夹落位至最后一个的需要单独计算大小
    // getGridItemRect方法中的应用排序是从1开始算的，所以此处给dropIndex加一
    let iconExchangeSize = folderLayoutUtil.getGridItemRect(FolderStatus.CLOSE_FOLDER, folder, dropIndex + 1);
    let targetSize: number[] = [iconExchangeSize.width as number, iconExchangeSize.height as number];
    return targetSize;
  }

  /**
   * 多选进文件夹落位时落在第几位上
   * @param length 文件夹当前图标数
   * @param firstPageMaxShowLength 文件夹折叠态第一页最大显示图标数
   * @param zIndex 图标排序
   * @returns 多选进文件夹落位时落在第几位上
   */
  public getMultiIconToFolderTargetIndex(
    length: number,
    firstPageMaxShowLength: number,
    zIndex: number
  ): number {
    let dropIndex = Math.min(length + (this.multiSelectMap.size - zIndex), firstPageMaxShowLength - 1);
    return dropIndex;
  }

  /**
   * 多选进文件夹落位时落位类型及初始透明度设定
   * @param length 文件夹当前图标数
   * @param firstPageMaxShowLength 文件夹折叠态第一页最大显示图标数
   * @param folder 文件夹信息
   * @param realIndex 图标在文件夹中排序
   * @param target 汇聚图标对象
   * @param item 多选图标对象
   */
  public getMultiIconToFolderType(
    item: MultiSelectItemType,
    firstPageMaxShowLength: number,
    folder: GridLayoutItemInfo,
    target: GatherAnimateTarget,
    realIndex: number,
    length: number,
  ): void {
    if (GridLayoutUtil.isBigFolder(folder)) {
      this.resetDropAnimationItemOpacity?.(item.parentId, 1);
      target.animationType = realIndex >= firstPageMaxShowLength - 1 ? AnimationType.FADE_DROP : AnimationType.DROP;
    } else {
      if (length >= firstPageMaxShowLength) {
        // 小文件夹满九落位，透明度1-0
        this.resetDropAnimationItemOpacity?.(item.parentId, 1);
        target.animationType = AnimationType.FADE_DROP;
      } else {
        // 小文件夹不满九落位，第九个及之前透明度维持1，后面的透明度0-1-0
        if (realIndex >= firstPageMaxShowLength) {
          this.resetDropAnimationItemOpacity?.(item.parentId, 0);
          target.animationType = AnimationType.REVERT_FADE_DROP;
        } else {
          this.resetDropAnimationItemOpacity?.(item.parentId, 1);
          target.animationType = AnimationType.DROP;
        }
        if (realIndex === firstPageMaxShowLength - 1) {
          this.resetDropAnimationItemZIndex?.(item.parentId);
        }
      }
    }
  }

  /**
   * 文件夹落位后执行落位动效
   * @param dropX 松手时图标X轴坐标
   * @param dropY 松手时图标Y轴坐标
   * @param folder 落位目标文件夹
   * @param dragItems 拖拽起的图标
   * @returns
   */
  public async startDropToFolder(
    dropX: number,
    dropY: number,
    folder: GridLayoutItemInfo
  ): Promise<void> {
    // 触发drop事件
    // 在动效中中断GC，以减少性能损耗
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
    this.status.setStatus(MultiSelectStatusEnum.Dropping);
    multiSelectListenManger.executeDropping([CommonConstants.CONTRACTED_FOLDER_MULTI_DRAG]);
    log.showInfo(`sendMessageToshowIcon`);
    let gatherTargetList: GatherAnimateTarget[] = [];
    // 文件夹现有多少图标
    let length = folderLayoutUtil.getFolderAppCount(folder);
    // 根据文件夹占用区域判断文件夹第一页最多展示多少图标
    let firstPageMaxShowLength = folderLayoutUtil.getFirstPageMaxShowLength(folder);
    this.multiSelectMap.forEach((item: MultiSelectItemType) => {
      // 初始坐标
      item.defaultX = dropX;
      item.defaultY = dropY;
      let dropIndex = this.getMultiIconToFolderTargetIndex(length, firstPageMaxShowLength, item.zIndex);
      // 每一个图标落位动效的目标坐标
      let targetPos =
        this.getMultiIconToFolderTargetPos(length, firstPageMaxShowLength, folder, dropIndex);
      item.targetX = targetPos[0];
      item.targetY = targetPos[1];
      // 每一个图标落位动效的最终大小
      let targetSize = this.getMultiIconToFolderTargetSize(folder, dropIndex);
      item.width = targetSize[0];
      item.height = targetSize[1];
      const target = this.createGatherAnimateTarget(item);
      // 图标落位的延时
      target.delay = this.getMultiIconToFolderDelay(length, firstPageMaxShowLength, folder, item.zIndex);
      // 图标落位的最终大小尺寸
      target.scale = item.height / folderLayoutUtil.getHeightByArea([1, 1]);
      // 图标在文件夹中的顺序
      let realIndex = length + (this.multiSelectMap.size - item.zIndex);
      // 图标落位类型
      this.getMultiIconToFolderType(item, firstPageMaxShowLength, folder, target, realIndex, length);
      gatherTargetList.push(target);
    });
    const doDropToFolderAnimate =
      await this.doDropToFolderAnimate?.(gatherTargetList, (parentId: string) => {});

    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
    // 落位动效结束后 触发事件finish
    this.finishDrag();
    FolderManager.getInstance().setMultiDropFolderId('');
    if (length === FolderConstants.DEFAULT_APP_LENGTH_WHEN_CREATE_FOLDER) {
      localEventManager.sendLocalEvent(EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_OPEN,
        {
          openedBy: FolderCommonConstants.OPEN_ADD_SHEET_CREATE_FOLDER,
          folderId: folder.folderId
        });
    }
  }

  /**
   * 拖拽结束 更新ItemInfo位置
   * @returns
   */
  public async finishDrag(): Promise<void> {
    if (this.inAnimation) {
      log.showInfo('in animation, can`t finish drag');
      return;
    }
    // 清理选择列表并更新checkbox.parentItemInfo
    this.syncCheckboxAppItemInfoFromCache();

    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
    this.lastActionTouchPosition = {x: -1, y: -1};
    this.releaseAnimateItem?.();

    this.onShowAppName();
    this.multiSelectMap.forEach(item => item.image?.release());
    this.multiSelectMap.clear();
    multiSelectListenManger.executeUpdatingMultiSelectMap();
    this.multiSelectDrag = null;
    this.mode = MultiSelectMode.INIT;
    log.showInfo('finish drag');

    // 防止落位动效打断后的在桌面进入多选
    if (this.status.isEntered) {
      this.status.setStatus(MultiSelectStatusEnum.Entered);
    }
    multiSelectListenManger.executeFinish();
    Trace.end(Trace.CORE_METHOD_MULTISELECT_DRAG);
  }

  /**
   * 拖拽结束 显示图标名称
   * @returns
   */
  private onShowAppName(): void {
    let idList: string[] = [];
    this.multiSelectMap.forEach(item => {
      idList.push(multiSelectListenManger.getListenerId(ListenerItemType.APP_ICON,
        MultiSelectManager.getInstance().getUniqueId(item.parentItemInfo)));
    });
    multiSelectListenManger.executeShowAppName(idList);
  }

  /** 落位流程结束后从缓存中更新itemInfo的行列页信息 */

  private async syncCheckboxAppItemInfoFromCache(): Promise<void> {
    const cacheFolderLayoutInfoList: Map<string, GridLayoutItemInfo[]> = new Map();
    this.checkboxInfoMap.forEach((checkboxInfo: CheckboxInfoType) => {
      checkboxInfo.checkState.setSelectedStatus(false);
      if (checkboxInfo.parentType !== CheckboxParentEnum.AppInFolder) {
        const cacheParentItemInfo: GridLayoutItemInfo = this.getCacheItemInfoByCheckboxInfo(checkboxInfo);
        if (cacheParentItemInfo) {
          checkboxInfo.parentItemInfo.page = cacheParentItemInfo.page;
          checkboxInfo.parentItemInfo.row = cacheParentItemInfo.row;
          checkboxInfo.parentItemInfo.column = cacheParentItemInfo.column;
        } else {
          log.showInfo(`cache without this itemInfo ${checkboxInfo.parentId}`);
        }
      }
    });
    cacheFolderLayoutInfoList.clear();
  }

  public syncAppItemInfoFormCacheAfterSingleDrag(parentId: string): boolean {
    if (!this.status.isEntered) {
      return false;
    }
    const checkboxInfo = this.checkboxInfoMap.get(parentId);
    if (!checkboxInfo) {
      return false;
    }
    const cacheItemInfo: GridLayoutItemInfo = this.getCacheItemInfoByCheckboxInfo(checkboxInfo);
    if (!cacheItemInfo) {
      return false;
    }
    const itemInfo = checkboxInfo.parentItemInfo;
    log.showInfo(`syncAppItemInfoFormCacheAfterSingleDrag ${parentId} ` +
      `form row:${itemInfo.row} col:${itemInfo.column} page:${itemInfo.page} ` +
      `to row:${cacheItemInfo.row} col:${cacheItemInfo.column} page:${cacheItemInfo.page} `
    );
    checkboxInfo.parentItemInfo.page = cacheItemInfo.page;
    checkboxInfo.parentItemInfo.row = cacheItemInfo.row;
    checkboxInfo.parentItemInfo.column = cacheItemInfo.column;
    return true;
  }

  /** 长按松手后检查是否触发多选 */
  public checkIsGatherStarted(event: GestureEvent): void {
    if (this.status.inStatus(MultiSelectStatusEnum.Exited)) {
      return;
    }
    if (!this.status.inGatherOrDragOrDrop) {
      // 长按时间不够没有触发gather
      multiSelectListenManger.executeFinish();
    }
  }

  private triggerManualDrop(): void {
    const selectItemInfo: AppItemInfo[] = this.getAllSelectedItem()
      .sort((a, b) => b.zIndex - a.zIndex).map(item => item.parentItemInfo);
    AppStorage.setOrCreate<boolean>('isDrag', true);
    AppStorage.setOrCreate<AppItemInfo[]>('dragItemInfo', selectItemInfo);
    AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
    multiSelectListenManger.executeDropWhenGathering();
  }

  /**
   * checkbox上传信息
   * @param checkboxInfo
   */
  public uploadCheckboxInfo(checkboxInfo: CheckboxInfoType): void {
    if (checkboxInfo.parentType === CheckboxParentEnum.Folder) {
      this.multiSelectMap.forEach((item: MultiSelectItemType) => {
        if (item.belongId === checkboxInfo.parentId) {
          checkboxInfo.checkState.add();
        }
      });
    } else {
      checkboxInfo.checkState.setSelectedStatus(this.multiSelectMap.has(checkboxInfo.parentId));
    }
    this.checkboxInfoMap.set(checkboxInfo.parentId, checkboxInfo);
  }

  /**
   * 判断传入的itemInfo是否被选中
   * @param appItemInfo AppItemInfo | GridLayoutItemInfo
   */
  public isItemSelected(appItemInfo: AppItemInfo | GridLayoutItemInfo): boolean {
    const parentId = this.getUniqueId(appItemInfo);
    return this.multiSelectMap.has(parentId);
  }

  /**
   * 获取itemInfo的唯一标识符
   * @param appItemInfo AppItemInfo | GridLayoutItemInfo
   */
  public getUniqueId(appItemInfo?: AppItemInfo | GridLayoutItemInfo): string {
    if (!appItemInfo) {
      return '';
    }
    let itemInfo: GridLayoutItemInfo;
    if (appItemInfo instanceof AppItemInfo) {
      itemInfo = appItemInfo as Object as GridLayoutItemInfo;
    } else {
      itemInfo = appItemInfo;
    }
    const unique = GridLayoutUtil.generateUniqueKey(itemInfo);
    return unique;
  };

  /**
   * 更新当前手指位置
   * @param event
   */
  public updateTouchPos(event: multiInputTouchEvent): void {
    if (this.status.inStatus(MultiSelectStatusEnum.Gathering)) {
      const touch = event.touches[0];
      if (!touch) {
        log.showInfo('updateTouchPos: touch undefined');
        return;
      }
      const currentTouchPos: Position = {
        x: px2vp(touch.windowX),
        y: px2vp(touch.windowY)
      };
      if (this.isMoveExceededThreshold(currentTouchPos)) {
        this.lastActionTouchPosition = currentTouchPos;
        this.updateAnimationTarget?.(this.getRealIconPosition(this.lastActionTouchPosition));
        multiSelectListenManger.executeMoveWhenGathering(undefined, currentTouchPos);
      }
    }
  }

  private canSelectWhenLayoutLocked(info: CheckboxInfoType): boolean {
    if (!layoutLockUtil.isLocked()) {
      return true;
    }
    // 文件夹内图标不支持选中
    let curItemPage: number = info.parentItemInfo.page ?? -1;
    if (info.parentType === CheckboxParentEnum.AppInFolder) {
      return false;
    }
    // 当前选中元素为图标或非预置页布局的文件夹内图标，且未选中其他图标时支持选中
    if (this.multiSelectMap.size === 0) {
      return true;
    }
    // 当前选中元素和已选中元素都位于预置页或非预置页时支持选中
    let selectType: MultiSelectItemType = this.getAllSelectedItem()[0];
    let selectPage: number = (typeof selectType.belongId === 'string' ?
    this.checkboxInfoMap.get(selectType.belongId)?.parentItemInfo.page : selectType.parentItemInfo.page) ?? -1;
    return layoutLockUtil.isLockedPage(curItemPage, undefined, true) === layoutLockUtil.isLockedPage(selectPage,
      undefined, true);
  }

  public getFinalIconPosition(): Position {
    return this.getRealIconPosition(this.lastActionTouchPosition);
  }

  private isMoveExceededThreshold(currentTouchPos: Position): boolean {
    return this.lastActionTouchPosition.x !== currentTouchPos.x ||
            this.lastActionTouchPosition.y !== currentTouchPos.y;
  }

  /**
   * checkbox选中回调
   * @param checkboxInfo
   */
  private async onCheckboxSelect(checkboxInfo: CheckboxInfoType): Promise<boolean> {
    // 状态更新
    this.status.setStatus(MultiSelectStatusEnum.Selecting);
    this.notifyFolderCheckboxUpdate(checkboxInfo, true);
    const multiSelectItem = await this.createMultiSelectItem(checkboxInfo);
    if (multiSelectItem) {
      this.multiSelectMap.set(checkboxInfo.parentId, multiSelectItem);
      multiSelectListenManger.executeUpdatingMultiSelectMap([
        multiSelectListenManger.getListenerId(
          checkboxInfo.parentItemInfo.container === CommonConstants.CONTAINER_DESKTOP ?
            ListenerItemType.SWIPER_ITEM : ListenerItemType.OPEN_FOLDER_SWIPER_ITEM,
          checkboxInfo.parentItemInfo.page?.toString() ?? '',
          checkboxInfo.parentItemInfo.container === CommonConstants.CONTAINER_DESKTOP ?
            launcherStatusUtil.getShowOutLauncherStatus() : false
        )
      ]);
      return true;
    }
    return false;
  };

  /**
   * checkbox 取消选中回调
   * @param checkboxId
   */
  private async onCheckboxUnSelect(checkboxInfo: CheckboxInfoType): Promise<boolean> {
    try {
      this.multiSelectMap.delete(checkboxInfo.parentId);
      multiSelectListenManger.executeUpdatingMultiSelectMap([
        multiSelectListenManger.getListenerId(
          checkboxInfo.parentItemInfo.container === CommonConstants.CONTAINER_DESKTOP ?
            ListenerItemType.SWIPER_ITEM : ListenerItemType.OPEN_FOLDER_SWIPER_ITEM,
          checkboxInfo.parentItemInfo.page?.toString() ?? '',
          checkboxInfo.parentItemInfo.container === CommonConstants.CONTAINER_DESKTOP ?
            launcherStatusUtil.getShowOutLauncherStatus() : false
        )
      ]);
      // 取消了所有选中 回到‘entered’状态
      if (this.multiSelectMap.size === 0) {
        this.status.setStatus(MultiSelectStatusEnum.Entered);
      }
      this.notifyFolderCheckboxUpdate(checkboxInfo, false);
      return true;
    } catch (error) {
      log.showError(`unselect item failed ${error.message}}`);
    }
    return false;
  };

  // 根据多选框信息创建多选对象
  private async createMultiSelectItem(checkboxInfo: CheckboxInfoType): Promise<MultiSelectItemType | undefined> {
    let selectItem: MultiSelectItemType | undefined;
    if (checkboxInfo.parentType === CheckboxParentEnum.AppInFolder) {
      selectItem = await this.createFolderAppMultiSelectItem(checkboxInfo);
    } else if (checkboxInfo.parentType === CheckboxParentEnum.App) {
      selectItem = await this.createDesktopAppMultiSelectItem(checkboxInfo);
    }
    log.showInfo(`create selectItem ${selectItem ? '' : 'failed'} ${checkboxInfo.parentId}`);
    return selectItem;
  };

  /**
   * 创建桌面应用的selectItem
   */
  private async createDesktopAppMultiSelectItem(
    checkboxInfo: CheckboxInfoType
  ): Promise<MultiSelectItemType | undefined> {
    const image = await this.getSnapshotById(checkboxInfo.rectId);
    if (!image) {
      return undefined;
    }
    const cachedItemInfo = checkboxInfo.parentItemInfo;
    const gridItemRect: GridItemRect = this.getRectByItemInfo(checkboxInfo.parentItemInfo);
    const multiSelectItem: MultiSelectItemType = {
      parentId: checkboxInfo.parentId,
      parentItemInfo: cachedItemInfo as Object as AppItemInfo,
      page: cachedItemInfo.page ?? -1,
      image: image,
      radius: checkboxInfo.radius,
      iconSize: checkboxInfo.iconSize,
      width: checkboxInfo.iconSize,
      height: checkboxInfo.iconSize,
      defaultX: gridItemRect.centerX,
      defaultY: gridItemRect.centerY,
      targetX: gridItemRect.centerX,
      targetY: gridItemRect.centerY,
      zIndex: 0,
      animationType: AnimationType.GATHER,
    };
    return multiSelectItem;
  }

  /**
   * 创建文件夹内应用的selectItem
   */
  private async createFolderAppMultiSelectItem(
    checkboxInfo: CheckboxInfoType
  ): Promise<MultiSelectItemType | undefined> {
    let selectItem = await this.createDesktopAppMultiSelectItem(checkboxInfo);
    if (!selectItem) {
      return undefined;
    }
    const folderInfo: FolderInfo = this.getCurrentFolderInfo();
    if (folderInfo.isOpened) {
      const cacheFolder = this.getCachedItemInfo(folderInfo.lastOpenedFolderItemInfo);
      const cacheItemInfo = cacheFolder?.layoutInfo?.[folderInfo.pageIndexInFolder].find(item => {
        return this.getUniqueId(item) === checkboxInfo.parentId;
      });
      if (cacheItemInfo) {
        checkboxInfo.parentItemInfo.page = cacheItemInfo.page;
        checkboxInfo.parentItemInfo.row = cacheItemInfo.row;
        checkboxInfo.parentItemInfo.column = cacheItemInfo.column;
      }
    }
    // 文件夹内应用 默认位置是文件夹中心
    const folderCheckboxInfo = this.checkboxInfoMap.get(checkboxInfo.belongFolderCheckboxId ?? '') as CheckboxInfoType;
    const folderRect = this.getRectByItemInfo(folderCheckboxInfo.parentItemInfo);
    selectItem.belongId = checkboxInfo.belongFolderCheckboxId;
    selectItem.defaultX = folderRect.centerX;
    selectItem.defaultY = folderRect.centerY;
    selectItem.targetX = folderRect.centerX;
    selectItem.targetY = folderRect.centerY;
    return selectItem;
  }

  /**
   * 更新文件夹checkbox状态 appInFolder调用
   * @param folderCheckboxId
   * @param isAdd
   */
  private updateFolderCheckboxState(folderCheckboxId: string, isAdd: boolean): boolean {
    try {
      let checkboxInfo: CheckboxInfoType | undefined = this.checkboxInfoMap.get(folderCheckboxId);
      if (!checkboxInfo) {
        log.showError('with out this folderCheckbox id:%{public}s', folderCheckboxId);
        return false;
      }
      let originState = checkboxInfo.checkState.isSelected();
      let resState = isAdd ? checkboxInfo.checkState.add() : checkboxInfo.checkState.sub();
      if (originState !== resState) {
        multiSelectListenManger.executeUpdateState([
          multiSelectListenManger.getListenerId(ListenerItemType.MULTISELECT_CHECKBOX_VIEW, folderCheckboxId, launcherStatusUtil.getShowOutLauncherStatus())
        ]);
      }
      return true;
    } catch (error) {
      log.showError(`update folder state failed ${error.message}`);
    }
    return false;
  }

  /**
   * 根据行列信息获取指定swiperPage中gridItem的位置信息，page只用来判断折叠屏
   * @param row 行
   * @param col 列
   * @param page 页
   * @param area 目标大小
   * @returns
   */
  private getSwiperPageGridByRowCol(row: number, col: number, page: number, area: number[] = [1, 1]): GridItemRect {
    let mTop: number[] = GridLayoutUtil.getGridItemPosition(row, col, page);
    let mCenter: number[] = GridLayoutUtil.getIconCenterPosition(row, col, area, page);
    let leftTopX = mTop[0];
    let leftTopY = mTop[1];
    let centerX = mCenter[0];
    let centerY = mCenter[1];
    const width = Math.abs(leftTopX - centerX) * 2;
    const height = Math.abs(leftTopY - centerY) * 2;

    return { width, height, centerX, centerY, leftTopX, leftTopY };
  }

  private getRectByItemInfo(itemInfo: AppItemInfo | GridLayoutItemInfo): GridItemRect {
    return this.getSwiperPageGridByRowCol(
      itemInfo.row ?? 0,
      itemInfo.column ?? 0,
      itemInfo.page ?? -1
    );
  }

  private getItemPositionInDesktop(
    itemInfo: AppItemInfo,
    gatherPage: number,
  ): Position {
    // 桌面应用
    const gridItemRect: GridItemRect = this.getRectByItemInfo(itemInfo);
    // 更新目标位置
    return this.updatePositionByPage(
      gridItemRect.centerX, gridItemRect.centerY, itemInfo.page ?? 0, gatherPage
    );
  }

  private updateSelectItemPosition(
    selectItem: MultiSelectItemType,
    gatherPage: number,
    gatherPosition: Position,
    folderInfo: FolderInfo
  ): void {
    selectItem.targetX = gatherPosition.x;
    selectItem.targetY = gatherPosition.y;
    if (typeof selectItem.belongId === 'undefined') {
      const position: Position = this.getItemPositionInDesktop(selectItem.parentItemInfo, gatherPage);
      selectItem.width = selectItem.iconSize;
      selectItem.height = selectItem.iconSize;
      selectItem.defaultX = position.x;
      selectItem.defaultY = position.y;
    } else {
      // 文件夹内应用
      const folderCheckboxInfo = this.checkboxInfoMap.get(selectItem.belongId);
      if (typeof folderCheckboxInfo === 'undefined') {
        log.showError('updateSelectItemPosition cant find belongCheckbox %{public}s', selectItem.parentId);
        return;
      }
      const cachedFolder = folderCheckboxInfo.parentItemInfo;
      const rect: Frame = this.getItemPositionInFolder(
        selectItem.parentItemInfo, cachedFolder as Object as AppItemInfo, gatherPage, folderInfo
      );
      selectItem.width = rect.width;
      selectItem.height = rect.height;
      selectItem.defaultX = rect.x;
      selectItem.defaultY = rect.y;
    }
  }

  /**
   * 获取文件夹内图标位置信息
   * @param selectItem
   * @param gatherPage
   * @param gatherRect
   * @param folderInfo
   */
  private getItemPositionInFolder(
    itemInfo: AppItemInfo,
    folder: AppItemInfo,
    gatherPage: number,
    folderInfo?: FolderInfo
  ): Frame {
    const currentFolderInfo = folderInfo ?? this.getCurrentFolderInfo();
    const convertedFolder = folder as Object as GridLayoutItemInfo;
    if (folderInfo?.isOpened && this.getUniqueId(folder) === currentFolderInfo.lastOpenedFolderUniqueId) {
      return this.getItemPositionInOpenedFolder(convertedFolder, itemInfo, currentFolderInfo);
    } else {
      return this.getItemPositionInCollapsedFolder(convertedFolder, itemInfo, gatherPage);
    }
  }

  /**
   * 获取文件夹展开态图标位置
   * @param folderItem
   * @param selectItem
   * @param folderInfo
   */
  private getItemPositionInOpenedFolder(folderItem: GridLayoutItemInfo, selectItem: AppItemInfo, folderInfo: FolderInfo): Frame {
    const appIndex: number = folderLayoutUtil.getItemIndex(selectItem as Object as GridLayoutItemInfo);
    const mCount: number[] = folderLayoutUtil.getRowAndColCount(FolderStatus.OPEN_FOLDER, new GridLayoutItemInfo());
    const rowCount = mCount[0];
    const columnCount = mCount[1];
    const appIndexInCurrentPage = appIndex % (rowCount * columnCount);
    const folderItemPosition = folderLayoutUtil.getItemPostion(FolderStatus.OPEN_FOLDER, folderItem, appIndexInCurrentPage);
    const appPosition = EditModeUtils.convertOpenFolderCoordinateToEditMode(folderItemPosition);
    const updatePosition = this.updatePositionByPage(
      appPosition.x, appPosition.y, selectItem.page ?? -1, folderInfo.pageIndexInFolder, true
    );
    const desktopIconSize: number = DesktopManager.getInstance().getDesktopParam().iconSize;
    log.showInfo(`folderPage:${folderInfo.pageIndexInFolder} appPage:${selectItem.page} iconSize:${desktopIconSize} ` +
      `appIndex:${appIndexInCurrentPage}  updatePosition:${[updatePosition.x, updatePosition.y]}`
    );
    return {
      x: updatePosition.x,
      y: updatePosition.y,
      width: EditModeUtils.convertWithDesktopScale(desktopIconSize),
      height: EditModeUtils.convertWithDesktopScale(desktopIconSize),
    };
  }

  /**
   * 获取文件夹折叠态图标位置
   * @param folderItem
   * @param selectItem
   * @param gatherPage
   */
  private getItemPositionInCollapsedFolder(folderItem: GridLayoutItemInfo, selectItem: AppItemInfo, gatherPage: number): Frame {
    // 获取桌面文件夹内坐标
    const folderPage = folderItem.page ?? -1;
    const folderRect: GridItemRect = this.getRectByItemInfo(folderItem);
    const appIndex: number = folderLayoutUtil.getItemIndex(selectItem as Object as GridLayoutItemInfo);
    const appOffsetInNormal = folderLayoutUtil.getItemPostion(FolderStatus.CLOSE_FOLDER, folderItem, appIndex);
    const appSize: Size = folderLayoutUtil.getGridItemRect(FolderStatus.CLOSE_FOLDER, folderItem, appIndex);
    const defaultX = folderRect.leftTopX + EditModeUtils.convertWithDesktopScale(appOffsetInNormal.x);
    const defaultY = folderRect.leftTopY + EditModeUtils.convertWithDesktopScale(appOffsetInNormal.y);
    const updatePosition = this.updatePositionByPage(defaultX, defaultY, folderPage, gatherPage);
    log.showInfo(`folderPage: ${folderPage}` +
      `appIndex:${appIndex} defaultX:${defaultX} defaultY${defaultY} width: ${appSize.width} height: ${appSize.height}`
    );
    const iconSize: number = DesktopManager.getInstance().getDesktopParam().iconSize;
    return {
      x: updatePosition.x,
      y: updatePosition.y,
      width: EditModeUtils.convertWithDesktopScale(iconSize),
      height: EditModeUtils.convertWithDesktopScale(iconSize),
    };
  }

  /**
   * 根据图标的位置页面信息转换到指定页面时的位置
   * @param x 图标x
   * @param y 图标y坐标
   * @param page 图标所在页面
   * @param targetPage
   * @returns
   */
  private updatePositionByPage(x: number, y: number, page: number, targetPage: number, inOpenedFolder: boolean = false): Position {
    const pageCountInOneScreen = PageInfoManager.getInstance().getDisplayCount();
    const currentScreen = Math.floor(page / pageCountInOneScreen);
    const targetScreen = Math.floor(targetPage / pageCountInOneScreen);
    const offsetScreenCount = Math.min(currentScreen - targetScreen, 2);
    return {
      x: x + offsetScreenCount * this.getGridSwiperWidth(inOpenedFolder) * (RTLUtil.isRTL() ? -1 : 1),
      y: y
    };
  }

  // 通知文件夹checkbox更新状态
  private notifyFolderCheckboxUpdate(checkboxInfo: CheckboxInfoType, isSelected: boolean): boolean {
    if (checkboxInfo.parentType === CheckboxParentEnum.AppInFolder) {
      if (typeof checkboxInfo.belongFolderCheckboxId === 'string') {
        this.updateFolderCheckboxState(checkboxInfo.belongFolderCheckboxId, isSelected);
        return true;
      } else {
        log.showWarn('appInfolder has no belongCheckbox %{public}s', checkboxInfo.parentId);
      }
    }
    return false;
  }

  /**
   * 判断是否属于不允许汇聚的状态
   * @param parentId
   * @returns
   */
  private illegalsGather(parentId: string): boolean {
    if (!this.status.isEntered) {
      log.showInfo('illegalsGather: multiSelect unloaded');
      return true;
    }
    const gatherIcon = this.checkboxInfoMap.get(parentId);
    if (!gatherIcon || gatherIcon.parentType === CheckboxParentEnum.Folder) {
      log.showInfo('illegalsGather: without gatherIcon or folderIcon');
      return true;
    }
    if (this.isDeliverApp(gatherIcon)) {
      log.showInfo('illegalsGather: deliverApp not allow');
      return true;
    }
    return false;
  }

  // 获取 gridswiper 宽度 用于计算不在当前屏幕的图标位置
  private getGridSwiperWidth(inOpenedFolder: boolean = false): number {
    const screenWidth = AppStorage.get<number>('screenWidth') as number;
    if (inOpenedFolder) {
      return screenWidth * EditModeUtils.getDesktopScale();
    } else {
      return screenWidth * EditModeUtils.getSwiperScale() -
        EditModeUtils.getPrevNextMargin() * EditModeUtils.getDesktopScale() * 2;
    }
  }

  /**
   * 获取指定页面的中心位置
   * @param currentPage 当前页面
   * @param targetPage 想获取位置的页面
   * @returns
   */
  private getScreenCenterByPage(currentPage: number, targetPage: number): Position {
    const screenWidth = AppStorage.get<number>('screenWidth') as number;
    const screenHeight = AppStorage.get<number>('screenHeight') as number;
    return this.updatePositionByPage(screenWidth / 2, screenHeight / 2, targetPage, currentPage);
  }

  // 获取图标截图
  private getSnapshotById(componentId: string): Promise<image.PixelMap | undefined> {
    return new Promise((resolve, reject) => {
      componentSnapshot.get(componentId).then(async image => {
        image.scaleSync(
          EditModeUtils.getDesktopScale() * StyleConstants.EDIT_MODE_LONG_PRESS_SCALE,
          EditModeUtils.getDesktopScale() * StyleConstants.EDIT_MODE_LONG_PRESS_SCALE
        );
        resolve(image);
      }).catch((error: Error) => {
        log.error('snapshot catch error', error.message);
        resolve(undefined);
      });
    });
  }

  // 创建drag事件
  private createDragAction(selectItemList: MultiSelectItemType[], touchPoint: Position): void {
    let selectAppItemInfoList: AppItemInfo[] = [];
    let selectImageList: image.PixelMap[] = [];

    selectItemList.forEach((item: MultiSelectItemType) => {
      selectAppItemInfoList.push(item.parentItemInfo);
      if (item.image) {
        selectImageList.push(item.image);
      }
    });

    this.multiSelectDrag = new MultiSelectDrag({
      dragItemImageList: selectImageList,
      imageRadius: selectItemList[0].radius,
      touchPoint: touchPoint,
      onDragStart: (): void => {
        Trace.start(Trace.CORE_METHOD_MULTISELECT_DRAG);
        this.cancelAnimation?.();
        this.hideAnimationItem?.();
        AppStorage.setOrCreate<boolean>('isDrag', true);
        AppStorage.setOrCreate<AppItemInfo[] | AppItemInfo>(
          'dragItemInfo', selectAppItemInfoList.length === 1 ? selectAppItemInfoList[0] : selectAppItemInfoList);
        AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
      },
      onDragEnd: (): void => {
        this.finishDrag();
      },
      onDragCancel: (): void => {
        // 处理汇聚过程中松手，手动触发落位的场景
        log.showError('multiSelect drag cancel');
        this.cancelAnimation?.();
        this.triggerManualDrop();
      },
      onDragFinish: (): void => {
        Trace.end(Trace.CORE_METHOD_MULTISELECT_DRAG);
      }
    });
  }

  private createGatherAnimateItem(selectItemList: MultiSelectItemType): GatherAnimateItem {
    const defaultIconSize = EditModeUtils.convertWithDesktopScale(
      DesktopManager.getInstance().getDesktopParam().iconSize
    );
    const gatherItem: GatherAnimateItem = {
      parentId: selectItemList.parentId,
      width: defaultIconSize,
      height: defaultIconSize,
      position: { x: selectItemList.defaultX, y: selectItemList.defaultY },
      image: selectItemList.image,
      zIndex: selectItemList.zIndex,
      radius: selectItemList.radius,
      scale: Number((selectItemList.width / defaultIconSize).toFixed(2)),
    };
    return gatherItem;
  }

  private createGatherAnimateTarget(selectItemList: MultiSelectItemType): GatherAnimateTarget {
    const defaultIconSize = EditModeUtils.convertWithDesktopScale(
      DesktopManager.getInstance().getDesktopParam().iconSize
    );
    const targetItem: GatherAnimateTarget = {
      parentId: selectItemList.parentId,
      startPosition: { x: selectItemList.defaultX, y: selectItemList.defaultY },
      endPosition: { x: selectItemList.targetX, y: selectItemList.targetY },
      scale: Number((selectItemList.width / defaultIconSize).toFixed(2)),
    };
    return targetItem;
  }

  /**
   * 判断是不是备份应用
   * @param checkboxInfo
   */
  private isDeliverApp(checkboxInfo: CheckboxInfoType): boolean {
    if (checkboxInfo.parentType === CheckboxParentEnum.AppInFolder) {
      let folderCheckboxInfo: CheckboxInfoType | undefined =
        this.checkboxInfoMap.get(checkboxInfo.belongFolderCheckboxId ?? '');
      if (!folderCheckboxInfo) {
        return false;
      }
      let parentItemInfo = folderCheckboxInfo.parentItemInfo as Object as GridLayoutItemInfo;
      return (DeliverUtil.isContainerFolder(parentItemInfo.folderId) &&
        !DeliverUtil.isdeliverFolder(parentItemInfo.folderId ?? '')) ||
        NotHarmonyUtil.isNotHarmonyFolderById(parentItemInfo.folderId);
    }
    return false;
  }

  // 获取当前展开态文件夹信息
  private getCurrentFolderInfo(): FolderInfo {
    const folderMgr: FolderManager = FolderManager.getInstance();
    const folderItemInfo: GridLayoutItemInfo = folderMgr.getOpenedFolder();
    const isFolderOpened: boolean = folderMgr.isFolderOpen();
    const openedFolderIndex: number = folderMgr.getPageIndex();
    return {
      isOpened: isFolderOpened,
      pageIndexInFolder: openedFolderIndex ?? -1,
      lastOpenedFolderItemInfo: folderItemInfo,
      lastOpenedFolderUniqueId: this.getUniqueId(folderItemInfo)
    };
  }

  /**
   * 汇聚动效
   * @param selectItemList
   * @returns isCancel
   */
  private async gatherAnimation(selectItemList: MultiSelectItemType[]): Promise<boolean | undefined> {
    if (this.isInMultiSelect) {
      let gatherTargetList: GatherAnimateTarget[] = [];
      selectItemList.forEach((selectItem, index) => {
        let target = this.createGatherAnimateTarget(selectItem);
        index === 0 && (target.scale *= DragConstants.DROP_START_SCALE);
        target.delay = MultiSelectStyleConfig.HIDE_CHECKBOX_DURING_GATHER_ANIMATE_DURATION;
        gatherTargetList.push(target);
      });
      const touchMoveMonitor = new TouchMoveMonitor();
      touchMoveMonitor.start((position, touchEvent) => {
        this.updateTouchPos(touchEvent);
      });
      const animateRes = await this.doGatherAnimate?.(gatherTargetList);
      touchMoveMonitor.end();
      return animateRes;
    }
    return false;
  }

  /**
   * 预加载动效组件
   * @param selectItemList
   * @returns
   */
  private preLoadAnimationViewBySelectItemList(selectItemList: MultiSelectItemType[]): boolean {
    if (this.isInMultiSelect) {
      let gatherItemList: GatherAnimateItem[] = [];
      selectItemList.forEach((selectItem) => {
        let animateItem = this.createGatherAnimateItem(selectItem);
        gatherItemList.push(animateItem);
      });
      this.preLoadAnimationView?.(gatherItemList);
    }
    return false;
  }

  private getSelectItemByGather(gatherIcon: CheckboxInfoType): MultiSelectItemType[] {
    let selectItemList: MultiSelectItemType[] = [];
    let mapSize = this.multiSelectMap.size;
    this.multiSelectMap.forEach((item: MultiSelectItemType, itemParentId: string) => {
      item.zIndex = itemParentId === gatherIcon.parentId ? this.multiSelectMap.size : --mapSize;
      // 触发汇聚的图标在堆叠最顶端
      itemParentId === gatherIcon.parentId ? selectItemList.unshift(item) : selectItemList.push(item);
    });
    return selectItemList;
  }

  private getTouchPositionByGestureEvent(event: GestureEvent): FingerInfo {
    return event.fingerList[0];
  }

  /** 记录跟手位置和图标中心点的偏移 */
  private recordTouchPointOffsetToCenter(touchPoint: Position, touchIcon: CheckboxInfoType): void {
    const offsetX = touchPoint.x - touchIcon.iconSize / 2;
    const offsetY = touchPoint.y - touchIcon.iconSize / 2;
    this.touchPointOffsetToCenter.x = offsetX;
    this.touchPointOffsetToCenter.y = offsetY;
  }

  /** 根据跟手位置，获取图标实际中心点 */
  private getRealIconPosition(touchPosition: Position): Position {
      return {
        x: touchPosition.x - this.touchPointOffsetToCenter.x,
        y: touchPosition.y - this.touchPointOffsetToCenter.y,
      };
  }

  /** 震动 */
  private vibrator(): void {
    DesktopItemVibratorManager.getInstance().longPressVibrator(TAG);
    DragAccessibilityUtils.textAnnouncedForMultiDragStart(this.getAllSelectedItem().length);
  }

  /** 监听文件夹展开事件， 更新文件夹内应用的belongId */
  private registerFolderCallback(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenCloseCallback);
  }

  private unregisterFolderCallback(): void {
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mOpenCloseCallback);
  }

  private mOpenCloseCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.NORMAL,
    onOpenedFolder: (folder: GridLayoutItemInfo) => {
      const folderParentId: string = this.getUniqueId(folder);
      const appInFolderParentIdSet: Set<string> = new Set();
      folder.layoutInfo?.flat().forEach((itemInfo: GridLayoutItemInfo, index: number) => {
        const parentId: string = this.getUniqueId(itemInfo);
        if (!this.checkboxInfoMap.has(parentId)) {
          return;
        }
        appInFolderParentIdSet.add(parentId);
        const checkboxInfo: CheckboxInfoType | undefined = this.checkboxInfoMap.get(parentId);
        if (checkboxInfo) {
          checkboxInfo.belongFolderCheckboxId = folderParentId;
        }
      });
      this.showCheckboxWithAnimation(Array.from(appInFolderParentIdSet.values()));
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      const curPageInFolder: number = FolderManager.getInstance().getPageIndex();
      log.showInfo(`closingFolderCallback curPageInFolder ${curPageInFolder}`);
      const folderParentId: string = this.getUniqueId(folder);
      this.hideCheckboxWithAnimation(folderParentId);
      folder.layoutInfo?.[curPageInFolder].forEach((itemInfo: GridLayoutItemInfo) => {
        const parentId: string = this.getUniqueId(itemInfo);
        this.hideCheckboxWithAnimation(parentId);
      });
      if (curPageInFolder !== 0) {
        folder.layoutInfo?.[0].forEach((itemInfo: GridLayoutItemInfo) => {
          const parentId: string = this.getUniqueId(itemInfo);
          this.hideCheckboxWithAnimation(parentId);
        });
      }
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      const folderParentId: string = this.getUniqueId(folder);
      this.showCheckboxWithAnimation(folderParentId);
    }
  };

  /**
   * 获取文件夹FolderComponent事件监听对象id
   * @param folder
   * @returns
   */
  public getFolderUniqueId(folder: GridLayoutItemInfo | AppItemInfo): string {
    if (GridLayoutUtil.isBigFolder(folder)) {
      return multiSelectListenManger.getListenerId(ListenerItemType.BIG_FOLDER, this.getUniqueId(folder));
    } else {
      return multiSelectListenManger.getListenerId(ListenerItemType.SMALL_FOLDER, this.getUniqueId(folder));
    }
  }

  private getCachedItemInfo(itemInfo: AppItemInfo | GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    return LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(itemInfo as Object as GridLayoutItemInfo);
  }

  private getCacheItemInfoByCheckboxInfo<
  T extends CheckboxInfoType | CheckboxInfoType[],
  R = GridLayoutItemInfo | GridLayoutItemInfo[]
  >(checkboxInfo: T): R {
    const checkboxList: CheckboxInfoType[] = Array.isArray(checkboxInfo) ? checkboxInfo : [checkboxInfo];
    const cacheItems: Map<string, GridLayoutItemInfo> = new Map();
    // 需要从缓存中拿哪些值
    const uniqueKeyList: string[] = checkboxList.map(item => {
      if (item.parentType === CheckboxParentEnum.AppInFolder) {
        return item.belongFolderCheckboxId ?? '';
      }
      return item.parentId;
    });
    // 把第一次获取的存起来
    const selectRes = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByUniqueKey(uniqueKeyList);
    (Array.isArray(selectRes) ? selectRes : [selectRes]).forEach((cacheItem: GridLayoutItemInfo | undefined) => {
      if (!cacheItem) {
        return;
      }
      cacheItems.set(this.getUniqueId(cacheItem), cacheItem);
    });
    const cacheArr = checkboxList.map((checkboxInfo: CheckboxInfoType) => {
      // 遍历文件夹layoutInfo缓存,然后存起来
      if (!cacheItems.has(checkboxInfo.parentId) && checkboxInfo.parentType === CheckboxParentEnum.AppInFolder) {
        const cacheFolder = cacheItems.get(checkboxInfo.belongFolderCheckboxId ?? '');
        cacheFolder?.layoutInfo?.flat().forEach(item => {
          cacheItems.set(this.getUniqueId(item), item);
        });
      }
      return cacheItems.get(checkboxInfo.parentId);
    });
    return (checkboxList.length > 1 ? cacheArr : cacheArr[0]) as R;
  }
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}