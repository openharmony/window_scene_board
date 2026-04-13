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

import { curves } from '@kit.ArkUI';
import {
  DomainName,
  LogDomain,
  LogHelper,
  StartType,
  TraceUtil
} from '@ohos/basicutils';
import { DeviceHelper, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { EventType, launcherStatusUtil, scbEventExclusiveManager } from '@ohos/windowscene';
import { DragAccessibilityUtils, dragSnapshotHelper, SnapshotType } from '@ohos/componenthelper';
import {
  AppItemInfo,
  editModeManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  MultiSelectManager
} from '../../TsIndex';
import { batchUninstallChain, ForwardType } from '../../editmode/viewModel/batchUninstall/BatchUninstallChain';
import { BadgeAnimationType } from '../../uicomponents/CustomBadge';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconLongPressGestureEventIface } from '../interface/AppIconLongPressGestureEventIface';
import { AppIconBadgeVm } from './AppIconBadgeVm';
import { AppIconMenuEvent } from './AppIconMenuEvent';
import { AppIconData } from './AppIconData';
import { AppIconBadgeEvent } from './AppIconBadgeEvent';
import { AppIconMenuVm } from './AppIconMenuVm';
import { lockLayoutManager } from '../../manager/LockLayoutManager';
import { DesktopItemVibratorManager } from '../../manager/DesktopItemVibratorManager';

const TAG = 'AppIconLongPressGestureEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
const LONG_PRESS_SNAPSHOT_DELAY: number = 50;

export interface AppIconLongPressEventParam {
  itemInfo: AppItemInfo;
  iconData: AppIconData;
  appIconConfig: AppIconConfig;
  iconBadgeVm: AppIconBadgeVm;
  iconMenuVm?: AppIconMenuVm;
  iconMenuEvent: AppIconMenuEvent;
  iconBadgeEvent: AppIconBadgeEvent;
  iconSizeCb?: () => number;
  iconDragBuilder: CustomBuilder;
  showLongPressContextMenu?: () => boolean;
}

export class AppIconLongPressGestureEvent implements AppIconLongPressGestureEventIface {
  private itemInfo?: AppItemInfo;
  private iconData?: AppIconData;
  private appIconConfig?: AppIconConfig;
  private iconBadgeVm?: AppIconBadgeVm;
  private iconMenuVm?: AppIconMenuVm;
  private iconMenuEvent?: AppIconMenuEvent;
  private iconBadgeEvent?: AppIconBadgeEvent;
  private iconSizeCb?: () => number;
  private iconDragBuilder?: CustomBuilder;
  private showLongPressContextMenu?: () => boolean;

  public initLongPressEventParam(param: AppIconLongPressEventParam): AppIconLongPressGestureEventIface {
    if (!param) {
      return this;
    }

    this.itemInfo = param.itemInfo;
    this.iconData = param.iconData;
    this.appIconConfig = param.appIconConfig;
    this.iconBadgeVm = param.iconBadgeVm;
    this.iconMenuVm = param.iconMenuVm;
    this.iconBadgeEvent = param.iconBadgeEvent;
    this.iconSizeCb = param.iconSizeCb;
    this.iconDragBuilder = param.iconDragBuilder;
    this.showLongPressContextMenu = param.showLongPressContextMenu;
    this.iconMenuEvent = param.iconMenuEvent;
    return this;
  }

  /**
   * 长按预汇聚事件
   * @param event GestureEvent
   */
  public onLongPressPreGatherAction(event: GestureEvent): void {
    if (this.canGather(this.appIconConfig?.enableMultiSelect as boolean) &&
    MultiSelectManager.getInstance().getStatus().isEntered) {
      this.onLongPressZoomIn();
      MultiSelectManager.getInstance().preGather(
        MultiSelectManager.getInstance().getUniqueId(this.itemInfo),
      );
    }
    this.appIconConfig?.externCb?.onLongPressPreGatherAction?.(event);
  }

  /**
   * 长按预汇聚事件结束
   * @param event GestureEvent
   */
  public onLongPressPreGatherActionEnd(event: GestureEvent): void {
    MultiSelectManager.getInstance().checkIsGatherStarted(event);
  }

  /**
   * 长按截图事件
   * @param event GestureEvent
   */
  public onLongPressSnapshotAction(event: GestureEvent): void {
    if (!editModeManager.isInEditMode() && this.iconBadgeVm?.animate) {
      this.iconBadgeVm.animate = BadgeAnimationType.OPACITY_ZERO;
    }

    this.onLongPressSnapshot(this.iconDragBuilder);
    if (!this.itemInfo || !this.iconData || !this.iconMenuEvent || !this.appIconConfig?.externCb) {
      log.showError('long press snapshot, getMenuInfo and position is invalid!');
      return;
    }

    this.iconMenuEvent.setMenuInfo(this.appIconConfig.externCb.getMenuInfo,
      this.appIconConfig.externCb.getNotInstalledMenuMap);

    // 长按350ms进入截图才设置菜单位置, 避免在touchDown计算影响点击首帧负载
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.iconMenuEvent.setOuterAppMenuPosition(this.itemInfo);
    } else {
      this.iconMenuEvent.setAppMenuPosition(event?.fingerList?.[0]?.displayX, this.iconData.iconId);
    }
  }

  /**
   * 长按截图事件结束
   * @param event GestureEvent
   */
  public onLongPressSnapshotActionEnd(event: GestureEvent): void {
    log.showDebug(`onLongPressSnapshotActionEnd isMenuShow: ${this.iconMenuVm?.isMenuShow()}`);
    if (this.iconBadgeVm && !this.iconMenuVm?.isMenuShow()) {
      this.iconBadgeVm.animate = BadgeAnimationType.TOUCH_UP;
    }
  }

  /**
   * 长按截图事件取消
   * @param event GestureEvent
   */
  public onLongPressSnapshotActionCancel(): void {
    if (this.iconBadgeVm) {
      this.iconBadgeVm.animate = BadgeAnimationType.TOUCH_UP;
    }
  }

  /**
   * 长按汇聚
   * @param event GestureEvent
   */
  public onLongPressGatherAction(event: GestureEvent): void {
    let enableMultiSelect: boolean = this.appIconConfig?.enableMultiSelect as boolean;
    if (this.canGather(enableMultiSelect)) {
      MultiSelectManager.getInstance().startGather(
        MultiSelectManager.getInstance().getUniqueId(this.itemInfo), event);
    }
    // 编辑模式 能够卸载的app 通知显示删除按钮
    if (editModeManager.isInEditMode() && this.appIconConfig?.enableDrag && this.itemInfo) {
      let batchItem: GridLayoutItemInfo[] = MultiSelectManager.getInstance().getAllSelectedGridItem(this.itemInfo);
      batchUninstallChain.forward(ForwardType.LONG_PRESS, batchItem);
    }
  }

  /**
   * 长按汇聚结束
   * @param event GestureEvent
   */
  public onLongPressGatherActionEnd(event: GestureEvent): void {
    // 编辑模式 通知隐藏删除按钮
    if (editModeManager.isInEditMode()) {
      batchUninstallChain.forward(ForwardType.LONG_PRESS_END);
    }
  }

  /**
   * 长按震动
   * @param event GestureEvent
   */
  public onLongPressVibrateAction(event: GestureEvent): void {
    log.showWarn(`onLongPressVibrateAction, bundleName: ${this.itemInfo?.bundleName}`);
    this.iconData?.setLongPressVibrated(true);

    // 锁定布局时弹出toast
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
    }

    if (!this.itemInfo) {
      log.showError('onLongPressVibrateAction failed, itemInfo is invalid!');
      return;
    }
    // 触发震动
    this.onLongPressVibrator(event);
    // 进入单选状态 隐藏
    const multiSelectManager = MultiSelectManager.getInstance();
    if (multiSelectManager.getStatus().isEntered) {
      multiSelectManager.startSingleDrag(multiSelectManager.getUniqueId(this.itemInfo));
    }

    if (this.appIconConfig?.enableMenu &&
      (this.appIconConfig?.enableMenuWithMouse || event?.source !== SourceType.Mouse)) {
      this.iconMenuEvent?.onLongPressShowMenu();
    }
  }

  /**
   * 长按震动结束
   * @param event GestureEvent
   */
  public onLongPressVibrateActionEnd(event: GestureEvent): void {
  }

  /**
   * 长按震动取消
   */
  public onLongPressVibrateActionCancel(): void {}

  /**
   * 长按缩放事件处理
   * @param event GestureEvent
   */
  public onLongPressZoomInAction(event: GestureEvent): void {
    if (this.showLongPressContextMenu?.()) {
      return;
    }

    this.onLongPressZoomIn();
  }

  /**
   * 长按500ms触发振动
   */
  public onLongPressVibrator(event: GestureEvent): void {
    if (event?.source === SourceType.Mouse && !this.appIconConfig?.enableMouseLongPressVibration) {
      log.showWarn('onLongPressVibrator, not response for Mouse');
      return;
    }
    // 编辑模式多选拖拽的振动和无障碍播报均在多选汇聚的逻辑中实现，此处仅单选拖拽场景调用
    if (!editModeManager.isInEditMode() || (editModeManager.isInEditMode() &&
      MultiSelectManager.getInstance().getAllSelectedItem().length <= 1)) {
      if (!scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
        DesktopItemVibratorManager.getInstance().longPressVibrator(TAG);
      }
      DragAccessibilityUtils.textAnnouncedForDragStart();
    }
  }

  private onLongPressZoomIn(): void {
    log.showInfo(`onLongPressZoomIn start, bundleName: ${this.itemInfo?.bundleName}`);
    this.iconData?.setIsLongPressHideMask(true);
    this.onIconLongPressZoomAnimation(false, this.itemInfo?.bundleName as string);
  }

  private canGather(enableMultiSelect: boolean): boolean {
    if (!enableMultiSelect) {
      return false;
    }

    if (!editModeManager.isInEditMode()) {
      return false;
    }

    if (!editModeManager.isDraggable(this.itemInfo as Object as GridLayoutItemInfo)) {
      return false;
    }

    return true;
  }

  /**
   * 图标长按动效
   * @param isZoomOut 是否缩小
   * @param bundleName 应用信息
   */
  public onIconLongPressZoomAnimation(isZoomOut: boolean, bundleName: string): void {
    if (isZoomOut) {
      log.showInfo(`${HiSysEventUtil.ICON_PRESS_ANI} zoom out, bundleName: ${bundleName}.`);
      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_ICON_PRESS_ANIMATION);
      this.iconData?.setTouchMaskVisible(true);
      animateTo({
        curve: curves.interpolatingSpring(1, 1, 410, 38),
        playMode: PlayMode.Normal,
        onFinish: () => {
          log.showInfo(`${HiSysEventUtil.ICON_PRESS_ANI} zoom out end, bundleName: ${bundleName}.`);
          TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_ICON_PRESS_ANIMATION);
        }
      }, () => {
        this.iconData?.setIconScale(0.9);
        this.iconBadgeEvent?.onIconScale(0.9, this.iconSizeCb?.() ?? 0);
      });
    } else {
      log.showInfo(`${HiSysEventUtil.ICON_PRESS_ANI} zoom in begin, bundleName: ${bundleName}.`);
      TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_ICON_PRESS_ANIMATION);
      animateTo({
        duration: 250,
        curve: Curve.Friction,
        playMode: PlayMode.Normal,
        onFinish: () => {
          log.showInfo(`${HiSysEventUtil.ICON_PRESS_ANI} zoom in end, bundleName: ${bundleName}.`);
          TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_ICON_PRESS_ANIMATION);
        }
      }, () => {
        this.iconData?.setIconScale(1.05);
        this.iconBadgeEvent?.onIconScale(1.05, this.iconSizeCb?.() ?? 0);
      });

      // 图标蒙层动效
      // touchMaskVisible不和scale在同一个动画闭包，避免蒙层与图标同时动画导致不贴合
      animateTo({
        duration: 250,
        curve: Curve.Linear
      }, () => {
        this.iconData?.setTouchMaskVisible(false);
      });
    }
  }

  /**
   * 触发长按截图
   *
   * @param iconBuilder 图标的builder
   */
  private onLongPressSnapshot(iconBuilder: CustomBuilder): void {
    log.showInfo(`start to snapshot key:${this.itemInfo?.keyName} image is null: ${!this.iconData?.image}.`);
    // 0ms 定时器确保UI刷新, builder截图正常截取canvas
    setTimeout(() => {
      dragSnapshotHelper.snapshotFromBuilder(iconBuilder, SnapshotType.BOTH,
        GridLayoutUtil.generateUniqueKey(this.itemInfo as Object as GridLayoutItemInfo), null,
        undefined, undefined, `appIconOnLongPressSnapshot`, LONG_PRESS_SNAPSHOT_DELAY);
    }, 0);
  }
}