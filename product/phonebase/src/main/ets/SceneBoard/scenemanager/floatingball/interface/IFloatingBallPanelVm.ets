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

import { FloatingBall } from '../model/FloatingBallModel';
import { SCBSystemSceneSession } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

export interface IFloatingBallPanelVm {
  /**
   * Z轴
   */
  zIndex: number;

  /**
   * 面板可见性
   */
  visible: boolean;

  /**
   * 系统窗口
   */
  sceneSession?: SCBSystemSceneSession;

  /**
   * 内层row宽度
   */
  rowWidth: number;

  /**
   * 外层底板宽度
   */
  outerPanelWidth: number;

  /**
   * 外底板高度
   */
  outerPanelHeight: number;

  /**
   * 面板透明度
   */
  opacity: number;

  /**
   * panel阴影，删除时降低，提升模糊效果
   */
  shadowRadius: number;

  /**
   * 蒙层透明度
   */
  overlayOpacity: number;

  /**
   * 旋转角度
   */
  rotateAngle: number;

  /**
   * 初始化
   */
  init(): void;

  /**
   * 销毁
   */
  destroy(): void;

  /**
   * 尝试避让输入法
   */
  tryAvoidKeyboard(): void;

  /**
   * 触摸事件
   * @param event
   */
  onTouchEvent(event?: TouchEvent): void;

  /**
   * 菜单即将消失
   */
  onMenuAboutDisappear(): void;

  /**
   * 菜单消失
   */
  onMenuDisappear(): void;

  /**
   * 填充模板数据到悬浮球
   * @param ball 悬浮球
   * @param fbTemplate 模板数据
   */
  fillTemplateToBall(ball: FloatingBall, fbTemplate: sceneSessionManager.FbTemplateInfo): void;
}