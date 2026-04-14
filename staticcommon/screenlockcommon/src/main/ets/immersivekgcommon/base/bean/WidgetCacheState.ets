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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseObj, StateType } from '../constants/BaseType';
import { WCacheProperty } from '../constants/WidgetCacheConst';
import { INestableState } from '../interface/INestableState';
import { CmpPosWrapper, ComponentPosition, PosProperty } from '../utils/ComponentPosition';
import { LimitMap } from '../utils/LimitMap';
import { StaticBaseState } from './StaticBaseState';

const TAG = 'WidgetPositionState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 组件缓存状态集
 */
export class WidgetCacheState extends StaticBaseState implements INestableState<WidgetCacheState> {
  // 子组件状态集
  private readonly childrenState: LimitMap<string, WidgetCacheState> = new LimitMap();

  // 组件位置
  private readonly wPosition: ComponentPosition = { width: 0, height: 0, globalX: 0, globalY: 0, radius: 0 };

  // 组件位置封装
  private readonly wPosWrap: CmpPosWrapper = CmpPosWrapper.wrapper(this.wPosition);

  protected initSetMethods(): void {
    this.addSetMethod(WCacheProperty.W_POSITION, this.setWidgetPosition);
  }

  protected initGetMethods(): void {
    this.addGetMethod(WCacheProperty.W_POSITION, this.getWidgetPosition);
  }

  public getStateType(): StateType {
    return StateType.CACHE;
  }

  public setStateValue(property: WCacheProperty, value?: BaseObj): WidgetCacheState {
    return super.setStateValue(property, value) as WidgetCacheState;
  }

  public getStateValue(property: WCacheProperty, scene?: BaseObj): BaseObj | undefined {
    return super.getStateValue(property, scene);
  }

  /**
   * 添加子组件缓存状态
   *
   * @param childState 子组件状态
   * @returns 链式
   */
  public addChildState(childState: WidgetCacheState): WidgetCacheState {
    if (!childState) {
      log.showWarn(`addChildState invalid state: ${this.splicePrint()}`);
      return this;
    }
    this.childrenState.set(childState.getStateId(), childState);
    return this;
  }

  /**
   * 移除子组件缓存状态
   *
   * @param childStateId 子组件唯一标识
   * @returns 链式
   */
  public removeChildState(childStateId?: string): WidgetCacheState {
    if (childStateId !== undefined) {
      this.childrenState.delete(childStateId);
    }
    return this;
  }

  /**
   * 获取子组件缓存状态
   *
   * @param childStateId 子组件唯一标识
   * @returns 链式
   */
  public getChildState(childStateId?: string): WidgetCacheState | undefined {
    if (childStateId === undefined) {
      return undefined;
    }
    return this.childrenState.get(childStateId);
  }

  /**
   * 设置组件位置
   *
   * @param position 组件位置
   */
  public setWidgetPosition(position: Area | SizeOptions | ComponentPosition): void {
    // 位置属性按需更新
    let hasChange = this.wPosWrap.updatePosProperty(PosProperty.WIDTH, position?.width as number);
    hasChange = this.wPosWrap.updatePosProperty(PosProperty.HEIGHT, position?.height as number) || hasChange;
    // Area则刷新位置
    if (typeof (position as Area)?.globalPosition !== 'undefined') {
      let globalPos = (position as Area).globalPosition;
      hasChange = this.wPosWrap.updatePosProperty(PosProperty.GLOBAL_X, globalPos.x as number) || hasChange;
      hasChange = this.wPosWrap.updatePosProperty(PosProperty.GLOBAL_Y, globalPos.y as number) || hasChange;
    }
    // ComponentPosition则刷新位置及圆角
    let tempPos = position as ComponentPosition;
    if (typeof tempPos?.radius !== 'undefined' || typeof tempPos?.globalX !== 'undefined' ||
      typeof tempPos?.globalY !== 'undefined') {
      hasChange = this.wPosWrap.updatePosProperty(PosProperty.RADIUS, tempPos.radius) || hasChange;
      hasChange = this.wPosWrap.updatePosProperty(PosProperty.GLOBAL_X, tempPos.globalX) || hasChange;
      hasChange = this.wPosWrap.updatePosProperty(PosProperty.GLOBAL_Y, tempPos.globalY) || hasChange;
    }
    if (hasChange) {
      this.notifyStateChange(WCacheProperty.W_POSITION);
    }
  }

  /**
   * 取值组件位置
   *
   * @returns 组件位置
   */
  public getWidgetPosition(): ComponentPosition {
    return { width: this.wPosition.width, height: this.wPosition.height, globalX: this.wPosition.globalX,
      globalY: this.wPosition.globalY, radius: this.wPosition.radius };
  }
}