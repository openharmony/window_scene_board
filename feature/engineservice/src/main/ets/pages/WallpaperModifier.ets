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
 * 动态设置解锁场景锁屏和桌面壁纸的属性
 *
 * @since 2024-07-05
 */

const OFFSET_ARR_SIZE: number = 2;

export class WallpaperModifier implements AttributeModifier<CommonAttribute> {
  public visibility: Visibility = Visibility.None;
  public opacity: number = 1;
  public id: string = '';
  public scale: number = 1;
  public offset: number[] = [0, 0];

  /**
   * Constructor.
   *
   * @param id 控件id属性
   * @param visibility 是否可见
   * @param opacity 透明度
   */
  constructor(id: string, visibility: Visibility, opacity: number) {
    this.id = id;
    this.visibility = visibility;
    this.opacity = opacity;
  }

  /**
   * 更新组件显隐
   *
   * @param visibility 是否可见
   */
  public updateVisibility(visibility: Visibility): void {
    this.visibility = visibility;
  }

  /**
   * 更新组件透明度
   *
   * @param opacity 透明度
   */
  public updateOpacity(opacity: number): void {
    this.opacity = opacity;
  }

  public updateScale(scale: number): void {
    this.scale = scale;
  }

  public setOffset(offset: number[]): void {
    if (!offset || offset.length !== OFFSET_ARR_SIZE) {
      return;
    }
    this.offset = offset;
  }

  /**
   * 设置组件样式【组件首次初始化或者关联的状态变量发生变化会触发】
   *
   * @param commAttribute 节点
   */
  public applyNormalAttribute(commAttribute: CommonAttribute): void {
    commAttribute
      .id(this.id)
      .visibility(this.visibility)
      .opacity(this.opacity)
      .scale({
        x: this.scale,
        y: this.scale,
      })
      .offset({
        x: this.offset[0] + 'px',
        y: this.offset[1] + 'px',
      });
  }
}
