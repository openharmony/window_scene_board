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

import { SCBScreenProperty } from '@ohos/windowscene';
import { EngineContainer } from './EngineContainer';
import { EngineContainerManager } from './EngineContainerManager';

/**
 * Rewrite component to manage ThemeEngine instances for verde outer screen
 * Per request to realise non-black-frame effect during theme switch, a dual instance mechanism is applied to ensure
 * there's always content to be displayed on the wallpaper component.
 *
 * @since 2025-03-04
 */
@Component
export struct OuterEngineWallpaper {
  @StorageLink('outerDualEngineSwitchPrimary') @Watch('outerFirstLoadStateChange')
  private outerPrimaryContainerSwitch: boolean = true;

  @StorageLink('outerDualEngineSwitchSecondary') @Watch('outerFirstLoadStateChange')
  private outerSecondaryContainerSwitch: boolean = false;

  @StorageLink('outerDualEnginePrimaryZIndex')
  private outerPrimaryContainerZIndex: number = 2;

  @StorageLink('outerDualEngineSecondaryZIndex')
  private outerSecondaryContainerZIndex: number = 1;

  @Link
  public screenProp: SCBScreenProperty;

  public outerScreenFlag: boolean = false;

  public proxyId: string = 'DefaultProxy';

  @State @Watch('outerFirstLoadStateChange')
  private isOuterFirstLoad: boolean = this.outerPrimaryContainerSwitch && this.outerSecondaryContainerSwitch;

  private outerFirstLoadStateChange(): void {
    if (!this.isOuterFirstLoad) {
      return;
    }
    if (!this.outerPrimaryContainerSwitch || !this.outerSecondaryContainerSwitch) {
      this.isOuterFirstLoad = false;
    }
  }

  public build(): void {
    Stack() {
      if ((this.outerPrimaryContainerSwitch && !this.isOuterFirstLoad) || (
        EngineContainerManager.getInstance().getOuterActiveInstanceId() === 'primary' && this.isOuterFirstLoad)) {
        EngineContainer({
          screenProp: this.screenProp,
          outerScreenFlag: this.outerScreenFlag,
          proxyId: this.proxyId
        })
          .zIndex(this.outerPrimaryContainerZIndex);
      }

      if ((this.outerSecondaryContainerSwitch && !this.isOuterFirstLoad) || (
        EngineContainerManager.getInstance().getOuterActiveInstanceId() === 'secondary' && this.isOuterFirstLoad)) {
        EngineContainer({
          screenProp: this.screenProp,
          outerScreenFlag: this.outerScreenFlag,
          proxyId: this.proxyId
        })
          .zIndex(this.outerSecondaryContainerZIndex);
      }
    }
  }
}