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
 * pc通知卡片动效配置参数
 *
 * @since 2024-06-20
 */
@Observed
export class NotificationAnimationParamsPC {
  public clearAnimTransY: number;
  public clearAnimOpacity: number;
  public clearAnimScale: number;
  /**
   * 通知列表item删除时的延迟
   */
  public clearAnimDelay: number;

  constructor(transY: number, opacity: number, scale: number, delay: number) {
    this.clearAnimTransY = transY;
    this.clearAnimOpacity = opacity;
    this.clearAnimScale = scale;
    this.clearAnimDelay = delay;
  }

  reset() {
    this.clearAnimTransY = 0;
    this.clearAnimOpacity = 1;
    this.clearAnimScale = 1;
    this.clearAnimDelay = 0;
  }
}