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

import { CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper, RectInfo } from '@ohos/basicutils';
import { EventType, scbEventExclusiveManager, } from '@ohos/windowscene';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { dragSnapshotHelper, ItemUtils, SnapshotType } from '@ohos/componenthelper';
import { GestureDockItemInfo } from '../../model/GestureDockItemInfo';
import { GestureDockConstants } from '../../../common/GestureDockConstants';
import type ctx from '@ohos.app.ability.common';
import { image } from '@kit.ImageKit';
import { GestureDockDirection } from '../../../dock/viewmodel/viewevent/GestureDockViewEventMgr';
import { GestureDockEventIdUtil } from '../../../common/util/GestureDockEventIdUtil';
import { GestureDockUtil } from '../../../common/util/GestureDockUtil';
import { SystemNavReporter } from '../../../common/util/SystemNavReporter';

const TAG = 'GestureDockItemDragHandler';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * gestureDock DragHandler
 */
export default class GestureDockItemDragHandler {
  private recentAppLength: number = 0;

  private copyResidentApps: GestureDockItemInfo[] = [];

  private desktopContext: ctx.ServiceExtensionContext = GlobalContext.getContext();

  private dragItemId: string = '';

  public dragItemImage: image.PixelMap | undefined;

  public positionX: number = 0;

  public positionY: number = 0;

  public squeezeIndex: number = -1;

  private squeezeFromIndex: number = 0;

  private dockDirection: number = GestureDockDirection.GESTURE_DOCK_RIGHT;

  private dockRectInfo: RectInfo | undefined;

  public dragAppItemInfo: GestureDockItemInfo | undefined;

  /**
   * 单例
   *
   * @returns GestureDockItemDragHandler
   */
  public static getInstance(): GestureDockItemDragHandler {
    return SingletonHelper.getInstance(GestureDockItemDragHandler, TAG);
  }

  /**
   * 构造器设置手势互斥
   */
  public constructor() {
    this.init();
  }

  private init(): void {
    scbEventExclusiveManager.registerEventExclusive(EventType.GESTUREDOCK_ITEM_DRAG, () => {
      scbEventExclusiveManager.setEventExclusive(EventType.GESTUREDOCK_ITEM_DRAG, false);
    });
  }

  /**
   * gesture dock栏内开始拖拽
   *
   * @param appInfo app信息
   * @param itemId 拖拽id
   */
  public handleDragStart(appInfo: GestureDockItemInfo, itemId: string): void {
    log.showInfo(`handleDragStart`);
    AppStorage.setOrCreate<GestureDockItemInfo>('gestureDockDragItemInfo', appInfo);
    this.dragAppItemInfo = appInfo;
    this.dragItemId = itemId;
    log.showInfo(`appInfo is bundleName:${appInfo.bundleName}, appIndex:${appInfo.appIndex}`);
  }

  /**
   * gesture dock栏内拖拽move事件
   *
   * @param event 拖拽event
   * @param scrollTranslate 滑动偏移量
   */
  public handleDragMove(event: DragEvent, scrollTranslate: number | undefined): void {
    if (!scrollTranslate) {
      scrollTranslate = 0;
    }
    const dragItem: GestureDockItemInfo =
      AppStorage.get<GestureDockItemInfo>('gestureDockDragItemInfo') as GestureDockItemInfo;
    if (!event || !dragItem) {
      log.showError('handleDragMove event or item undefined');
      return;
    }
    let rectangle = event.getPreviewRect();
    let dragPositionX = Number(rectangle.x) + Number(rectangle.width) / 2;
    let dragPositionY = Number(rectangle.y) + Number(rectangle.height) / 2;
    let bestIndex = this.findNearestArea(dragPositionY, scrollTranslate);
    log.showInfo(`bestIndex is ${bestIndex},dragPositionX is ${dragPositionX},dragPositionY is ${dragPositionY}`);
    this.squeezeItem(bestIndex, dragItem, scrollTranslate);
  }

  /**
   * gesture dock栏内拖拽drop事件
   *
   * @param event dragEvent
   *
   */
  public handleDragDrop(event?: DragEvent): GestureDockItemInfo[] {
    log.showInfo(`handleDragDrop`);
    this.dragItemImage = dragSnapshotHelper.getSnapshot(SnapshotType.DROP, this.dragItemId);
    this.desktopContext?.eventHub.emit(GestureDockEventIdUtil.getDockItemVisibleEventId(this.dragAppItemInfo)
      , true);
    log.showInfo(`dragItemImage is ${this.dragItemImage?.getImageInfoSync()}`);
    SystemNavReporter.reportSwapAppInDock(this.dragAppItemInfo?.bundleName, this.squeezeFromIndex, this.squeezeIndex);
    let tempDockApps: GestureDockItemInfo[] = this.copyResidentApps.slice();
    this.squeezeIndex = GestureDockConstants.INVALID_VALUE;
    this.dragAppItemInfo = undefined;
    this.dockRectInfo = undefined;
    return tempDockApps;
  }

  /**
   * 尝试挤位
   *
   * @param index 目标索引
   * @param dragItem 拖拽元素
   * @param scrollTranslate 滑动偏移量
   */
  private squeezeItem(index: number, dragItem: GestureDockItemInfo, scrollTranslate: number): void {
    if (this.squeezeIndex === index) {
      log.showWarn(`squeezeindex ${index} equal`);
      return;
    }
    this.adjustItem(dragItem, index, scrollTranslate);
  }

  /**
   * 将元素调整至挤位方案中的指定位置
   *
   * @param item 待调整元素
   * @param index 目标索引
   * @param scrollTranslate 滑动偏移量
   * @returns 是否调整成功
   */
  private adjustItem(item: GestureDockItemInfo, index: number, scrollTranslate: number): boolean {
    if (index < 0 || index >= this.copyResidentApps.length) {
      log.showInfo(`adjustItem fail, index:${index};length:${this.copyResidentApps.length}`);
      return false;
    }
    this.copyResidentApps.splice(this.squeezeIndex, 1);
    this.copyResidentApps.splice(index, 0, item);
    this.squeezeIndex = index;
    this.moveItem(item, scrollTranslate);
    log.showInfo('adjustItem success, key: %{public}s appIndex：%{public}d index: %{public}d', item.bundleName,
      item.appIndex, index);
    return true;
  }

  /**
   * 触发拖拽相关动效
   *
   * @param item 侧边dock中的item
   * @param scrollTranslate 滑动偏移量
   */
  private moveItem(item: GestureDockItemInfo, scrollTranslate: number): void {
    for (let index = 0; index < this.copyResidentApps.length; index++) {
      let dockItem = this.copyResidentApps[index];
      if (dockItem.bundleName !== item.bundleName || dockItem.appIndex !== item.appIndex) {
        const center: number = this.getGestureDockItemCenter(index, scrollTranslate)[1];
        log.showInfo(`moveItem,bundleName:${dockItem.bundleName} appIndex:${dockItem.appIndex} index:${index} \
        center:${center} `);
        this.desktopContext.eventHub.emit(GestureDockEventIdUtil.getStartSqueezeEventId(dockItem), center);
      }
    }
  }

  /**
   * 寻找最近落点
   *
   * @param dragPositionY 当前触点y坐标
   * @param scrollTranslate 滑动偏移量
   * @returns 最近落点索引
   */
  private findNearestArea(dragPositionY: number, scrollTranslate: number): number {
    // 挤位方案为空时，最近落点索引为0
    if (this.copyResidentApps.length === 0) {
      log.showInfo(`copyDockApps length === 0`);
      return 0;
    }
    let bestLocation: number = GestureDockConstants.INVALID_VALUE;
    let bestDistance: number = Number.MAX_SAFE_INTEGER;
    for (let i = 0; i < this.copyResidentApps.length; ++i) {
      if (CheckEmptyUtils.isEmpty(this.copyResidentApps[i].bundleName)) {
        continue;
      }
      let centerY: number = this.getGestureDockItemCenter(i, scrollTranslate)[1];
      let distance: number = Math.abs(centerY - dragPositionY);
      if (distance <= bestDistance) {
        bestDistance = distance;
        bestLocation = i;
      }
    }
    return bestLocation;
  }

  /**
   * 获取含指定元素个数的dock栏中索引对应元素中心点坐标
   * @param customIndex 自定义区的index
   * @param scrollTranslate 滑动偏移量
   * @returns center[x,y]
   */
  public getGestureDockItemCenter(customIndex: number, scrollTranslate: number): number[] {
    if (!this.dockRectInfo) {
      log.showInfo('getGestureDockItemCenter dockRectInfo is undefined')
      return [0, 0];
    }
    let iconSize = GestureDockConstants.GESTURE_DOCK_ICON_SIZE;
    let component = this.dockRectInfo;
    let recentWidth = this.recentAppLength === 0 ? 0 : (this.recentAppLength + 1) *
    GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE + this.recentAppLength * iconSize;
    let itemPosition = component.top + (customIndex + 1) * GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE +
      customIndex * iconSize + iconSize / 2 + recentWidth - scrollTranslate;
    return [(component.left + component.right) / 2, itemPosition];
  }

  /**
   * gesture dock栏内拖拽enter事件
   *
   * @param recentAppLength dock栏最近任务区数据
   * @param dockApps dock栏编辑区源数据
   * @param dockDirection dock方向
   */
  public handleDragEnter(recentAppLength: number, dockApps: GestureDockItemInfo[], dockDirection: number): void {
    let isGestureDockDrag = AppStorage.get('isGestureDockDrag') as boolean
    if (isGestureDockDrag) {
      log.showError('isGestureDockDrag,return');
      return;
    }
    this.dockDirection = dockDirection;
    this.dockRectInfo = ItemUtils.getRectById(`${GestureDockConstants.GESTURE_DOCK_SCROLL}${this.dockDirection}`);
    this.copyResidentApps.splice(0, this.copyResidentApps.length);
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    let dragItem: GestureDockItemInfo =
      AppStorage.get<GestureDockItemInfo>('gestureDockDragItemInfo') as GestureDockItemInfo;
    if (!residentApps || !dragItem) {
      log.showError('appStorage get empty value');
      return;
    }
    AppStorage.setOrCreate('isGestureDockDrag', true);
    log.showInfo(`handleDragEnter,dockApplength is ${dockApps.length} copyDockApps is ${this.copyResidentApps.length}`);
    for (let index = 0; index < residentApps.length; index++) {
      let dockItemInfo = residentApps[index];
      this.copyResidentApps.push(dockItemInfo);
      if (GestureDockUtil.areTwoAppItemsSame(dockItemInfo, dragItem)) {
        this.squeezeIndex = index;
      }
    }
    this.recentAppLength = recentAppLength > GestureDockConstants.GESTURE_DOCK_MAX_RECENT ?
    GestureDockConstants.GESTURE_DOCK_MAX_RECENT : recentAppLength;
    this.squeezeFromIndex = this.squeezeIndex;
    log.showInfo(`recent length is ${this.recentAppLength}, copy length is ${this.copyResidentApps.length},squeezeIndex is ${this.squeezeIndex}`);
  }
}