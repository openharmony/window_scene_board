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

import { MirrorScene } from '../service/OneMirrorService';

/**
 * 一镜到底策略接口
 */
export interface IOneMirrorStrategy {
  /**
   * 获取策略名称
   *
   * @returns 策略名称
   */
  getName: () => string;

  /**
   * 是否需要播壁纸动效
   *
   * @returns true，需要播壁纸动效
   */
  needWallpaperAnim: () => boolean;

  /**
   * 是否需要播锁屏动效
   *
   * @param toScene 目标场景
   * @returns true，需要播锁屏动效
   */
  needScreenLockAnim: (toScene: MirrorScene) => boolean;

  /**
   * 是否有额外的灭屏动画
   *
   * @returns true，有额外的灭屏动画
   */
  hasExtraScreenOffAnim: () => boolean;

  /**
   * 是否灭屏强制进AOD
   *
   * @returns true，灭屏强制进AOD
   */
  forceIntoAod: () => boolean;

  /**
   * 折叠场景
   *
   * @param isFold 是否折叠
   * @param isWallpaperAodState 壁纸是否是AOD状态
   * @param isAodEnabled 是否开启了AOD
   */
  onFold: (isFold: boolean, isWallpaperAodState: boolean, isAodEnabled: boolean) => void;
}