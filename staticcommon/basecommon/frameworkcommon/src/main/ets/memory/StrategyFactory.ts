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
import { TrimLevel, ViewType } from '@ohos/frameworkwrapper';
import { TrimScene } from './MemoryManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { GcDecider } from './GcDecider';
import { ClearMissionFullGcDecider, PssGcDecider } from './GcDecider';

const TAG = 'StrategyFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 内存回收策略
 * 指定不同场景下不同0层组件的内存回收策略
 *
 * @since 2023-11-04
 */
export class TrimStrategy {
  viewType: ViewType | string;
  scene: TrimScene;
  level: TrimLevel;

  constructor(viewType: ViewType | string, scene: TrimScene, level: TrimLevel) {
    this.viewType = viewType;
    this.scene = scene;
    this.level = level;
  }
}

/**
 * 内存监控策略
 * 指定对应场景的Gc触发策略
 *
 * @since 2023-11-04
 */
export class GcMonitorStrategy {
  scene: TrimScene;

  /**
   * GcDecider
   */
  gcDecider: GcDecider;

  constructor(scene: TrimScene, decider: GcDecider) {
    this.scene = scene;
    this.gcDecider = decider;
  }
}

/**
 * 内存策略管理工厂类
 *
 * @since 2023-11-04
 */
export abstract class StrategyFactory {
  public constructor() {
  }

  /**
   * 初始化内存回收策略集合
   *
   * @param map 内存回收策略集合
   */
  public intTrimStrategyMap(map: Map<TrimScene, Map<ViewType | string, TrimLevel>>): void {
    let array: Array<TrimStrategy> = this.buildTrimStrategies();
    log.showInfo(`intTrimStrategyMap -> get trimStrategy, length:${array.length}`);
    for (const strategy of array) {
      let levelMap: Map<ViewType | string, TrimLevel> | undefined = map.get(strategy.scene);
      if (!levelMap) {
        levelMap = new Map<ViewType | string, TrimLevel>();
        map.set(strategy.scene, levelMap);
      }
      levelMap.set(strategy.viewType, strategy.level);
    }
  }

  /**
   * 初始化内存监控策略集合
   *
   * @param map 内存监控策略集合
   */
  public intGcStrategyMap(map: Map<TrimScene, GcDecider>): void {
    let array: Array<GcMonitorStrategy> = this.buildGcMonitorStrategies();
    log.showInfo(`intGcStrategyMap -> get gcStrategy, length:${array.length}`);
    for (const strategy of array) {
      map.set(strategy.scene, strategy.gcDecider);
    }
  }

  /**
   * 加载内存回收策略列表
   * 子类通过复写这个方法来定制化加载内存回收策略
   *
   * @returns 内存回收策略列表
   */
  protected abstract buildTrimStrategies(): Array<TrimStrategy>;

  /**
   * 加载内存监控策略列表
   * 子类通过复写这个方法来定制化加载内存监控策略
   *
   * @returns 内存监控策略列表
   */
  protected abstract buildGcMonitorStrategies(): Array<GcMonitorStrategy>;
}

/**
 * 手机形态产品内存回收策略工厂
 *
 * @since 2023-11-04
 */
export class PhoneStrategyFactory extends StrategyFactory {
  protected buildTrimStrategies(): Array<TrimStrategy> {
    let array: Array<TrimStrategy> = new Array<TrimStrategy>();
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.CLEAR_MISSION_FULL, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.LOCK_SCREEN, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.DESKTOP, TrimScene.OPEN_APP, TrimLevel.LIGHT));

    array.push(new TrimStrategy(ViewType.CONTROL_CENTER, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.CONTROL_CENTER, TrimScene.LOCK_SCREEN, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.DROPDOWN, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.DROPDOWN, TrimScene.LOCK_SCREEN, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.DROPDOWN, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    array.push(new TrimStrategy(ViewType.DROPDOWN, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.GLOBAL_SEARCH, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.GLOBAL_SEARCH, TrimScene.LOCK_SCREEN, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.WALLPAPER, TrimScene.CLEAR_MISSION, TrimLevel.LIGHT));
    array.push(new TrimStrategy(ViewType.WALLPAPER, TrimScene.LOCK_SCREEN, TrimLevel.COMPLETE));
    array.push(new TrimStrategy(ViewType.WALLPAPER, TrimScene.MEMORY_LEVEL, TrimLevel.COMPLETE));

    array.push(new TrimStrategy(ViewType.NEGATIVE_SCREEN, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));

    array.push(new TrimStrategy(ViewType.VOLUME, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));

    array.push(new TrimStrategy(ViewType.GLOBAL_SEARCH, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));

    array.push(new TrimStrategy(ViewType.RECENT, TrimScene.CLEAR_MISSION_FULL, TrimLevel.CRITICAL));
    return array;
  }

  protected buildGcMonitorStrategies(): Array<GcMonitorStrategy> {
    // let defaultPssThreshold: bigint = MemoryUtils.getDefaultPssThreshold();
    let array: Array<GcMonitorStrategy> = new Array<GcMonitorStrategy>();
    // array.push(new GcMonitorStrategy(TrimScene.CLEAR_MISSION, new PssGcDecider(defaultPssThreshold)));
    array.push(new GcMonitorStrategy(TrimScene.CLEAR_MISSION, new PssGcDecider()));
    // array.push(new GcMonitorStrategy(TrimScene.MEMORY_LEVEL, new PssGcDecider(defaultPssThreshold)));
    array.push(new GcMonitorStrategy(TrimScene.MEMORY_LEVEL, new PssGcDecider()));

    // array.push(new GcMonitorStrategy(TrimScene.CLEAR_MISSION_FULL, new ClearMissionFullGcDecider(defaultPssThreshold)));
    array.push(new GcMonitorStrategy(TrimScene.CLEAR_MISSION_FULL, new ClearMissionFullGcDecider()));
    // array.push(new GcMonitorStrategy(TrimScene.MEMORY_LEVEL, new ClearMissionFullGcDecider(defaultPssThreshold)));
    array.push(new GcMonitorStrategy(TrimScene.MEMORY_LEVEL, new ClearMissionFullGcDecider()));
    return array;
  }
}