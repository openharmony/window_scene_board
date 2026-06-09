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
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { ClockShowType, IconFilterType } from '../enum/StatusBarEnum';
import { IStatusBarIconVm } from './IStatusBarIconVm';

export interface IStatusBarIconAnimVm {
  clockTextScale: number;
  isExtrudeType: boolean;

  /**
   * 创建新的动效对象执行 动效
   * @param cmds，动效参数
   */
  executeAnimation(cmds: AnimateParams[]): Promise<void>;

  /**
   * 状态栏图标显隐动效
   * @param iconVm 图标对应的VM
   * @param duration 动效执行时长
   * @param targetOpacity 目标透明度
   */
  getSystemIconAnimatePara(
    iconVm: IStatusBarIconVm, opacity: number, scale: number, offset: number, delay: number, duration?: number
  ): AnimateParams;

  /**
   * 时间图标压缩、显隐动效
   * @param iconVm 图标对应的VM
   * @param showType 时间显示类型
   * @param clockTextExtrudeScale 时钟文本折叠时的缩放比例
   * @param baseDelay 动效延迟时间
   */
  getClockAnimateParam(
    iconVm: IStatusBarIconVm, showType: ClockShowType, clockTextExtrudeScale: number,
    baseDelay: number): Array<AnimateParams>;

  /**
   * 通知图标的显隐动效
   * @param iconVm 图标对应的VM
   * @param showMaxIconCount 通知图标可显示数量
   * @param duration 动效持续时长
   */
  getNtfIconAnimateParam(
    iconVm: IStatusBarIconVm, showMaxIconCount: number, delay: number): AnimateParams

  /**
   * 图标仅透明度变化动效
   * @param iconVm 图标对应的VM
   * @param needOpacity 目标透明度
   * @param duration 动效持续时长
   */
  getIconOpacityParam(iconVm: IStatusBarIconVm, needOpacity: number, duration: number): AnimateParams;

  /**
   * 状态栏布局变更动效
   * @param cmds
   * @param animateDurationMs
   * @param delay
   * @param newVisibleIcons
   * @param avoidName
   * @param avoidMargin
   * @param tempHideInfo
   */
  getVisibleChangeParam(cmds: AnimateParams[], animateDurationMs: number, delay: number, newVisibleIcons: Set<string>,
    avoidName: string, avoidMargin: number, tempHideInfo: Set<string>): void;
}