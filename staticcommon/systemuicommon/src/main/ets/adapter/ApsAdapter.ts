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
import { threadCall } from '../messageChannel/ThreadCall';
import lazy { ApsUtils } from '@ohos/frameworkwrapper';
// import lazy apsManager from '@ohos.graphic.apsManager';

export class ApsAdapter {
  private static notificationAPSTaskId: number | undefined = undefined;

  @threadCall()
  public static notifyApsManager(isShow: boolean): void | Promise<void> {
    // 展开窗口时通知ApsManager
    if (isShow) {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.S_DDN, 1);
      if (ApsAdapter.notificationAPSTaskId === undefined) {
        ApsAdapter.notificationAPSTaskId = setInterval(() => {
          // ApsUtils.setApsScene(apsManager.SceneAnimation.S_DDN, 1);
        }, 2000);
      }
    } else {
      // 隐藏窗口时通知ApsManager
      if (ApsAdapter.notificationAPSTaskId !== undefined) {
        clearInterval(ApsAdapter.notificationAPSTaskId);
        ApsAdapter.notificationAPSTaskId = undefined;
      }
      // ApsUtils.setApsScene(apsManager.SceneAnimation.S_DDN, 2);
    }
  }
}