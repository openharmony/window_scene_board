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
export class GestureDockPullOutData {
  public isLock: boolean = false;
  public isLeft: boolean = false;
  public persistentId: number = 0;
  // Back手势的图标是否变为了Dock的图标
  public isBackImageChange: boolean = false;
  // Back手势的图标变Dock的图标的动效进行中
  public isChangeDockImgAnimRunning: boolean = false;
  // Back手势图标移动开始
  public isMoveBackAnimStart: boolean = false;
  // Back手势的图标变Dock的图标的动效开始的时间
  public startChangeDockImgTime: number = 0;
  // 滑动手势的松手时间
  public actionUpTime: number = 0;
  // Dock呼入的动效执行过程中
  public isGestureDockInRunning: boolean = false;
  public isPullOutDock: boolean = false;

  public reset(): void {
    this.isBackImageChange = false;
    this.isChangeDockImgAnimRunning = false;
    this.isMoveBackAnimStart = false;
    this.isPullOutDock = false;
    this.startChangeDockImgTime = 0;
    this.actionUpTime = 0;
  }
}