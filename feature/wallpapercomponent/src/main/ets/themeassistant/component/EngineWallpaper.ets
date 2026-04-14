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
 * Redesigned component to manage ThemeEngine instances
 * Per request to realise non-black-frame effect during theme switch, a dual instance mechanism is applied to ensure
 * there's always content to be displayed on the wallpaper component.
 *
 * @since 2024-07-18
 */
@Component
export struct EngineWallpaper {
  @StorageLink('dualEngineSwitchPrimary') @Watch('firstLoadStateChange')
  private primaryContainerSwitch: boolean = true;

  @StorageLink('dualEngineSwitchSecondary') @Watch('firstLoadStateChange')
  private secondaryContainerSwitch: boolean = false;

  @StorageLink('dualEnginePrimaryZIndex')
  private primaryContainerZIndex: number = 2;

  @StorageLink('dualEngineSecondaryZIndex')
  private secondaryContainerZIndex: number = 1;

  @Link
  public screenProp: SCBScreenProperty;

  public proxyId: string = 'DefaultProxy';

  private persistentId: number = 0;

  @State @Watch('firstLoadStateChange')
  private isFirstLoad: boolean = this.primaryContainerSwitch && this.secondaryContainerSwitch;

  private firstLoadStateChange() :void {
    if (!this.isFirstLoad) {
      return
    }
    if (!this.primaryContainerSwitch || !this.secondaryContainerSwitch) {
      this.isFirstLoad = false;
    }
  }

  public build(): void {
    Stack({ alignContent: Alignment.Center }) {
      if ((this.primaryContainerSwitch && !this.isFirstLoad) || (
        EngineContainerManager.getInstance().getActiveInstanceId() === 'primary' && this.isFirstLoad)) {
        EngineContainer({
          screenProp: this.screenProp,
          proxyId: this.proxyId,
          persistentId: this.persistentId
        })
          .zIndex(this.primaryContainerZIndex);
      }

      if ((this.secondaryContainerSwitch && !this.isFirstLoad) || (
        EngineContainerManager.getInstance().getActiveInstanceId() === 'secondary' && this.isFirstLoad)) {
        EngineContainer({
          screenProp: this.screenProp,
          proxyId: this.proxyId,
          persistentId: this.persistentId
        })
          .zIndex(this.secondaryContainerZIndex);
      }
    }
    .width('100%')
    .height('100%')
  }
}