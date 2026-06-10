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

import { dragController, Position } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { EditModePageActionEnum } from '../data/PageEditData';

const TAG = 'pageDragAction';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 页面拖拽事件类参数
 */
export class PageDragParamsType {
  /**
   * 拖拽页面
   */
  public dragItemImage?: image.PixelMap;

  /**
   * 拖拽跟手点
   */
  public touchPoint?: Position;
  /**
   * 拖拽图标圆角
   */
  public imageRadius: number = 0;

  /**
   * 拖拽开始回调
   */
  public onDragStart?: () => void;

  /**
   * 拖拽松手回调
   */
  public onDragEnd?: () => void;

  /**
   * 拖拽失败
   */
  public onDragCancel?: () => void;

  /**
   * 拖拽流程结束
   */
  public onDragFinish?: () => void;
}

//拖拽页面对象
export class DragingPageType {
  public width: number = 0;
  public height: number = 0;
  public defaultX: number = 0;
  public defaultY: number = 0;
  public targetX: number = 0;
  public targetY: number = 0;
  public image?: image.PixelMap;
  public pageIndex: number = 0;
  public pageKey: number = 0;
  public radius: number = 0;
  public animationType?: EditModePageActionEnum;
}

export class PageDragAction {
  private dragAction?: dragController.DragAction;
  private dragParams: PageDragParamsType;

  constructor(params: PageDragParamsType) {
    log.showInfo(`createDrag touchPoint:%{public}d %{public}d`, params.touchPoint?.x, params.touchPoint?.y);
    this.dragParams = params;
  };


  /**
   * 触发拖拽
   */
  public async executeDrag(uiContext?: UIContext): Promise<boolean> {
    try {
      const dragInfo: dragController.DragInfo = {
        pointerId: 0,
        touchPoint: this.dragParams.touchPoint,
        previewOptions:
          { mode: DragPreviewMode.DISABLE_SCALE }
      };
      const dragItemInfo: DragItemInfo = {
        pixelMap: this.dragParams.dragItemImage,
      };
      if (!uiContext) {
        this.dragAction = dragController.createDragAction(
          [dragItemInfo],
          dragInfo
        );
      } else {
        this.dragAction = uiContext.getDragController().createDragAction(
          [dragItemInfo],
          dragInfo
        );
      }
      this.dragAction?.on('statusChange', (dragAndDropInfo: dragController.DragAndDropInfo) => {
        this.handleDragCallback(dragAndDropInfo);
      });
      await this.dragAction?.startDrag();
      return true;
    } catch (error) {
      log.showError('page start drag Error:' + error.message);
    }
    this.onDragCancel();
    this.onDragFinish();
    return false;
  };

  /**
   * 拖拽事件处理
   *
   * @param dragAndDropInfo 拖拽及落位信息
   */
  protected handleDragCallback(dragAndDropInfo: dragController.DragAndDropInfo): void {
    if (dragAndDropInfo.status === dragController.DragStatus.STARTED) {
      log.showInfo('Drag start');
      this.onDragStart();
    } else if (dragAndDropInfo.status === dragController.DragStatus.ENDED) {
      log.showInfo('Drag end');
      if (!this.dragAction) {
        return;
      }
      this.dragAction.off('statusChange');
      this.dragAction = undefined;
      this.onDragEnd?.();
      this.onDragFinish?.();
    }
  };

  /**
  * 拖拽开始
  */
  private onDragStart(): void {
    log.showInfo('onDragStart');
    this.dragParams.onDragStart?.();
  }

  /**
   * 拖拽结束
   */
  private onDragEnd(): void {
    log.showInfo('onDragEnd');
    this.dragParams.onDragEnd?.();
  }

  /**
   * 拖拽异常结束
   */
  private onDragCancel(): void {
    log.showInfo('onDragCancel');
    this.dragParams.onDragCancel?.();
  }

  /**
   * 拖拽结束或者异常结束后回调
   */
  private onDragFinish(): void {
    log.showInfo('onDragFinish');
    this.dragParams.onDragFinish?.();
  }
}