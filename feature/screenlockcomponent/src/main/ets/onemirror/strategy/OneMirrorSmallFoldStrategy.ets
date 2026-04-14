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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { OneMirrorDefaultStrategy } from './OneMirrorDefaultStrategy';
import { MirrorScene } from '../service/OneMirrorService';

const TAG = 'OneMirrorSmallFoldStrategy';

/**
 * 一镜到底小折叠手机策略
 */
export class OneMirrorSmallFoldStrategy extends OneMirrorDefaultStrategy {
  public getName(): string {
    return TAG;
  }

  public needWallpaperAnim(): boolean {
    if (DeviceHelper.isSubDisplayMode()) {
      return false;
    }
    return super.needWallpaperAnim();
  }

  public needScreenLockAnim(toScene: MirrorScene): boolean {
    if (DeviceHelper.isSubDisplayMode() && toScene === MirrorScene.AOD) {
      return false;
    }
    return super.needScreenLockAnim(toScene);
  }

  public hasExtraScreenOffAnim(): boolean {
    if (DeviceHelper.isSubDisplayMode()) {
      return true;
    }
    return super.hasExtraScreenOffAnim();
  }

  public forceIntoAod(): boolean {
    if (DeviceHelper.isSubDisplayMode()) {
      return true;
    }
    return super.forceIntoAod();
  }
}