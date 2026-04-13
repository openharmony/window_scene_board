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
import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { OuterFormBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

// 锁屏时钟组件UI绑定状态
@Observed
export class SlOuterFormBindState extends WidgetBindState<OuterFormBindStateType> {
  // 透明度
  @Track private opacity?: number;
  // 当前小外屏服务卡片是否从桌面/应用到AOD一镜到底
  @Track private isOuterFormDesktopToAod?: boolean;
  // 外屏服务卡片是否执行进入/退出沉浸式列表态动效
  @Track private isOuterFormImmersiveAnimating?: boolean;

  constructor() {
    super(SlMainStateType.SL_OUTER_FORM_WG_BIND_STATE);
  }

  protected initSetMethods(): void {
    this.setMethods.set(OuterFormBindStateType.OPACITY_ALPHA, this.setMethodOpacity);
  }

  private setMethodOpacity(st: SlOuterFormBindState, value: number): void {
    st.setOpacity(value);
  }

  private getMethodOpacity(st: SlOuterFormBindState): number | undefined {
    return st.getOpacity();
  }

  protected initGetMethods(): void {
    this.getMethods.set(OuterFormBindStateType.OPACITY_ALPHA, this.getMethodOpacity);
  }

  public setOpacity(opacity: number): SlOuterFormBindState {
    if (this.opacity !== opacity) {
      this.opacity = opacity;
    }
    return this;
  }

  public getOpacity(): number | undefined {
    return this.opacity;
  }

  public setOuterFormDesktopToAod(isOuterFormDesktopToAod: boolean): SlOuterFormBindState {
    if (this.isOuterFormDesktopToAod !== isOuterFormDesktopToAod) {
      this.isOuterFormDesktopToAod = isOuterFormDesktopToAod;
    }
    return this;
  }

  public getOuterFormDesktopToAod(): boolean {
    return this.isOuterFormDesktopToAod ?? false;
  }

  public setIsOuterFormImmersiveAnimating(isAnimating: boolean): SlOuterFormBindState {
    if (this.isOuterFormImmersiveAnimating !== isAnimating) {
      this.isOuterFormImmersiveAnimating = isAnimating;
    }
    return this;
  }

  public getIsOuterFormImmersiveAnimating(): boolean {
    return this.isOuterFormImmersiveAnimating ?? false;
  }
}