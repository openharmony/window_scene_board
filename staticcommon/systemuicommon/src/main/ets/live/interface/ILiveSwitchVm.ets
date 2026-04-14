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

export interface ILiveSwitchVm {
  /**
   * 卡片是否正在展开
   */
  isExpanding: boolean;

  /**
   * 卡片是否正在收起
   */
  isCollapsing: boolean;

  /**
   * 卡片列表容器尺寸变化，用于感知面板已出场
   */
  onPanelSizeChange(oldSize: SizeOptions, newSize: SizeOptions): void;

  /**
   * 展开所有胶囊为卡片
   */
  expandCapsuleToCard(): Promise<void>;

  /**
   * 从卡片收起为胶囊
   */
  collapseCardToCapsule(): void;

  /**
   * 收起实况面板
   */
  hidePanel(): void;

  /**
   * 设置卡片动态模糊
   */
  setDynamicEffect(duration?: number): void;

  /**
   * 根据场景设置卡片动态模糊
   */
  setDynamicByScene(duration?: number): void;
}