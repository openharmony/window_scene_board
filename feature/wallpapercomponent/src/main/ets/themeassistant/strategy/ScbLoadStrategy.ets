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

import { dtWallpaperStateMgr } from '../../wallpaper/model/DesktopWallpaperModel';
import { DualInstanceHandler } from '../handler/DualInstanceHandler';
import { EngineLoadStrategy } from './EngineLoadStrategy';

/**
 * Bottom line strategy to notify SceneBoard to load wallpaper
 *
 * @since 2024-07-18
 */
export class ScbLoadStrategy extends EngineLoadStrategy {
  /**
   * Notify SceneBoard to update whole DesktopWallpaper and display its wallpaper
   * TE will be completely disabled until next theme activation
   */
  public execution(): void {
    super.execution();
    DualInstanceHandler.getInstance().registerCurrentStrategy(this);
    dtWallpaperStateMgr.setDesktopWallpaperMode(false);
  }
}