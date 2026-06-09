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
import { ScreenLockLayoutStyle, ScreenLockLayoutStyleForHPR } from '../style/ScreenLockLayoutStyle';

export class ScreenLockLayoutManager {
  private static sInstance: ScreenLockLayoutManager;
  private mScreenLockLayoutImpl: ScreenLockLayoutStyle;

  constructor() {
    this.mScreenLockLayoutImpl = new ScreenLockLayoutStyle();
  }

  public static getInstance(): ScreenLockLayoutManager {
    if (!ScreenLockLayoutManager.sInstance) {
      ScreenLockLayoutManager.sInstance = new ScreenLockLayoutManager();
    }
    return ScreenLockLayoutManager.sInstance;
  }

  get gridWidth(): number {
    return this.mScreenLockLayoutImpl.gridWidth;
  }

  get clockGridColumns(): number {
    return this.mScreenLockLayoutImpl.clockGridColumns;
  }

  get clockGridRows(): number {
    return this.mScreenLockLayoutImpl.clockGridRows;
  }

  get timeFontScale(): number {
    return this.mScreenLockLayoutImpl.timeFontScale;
  }

  get timeDateSpace(): number {
    return this.mScreenLockLayoutImpl.timeDateSpace;
  }

  get dateTextSize(): Resource {
    return this.mScreenLockLayoutImpl.dateTextSize;
  }

  get multiUserWidth(): number {
    return this.mScreenLockLayoutImpl.multiUserWidth;
  }

  get multiUserHeight(): number {
    return this.mScreenLockLayoutImpl.multiUserHeight;
  }

  get multiUserColGap(): number {
    return this.mScreenLockLayoutImpl.multiUserColGap;
  }

  get multiUserRowGap(): number {
    return this.mScreenLockLayoutImpl.multiUserRowGap;
  }
}