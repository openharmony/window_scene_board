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

import { performanceMonitor } from '@kit.ArkUI';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper';
import { DropAnimationScene } from '@ohos/componentanimator';
import { DragDataType, DragEventManager, DragExtraInfo } from '@ohos/componentdrag';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import {
  AppItemInfo,
  CommonConstants,
  editModeManager,
  EditModeUtils,
  EventConstants,
  GridLayoutItemInfo,
  GridLayoutUtil
} from '../../TsIndex';
import { BadgeAnimationType } from '../../uicomponents/CustomBadge';
import { AppIconDragEventIface } from '../interface/AppIconDragEventIface';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconData } from './AppIconData';
import { AppIconMenuVm } from './AppIconMenuVm';
import { AppIconBadgeVm } from './AppIconBadgeVm';
import { AppIconBadgeEvent } from './AppIconBadgeEvent';
import { launcherStatusUtil } from '@ohos/windowscene';
import { dragSnapshotHelper, SnapshotType } from '@ohos/componenthelper';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG = 'AppIconDragEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export interface AppIconDragEventParam {
  itemInfo: AppItemInfo;
  iconData: AppIconData;
  appIconConfig: AppIconConfig;
  iconMenuVm: AppIconMenuVm;
  iconSizeCb: () => number;
  iconBadgeVm: AppIconBadgeVm;
  iconBadgeEvent: AppIconBadgeEvent;
  dragIconBuilder: CustomBuilder;
}

export class AppIconDragEvent implements AppIconDragEventIface {
  private itemInfo?: AppItemInfo;
  private iconData?: AppIconData;
  private appIconConfig?: AppIconConfig;
  private iconMenuVm?: AppIconMenuVm;
  private iconSizeCb?: () => number;
  private iconBadgeVm?: AppIconBadgeVm;
  private iconBadgeEvent?: AppIconBadgeEvent;
  private dragIconBuilder?: CustomBuilder;

  public initDragParam(param: AppIconDragEventParam): AppIconDragEventIface {
    if (!param) {
      return this;
    }

    this.itemInfo = param.itemInfo;
    this.iconData = param.iconData;
    this.appIconConfig = param.appIconConfig;
    this.iconMenuVm = param.iconMenuVm;
    this.iconSizeCb = param.iconSizeCb;
    this.iconBadgeVm = param.iconBadgeVm;
    this.iconBadgeEvent = param.iconBadgeEvent;
    this.dragIconBuilder = param.dragIconBuilder;
    return this;
  }

  /**
   * 拖拽开始回调
   * @param event DragEvent
   * @returns CustomBuilder | DragItemInfo
   */
  public onDragStart(event: DragEvent): CustomBuilder | DragItemInfo {
    if (!this.itemInfo || !this.iconData) {
      log.showError('onDragStart failed, itemInfo or iconData is invalid!');
      return {} as DragItemInfo;
    }

    log.showInfo('onDragStart.');
    this.iconMenuVm?.setIsMenuShow(false);

    if (this.iconData.iconOpacity <= 0) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT, 1);
    }

    performanceMonitor.begin(HiSysEventUtil.DRAG_ITEM_ANI, performanceMonitor.ActionType.FIRST_MOVE, 'item:[App]');
    TraceUtil.startTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    this.iconData.isDragFlag = true;

    AppStorage.setOrCreate<boolean>('isDrag', true);
    ContextMenu.close();
    AppStorage.setOrCreate<number>('dragItemType', CommonConstants.DRAG_FROM_DESKTOP);
    AppStorage.setOrCreate<AppItemInfo>('dragItemInfo', this.itemInfo);
    log.showInfo('drag start: %{public}s.%{public}s.%{public}s, page: %{public}d, column: %{public}d, row: %{public}d.',
      this.itemInfo.bundleName, this.itemInfo.abilityName, this.itemInfo.moduleName,
      this.itemInfo.page, this.itemInfo.column, this.itemInfo.row);
    log.showInfo(`keyName: ${this.itemInfo.keyName}.`);

    const iconSize: number = this.iconSizeCb?.() ?? 0;
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP,
      GridLayoutUtil.generateUniqueKey(this.itemInfo as Object as GridLayoutItemInfo))
    ?.setWidth(EditModeUtils.convertWithDesktopScale(iconSize))
      .setHeight(EditModeUtils.convertWithDesktopScale(iconSize));

    // 同步执行外部的dragStartExtend接口
    this.appIconConfig?.externCb?.dragStartExtend?.(event);

    let dragItemInfo: DragItemInfo = {
      extraInfo: new DragExtraInfo(DragDataType.APP).setRadius(CommonConstants.DEFAULT_ICON_RADIUS).toString(),
      pixelMap: dragSnapshotHelper.getSnapshot(SnapshotType.DRAG,
        GridLayoutUtil.generateUniqueKey(this.itemInfo as Object as GridLayoutItemInfo))
    };
    return dragItemInfo;
  }

  /**
   * 拖拽结束回调
   * @param event DragEvent
   */
  public onDragEnd(event: DragEvent): void {
    if (!this.itemInfo || !this.iconData || !event) {
      log.showError('onDragEnd failed, itemInfo or iconData or event is invalid!');
      return;
    }

    log.showInfo('drag app end, position is [%{public}d, %{public}d], drag result is %{public}d.',
      event.getWindowX(), event.getWindowY(), event.getResult());
    this.iconData.isDragFlag = false;

    // 同步执行外部的dragEndExtend接口
    this.appIconConfig?.externCb?.dragEndExtend?.(event);
    DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).startDrop(
      GridLayoutUtil.generateUniqueKey(this.itemInfo as Object as GridLayoutItemInfo));
    AppStorage.setOrCreate<boolean>('isDrag', false);
    AppStorage.setOrCreate<Object>('dragItemInfo', {});
    if (!CommonUtils.equals(this.iconData.iconScale, 1)) {
      this.iconData.setIconScale(1);
      this.iconBadgeEvent?.onIconScale(1, this.iconSizeCb?.() as number);
    }
    this.iconData.touchMaskVisible = false;
  }

  /**
   * 拖拽前预处理
   * @param preDragStatus PreDragStatus
   */
  public onPreDrag(preDragStatus: PreDragStatus): void {
    if ((preDragStatus === PreDragStatus.PREVIEW_LANDING_FINISHED ||
      preDragStatus === PreDragStatus.ACTION_CANCELED_BEFORE_DRAG) &&
      !editModeManager.isInEditMode() && !this.iconMenuVm?.isMenuShow()) {
      log.showInfo(`preDragStatus: ${preDragStatus}.`);
      if (this.iconBadgeVm) {
        this.iconBadgeVm.animate = BadgeAnimationType.TOUCH_UP;
      }
    }
  }

  /**
   * 获取DragPreview Builder
   * @returns string | CustomBuilder | DragItemInfo
   */
  public getDragPreviewBuilder(): string | CustomBuilder | DragItemInfo | undefined {
    if (this.appIconConfig?.externCb?.getDragIconBuilder) {
      return this.appIconConfig?.externCb?.getDragIconBuilder?.();
    }
    return this.dragIconBuilder;
  }
}