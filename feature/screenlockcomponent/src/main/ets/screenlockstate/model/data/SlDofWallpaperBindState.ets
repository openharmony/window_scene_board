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

import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { DofWallpaperBindStateType, SlMainStateType,
  SlSubStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';

// 锁屏景深壁纸UI绑定状态
@Observed
export class SlDofWallpaperBindState extends WidgetBindState<DofWallpaperBindStateType> {
  public slStateChangeListener?: ISlStateChangeListener | undefined; // 复写ISlState
  @Track private dofWallpaperLight: number = 1; // 壁纸亮度

  constructor() {
    super(SlMainStateType.SL_DOF_WALLPAPER_BIND_STATE);
  }

  protected initSetMethods(): void {
    this.setMethods.set(DofWallpaperBindStateType.DOF_WALLPAPER_LIGHT, this.setMethodLight);
  }

  private setMethodLight(st: SlDofWallpaperBindState, value: number): void {
    st.setLight(value);
  }

  protected notifyStateChange(subType: DofWallpaperBindStateType): void { // 通知状态切换
    this.slStateChangeListener?.onSlStateChange?.(SlMainStateType.SL_DOF_WALLPAPER_BIND_STATE, subType);
  }

  public setLight(light: number): void {
    if (this.dofWallpaperLight !== light) {
      this.dofWallpaperLight = light;
      this.notifyStateChange(DofWallpaperBindStateType.DOF_WALLPAPER_LIGHT);
    }
  }

  public getDofLight(): number {
    return this.dofWallpaperLight;
  }
}