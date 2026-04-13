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
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { ScreenLockAniParam, ScreenLockFormAniData } from './ScreenLockFormAniData';
import { ScreenLockFormAniModel } from './ScreenLockFormAniModel';

const TAG = 'ScreenLockAnimationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum ScreenLockAniScene {
  INNER,
  BIND_SHEET
}

class ScreenLockFormAniMgr {
  public aniModelMap: Map<ScreenLockAniScene, Map<string, ScreenLockFormAniModel>> = new Map();
  public aniDataArrayMap: Map<ScreenLockAniScene, ScreenLockFormAniData[]> = new Map();

  public prepareAnimation(scene: ScreenLockAniScene, key: string): ScreenLockFormAniModel | undefined {
    if (!this.aniDataArrayMap.has(scene) || CheckEmptyUtils.isEmpty(key)) {
      return undefined;
    }
    log.showInfo(`prepareAnimation scene = ${scene} key = ${key}`);
    let map = this.aniModelMap.get(scene);
    if (CheckEmptyUtils.isEmpty(map)) {
      map = new Map();
      this.aniModelMap.set(scene, map);
    }

    let data: ScreenLockFormAniData = new ScreenLockFormAniData();
    data.id = key;
    let aniModel = new ScreenLockFormAniModel(data);
    map?.set(key, aniModel);
    this.aniDataArrayMap.get(scene)?.push(data);
    log.showInfo(`prepareAnimation size = ${this.aniDataArrayMap.get(scene)?.length}`)
    return aniModel;
  }

  public playAnimation(scene: ScreenLockAniScene, key: string,
    aniData: ScreenLockAniParam, onFinish?: () => void): void {
    if (!this.aniModelMap.has(scene) || CheckEmptyUtils.isEmpty(key)) {
      return;
    }
    log.showInfo(`playAnimation scene = ${scene} key = ${key}`);
    let model = this.aniModelMap.get(scene)?.get(key);
    model?.playAnimation(aniData, () => {
      onFinish?.();
      this.removeData(scene, model?.data);
      this.removeModel(scene, key);
    });
  }

  public cancelAnimation(scene: ScreenLockAniScene, key: string): void {
    log.showInfo(`cancelAnimation scene = ${scene} key = ${key}`);
    if (!this.aniModelMap.has(scene) || CheckEmptyUtils.isEmpty(key)) {
      return;
    }

    let model = this.aniModelMap.get(scene)?.get(key);
    model?.cancelAnimation(() => {
      this.removeData(scene, model?.data);
      this.removeModel(scene, key)
    });
  }

  private removeData(scene: ScreenLockAniScene, data?: ScreenLockFormAniData): void {
    if (!data) {
      return;
    }
    let aniDatas = this.aniDataArrayMap.get(scene);
    if (!aniDatas) {
      return;
    }
    for (let index = aniDatas.length - 1; index >= 0; index--) {
      if (aniDatas[index].id === data.id) {
        aniDatas.splice(index, 1);
      }
    }
  }

  private removeModel(scene: ScreenLockAniScene, key: string): void {
    if (!this.aniModelMap.has(scene) || CheckEmptyUtils.isEmpty(key)) {
      return;
    }
    this.aniModelMap.get(scene)?.delete(key);
  }
}

export const screenLockAniMgr: ScreenLockFormAniMgr = SingletonHelper.getInstance(ScreenLockFormAniMgr, TAG);