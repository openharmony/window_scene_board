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
import { CommonUtils } from '@ohos/basicutils';
import { CapsuleShowType } from '../../common/LiveConstants';

/**
 * 动效胶囊的样式
 */
@Observed
export class CapsuleAnimStyle {
  /**
   * 动效胶囊的背景颜色，有值则优先使用
   */
  backgroundColor?: string;

  /**
   * 动效胶囊显示类型，内容/阴影，默认不启用
   */
  capsuleShowType?: CapsuleShowType;

  /**
   * 是否存在动效胶囊显示类型
   *
   * @returns true动效自定义类型
   */
  hasCapsuleShowType(): boolean {
    return !CommonUtils.isInvalid(this.capsuleShowType);
  }

  /**
   * 设置动效期间的胶囊显示类型
   * @param showType 胶囊显示类型
   */
  public setCapsuleShowType(showType?: CapsuleShowType): void {
    this.capsuleShowType = showType;
  }

  /**
   * 胶囊是否显示内容
   *
   * @returns true显示内容
   */
  isCapsuleShowContent(): boolean {
    return this.capsuleShowType === CapsuleShowType.SHOW || this.capsuleShowType === CapsuleShowType.TOP;
  }

  /**
   * 胶囊是否显示阴影
   *
   * @returns true显示阴影
   */
  isCapsuleShowShadow(): boolean {
    return this.capsuleShowType === CapsuleShowType.SHADOW;
  }
}