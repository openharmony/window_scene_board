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

export class BasicMediaData {}

export class BasicMediaController {
  public release(): void {};
}

export class BasicMediaVM {
  private holdCount = 0;
  protected data: BasicMediaData;
  protected controller: BasicMediaController;

  constructor() {
    this.data = new BasicMediaData();
    this.controller = new BasicMediaController();
  }

  /**
   * 获取view显示用的数据
   * @param isStrongRef 此次获取是否是长期保存（非临时查询），与releaseData对应，计数器控制动态销毁
   * @returns BasicMediaData
   */
  public getData(isStrongRef: boolean): BasicMediaData {
    if (isStrongRef) {
      this.holdCount += 1;
    }
    return this.data;
  }

  /**
   * 释放单个data强引用，计数器减一
   * @returns 是否这次计数为0导致释放
   */
  public releaseData(): boolean {
    this.holdCount -= 1;
    if (this.holdCount <= 0) {
      this.release();
      return true;
    }
    return false;
  }

  private release() {
    this.controller.release();
  }
}