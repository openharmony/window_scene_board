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
import { StatusBarChangeType } from '../../live/model/LiveCommonModel';
import { ClockShowType } from '../enum/StatusBarEnum';
import { IStatusBarIconVm } from './IStatusBarIconVm';
import lazy {
  SCBTripleStateChange,
} from '@ohos/launchercommon/src/main/ets/utils/UltraScreenExpandAnimUtils';

export interface IStatusBarAnimVm {
  /**
   * 状态栏图标内容模糊半径
   */
  blurRadiusLeft: number;
  blurRadiusRight: number;

  /**
   * 状态栏图标内容偏移距离
   */
  offsetX: number;
  /**
   * 状态栏左侧区域平移，(非镜像左侧平移，镜像右侧平移)
   * 在XT设备M态和G态切换动效时使用
   */
  leftGroupTranslateX: number;

  /**
   * 状态栏右侧区域平移，(非镜像左侧平移，镜像右侧平移)
   * 在XT设备M态和G态切换动效时使用
   */
  rightGroupTranslateX: number;

  /**
   * 左组图标透明度，小外屏进入AOD左组图标透明度为0.4
   */
  leftGroupOpacity: number;

  /**
   * 右组图标透明度，小外屏进入AOD右组图标透明度为0
   */
  rightGroupOpacity: number;

  /**
   * 状态栏X轴缩放
   */
  scaleXLeft: number;
  scaleXRight: number;

  /**
   * 状态栏单个图标显隐动效, 对baseLayoutOpacity进行动效，在状态栏自身图标显隐变化时调用。
   */
  animateBaseLayoutOpacityChange(iconVms: IStatusBarIconVm[], needOpacity: number, duration: number): Promise<void>;

  /**
   * 状态栏缩放动效
   */
  animateScale(startDuration: number, resumeDuration: number): Promise<void>;

  /**
   * 状态栏移动和模糊动效
   */
  animateMoveAndBlur(startDuration: number, resumeDuration: number): Promise<void>;

  /**
   * 状态栏变化回调
   */
  onStatusBarChange(type?: StatusBarChangeType): Promise<void>;

  /**
   * 状态栏左/右侧区域平移动效，非镜像场景左侧平移，镜像场景右侧平移
   * 在XT设备M态和G态切换时执行
   * @param translateDelta
   * @returns
   */
  animateGroupTranslate(stateChange: SCBTripleStateChange, orientation: number,
    screenChangeDelta: number): Promise<void>;

  init(): void;
}