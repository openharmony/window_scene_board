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

import { LogDomain, LogHelper } from '@ohos/basicutils';


const TAG = 'AnimManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class AnimManager {
  private anims: Map<string, AnimProperty> = new Map();
  private static mInstance: AnimManager;

  public static getInstance(): AnimManager {
    if (!AnimManager.mInstance) {
      AnimManager.mInstance = new AnimManager();
    }
    return AnimManager.mInstance;
  }

  getAnim(key: string): AnimProperty {
    if (!this.anims.has(key)) {
      let anim = new AnimProperty(key);
      this.anims.set(key, anim);
      return anim;
    }
    return this.anims.get(key) as AnimProperty;
  }

  clear(): void {
    this.anims.clear();
  }

  resetAnims(): void {
    this.anims.forEach((anim) => {
      anim.isPluginIconAnimating = false;
      anim.scaleX = 1;
      anim.scaleY = 1;
      anim.backgroundScaleX = 1;
      anim.backgroundScaleY = 1;
    });
  }

  updateScale(key: string, scaleX?: number, scaleY?: number): void {
    if (!this.anims.has(key)) {
      log.showDebug('updateSelectedState failed, not found key: ' + key);
      return;
    }
    let anim = this.anims.get(key) as AnimProperty;
    if (scaleX !== undefined) {
      anim.scaleX = scaleX;
    }
    if (scaleY !== undefined) {
      anim.scaleY = scaleY;
    }
  }

  updateBgScale(key: string, bgScaleX?: number, bgScaleY?: number): void {
    if (!this.anims.has(key)) {
      log.showDebug('updateBgScale failed, not found key: ' + key);
      return;
    }
    let anim = this.anims.get(key) as AnimProperty;
    if (bgScaleX !== undefined) {
      anim.backgroundScaleX = bgScaleX;
    }
    if (bgScaleY !== undefined) {
      anim.backgroundScaleY = bgScaleY;
    }
  }

  updatePlayingState(key: string, isPlaying: boolean): void {
    if (!this.anims.has(key)) {
      log.showDebug('updatePlayingState failed, not found key: ' + key);
      return;
    }
    let anim = this.anims.get(key) as AnimProperty;
    if (anim.isPluginIconAnimating !== isPlaying) {
      anim.isPluginIconAnimating = isPlaying;
    }
  }
}

@Observed
export class AnimProperty {
  public slot: string = '';
  /**
   * 图标是否正在动画
   */
  public isPluginIconAnimating: boolean = false;
  /**
   * 图标横向缩放
   */
  public scaleX: number = 1;
  /**
   * 图标纵向缩放
   */
  public scaleY: number = 1;
  /**
   * 底板横向缩放
   */
  public backgroundScaleX: number = 1;
  /**
   * 底板纵向缩放
   */
  public backgroundScaleY: number = 1;

  constructor(slot: string) {
    this.slot = slot;
  }
}