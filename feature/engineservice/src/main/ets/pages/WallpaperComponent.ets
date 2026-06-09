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
import { DefaultWallpaperDataSource } from "../datasource/DefaultWallpaperDataSource";
import { StaticWallpaperDataSource } from "../datasource/StaticWallpaperDataSource";
import { TriFoldStaticWallpaperDataSource } from "../datasource/TriFoldStaticWallpaperDataSource";
import { Constants } from "../utils/Constants";
import { DeviceUtil } from "../utils/DeviceUtil";
import { FileUtils } from "../utils/FileUtils";
import { Log } from "../utils/Log";
import { TextUtil } from "../utils/TextUtil";
import { WallpaperConfig } from "./WallpaperConfig";
import { WallpaperType } from "./WallpaperConstants";
import { WallpaperModifier } from "./WallpaperModifier";

const TAG: string = 'WallpaperComponent';

/**
 * Definition of a single wallpaper component, which is decided by its wallpaper type
 *
 * @since 2024-04-25
 */
@Component
export struct WallpaperComponent {
  private bsodTag: string = Constants.PREFIX_BSOD + TAG;

  // Wallpaper type for this component
  public wallpaperType: WallpaperType = WallpaperType.DEFAULT;

  // Path to the image, if ever this component uses StaticWallpaperDataSource
  @Link
  public imagePath: string;

  @Link
  public wallpaperConfig: WallpaperConfig | undefined;

  // Indicates whether the resource reading mode is new
  @Link
  public isNewResourceLoad: boolean;

  public sendCode: number = 0;

  @State public modifier: WallpaperModifier | null = null;

  // If using static, validity of image would be checked before it may be fallen back to default
  private checkStaticValidity(): boolean {
    Log.info(TAG, ' checkStaticValidity'+ this.imagePath)
    if (TextUtil.isEmpty(this.imagePath) || !FileUtils.isExists(this.imagePath)) {
      return false;
    }

    return true;
  }

  /**
   * Check validity if using static, switch to default if given image is invalid.
   */
  public async aboutToAppear(): Promise<void> {
    Log.warn(this.bsodTag, `wallpaperComponent in aboutToAppear.` + this.modifier?.id);

    if (this.wallpaperType === WallpaperType.STATIC && !this.checkStaticValidity()) {
      Log.warn(`Wallpaper component ${this.id} uses invalid static source, fallback to default.`);
      this.wallpaperType = WallpaperType.DEFAULT;
    }
  }

  public aboutToDisappear(): void {
    Log.warn(this.bsodTag, `wallpaperComponent in aboutToDisappear() release resource.  ` + this.wallpaperType + '   ' + this.checkStaticValidity());
  }

  public onPageHide(): void {
    Log.warn(this.bsodTag, `wallpaperComponent in onPageHide() release resource.`);
  }

  /**
   * Build the component according to its wallpaper type
   */
  public build(): void {
    if (DeviceUtil.isTriFoldProduct() && this.wallpaperType === WallpaperType.STATIC) {
      TriFoldStaticWallpaperDataSource({
        imagePath: this.imagePath,
        modifier: this.modifier,
        wallpaperConfig: this.wallpaperConfig,
        isNewResourceLoad: this.isNewResourceLoad,
      });
    } else if (this.wallpaperType === WallpaperType.STATIC) {
      StaticWallpaperDataSource({
        imagePath: this.imagePath,
        modifier: this.modifier,
        wallpaperConfig: this.wallpaperConfig,
        isNewResourceLoad: this.isNewResourceLoad,
      });
    } else {
      DefaultWallpaperDataSource({ modifier: this.modifier });
    }
  }
}