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

export interface IFloatingBallMenuVm {
  /**
   * 菜单是否显示
   */
  isShow: boolean;

  /**
   * 透明度
   */
  opacity: number;

  /**
   * 缩放
   */
  scale: number;

  /**
   * 菜单宽度，与原面板相同
   */
  width: number;

  /**
   * 菜单高度，与原面板相同
   */
  height: number;

  /**
   * 初始化
   * @param width
   * @param height
   */
  init(width: number, height: number): void;
}