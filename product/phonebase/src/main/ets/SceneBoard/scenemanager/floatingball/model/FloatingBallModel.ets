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

import image from '@ohos.multimedia.image';
import { SCBSpecificSession } from '@ohos/windowscene';
import { FBTemplate } from '../constants/FloatingConstants';

@ObservedV2
export class FloatingBall {
  /**
   * 会话信息
   */
  public specificSession: SCBSpecificSession;
  /**
   * 悬浮球图标
   */
  @Trace public icon?: image.PixelMap | Resource;
  /**
   * 悬浮球标题
   */
  @Trace public title: string = '';
  /**
   * 悬浮球内容
   */
  @Trace public content?: string = '';
  /**
   * 悬浮球模板类型
   */
  @Trace public template: number = FBTemplate.STATIC;
  /**
   * 悬浮球背景色
   */
  @Trace public backgroundColor?: string;
  /**
   * 悬浮球是否激活
   */
  @Trace public isActive: boolean = false;

  /**
   * 悬浮球缩放
   */
  @Trace public scale: number = 0.25;

  /**
   * 悬浮球透明度
   */
  @Trace public opacity: number = 0;

  /**
   * 悬浮球Y轴平移
   */
  @Trace public translateY?: number;

  /**
   * 悬浮球z轴index
   */
  @Trace public zIndex: number = 1;

  /**
   * 字体颜色
   */
  @Trace public fontColor?: ResourceColor;

  /**
   * 内容字体颜色
   */
  @Trace public contentFontColor?: ResourceColor;

  /**
   * 是否正在删除
   */
  public isRemoving: boolean = false;

  constructor(specificSession: SCBSpecificSession) {
    this.specificSession = specificSession;
  }

  public isSameBall(ball: FloatingBall): boolean {
    if (!ball || this.specificSession.session.persistentId === undefined) {
      return false;
    }
    return this.specificSession.session.persistentId === ball.specificSession.session.persistentId;
  }
}

@ObservedV2
export class FloatingBallPosition {
  /**
   * 当前坐标,单位: vp
   */
  @Trace public x: number = 0;
  @Trace public y: number = 0;
  @Trace public positionX: number = 0;
  @Trace public positionY: number = 0;
}