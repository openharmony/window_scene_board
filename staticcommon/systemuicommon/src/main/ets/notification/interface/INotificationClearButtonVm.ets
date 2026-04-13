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

/**
 * 通知中心挖孔布局信息
 */
export interface CutoutLayout {
  /**
   * 挖孔宽度
   */
  cutoutHeight: number,
  /**
   * 带孔时通知中心header宽度
   */
  headerWidth: number,
  /**
   * 一键删除按钮宽度
   */
  clearBtnWidth: number;
  /**
   * 一键删除按钮右侧margin
   */
  clearBtnMarginEnd: number;
}

export interface INotificationClearButtonVm {
  /**
   * 一键清除按钮的缩放值
   */
  readonly scale: number;

  /**
   * 一键清除按钮的旋转度
   */
  readonly angle: number;

  /**
   * 实时背景模糊参数
   */
  readonly backgroundEffectOptions?: BackgroundEffectOptions;

  /**
   * 是否显示按钮
   * @returns
   */
  readonly isShow: boolean;

  /**
   * 挖孔避让布局
   */
  readonly cutoutLayout?: CutoutLayout;

  /**
   * 一键清除按钮底边距
   */
  marginBottom: LengthMetrics;

  /**
   * 一键清除容器宽度
   */
  width: string | Resource;

  /**
   * 一键清除按钮外边距
   */
  margin: Margin | LocalizedMargin
  /**
   * 是否在一键清除
   */
  isClearingAll: boolean;

  /**
   * 对齐规则
   */
  alignRules: LocalizedAlignRuleOptions;
  /**
   * 一键清除通知
   */
  clear(): void;

  /**
   * 修改一键清除按钮的属性
   *
   * @param scale 缩放
   * @param angle 翻转
   */
  updateClearButtonParams(scale?: number, angle?: number): void;

  /**
   * 开关背景模糊
   */
  enableBackgroundEffect(enable: boolean): void;

  /**
   * 注册事件监听
   */
  registerEventListener(): void;

  /**
   * 解注册事件
   */
  unRegisterEventListener(): void;

  /**
   * 设置挖孔布局信息
   */
  setCutoutLayout(cutoutLayout?: CutoutLayout): void;
}