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

export class BlankPageTransFormItem {
  /** BlankPageTransFormItem单例 */
  private static instance: BlankPageTransFormItem;
  /** 旧机克隆时空白页列表 */
  public oldBlankPageList: number[] = [];
  /** 旧机克隆时总页数 */
  public oldPageCount: number = 0;

  public static getInstance(): BlankPageTransFormItem {
    if (!(BlankPageTransFormItem.instance instanceof BlankPageTransFormItem)) {
      BlankPageTransFormItem.instance = new BlankPageTransFormItem();
    }
    return BlankPageTransFormItem.instance;
  }
}