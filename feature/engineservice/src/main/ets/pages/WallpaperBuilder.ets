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

import { WallpaperComponent } from './WallpaperComponent';
import lazy { WallpaperConfig } from './WallpaperConfig';
import { WallpaperConstants, WallpaperType } from './WallpaperConstants';
import { WallpaperModifier } from './WallpaperModifier';
import { Constants } from "../utils/Constants";

const TAG: string = 'WallpaperBuilder';

/**
 * Builder component to decide wallpaper component arrangement for all scenarios
 *
 * @since 2024-04-25
 */
@Component
export struct WallpaperBuilder {
  // Wallpaper type for lockscreen component
  public lockType: WallpaperType = WallpaperType.DEFAULT;

  // Wallpaper type for home component
  public homeType: WallpaperType = WallpaperType.DEFAULT;

  @Consume('lockPath')
  private lockImagePath: string;

  @Consume('lockWallpaperConfig')
  private lockWallpaperConfig: WallpaperConfig | undefined;

  @Consume('homeWallpaperConfig')
  private homeWallpaperConfig: WallpaperConfig | undefined;

  @Consume('isLockNewResource')
  private isLockNewResource: boolean;

  @Consume('isHomeNewResource')
  private isHomeNewResource: boolean;

  @Consume('homePath')
  private homeImagePath: string;

  @Consume('aodMaskPath')
  private aodMaskPath: string;

  @State
  private isShowAod: boolean = false;

  @StorageLink('lockVis') @Watch('updateLockVisibility')
  private lockVis: Visibility = Visibility.Visible;

  @StorageLink('homeVis') @Watch('updateHomeVisibility')
  private homeVis: Visibility = Visibility.Hidden;

  @StorageLink('lockOpacity') @Watch('updateLockOpacity')
  private lockOpacity: number = 1;

  @StorageLink('innerWallpaperScale') @Watch('updateScale')
  private innerScale: number = 1;

  @StorageLink('wallpaperOffset') @Watch('updateWallpaperOffset')
  private wallpaperOffset: number[] = [0, 0];

  @State private homeModifier: WallpaperModifier = new WallpaperModifier(WallpaperConstants.ID_HOME, this.homeVis, 1);

  @State private lockModifier: WallpaperModifier = new WallpaperModifier(WallpaperConstants.ID_LOCK, this.lockVis,
    this.lockOpacity);

  @StorageLink('isRenderAodMask') private isRenderAodMask: boolean = false;

  private updateLockVisibility(): void {
    this.lockModifier.updateVisibility(this.lockVis);
  }

  private updateHomeVisibility(): void {
    this.homeModifier.updateVisibility(this.homeVis);
  }

  private updateLockOpacity(): void {
    this.lockModifier.updateOpacity(this.lockOpacity);
  }

  private updateScale(): void {
    this.homeModifier.updateScale(this.innerScale);
    this.lockModifier.updateScale(this.innerScale);
  }

  private updateWallpaperOffset(): void {
    this.lockModifier.setOffset(this.wallpaperOffset);
    this.homeModifier.setOffset(this.wallpaperOffset);
  }

  @Builder
  private mashupBuilder(): void {
    Stack() {
      WallpaperComponent({
        wallpaperType: this.homeType,
        imagePath: this.homeImagePath,
        modifier: this.homeModifier,
        wallpaperConfig: this.homeWallpaperConfig,
        isNewResourceLoad: this.isHomeNewResource,
      })
      WallpaperComponent({
        wallpaperType: this.lockType,
        imagePath: this.lockImagePath,
        modifier: this.lockModifier,
        wallpaperConfig: this.lockWallpaperConfig,
        isNewResourceLoad: this.isLockNewResource,
      })
    }
  }

  /**
   * Construct the overall wallpaper component by its type
   */
  public build(): void {
    this.mashupBuilder();
  }
}