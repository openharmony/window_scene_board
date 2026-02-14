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

import dragController from '@ohos.arkui.dragController';
import image from '@ohos.multimedia.image';
import { DragEvent, DragItemInfo } from 'DragControllerParam';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SingletonHelper } from '@ohos/basicutils';
import { dragSnapshotHelper, SnapshotType } from './DragSnapshotHelper';

const TAG: string = 'DragControllerUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 应用侧主动发起拖拽工具类
 */
export class DragControllerUtil {
  private dragAction: dragController.DragAction | null = null;

  /**
   * 发起拖拽
   *
   * @param params 发起拖拽所需参数
   * @returns 是否发起成功
   */
  public async executeDrag(params: DragControllerParams, triggerX: number, triggerY: number): Promise<boolean> {
    if (this.dragAction) {
      log.showWarn('executeDrag interrupt with repeated execute');
      return false;
    }
    if (!this.checkParams(params)) {
      log.showWarn('executeDrag interrupt with invalid params');
      return false;
    }

    try {
      log.showInfo('executeDrag start');
      this.dragAction = dragController.createDragAction(params.dragItemInfo, params.dragInfo);
      this.dragAction.on('statusChange', (dragAndDropInfo: dragController.DragAndDropInfo) => {
        this.dragStatusChange(dragAndDropInfo, params, triggerX, triggerY);
      });
      await this.dragAction.startDrag();
      return true;
    } catch (err) {
      log.error('executeDrag error:', err);
      this.dragAction = null;
    }
    return false;
  }

  /**
   * 拖拽状态变化监听，仅用于提高DT覆盖率，其他场景不可直接调用
   *
   * @param dragAndDropInfo 拖拽过程中监听到status改变时上报的数据
   * @param params 发起拖拽所需参数
   */
  public dragStatusChange(dragAndDropInfo: dragController.DragAndDropInfo, params: DragControllerParams,
    triggerX: number, triggerY: number): void {
    if (dragAndDropInfo.status === dragController.DragStatus.STARTED) {
      log.showInfo('dragAction start');
      // 拖拽状态监听中返回的dragEvent暂无触点信息，已推动底座添加触点信息，待底座修改上库后回退此处修改
      // 此处根据触点信息手动构造event，保证pc上挤位功能正常
      let event: DragEvent = {
        getWindowX: ((): number => { return triggerX }),
        getWindowY: ((): number => { return triggerY }),
      } as DragEvent;
      params.dragStartCallback?.(event);
    }
    if (dragAndDropInfo.status === dragController.DragStatus.ENDED) {
      log.showInfo('dragAction end');
      params.dragEndCallback?.(dragAndDropInfo.event);
      this.dragAction?.off('statusChange');
      this.dragAction = null;
    }
  }

  private checkParams(params: DragControllerParams): boolean {
    if (!params.dragItemInfo || !params.dragInfo || !params.dragInfo.touchPoint) {
      return false;
    }

    let res: boolean = true;
    let touchPoint: TouchPoint = params.dragInfo.touchPoint;
    let minWidth: number = Number.MAX_VALUE;
    let minHeight: number = Number.MAX_VALUE;
    // 传入key时，通过key获取拖拽对象截图，并写入对应的dragItemInfo
    if (params.key && params.key.length !== 0) {
      for (let i = 0; i < params.key.length; i++) {
        let snapshot: image.PixelMap | undefined = dragSnapshotHelper.getSnapshot(SnapshotType.DRAG, params.key[i]);
        if (!snapshot) {
          res = false;
          log.showWarn('unready snapshot, key: %{public}s', params.key[i]);
          break;
        }
        params.dragItemInfo[i].pixelMap = snapshot;
        let imageSize: Size = snapshot.getImageInfoSync().size;
        minWidth = Math.min(minWidth, px2vp(imageSize.width));
        minHeight = Math.min(minHeight, px2vp(imageSize.height));
      }
    }
    // 当配置的跟手点坐标超出跟手图尺寸时，清除配置的跟手点，使用底座默认的跟手点，保证拖拽的正常触发
    if (touchPoint.x < 0 || touchPoint.y < 0 || touchPoint.x > minWidth || touchPoint.y > minHeight) {
      log.showWarn('invalid touchPoint, pointInfo: [%{public}d, %{public}d]', touchPoint.x, touchPoint.y);
      params.dragInfo.touchPoint = undefined;
    }
    return res;
  }
}

/**
 * 发起拖拽所需参数
 */
export interface DragControllerParams {
  /**
   * 拖拽元素key数组
   * 当DragItemInfo内部使用pixelMap时必须同步传入key，确保发起拖拽时截图已完成，索引需要与dragItemInfo保持严格一致
   */
  key?: string[];

  /**
   * 拖拽发起后跟手效果所拖拽的对象数组
   */
  dragItemInfo?: DragItemInfo[];

  /**
   * 发起拖拽所需要的属性和拖拽时携带的信息
   */
  dragInfo?: dragController.DragInfo;

  /**
   * 发起拖拽后，拖拽开始回调
   *
   * @param event 拖拽事件
   */
  dragStartCallback?: (event: DragEvent) => void;

  /**
   * 发起拖拽后，拖拽结束回调
   *
   * @param event 拖拽事件
   */
  dragEndCallback?: (event: DragEvent) => void;
}

export const dragControllerUtil: DragControllerUtil = SingletonHelper.getInstance(DragControllerUtil, TAG);