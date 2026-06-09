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

import lazy fs from '@ohos.file.fs';
import lazy { ThemeConstant, WallpaperType } from '../utils/ThemeConstant';
import lazy { MashupHandler } from '../engineserviceability/MashupHandler';
import lazy { ThemePermissionParser } from '../utils/ThemePermissionParser';
import { WallpaperDataManager } from './WallpaperDataManager';
import { ScbState } from './WallpaperConstants';
import { WallpaperComponentModifier } from './WallpaperComponentModifier';
import { Log } from '../utils/Log';

const TAG: string = 'EngineWallpaperPage';

@Entry
@Component
struct EngineWallpaperPage {
  @StorageLink('engineScbState') private scbState: number = 0;

  @State private modifier: WallpaperComponentModifier = new WallpaperComponentModifier();

  private wallpaperType: WallpaperType = WallpaperType.UNKNOWN;

  private mashupHandler: MashupHandler = MashupHandler.getInstance();

  private isForceStatic: boolean = false;

  private isPandoraTheme: boolean = false;

  async aboutToAppear() {
    this.initWallpaperType();
    this.scbState = AppStorage.get<number>('savedTargetState') ?? ScbState.LOCKSCREEN;
    this.isForceStatic = AppStorage.get<boolean>(ThemeConstant.KEY_ENGINE_IS_STATIC) ?? false;
    this.isPandoraTheme = AppStorage.get<boolean>(ThemeConstant.KEY_ENGINE_IS_PANDORA) ? true : false;

    let themePermissionParser: ThemePermissionParser = new ThemePermissionParser();
    let res: string[] = await themePermissionParser.parse(AppStorage.get<string>('activeThemePath'));
    if (res.length !== 0 && res.includes('ohos.permission.APPROXIMATELY_LOCATION')) {
      Log.info(TAG, 'Begin refresh location data.');
    }
  }

  build() {
      Stack() {
        WallpaperDataManager({
          wallpaperType: this.wallpaperType,
          activeThemePath: AppStorage.get<string>('activeThemePath'),
          scbState: this.scbState,
          homeType: this.isForceStatic ? WallpaperType.STATIC : this.mashupHandler.getHomeType(),
          lockType: this.isForceStatic ? WallpaperType.STATIC : this.mashupHandler.getLockType(),
          modifier: this.modifier,
        });
      }
      .attributeModifier(this.modifier)
  }

  private initWallpaperType(): void {
    if (!this.isThemeAvailable()) {
      this.wallpaperType = WallpaperType.DEFAULT;
      return;
    }
    this.wallpaperType = AppStorage.get<boolean>(ThemeConstant.KEY_ENGINE_IS_STATIC) as boolean ?
      WallpaperType.STATIC : WallpaperType.DYNAMIC;
  }

  private isThemeAvailable(): boolean {
    let ret: boolean = false;
    try {
      ret = fs.accessSync(ThemeConstant.THEME_A_FLAG) || fs.accessSync(ThemeConstant.THEME_B_FLAG);
    } catch (err) {
      Log.error(TAG, `fs error on checking flag status ${err.code}`);
    }
    return ret;
  }
}
