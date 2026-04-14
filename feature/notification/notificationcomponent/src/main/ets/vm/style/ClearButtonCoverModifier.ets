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
 * 一键清除按钮垃圾桶盖的属性
 *
 * @since 2024/08/27
 */
export class ClearButtonCoverModifier implements AttributeModifier<ImageAttribute> {
  public angle: number = 0;

  applyNormalAttribute(instance: ImageAttribute) {
    instance.rotate({
      z: 1,
      centerX: '90%',
      centerY: '30%',
      angle: this.angle
    });
  }
}