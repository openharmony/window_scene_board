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
import { Singleton } from '../utils/Singleton';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../live/model/LiveNotification';
import { SCBSceneContainerSession } from '@ohos/windowscene';
import { AppIndexInfo } from '../adapter/PipSceneManagerAdapter';

const TAG = 'PipSceneManager';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class PipSceneManager {
  @Singleton.decorate()
  public static get instance(): PipSceneManager { return new PipSceneManager(); }

  /**
   * 画中画场景集
   */
  public pipScenes: Set<SCBSceneContainerSession> = new Set();
  
  /**
   * 新增画中画场景
   */
  public addPipScene(scene: SCBSceneContainerSession): void {
    log.showInfo(`addPipScene for live, bundleName: ${scene.primarySession?.sceneInfo.bundleName}`);
    // 当前暂不支持多画中画，所以清空之前的画中画场景
    this.pipScenes.clear();
    this.pipScenes.add(scene);
  }

  /**
   * 移除画中画
   */
  public removePipScene(scene: SCBSceneContainerSession): void {
    log.showInfo(`removePipScene for live, bundleName: ${scene.primarySession?.sceneInfo.bundleName}`);
    this.pipScenes.delete(scene);
  }

  /**
   * 当前实况是否处于画中画
   */
  public isPipLive(live: LiveNotification): boolean {
    for (const containerSession of this.pipScenes) {
      // 非播控不处理
      if (!live.isMediaPlayer()) {
        continue;
      }

      // 分屏主窗判断
      const primaryBundleName = containerSession.primarySession?.sceneInfo.bundleName;
      const primaryAppIndex = containerSession.primarySession?.sceneInfo.appIndex;
      if (live.creatorBundleName === primaryBundleName && live.appIndex === primaryAppIndex) {
        return true;
      }

      // 分屏副窗判断
      const secondaryBundleName = containerSession.secondarySession?.sceneInfo.bundleName;
      const secondaryAppIndex = containerSession.secondarySession?.sceneInfo.appIndex;
      if (live.creatorBundleName === secondaryBundleName && live.appIndex === secondaryAppIndex) {
        return true;
      }
    }

    return false;
  }

  public getPipSceneAppInfo(): AppIndexInfo[] {
    let appIndexInfos: AppIndexInfo[] = [];
    for (const containerSession of this.pipScenes) {
      // 分屏主窗判断
      const primaryBundleName = containerSession.primarySession?.sceneInfo.bundleName;
      const primaryAppIndex = containerSession.primarySession?.sceneInfo.appIndex;
      appIndexInfos.push({bundleName: primaryBundleName, appIndex: primaryAppIndex});

      // 分屏副窗判断
      const secondaryBundleName = containerSession.secondarySession?.sceneInfo.bundleName;
      const secondaryAppIndex = containerSession.secondarySession?.sceneInfo.appIndex;
      appIndexInfos.push({bundleName: secondaryBundleName, appIndex: secondaryAppIndex});
    }
    return appIndexInfos;
  }
}
