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
 * 签名、服务卡片可见性标示
 */
export enum SignFormKey {
  VISIBLE_NONE = 'false_false',
  VISIBLE_SIGN = 'true_false',
  VISIBLE_FORM = 'false_true',
  VISIBLE_SIGN_FORM = 'true_true',
}

/**
 * 签名、服务卡片可见性标示装饰器
 */
export class VisibleKeyWrapper {
  public isSignVisible?: boolean = false; // 签名可见性
  public isFormVisible?: boolean = false; // 服务卡片可见性

  /**
   * 可见性转唯一标示
   *
   * @param wrapper 装饰器-可见性参数
   * @returns 唯一标识
   */
  public static getKey(wrapper: VisibleKeyWrapper): SignFormKey {
    let isSignVisible = wrapper?.isSignVisible ?? false;
    let isFormVisible = wrapper?.isFormVisible ?? false;
    return `${isSignVisible}_${isFormVisible}` as SignFormKey;
  }
}