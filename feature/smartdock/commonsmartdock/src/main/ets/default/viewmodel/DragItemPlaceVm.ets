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

import SmartDockDragHandler from '../common/SmartDockDragHandler';

const BACK_PLANE_ANIM_DURATION: number = 400;

/**
 * 拖拽占位框View Model
 */
export class DragItemPlaceVm {
  @Track public translateX: number = 0;
  @Track public opacity: number = 0;

  /**
   * 占位框位置变化事件
   *
   * @param newCenterX 新中心点
   * @param oldCenterX 旧中心点
   * @param isShow 显示或隐藏
   * @param immediate 是否立即执行
   */
  public onDockHolderIndexChange(newCenterX: number, oldCenterX: number, isShow: boolean, immediate: boolean): void {
    const duration: number = immediate ? 0 : BACK_PLANE_ANIM_DURATION;
    const opacity: number = isShow ? 1 : 0;
    // 原始位置获取异常、目标位置无效及两者位置一致时不执行动效
    if (oldCenterX < 0 || newCenterX < 0 ||
      (Math.abs(newCenterX - oldCenterX - this.translateX) < 1 && this.opacity === opacity)) {
      return;
    }

    if (isShow) {
      this.translateX = newCenterX - oldCenterX;
      // 落位框先隐藏后渐显
      this.opacity = 0;
    }
    animateTo({
      duration: duration,
    }, () => {
      this.opacity = opacity;
    })
  }

  /**
   * 刷新占位框可见性
   *
   * @param isDrag 是否在拖拽
   */
  public refreshVisibility(isDrag: boolean): void {
    if (isDrag) {
      return;
    }
    this.opacity = 0;
    if (!SmartDockDragHandler.getInstance().getEmptyItemExist()) {
      SmartDockDragHandler.getInstance().clearSqueezeInfo();
    }
  }
}