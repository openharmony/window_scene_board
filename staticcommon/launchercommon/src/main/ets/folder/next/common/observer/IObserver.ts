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
 * 布局属性相关的observer接口
 */
export interface IObserver {
  /* 透明度 */
  opacity: number,

  /* 缩放值 */
  scale: number,

  /* X方向缩放值 */
  scaleX: number,

  /* Y方向缩放值 */
  scaleY: number,

  /* X方向位移值 */
  transX: number,

  /* Y方向位移值 */
  transY: number,

  /* X方向偏移值 */
  offsetX: number,

  /* Y方向偏移值 */
  offsetY: number

  /**
   * 设置属性值
   *
   * @param type 属性类型
   * @param value 更新值
   */
  setAttribute(type: number, value: number): void;

  /**
   * 获取属性值
   *
   * @param type 属性类型
   * @returns 属性值
   */
  getAttribute(type: number): number;
}