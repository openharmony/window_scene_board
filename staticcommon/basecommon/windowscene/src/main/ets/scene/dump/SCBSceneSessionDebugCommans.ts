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
import { KeyValueArray, SCBDebugUtils } from './uiDumpUtils/SCBDebugUtils';
import { SCBSceneSessionArray } from '../session/SCBSceneContainerSession';
import { SCBSceneSession } from '../session/SCBSceneSession';

export class SCBSceneSessionDebugCommands {
  public static buildListSession(sessionArray: SCBSceneSessionArray): string {
    return JSON.stringify(sessionArray);
  }

  public static buildSession(session: SCBSceneSession | null): string {
    if (session == null) {
      return '';
    }
    let sessionArray: KeyValueArray = new KeyValueArray;
    sessionArray.push('isNewWant', session.isNewWant);
    sessionArray.push('isFocused', session.isFocused);
    sessionArray.push('isFocusable', session.isFocusable);
    sessionArray.push('isTouchable', session.isTouchable);
    sessionArray.push('isShowWhenLocked', session.isShowWhenLocked);
    sessionArray.push('isShowAboveKeyguard', session.isShowAboveKeyguard);
    sessionArray.push('isHideShadow', session.isHideShadow);
    sessionArray.push('visibility', session.visibility);
    sessionArray.push('needAvoid', session.needAvoid);
    sessionArray.push('statusVisible', session.statusVisible);
    sessionArray.push('isMaximizeFloating', session.isMaximizeFloating);
    sessionArray.push('translateX', session.translateX);
    sessionArray.push('translateY', session.translateY);
    sessionArray.push('positionX', session.positionX);
    sessionArray.push('positionY', session.positionY);
    sessionArray.push('scaleX', session.scaleX);
    sessionArray.push('scaleY', session.scaleY);
    sessionArray.push('opacity', session.opacity);
    sessionArray.push('isMinimizing', session.isMinimizing);
    sessionArray.push('isClosing', session.isClosing);
    sessionArray.push('floatBorderRadius', session.floatBorderRadius);
    sessionArray.push('width', session.width.getPxSizeStr());
    sessionArray.push('height', session.height.getPxSizeStr());
    sessionArray.push('shadowConfig', session.shadowConfig);
    sessionArray.push('lastRect', session.lastRect);
    sessionArray.push('currRect', session.currRect);
    sessionArray.push('zOrder', session.sessionInfo.zOrder);
    sessionArray.push('currentRotation', session.currentRotation);
    sessionArray.push('isLastSplit', session.isLastSplit);
    sessionArray.push('sessionState', session.sessionState);
    sessionArray.push('systemBarProperty', session.systemBarProperty);
    sessionArray.push('subSessionCacheList', session.subSessionCacheList);
    sessionArray.push('subSessionList', session.subSessionList);
    sessionArray.push('dialogSessionList', session.dialogSessionList);
    return SCBDebugUtils.buildContext(sessionArray);
  }
}