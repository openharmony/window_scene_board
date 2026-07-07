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

import type ctx from '@ohos.app.ability.common';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { AppStorageUtil, DataProperty, LogDomain, LogHelper, } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, localEventManager } from '@ohos/frameworkwrapper';
import { BaseDragHandler, DragDataType, DragEventManager, DragExtraInfo } from '@ohos/componentdrag';
import { DropAnimationScene } from '@ohos/componentanimator';
import {
  CardItemInfo,
  CommonConstants,
  desktopItemDraggableManager,
  editModeManager,
  EditModeUtils,
  EventConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  StyleConstants,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AiSuggestionFormManager } from '../manager/AiSuggestionFormManager';
import { AiSuggestionViewData } from '../viewmodel/AiSuggestionViewData';
import { AiSuggestionItemStateController } from './AiSuggestionItemStateController';
import { dragSnapshotHelper, SnapshotType } from '@ohos/componenthelper/src/main/ets/utils/DragSnapshotHelper';
import { launcherStatusUtil, ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';

const TAG = 'AiSuggestionDragEventProcessor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * AiSuggestionComponent view model
 */
export class AiSuggestionDragEventProcessor {
  private formItem: GridLayoutItemInfo;
  private containerId: string;
  private containerIdWithName: string;
  private formItemWidth: number;
  private formItemHeight: number;
  private formBorderRadius: number;
  private eventIds: Map<string, Function>;
  private pageDesktopDragHandler?: BaseDragHandler;
  private itemStateController: AiSuggestionItemStateController;
  private viewData: AiSuggestionViewData;
  private desktopContext?: ctx.ServiceExtensionContext = GlobalContext.getContext();
  private formItemKey: string;

  constructor(params: DragEventParams) {
    this.formItem = params.formItem;
    this.containerId = params.containerId;
    this.containerIdWithName = params.containerIdWithName;
    this.formItemWidth = params.formItemWidth;
    this.formItemHeight = params.formItemHeight;
    this.formBorderRadius = params.formBorderRadius;
    this.eventIds = params.eventIds;
    this.pageDesktopDragHandler = params.pageDesktopDragHandler;
    this.itemStateController = params.itemStateController;
    this.viewData = params.viewData;
    this.formItemKey = GridLayoutUtil.generateUniqueKey(this.formItem);
    log.showInfo(`create drag event processor, cardId=${this.formItem.cardId}`);
  }

  public setFormSize(width: number, height: number) {
    log.showInfo(`setFormSize: [${width}, ${height}]`);
    if (!width || !height || width <= 0 || height <= 0) {
      log.showError('invalid size!');
      return;
    }
    this.formItemWidth = width;
    this.formItemHeight = height;
  }

  private onFormItemDraggedRemoved(cardId: string, thisCardId: string): void {
    if (cardId === thisCardId) {
      AiSuggestionFormManager.getInstance().deleteCardInfo(cardId);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FALL_BOX_HIDE,
        TAG + ' onFormItemDraggedRemoved');
    }
  }

  public dragStart(event: DragEvent, itemUniqueKey: string, isOuterDesktop: boolean = false): DragItemInfo {
    let x: number = event.getWindowX();
    let y: number = event.getWindowY();
    log.showInfo(`form onDragStart event: [${x}, ${y}]`);
    this.viewData.isMenuShow = false;
    const pixMap = dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, itemUniqueKey);
    //语音助手建议卡片上层组件设置了padding值，Y轴需要设置偏差值，避免PC端落位出现偏差
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, this.formItemKey)
      ?.setWidth(EditModeUtils.convertWithDesktopScale(this.formItemWidth))
      .setHeight(EditModeUtils.convertWithDesktopScale(this.formItemHeight))
      .setRadius(isOuterDesktop ? ResUtils.getNumber($r('app.float.form_corner_radius')) :
      EditModeUtils.convertWithDesktopScale(this.formBorderRadius))
      .setUseEffect(!SCBVisualEffectMgr.isFolderSolidColor());

    const eventName: string = 'formItemDraggedRemoved';
    this.desktopContext?.eventHub.off(eventName);
    let dragRemovedEventHandler: (cardId: string) => void = (cardId: string): void =>
      this.onFormItemDraggedRemoved(cardId, this.formItem.cardId ?? '');
    this.desktopContext?.eventHub.on(eventName, dragRemovedEventHandler);
    this.eventIds.set(eventName, dragRemovedEventHandler);
    AppStorageUtil.setOrCreate('isDrag', true, new DataProperty(true, false));
    ContextMenu.close();
    AppStorageUtil.setOrCreate('selectItem', '', new DataProperty(false, false));
    if (!DeviceHelper.isPhone()) {
      AppStorageUtil.setOrCreate('selectDesktopItem', [], new DataProperty(false, false, 'string[]'));
    }
    AppStorageUtil.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_DESKTOP, new DataProperty(true, false));
    AppStorageUtil.setOrCreate('dragItemInfo', this.formItem, new DataProperty(true, false, 'GridLayoutItemInfo'));

    if (editModeManager.isInEditMode()) {
      this.itemStateController.prepareToUninstall();
    }
    this.pageDesktopDragHandler?.onDragStart(x, y);
    log.showInfo(`onDragStart event: [${x}, ${y}]`);

    // 这里drag_data_type必须是scb_folder，才能在拖拽时有背景模糊效果
    let dragItemInfo: DragItemInfo = {
      extraInfo: new DragExtraInfo(DragDataType.FOLDER).setRadius(this.formBorderRadius).toString(),
      pixelMap: pixMap,
    };
    return dragItemInfo;
  }

  public dragEnd(): void {
    this.itemStateController.setAppNameBackgroundColor(StyleConstants.DEFAULT_DESKTOP_BACKGROUND_COLOR);
    log.showInfo(`form onDragEnd event, animateScale=${this.viewData.animateScale}`);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, true);
    AppStorageUtil.setOrCreate('isDrag', false, new DataProperty(true, false));
    DragEventManager.getInstance(false).startDrop(this.formItemKey);
    AppStorageUtil.setOrCreate('dragItemInfo', new CardItemInfo(), new DataProperty(true, false, 'CardItemInfo'));
    if (!this.viewData.isFormShow) {
      this.viewData.isFormShow = true;
    }
    // 拖拽结束后，将hover动效放大的图标设置为初始值，防止落位动效完成后，出现图标一帧变大
    this.viewData.animateScale = 1;
    this.desktopContext?.eventHub.emit('appIconLongPressEffectCancel');
  }

  public destroy(): void {
    log.showInfo('destroy drag event processor');
  }

  /**
   * 判断是否接受对应的手势
   *
   * @param gestureInfo 手势信息
   * @param event 手势事件
   * @returns 是否接受对应的手势
   */
  public onGestureJudgeBegin(gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult {
    if (gestureInfo.type === GestureControl.GestureType.DRAG) {
      if (editModeManager.isInEditMode() &&
        !editModeManager.isDraggable(this.formItem) || !desktopItemDraggableManager.getEnableDrag()) {
        return GestureJudgeResult.REJECT;
      }
    }
    return GestureJudgeResult.CONTINUE;
  }
}

export interface DragEventParams {
  formItem: GridLayoutItemInfo;
  containerId: string;
  containerIdWithName: string;
  formItemWidth: number;
  formItemHeight: number;
  formBorderRadius: number;
  eventIds: Map<string, Function>;
  pageDesktopDragHandler?: BaseDragHandler;
  itemStateController: AiSuggestionItemStateController;
  viewData: AiSuggestionViewData;
}
