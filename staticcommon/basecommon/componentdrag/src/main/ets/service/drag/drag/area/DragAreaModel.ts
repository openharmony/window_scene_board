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

import { DragEvent } from 'DragControllerParam';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { dragContext, DragContextType } from '../../common/recover/DragContext';
import { dragRecoverManager } from '../../common/recover/DragRecoverManager';
import { ShareDataManager } from '../../common/share/ShareDataManager';
import { ShareDragInfo } from '../../common/share/ShareDragInfo';
import { ShareDragLayout } from '../../common/share/ShareDragLayout';
import {
  DragGridInfo,
  DragGridLayout,
  DragGridPosition,
  DragCallbackParams,
} from '../../common/type/CommonTypes';
import { DragParams } from '../../common/type/DragTypes';
import { DragUtils } from '../../common/utils/DragUtils';
import { DragModel } from '../model/DragModel';

const TAG = 'Drag-DragAreaModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 拖拽AREA热区模块
 */
export class DragAreaModel extends DragModel {
  private areaDragEnterCallback: (params: DragCallbackParams) => void;
  private areaDragLeaveCallback: (params: DragCallbackParams) => void;
  private areaDragDropCallback: (params: DragCallbackParams) => void;
  private shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
  private shareDragLayout: ShareDragLayout = ShareDataManager.getInstance(ShareDragLayout, 'ShareDragLayout');

  constructor(params: DragParams) {
    super();
    this.areaDragEnterCallback = params.areaDragEnterCallback;
    this.areaDragLeaveCallback = params.areaDragLeaveCallback;
    this.areaDragDropCallback = params.areaDragDropCallback;
    this.shareDragLayout.setGridLayout(params.dragLayout);
    log.showInfo('layout length: %{public}d', this.shareDragLayout.getLayout().length);
  }

  public start(event: DragEvent, extraParams?: string): void {
    log.showWarn('It is not necessary to register start-callback for DragAreaModel');
    return;
  }

  public end(event: DragEvent, extraParams?: string): void {
    log.showWarn('It is not necessary to register end-callback for DragAreaModel');
    return;
  }

  public enter(event: DragEvent, extraParams?: string): void {
    try {
      dragContext.addContent(DragContextType.DRAG_AREA, this);
      dragContext.setDragParam(event, extraParams);
      dragRecoverManager.startDragTimer();
      let dragInfo: DragGridInfo = this.shareDragInfo.getDragInfo();
      let gridLayout: DragGridLayout = this.shareDragLayout.getGridLayout();
      let gridPosition: DragGridPosition =
        DragUtils.getNearestGridPosition(event, dragInfo.dragItem[0], gridLayout.gridParam);
      if (this.areaDragEnterCallback) {
        this.areaDragEnterCallback(DragUtils.buildDragCallbackParams(event, extraParams, dragInfo, gridPosition));
      }
    } catch (err) {
      log.showError(`enter error: ${err}`);
    }
  }

  public leave(event: DragEvent, extraParams?: string): void {
    try {
      dragContext.removeContent(DragContextType.DRAG_AREA, this);
      dragContext.setDragParam(event, extraParams);
      dragRecoverManager.clearDragTimer();
      let dragInfo: DragGridInfo = this.shareDragInfo.getDragInfo();
      let gridLayout: DragGridLayout = this.shareDragLayout.getGridLayout();
      let gridPosition: DragGridPosition =
        DragUtils.getNearestGridPosition(event, dragInfo.dragItem[0], gridLayout.gridParam);
      if (this.areaDragLeaveCallback) {
        this.areaDragLeaveCallback(DragUtils.buildDragCallbackParams(event, extraParams, dragInfo, gridPosition));
      }
      this.shareDragLayout.setGridLayout(null);
    } catch (err) {
      log.showError(`leave error: ${err}`);
    }
  }

  public drop(event: DragEvent, extraParams?: string): void {
    try {
      dragContext.removeContent(DragContextType.DRAG_AREA, this);
      dragContext.setDragParam(event, extraParams);
      dragRecoverManager.clearDragTimer();
      let dragInfo: DragGridInfo = this.shareDragInfo.getDragInfo();
      let gridLayout: DragGridLayout = this.shareDragLayout.getGridLayout();
      let gridPosition: DragGridPosition =
        DragUtils.getNearestGridPosition(event, dragInfo.dragItem[0], gridLayout.gridParam);
      if (this.areaDragDropCallback) {
        this.areaDragDropCallback(DragUtils.buildDragCallbackParams(event, extraParams, dragInfo, gridPosition));
      }
      this.shareDragLayout.setGridLayout(null);
    } catch (err) {
      log.showError(`drop error: ${err}`);
    }
  }

  /**
   * 清空拖拽热区状态，手动触发leave
   */
  public release(): void {
    if (dragContext.event) {
      log.showInfo('release drag area info');
      this.leave(dragContext.event, dragContext.extraParams);
    }
  }
}