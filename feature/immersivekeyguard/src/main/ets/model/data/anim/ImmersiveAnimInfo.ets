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

import { CommonUtils } from '@ohos/basicutils';
import { ComponentPosition, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ANIM_STATE_MAP } from '../../../common/anim/ImmersiveAnimParam';
import { AnimStyleType, ImmersiveAnimStyle } from './ImmersiveAnimStyle';

/**
 * 沉浸锁屏动效数据结构
 */
export class ImmersiveAnimInfo {
  /**
   * 动效唯一标示
   */
  private animKey?: string;

  /**
   * 动效目标组件唯一标示
   */
  private componentId?: string;

  /**
   * 目标组件动效状态管理
   */
  private state: WidgetAnimState;

  /**
   * 组件位置
   */
  private componentArea: Area = { width: 0, height: 0, position: { x: 0, y: 0 }, globalPosition: { x: 0, y: 0 } };

  /**
   * 组件位置转换类型
   */
  private componentPosition?: ComponentPosition;

  /**
   * 组件动效相关
   */
  private componentStyle?: ImmersiveAnimStyle;

  /**
   * 子组件动效
   */
  private childrenInfo: Map<string, ImmersiveAnimInfo> = new Map();

  /**
   * 构造
   *
   * @param animKey 动效唯一标示
   * @param style 组件动效UI样式
   * @param componentId 组件唯一标识
   */
  constructor(animKey: string, style?: ImmersiveAnimStyle, componentId?: string) {
    let animState = ANIM_STATE_MAP.get(animKey);
    if (!animState) {
      animState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, animKey);
    }
    this.state = animState;
    this.componentStyle = style;
    this.animKey = animKey;
    this.componentId = componentId;
  }

  /**
   * 设置组件唯一标示
   *
   * @param id 组件ID
   */
  setComponentId(id: string): void {
    this.componentId = id;
  }

  /**
   * 获取组件ID
   *
   * @returns 组件ID
   */
  getComponentId(): string {
    return this.componentId ?? '';
  }

  /**
   * 缓存组件位置
   *
   * @param area 组件位置
   */
  setComponentArea(area?: Area | SizeOptions): void {
    let areaSize = area as Area;
    this.componentArea.width = areaSize?.width;
    this.componentArea.height = areaSize?.height;
    if ((typeof areaSize?.globalPosition) !== 'undefined') {
      this.componentArea.globalPosition = areaSize.globalPosition;
    }
    this.componentPosition = undefined;
  }

  updateAreaWidth(width: number): void {
    if (this.componentArea) {
      this.componentArea.width = width;
      this.componentPosition = undefined;
    }
  }

  /**
   * 获得组件位置
   *
   * @returns 组件位置
   */
  getComponentArea(): Area | undefined {
    return this.componentArea;
  }

  /**
   * 获取组件全局位置
   *
   * @returns 组件位置
   */
  getComponentPosition(): ComponentPosition {
    if (CommonUtils.isInvalid(this.componentPosition)) {
      let style = this.getComponentAnimStyle();
      let offsetTop = style.getValueDefault(AnimStyleType.MARGIN_TOP);
      let offsetLeft = style.getValueDefault(AnimStyleType.MARGIN_LEFT);
      let offsetRight = style.getValueDefault(AnimStyleType.MARGIN_RIGHT);
      let area = this.componentArea as Area;
      let posX = (area?.globalPosition?.x ?? 0) as number;
      let posY = (area?.globalPosition?.y ?? 0) as number;
      let width = (this.componentArea?.width ?? 0) as number;
      let height = (this.componentArea?.height ?? 0) as number;
      this.componentPosition = {
        globalX: posX + offsetLeft,
        globalY: posY + offsetTop,
        width: width - (offsetLeft + offsetRight),
        height: height - offsetTop
      };
    }
    return this.componentPosition as ComponentPosition;
  }

  /**
   * 获取组件动效状态
   *
   * @returns 组件动效状态
   */
  getWidgetAnimState(): WidgetAnimState {
    return this.state as WidgetAnimState;
  }

  /**
   * 组件动效UI样式
   *
   * @returns UI样式
   */
  getComponentAnimStyle(): ImmersiveAnimStyle {
    if (CommonUtils.isInvalid(this.componentStyle)) {
      this.componentStyle = new ImmersiveAnimStyle();
    }
    return this.componentStyle as ImmersiveAnimStyle;
  }

  /**
   * 添加子组件动效
   *
   * @param childInfo 子组件动效
   */
  addChildAnimInfo(childInfo: ImmersiveAnimInfo): void {
    if (CommonUtils.isInvalid(childInfo)) {
      return;
    }
    if (childInfo.animKey) {
      this.childrenInfo.set(childInfo.animKey, childInfo);
      this.state.addChildState(childInfo.state);
    }
  }

  /**
   * 移除子组件动效
   *
   * @param animKey 子组件动效唯一标示
   */
  removeChildAnimInfo(animKey: string): void {
    this.childrenInfo.delete(animKey);
    this.state.removeChildState(animKey);
  }

  /**
   * 获取子组件动效
   *
   * @param animKey 子组件动效唯一标示
   * @returns 子组件动效
   */
  getChildAnimInfo(animKey: string): ImmersiveAnimInfo {
    return this.childrenInfo.get(animKey) as ImmersiveAnimInfo;
  }
}