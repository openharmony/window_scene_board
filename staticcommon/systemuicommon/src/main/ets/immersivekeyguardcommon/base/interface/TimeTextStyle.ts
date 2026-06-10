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
 * 沉浸胶囊主、副文本时间组件默认UI样式
 */
export class TimeTextStyle {
  /**
   * 高度
   */
  public height: number = 19;

  /**
   * 字体大小
   */
  public fontSize: number = 14;

  /**
   * 底边距
   */
  public marginBottom: number = 0;

  constructor(height: number, fontSize: number) {
    this.height = height;
    this.fontSize = fontSize;
  }

}