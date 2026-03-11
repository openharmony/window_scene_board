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

import { HiSysReportEvent, ReportDomain } from '@ohos/frameworkwrapper';

export enum EventName {
  /**
   * 点击悬浮球
   */
  CLICK_FLOATING_BALL = 'CLICK_FLOATING_BALL',

  /**
   * 删除悬浮球
   */
  REMOVE_FLOATING_BALL = 'REMOVE_FLOATING_BALL',
}

class FloatingBallBaseParams {
  public PNAMEID: string = 'SCB_FLOATING_BALL';
  public PVERSION: string = '1.0';
  /**
   * 悬浮球包名
   */
  public PACKAGE_NAME?: string;
  /**
   * 模板类型
   */
  public TEMPLATE_TYPE?: number;
  /**
   * 错误原因，成功时为空
   */
  public ERROR_REASON?: string;
}

export class ClickFloatingBallParams extends FloatingBallBaseParams {
  /**
   * 悬浮球个数
   */
  public BALL_NUM?: number;
  /**
   * 悬浮球下标
   */
  public CLICK_INDEX?: number;
}

export class RemoveFloatingBallParams extends FloatingBallBaseParams {
  /**
   * 删除类型: 0 应用删除， 1 用户删除
   */
  public REMOVE_TYPE?: number;
  /**
   * 用户删除类型（0：拖动删除，1：长按单个删除，2：长按全部删除）
   */
  public USER_REMOVE_TYPE?: number;
}

/**
 * 悬浮球打点函数类
 */
export class FloatingBallSysEventReporter {
  private static readonly MULTI_WINDOW_UE: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.MULTIWINDOW_UE);

  public static reportClickFloatingBall(param: ClickFloatingBallParams): void {
    FloatingBallSysEventReporter.MULTI_WINDOW_UE.reportBehavior(EventName.CLICK_FLOATING_BALL, param);
  }

  public static reportRemoveFloatingBall(param: RemoveFloatingBallParams): void {
    FloatingBallSysEventReporter.MULTI_WINDOW_UE.reportBehavior(EventName.REMOVE_FLOATING_BALL, param);
  }
}