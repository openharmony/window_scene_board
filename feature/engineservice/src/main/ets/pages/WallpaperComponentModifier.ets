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
 * 动态设置壁纸的属性
 *
 * @since 2024-06-11
 */
export class WallpaperComponentModifier implements AttributeModifier<CommonAttribute> {
  private blurRadius: number = 0;
  private lightUpFactor: number = 1;

  /**
   * 更新模糊半径
   *
   * @param blurRadius 模糊半径
   */
  public updateBlurRadius(blurRadius: number): void {
    this.blurRadius = blurRadius;
  }

  /**
   * 更新组件点亮效果
   *
   * @param lightUpFactor 点亮效果
   */
  public updateLightUpFactor(lightUpFactor: number): void {
    this.lightUpFactor = lightUpFactor;
  }

  /**
   * 设置组件样式【组件首次初始化或者关联的状态变量发生变化会触发】
   *
   * @param commAttribute 节点
   */
  public applyNormalAttribute(commAttribute: CommonAttribute): void {
    commAttribute
      .blur(this.blurRadius)
      .lightUpEffect(this.lightUpFactor)
  }
}
