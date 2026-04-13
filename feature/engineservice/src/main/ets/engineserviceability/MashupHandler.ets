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

import lazy fs from '@ohos.file.fs';
import { Constants } from '../utils/Constants';
import { Log } from '../utils/Log';
import lazy { WallpaperType } from '../utils/ThemeConstant';

const TAG: string = 'MashupHandler';
const ANIMATION_SKIP: number = -1;

const DYNAMIC_LOCK_ANIMATION_REMAP: Map<number, number> = new Map([
  [Constants.LOCKSCREEN_TO_LAUNCHER, ANIMATION_SKIP],
  [Constants.AOD_TO_LAUNCHER, Constants.AOD_TO_LOCKSCREEN],
  [Constants.LAUNCHER_TO_AOD, Constants.LOCKSCREEN_TO_AOD],
  [Constants.LAUNCHER_TO_LOCKSCREEN, Constants.LOCKSCREEN_STATUS],
  [Constants.LAUNCHER_STATUS, Constants.LOCKSCREEN_STATUS],
]);

/**
 * Used to help with Mashup condition. i.e. when home and lock are not in the same static/dynamic state
 *
 * @since 2024-05-27
 */
export class MashupHandler {
  private homeType: WallpaperType = WallpaperType.UNKNOWN;

  private lockType: WallpaperType = WallpaperType.UNKNOWN;

  private isHomeForceAnimate: boolean = false;

  private static instance: MashupHandler | undefined;

  /**
   * Init both type on creating this class
   */
  private constructor() {
    this.homeType = this.getTypeByPart('home');
    this.lockType = this.getTypeByPart('lock');
    Log.info(TAG, `Init with home type ${this.homeType} and lock type ${this.lockType}`);
  }

  public static getInstance(): MashupHandler {
    if (!MashupHandler.instance) {
      MashupHandler.instance = new MashupHandler();
    }
    return MashupHandler.instance;
  }

  /**
   * Get the home wallpaper's dynamic/static state
   *
   * @returns Home wallpaper's dynamic/static state
   */
  public getHomeType(): WallpaperType {
    if (this.homeType === WallpaperType.UNKNOWN || this.homeType === WallpaperType.DEFAULT) {
      this.homeType = this.getTypeByPart('home');
      Log.info(TAG, `Load home type ${this.homeType}.`);
    }
    return this.homeType;
  }

  /**
   * Get the lock wallpaper's dynamic/static state
   *
   * @returns Lock wallpaper's dynamic/static state
   */
  public getLockType(): WallpaperType {
    if (this.lockType === WallpaperType.UNKNOWN || this.lockType === WallpaperType.DEFAULT) {
      this.lockType = this.getTypeByPart('lock');
      Log.info(TAG, `Load lock type ${this.lockType}.`);
    }
    return this.lockType;
  }

  /**
   * Get the live dynamic/static state of given part
   *
   * @param part Wallpaper part, which would be either home or lock
   * @returns Wallpaper's dynamic/static state
   */
  private getTypeByPart(part: string): WallpaperType {
    let manifest: object | undefined = this.parseManifest(part);
    if (!manifest || manifest['type'] === undefined) {
      Log.warn(TAG, 'Invalid manifest were given, unable to get type');
      return WallpaperType.UNKNOWN;
    }

    if (manifest['type'] === 'image') {
      return WallpaperType.STATIC;
    }

    if (manifest['type'] === 'script' || manifest['type'] === 'longTake') {
      if (part === 'home' && manifest['type'] === 'script') {
        this.isHomeForceAnimate = true;
      }
      return WallpaperType.DYNAMIC;
    }

    Log.warn(TAG, `Unknown type ${manifest['type']}`);
    return WallpaperType.DEFAULT;
  }

  private parseManifest(part: string): object | undefined {
    let manifestFile: string = `${AppStorage.get<string>('activeThemePath')}/${part}/manifest.json`;

    try {
      if (!fs.accessSync(manifestFile)) {
        Log.error(TAG, `No manifest file exists: ${manifestFile}`);
        return undefined;
      }
      let jsonContent: object = JSON.parse(fs.readTextSync(manifestFile));
      return jsonContent;
    } catch (e) {
      Log.error(TAG, `Error on parsing manifest file, error ${e?.code} message ${e?.message}}`);
      return undefined;
    }
  }

  /**
   * Remap the animation when under mashup state
   * Especially when mashing and lock is dynamic, it's better for engine never reached LAUNCHER state.
   * While when home is dynamic, it never should play any transitioning animation.
   *
   * @param incomingAnimation Candidate animation getting from the default animation map
   * @returns Remapped animation state
   */
  public animationRemap(incomingAnimation: number): number {
    // No need for remap if not mashing up
    if (this.homeType === this.lockType) {
      return incomingAnimation;
    }

    if (this.lockType === WallpaperType.DYNAMIC) {
      let remappedAnimation: number = DYNAMIC_LOCK_ANIMATION_REMAP.get(incomingAnimation) ?? incomingAnimation;
      if (incomingAnimation !== remappedAnimation) {
        Log.info(TAG, `Remapping animation from ${incomingAnimation} to ${remappedAnimation}`);
      }
      return remappedAnimation;
    }

    // Mashing up but home in dynamic, no transition animation is necessary.
    Log.info(TAG, 'Intercepting animation call under mashup home dynamic');
    return this.isHomeForceAnimate ? incomingAnimation : ANIMATION_SKIP;
  }
}