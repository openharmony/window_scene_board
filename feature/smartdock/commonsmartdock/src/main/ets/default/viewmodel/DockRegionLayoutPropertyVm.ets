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

import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';

/**
 * Dock区域布局关键属性View Model
 */
@Observed
export class DockRegionLayoutPropertyVm {
  @Track public iconSize: number = 0;
  @Track public iconRadius: number = 0;
  @Track public dockHeight: number = 1;
  @Track public dockRadius: number = 0;
  @Track public dividerWidth: number = 0;
  @Track public space: number = 0;
  @Track public listPadding: number = 0;
  @Track public scale: number = 1;
  @Track public collaborationDividerWidth: number = 0;

  /**
   * 计算区域宽度
   *
   * @param num 图标个数
   * @returns 区域宽度
   */
  public calculateRegionWidth(num: number): number {
    return DockRegionLayoutModel.getInstance().calculateRegionWidth(num) * this.scale;
  }

  /**
   * 重新加载布局属性
   *
   * @param num 图标个数
   */
  public reloadLayoutProperties(num: number): void {
    this.scale = DockRegionLayoutModel.getInstance().getScale();
    this.iconSize = DockRegionLayoutModel.getInstance().getIconSize();
    this.iconRadius = DockRegionLayoutModel.getInstance().getIconRadius();
    this.dockHeight = DockRegionLayoutModel.getInstance().getDockHeight();
    this.dockRadius = DockRegionLayoutModel.getInstance().getDockRadius();
    this.dividerWidth = DockRegionLayoutModel.getInstance().getDividerWidth();
    this.collaborationDividerWidth = DockRegionLayoutModel.getInstance().getDividerWidth();
    this.space = DockRegionLayoutModel.getInstance().getSpace(num);
    this.listPadding = DockRegionLayoutModel.getInstance().getListPadding(num);
  }
}