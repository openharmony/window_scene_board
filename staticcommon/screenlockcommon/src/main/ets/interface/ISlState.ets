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
import { SizeBreakPoint } from '../constants/ScreenBreakPoint';
import { SlMainStateType, SlSubStateType } from '../constants/SlStateType';
import { ISlStateChangeListener } from './ISlStateChangeListener';

// 锁屏状态值类型
export type SlObject = undefined | string | number | boolean | object;

// 组件大小
export interface WidgetSize {
  width: number;
  height: number;
}

// 屏幕宽高断点状态
export interface ScreenBp {
  widthBp: SizeBreakPoint;
  heightBp: SizeBreakPoint;
}

// 触摸点坐标
export interface DownPosition {
  positionX: number;
  positionY: number;
}

// 组件显示区域
export interface WidgetArea {
  globalX?: number;
  globalY?: number;
  width: number;
  height: number;
}

// 组件缩放、旋转中心点
export interface WidgetPivot {
  centerX?: number | string;
  centerY?: number | string;
  centerZ?: number | string;
}

// 栅格数
export interface GridAmount {
  x: number;
  y: number;
}

// 模糊冻结场景
export interface BlurFreezeScene {
  isFreeze: boolean;
  scene?: string;
}

/**
 * 锁屏页面状态变量接口
 */
export interface ISlState {
  slStateChangeListener?: ISlStateChangeListener; // 状态切换监听器

  widgetStateChangeListener?: ISlStateChangeListener; // 适配时钟组件化状态切换监听器

  getSlStateType(): SlMainStateType; // 当前状态变量主类型标记

  setSlState(subType: SlSubStateType, value: SlObject): ISlState; // 设置主类型中的状态变量值

  getSlState(subType: SlSubStateType, scene?: SlObject): SlObject; // 获取主类型中的状态变量值
}

// 状态切换回调函数类型
export type StateChange = (state?: ISlState) => void;