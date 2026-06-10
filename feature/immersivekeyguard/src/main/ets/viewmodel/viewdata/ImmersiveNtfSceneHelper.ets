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
import { CommonUtils, SingletonHelper } from '@ohos/basicutils'
import { ImmersiveConstants } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveNtfScene } from '../../common/anim/ImmersiveAnimConstants';

const TAG = 'ImmersiveDataSceneHelper';

/**
 * 沉浸通知变化场景检测辅助类
 */
export class ImmersiveNtfSceneHelper {
  /**
   * 通知变化场景缓存
   */
  private ntfChangeScene: Map<string, ImmersiveNtfScene> = new Map();

  /**
   * 沉浸锁屏通知数据场景
   */
  private immersiveDataSence: Map<string, number> = new Map();

  /**
   * 沉浸锁屏通知数据更新对象记录,避免后续使用时进行遍历
   */
  private immersiveSenceKey: string = '';

  /**
   * 通知新增
   *
   * @param ntfHashCode 通知hash值
   */
  onNtfAdd(ntfHashCode: string) {
    if (CommonUtils.isEmpty(ntfHashCode)) {
      return;
    }
    this.ntfChangeScene.set(ntfHashCode, ImmersiveNtfScene.SCENE_NTF_ADD);
  }

  /**
   * 通知更新
   *
   * @param ntfHashCode 通知hash值
   */
  onNtfUpdate(ntfHashCode: string) {
    if (CommonUtils.isEmpty(ntfHashCode)) {
      return;
    }
    this.ntfChangeScene.set(ntfHashCode, ImmersiveNtfScene.SCENE_NTF_UPDATE);
  }

  /**
   * 设置沉浸锁屏数据的变化场景
   *
   * @param immersiveDataKey 沉浸锁屏数据key值
   * @param childNtfHashCode 子通知hash值
   */
  setImmersiveDataScene(immersiveDataKey: string, childNtfHashCode: string) {
    let childNtfScene = this.ntfChangeScene.get(childNtfHashCode) as ImmersiveNtfScene;
    if (CommonUtils.isEmpty(immersiveDataKey) || CommonUtils.isInvalid(childNtfScene)) {
      return;
    }
    this.ntfChangeScene.delete(childNtfHashCode);
    let dataScene: number = this.immersiveDataSence.get(immersiveDataKey) as number;
    if (CommonUtils.isInvalid(dataScene)) {
      dataScene = childNtfScene;
    } else {
      dataScene |= childNtfScene;
    }
    this.immersiveSenceKey = immersiveDataKey;
    this.immersiveDataSence.set(immersiveDataKey, dataScene);
  }

  /**
   * 清除通知变化场景缓存数据
   */
  clearNtfChangeScene() {
    this.ntfChangeScene.clear();
  }

  /**
   * 清除沉浸锁屏数据变化场景缓存
   */
  clearImmersiveDataScene() {
    this.immersiveDataSence.clear();
    this.immersiveSenceKey = '';
  }

  /**
   * 检测沉浸锁屏数据变化场景是否为对应的场景
   *
   * @param key 沉浸锁屏数据分组key
   * @param scene 检测的场景集
   * @param isAllCheck true则表示检测全场景, false则表示满足其中一个场景
   * @returns 是否为检测的场景
   */
  checkImmersiveDataScene(key: string, scene: number, isAllCheck?: boolean): boolean {
    let dataScene = this.immersiveDataSence.get(key) as number;
    if (CommonUtils.isInvalid(dataScene)) {
      return false;
    }
    return isAllCheck ? (dataScene === scene) : ((dataScene & scene) != 0);
  }

  getImmersiveDataScene(key: string): number | undefined {
    return this.immersiveDataSence.get(key);
  }

  getImmersiveSceneKey(): string {
    return this.immersiveSenceKey;
  }
}

export let immersiveNtfSceneHelper : ImmersiveNtfSceneHelper =
  SingletonHelper.getInstance(ImmersiveNtfSceneHelper, TAG);