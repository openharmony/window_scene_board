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
export class ThreeFingerSwipeEvent {
  public x: number = -1;
  public y: number = -1;
  public timestamp: number = 0;

  clone(event: ThreeFingerSwipeEvent): void {
    this.x = event.x;
    this.y = event.y;
    this.timestamp = event.timestamp;
  }

  set(x: number, y: number, time: number): void {
    this.x = x;
    this.y = y;
    this.timestamp = time;
  }

  reset(): void {
    this.set(-1, -1, 0);
  }
}