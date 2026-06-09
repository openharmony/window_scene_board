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

import { CustomPromise } from '@ohos/frameworkwrapper';
import { RemoveType } from '../constants/FloatingConstants';
import { FloatingBall } from '../model/FloatingBallModel';

export interface IFloatingBallListVm {
  /**
   * 悬浮球列表
   */
  floatingBallList: FloatingBall[];

  /**
   * 冻结promise
   */
  freezePromise?: CustomPromise<void>;

  /**
   * 当前长按的悬浮球id
   */
  selectId: number;

  /**
   * 是否正在删除悬浮球
   */
  isRemovingBall: boolean;

  /**
   * 是否镜像语言
   */
  isRtl: boolean;

  /**
   * 初始化
   */
  init(): void;

  /**
   * 悬浮球是否已存在
   * @param persistentId
   * @returns
   */
  isExist(persistentId: number): boolean;

  /**
   * 获取指定悬浮球
   * @param persistentId
   * @returns
   */
  getFloatingBall(persistentId: number): FloatingBall | undefined;

  /**
   * 新增悬浮球
   * @param ball
   * @returns
   */
  addFloatingBall(ball: FloatingBall): Promise<void>;

  /**
   * 更新悬浮球
   * @param ball
   * @returns
   */
  updateFloatingBall(ball: FloatingBall): Promise<void>;

  /**
   * 删除悬浮球
   * @param persistentId
   * @param type
   * @returns
   */
  removeFloatingBall(persistentId: number, type: RemoveType): Promise<void>;

  /**
   * 清除所有悬浮球
   * @param type
   * @param withAnim
   */
  clearAll(type: RemoveType, withAnim?: boolean): Promise<void>;

  /**
   * 计算悬浮球最大宽度
   * @param floatingBallList
   * @returns 宽度
   */
  calcMaxRowWidth(floatingBallList?: FloatingBall[]): number;

  /**
   * 点击悬浮球
   * @param ball
   */
  onClick(ball: FloatingBall): void;

  /**
   * 长按显示菜单
   * @param event
   * @param persistentId
   */
  onLongPressShowMenu(event: GestureEvent, persistentId: number): void;

  /**
   * 重置所有悬浮球透明度
   */
  restoreAllFloatingBallsOpacity(): void;
}