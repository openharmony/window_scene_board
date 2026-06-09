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

import {
  ClearMissionFullGcDecider,
  TrimScene,
  GcMonitorStrategy,
  TrimStrategy,
  StrategyFactory,
  PssGcDecider
} from '@ohos/frameworkcommon';
import { TrimLevel, ViewType } from '@ohos/frameworkwrapper';

/**
 * Pad内存回收触发水线
 */
export const TRIGGER_MEMORY_LEVEL: bigint = BigInt(1024 * 190);

export class PadStrategyFactory extends StrategyFactory {
  protected buildTrimStrategies(): Array<TrimStrategy> {
    let array: TrimStrategy[] = [];
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.LOCK_SCREEN, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.OPEN_APP, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.CONTROL_CENTER, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.CONTROL_CENTER, TrimScene.LOCK_SCREEN, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.CONTROL_CENTER, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.DROPDOWN, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.DROPDOWN, TrimScene.LOCK_SCREEN, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.DROPDOWN, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    array.push(new TrimStrategy(ViewType.DROPDOWN, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.GLOBAL_SEARCH, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.GLOBAL_SEARCH, TrimScene.LOCK_SCREEN, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.GLOBAL_SEARCH, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.WALLPAPER, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.WALLPAPER, TrimScene.LOCK_SCREEN, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.WALLPAPER, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.NEGATIVE_SCREEN, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    array.push(new TrimStrategy(ViewType.NEGATIVE_SCREEN, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.VOLUME, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    array.push(new TrimStrategy(ViewType.VOLUME, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.GLOBAL_SEARCH, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    array.push(new TrimStrategy(ViewType.GLOBAL_SEARCH, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.RECENT, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    array.push(new TrimStrategy(ViewType.RECENT, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.NOTIFICATION_BANNER, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.KEYGUARD, TrimScene.LOCK_SCREEN_SLEEP, TrimLevel.COMPLETE));
    return array;
  }

  protected buildGcMonitorStrategies(): Array<GcMonitorStrategy> {
    //let defaultPssThreshold: bigint = MemoryUtils.getDefaultPssThreshold();
    let array: GcMonitorStrategy[] = [];
    // array.push(new GcMonitorStrategy(TrimScene.CLEAR_MISSION, new PssGcDecider(defaultPssThreshold)));
    // array.push(new GcMonitorStrategy(TrimScene.MEMORY_LEVEL, new PssGcDecider(defaultPssThreshold)));
    //
    // array.push(new GcMonitorStrategy(TrimScene.CLEAR_MISSION_FULL, new ClearMissionFullGcDecider(defaultPssThreshold)));
    // array.push(new GcMonitorStrategy(TrimScene.MEMORY_LEVEL, new ClearMissionFullGcDecider(defaultPssThreshold)));
    //
    // array.push(new GcMonitorStrategy(TrimScene.LOCK_SCREEN_SLEEP, new ClearMissionFullGcDecider(TRIGGER_MEMORY_LEVEL)));
    return array;
  }
}