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

import { IOneMirrorStrategy } from '../model/IOneMirrorStrategy';
import { MirrorScene } from '../service/OneMirrorService';

const TAG = 'OneMirrorDefaultStrategy';

/**
 * 一镜到底默认策略
 */
export class OneMirrorDefaultStrategy implements IOneMirrorStrategy {
  public getName(): string {
    return TAG;
  }

  public needWallpaperAnim(): boolean {
    return true;
  }

  public needScreenLockAnim(toScene: MirrorScene): boolean {
    return true;
  }

  public hasExtraScreenOffAnim(): boolean {
    return false;
  }

  public forceIntoAod(): boolean {
    return false;
  }

  public onFold(isFold: boolean, isWallpaperAodState: boolean, isAodEnabled: boolean): void {
  }
}