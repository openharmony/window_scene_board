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

import { DragEvent } from 'DragControllerParam';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ShareDataManager } from '../../common/share/ShareDataManager';
import { ShareDragInfo } from '../../common/share/ShareDragInfo';
import { ShareDragStatus } from '../../common/share/ShareDragStatus';
import { DragCallbackParams } from '../../common/type/CommonTypes';
import { DragParams } from '../../common/type/DragTypes';
import { DragUtils } from '../../common/utils/DragUtils';
import { DragModel } from '../model/DragModel';
import { DragListenerManager } from '../manager/DragListenerManager';
import { dragContext, DragContextType } from '../../common/recover/DragContext';
import { dragRecoverManager } from '../../common/recover/DragRecoverManager';

const TAG = 'Drag-DragItemModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 拖拽ITEM被拖模块
 */
export class DragItemModel extends DragModel {
  private itemDragStartCallback: (params: DragCallbackParams) => void;
  private itemDragEndCallback: (params: DragCallbackParams) => void;
  private shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
  private shareDragStatus: ShareDragStatus = ShareDataManager.getInstance(ShareDragStatus, 'ShareDragStatus');
  private itemKey: string;

  constructor(params: DragParams) {
    super();
    this.itemDragStartCallback = params.itemDragStartCallback;
    this.itemDragEndCallback = params.itemDragEndCallback;
    this.shareDragInfo.setDragInfo(params.dragInfo);
    this.itemKey = params.key;
    log.showInfo('dragItem length: %{public}d', this.shareDragInfo.getDragItem().length);
  }

  public start(event: DragEvent, extraParams?: string): void {
    dragContext.addContent(DragContextType.DRAG_ITEM, this);
    dragContext.setDragParam(event, extraParams);
    dragRecoverManager.startDragTimer();
    this.shareDragStatus.startDrag();
    if (this.itemDragStartCallback) {
      this.itemDragStartCallback(
        DragUtils.buildDragCallbackParams(event, extraParams, this.shareDragInfo.getDragInfo()));
    }
    DragListenerManager.getInstance().notifyDragStart(this.shareDragInfo.getDragInfo(), this.itemKey);
  }

  public end(event: DragEvent, extraParams?: string): void {
    dragContext.removeContent(DragContextType.DRAG_ITEM, this);
    dragContext.setDragParam(event, extraParams);
    dragRecoverManager.clearDragTimer();
    if (this.itemDragEndCallback) {
      this.itemDragEndCallback(DragUtils.buildDragCallbackParams(event, extraParams, this.shareDragInfo.getDragInfo()));
    }
    DragListenerManager.getInstance().notifyDragEnd(this.shareDragInfo.getDragInfo(), this.itemKey);
    this.shareDragStatus.stopDrag();
    this.shareDragInfo.setDragInfo(null);
  }

  public enter(event: DragEvent, extraParams?: string): void {
    log.showWarn('It is not necessary to register enter-callback for DragItemModel');
    return;
  }

  public leave(event: DragEvent, extraParams?: string): void {
    log.showWarn('It is not necessary to register leave-callback for DragItemModel');
    return;
  }

  public drop(event: DragEvent, extraParams?: string): void {
    log.showWarn('It is not necessary to register drop-callback for DragItemModel');
    return;
  }

  /**
   * 清空拖拽元素状态，手动触发end
   */
  public release(): void {
    if (dragContext.event) {
      log.showInfo('release drag item info');
      this.end(dragContext.event, dragContext.extraParams);
    }
  }
}