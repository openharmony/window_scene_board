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
import { ScreenLockSpaceAniData, ScreenLockSpaceBlurData } from './ScreenLockSpaceAniOptions'


class SpaceAniHelper {
  private spaceAniLockIconState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniClockState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniFormState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniQuickToolState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniCameraState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniImmersiveCapState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniImmersiveListState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniImmersiveCardState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniGreetState: ScreenLockSpaceAniData = new ScreenLockSpaceAniData();
  private spaceAniBlurState: ScreenLockSpaceBlurData = new ScreenLockSpaceBlurData();

  public getSpaceAniClockState(): ScreenLockSpaceAniData {
    return this.spaceAniClockState;
  }

  public getSpaceAniFormState(): ScreenLockSpaceAniData {
    return this.spaceAniFormState;
  }

  public getSpaceAniQuickToolState(): ScreenLockSpaceAniData {
    return this.spaceAniQuickToolState;
  }

  public getSpaceAniCameraState(): ScreenLockSpaceAniData {
    return this.spaceAniCameraState;
  }

  public getSpaceAniImmersiveCapState(): ScreenLockSpaceAniData {
    return this.spaceAniImmersiveCapState;
  }

  public getSpaceAniImmersiveListState(): ScreenLockSpaceAniData {
    return this.spaceAniImmersiveListState;
  }

  public getSpaceAniImmersiveCardState(): ScreenLockSpaceAniData {
    return this.spaceAniImmersiveCardState;
  }

  public getSpaceAniGreetState(): ScreenLockSpaceAniData {
    return this.spaceAniGreetState;
  }

  public getSpaceAniLockIconState(): ScreenLockSpaceAniData {
    return this.spaceAniLockIconState;
  }

  public getSpaceAniBlurState(): ScreenLockSpaceBlurData {
    return this.spaceAniBlurState;
  }
}

export let spaceAniHelper: SpaceAniHelper = new SpaceAniHelper();