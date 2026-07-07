/**
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { RotationConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SCBScreenSessionManager,
  SCBScreenProperty,
  RecentsStyleConstants,
  SCBContainerRotationReason,
  SCBSceneContainerSession
} from '@ohos/windowscene';
import {
  RotateFuncType,
  WrapRotationEntryParam } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';

export class RecentRotationUtil {
  public static isSameRotation(screenRotation: number, sessionRotation: number): boolean {
    let diff = Math.abs(screenRotation - sessionRotation);
    return diff === RotationConstants.ROTATION_0 ||
      diff === RotationConstants.ROTATION_180 ||
      diff === RotationConstants.ROTATION_360;
  }

  public static getRecentScaleByRotation(isScreenVertical: boolean): number {
    if (isScreenVertical) {
      return RecentsStyleConstants.VERTICAL_RECENT_SCALE;
    }
    return RecentsStyleConstants.HORIZONTAL_RECENT_SCALE;
  }

  public static getScreenRotation(screenProperty: SCBScreenProperty): number {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (screenSession) {
      return screenSession.getRealRotation(screenProperty.rotation);
    }
    return screenProperty.rotation;
  }

  /**
   * 返回设备的旋转状态
   * @returns 旋转状态 0 竖屏 1 横屏 2 和横屏相对 3 和竖屏相对
   */
  public static getRotateStatus(rotate: number): number {
    switch (rotate) {
      case RotationConstants.ROTATION_0:
        return 0;
      case RotationConstants.ROTATION_270:
        return 1;
      case RotationConstants.ROTATION_90:
        return 2;
      case RotationConstants.ROTATION_180:
        return 3;
      default:
        return 0;
    }
  }

  public static createRotationParam(rotateFuncType: RotateFuncType, reason: SCBContainerRotationReason,
    containerSession?: SCBSceneContainerSession, needAnimation?: boolean,
    isFromRecent?: boolean): WrapRotationEntryParam {
    let param = new WrapRotationEntryParam();
    param.rotateFuncType = rotateFuncType;
    param.reason = reason;
    if (containerSession !== undefined) {
      param.containerSession = containerSession;
    }
    if (needAnimation !== undefined) {
      param.needAnimation = needAnimation;
    }
    if (isFromRecent !== undefined) {
      param.isFromRecent = isFromRecent;
    }
    return param;
  }
}
