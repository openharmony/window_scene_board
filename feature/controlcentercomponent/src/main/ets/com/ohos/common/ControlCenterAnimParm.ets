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

class ControlCenterAnim {
  /**
   * Control center card entry shape animate duration (by area)
   */
  public readonly APPEAR_DURATION: number = 250;
  /**
   * Animate duration of the exit chart of the control center card (by area)
   */
  public readonly DISAPPEAR_DURATION: number = 250;

  public readonly APPEAR_DELAY_INTERVAL: number = 32;

  public readonly DISAPPEAR_DELAY_INTERVAL: number = 16;

  public readonly SCALE_VAL: number = 0.9;

  public readonly TRANSITION_Y: number = 150;
}

export default new ControlCenterAnim();
