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

import { SCBSceneInfo } from '@ohos/windowscene';
import { CommonConstants } from '@ohos/launchercommon';

const WITHOUT_ANIMATION_LIST: string[] = ['com.ohos.onekeylock'];

export class SCBPhoneSceneUtils {

  /**
   * judge scene whether need animation to transition.
   * @param sceneInfo info to match list.
   * @returns boolean
   */
  public static isSceneWithoutAnimation(sceneInfo: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      return false;
    }
    // 屏蔽一键锁屏快捷图标启动动效
    if (sceneInfo.bundleName === CommonConstants.SCENEBOARD_BUNDLE &&
      sceneInfo.abilityName === CommonConstants.ONEKEY_LOCK_UIABILITY) {
      return true;
    }
    return WITHOUT_ANIMATION_LIST.includes(sceneInfo.bundleName);
  }

  /**
   * special list for judging a scene whether phone call related.
   * @param sceneInfo info
   * @returns boolean
   */
  public static isPhoneCallScene(sceneInfo: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      return false;
    }

    let phoneSceneList = [
      { bundleName: 'com.ohos.callui', moduleName: '', abilityName: 'com.ohos.callui.MainAbility', appIndex: 0 },
      { bundleName: 'com.ohos.meetimeservice', moduleName: '', abilityName: 'CallUIKitAbility', appIndex: 0 }
    ];

    for (let item of phoneSceneList) {
      if (sceneInfo.bundleName === item.bundleName && sceneInfo.abilityName === item.abilityName) {
        return true;
      }
    }

    return false;
  }

  /**
   * Judging a scene whether is callUI related.
   * @param sceneInfo info
   * @returns boolean
   */
  public static isCallUIScene(sceneInfo: SCBSceneInfo): boolean {
    if (sceneInfo === null) {
      return false;
    }
    if (sceneInfo.bundleName === 'com.ohos.callui' && sceneInfo.abilityName === 'com.ohos.callui.MainAbility') {
      return true;
    }
    return false;
  }
}