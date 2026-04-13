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

import { dragController } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { LogDomain, Logger, PixelMapUtil } from '@ohos/basicutils';
import {
  CheckZoomResult,
  FormZoomDragEvtParams,
  FormZoomDragEvtType,
  ZoomHotArea,
  ZoomOffset,
  ZoomType,
} from '../common/FormZoomCommonType';
import { FormZoomComponent } from '../view/FormZoomComponent';
import { FormZoomUtil } from '../common/FormZoomUtil';
import { NORMAL_CARD_ALIGN_DEFAULT_MAP, THEME_CARD_ALIGN_DEFAULT_MAP } from '../common/FormZoomConstants';
import { ZoomBarVisible } from './FormZoomVm';

const TAG: string = 'FormZoomController';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const DRAG_FORM_EXTRA_INFO: string = 'form_zoom_drag_action';

class FormZoomController {
  private formZoomComponent?: FormZoomComponent;
  private mHotArea: ZoomHotArea = FormZoomUtil.AREA_NONE;
  private dragAction?: dragController.DragAction;
  private dragStartPos?: Position;
  private currentZoomResult?: CheckZoomResult;

  public isMenuPreviewDragging(extraParams?: string): boolean {
    return this.mHotArea.position > 0 && (extraParams || '').includes(DRAG_FORM_EXTRA_INFO);
  }

  public bindFormZoomComponent(formZoomComponent: FormZoomComponent): void {
    this.formZoomComponent = formZoomComponent;
  }

  public unbindFormZoomComponent(): void {
    this.formZoomComponent = undefined;
  }

  public getDragStartPos(): Position | undefined {
    return this.dragStartPos;
  }

  public setDragStartPos(pos: Position): void {
    this.dragStartPos = pos;
  }

  public setDragState(value: boolean): void {
    if (this.formZoomComponent) {
      this.formZoomComponent.inDrag = value;
    }
  }

  public getDragState(): boolean {
    if (this.formZoomComponent) {
      return this.formZoomComponent.inDrag;
    }
    return false;
  }

  public handleDragFormZoom(params: FormZoomDragEvtParams): void {
    if (this.formZoomComponent) {
      if (params.type === FormZoomDragEvtType.DRAG_MOVE) {
        let zoomType: ZoomType = FormZoomUtil.getZoomType(this.mHotArea.position, params.offsetX, params.offsetY);
        let zoomOffset: ZoomOffset = FormZoomUtil.getOffset(this.mHotArea.position, params.offsetX, params.offsetY);
        let defaultAlignContent: Alignment = NORMAL_CARD_ALIGN_DEFAULT_MAP.get(this.mHotArea.position) as Alignment;
        if (this.currentZoomResult?.zoomType !== zoomType) {
          log.showWarn(TAG, 'drag zoom type changed');
          this.formZoomComponent.barVisible = new ZoomBarVisible(
            this.mHotArea.offsetX === '-50%',
            this.mHotArea.offsetY === '-50%',
            this.mHotArea.offsetX === '50%',
            this.mHotArea.offsetY === '50%',
          );
          this.currentZoomResult = FormZoomUtil.checkZoom(this.mHotArea.position,
            zoomType, this.formZoomComponent.mFormZoomEvent.getFormItem());
        }
        this.formZoomComponent.mFormZoomEvent.onDragZoomMove(this.currentZoomResult, zoomOffset, defaultAlignContent);
      } else if (params.type === FormZoomDragEvtType.DRAG_END) {
        this.formZoomComponent.barVisible = new ZoomBarVisible(true, true, true, true);
        this.formZoomComponent.mFormZoomEvent.onDragZoomEnd();
        this.dragStartPos = undefined;
        this.currentZoomResult = undefined;
      }
    }
  }

  public async startDrag(hotArea: ZoomHotArea): Promise<void> {
    try {
      log.showInfo(TAG, `form zoom start drag, hot area position: ${hotArea.position}`);
      let map = image.createPixelMapSync(new ArrayBuffer(4), { pixelFormat: 3, size: { height: 1, width: 1 } });
      PixelMapUtil.addName(map, 'FormZoomStartDrag');

      this.dragAction = dragController.createDragAction([{
        pixelMap: map,
        extraInfo: DRAG_FORM_EXTRA_INFO,
      }], {
        pointerId: 0,
      });
      this.mHotArea = hotArea;
      this.dragAction.on('statusChange', this.dragActionStatusChange);
      await this.dragAction.startDrag();
    } catch (err) {
      log.showError(TAG, `form zoom start drag error: ${err?.code}, ${err?.message}`);
    }
  }

  private dragActionStatusChange = (dragAndDropInfo: dragController.DragAndDropInfo): void => {
    if (dragAndDropInfo.status === dragController.DragStatus.STARTED) {
      log.showInfo(TAG, 'form zoom drag action start');
      this.setDragState(true);
    } else if (dragAndDropInfo.status === dragController.DragStatus.ENDED) {
      log.showInfo(TAG, 'form zoom drag action end');
      const params: FormZoomDragEvtParams = {
        type: FormZoomDragEvtType.DRAG_END,
        offsetX: 0,
        offsetY: 0,
      };
      formZoomController.handleDragFormZoom(params);
      this.dragAction?.off('statusChange', this.dragActionStatusChange);
    }
  }
}

export const formZoomController = new FormZoomController();