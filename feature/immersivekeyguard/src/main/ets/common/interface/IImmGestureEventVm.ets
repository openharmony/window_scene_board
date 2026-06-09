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
/**
 * 沉浸模块手势事件业务抽象层
 */
export interface IImmGestureEventVm {
  /**
   * 返回手势回调
   *
   * @returns true消费事件
   */
  onBackGestureEvent?(): boolean;

  /**
   * 检测热区匹配
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true热区匹配
   */
  checkMatchHotZones?(globalX: number, globalY: number): boolean;

  /**
   * 检测精确位置匹配
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true位置匹配
   */
  checkMatchExactArea?(globalX: number, globalY: number): boolean;
}

// 手势事件业务集
export class IImmGestureEventVmArray extends Array<IImmGestureEventVm> {
}