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

export default class IDHelperUtil {
  private constructor() {
  }

  public static getTextId(tag: string, subId: string): string {
    return `${tag}_Text_${subId}`;
  }

  public static getColumnId(tag: string, subId: string): string {
    return `${tag}_Column_${subId}`;
  }

  public static getStackId(tag: string, subId: string): string {
    return `${tag}_Stack_${subId}`;
  }

  public static getImageId(tag: string, subId: string): string {
    return `${tag}_Image_${subId}`;
  }
}

