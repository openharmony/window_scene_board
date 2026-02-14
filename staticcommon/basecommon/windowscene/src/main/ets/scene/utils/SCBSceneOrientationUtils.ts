/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SCBSceneOrientation } from '../session/SCBSceneOrientation';
import { RotationConstants } from '@ohos/commonconstants';

export class SCBSceneOrientationUtils {

  /**
   * Judge target rotation is 0 and orientation is allowed portrait.
   */
  public static isAllowPortrait(targetRotation: number, orientation: SCBSceneOrientation): boolean {
    return targetRotation === RotationConstants.ROTATION_0 &&
      SCBSceneOrientationUtils.isOrientationAllowPortrait(orientation);
  }

  /**
   * Judge target rotation is 270 and orientation is allowed landscape.
   */
  public static isAllowLandscape(targetRotation: number, orientation: SCBSceneOrientation): boolean {
    return targetRotation === RotationConstants.ROTATION_270 &&
      SCBSceneOrientationUtils.isOrientationAllowLandscape(orientation);
  }

  /**
   * Judge the orientation is allowed inverted portrait.
   */
  public static isAllowPortraitInverted(targetRotation: number, orientation: SCBSceneOrientation): boolean {
    return targetRotation === RotationConstants.ROTATION_180 &&
      SCBSceneOrientationUtils.isOrientationAllowPortraitInverted(orientation);
  }

  /**
   * Judge the orientation is allowed inverted portrait.
   */
  public static isAllowLandscapeInverted(targetRotation: number, orientation: SCBSceneOrientation): boolean {
    return targetRotation === RotationConstants.ROTATION_90 &&
      SCBSceneOrientationUtils.isOrientationAllowLandscapeInverted(orientation);
  }

  /**
   * Judge the orientation is allowed portrait.
   */
  public static isOrientationAllowPortrait(orientation: SCBSceneOrientation): boolean {
    return orientation === SCBSceneOrientation.VERTICAL ||
      SCBSceneOrientationUtils.isOrientationAllowCommonPortrait(orientation);
  }

  /**
   * Judge the orientation is allowed landscape.
   */
  public static isOrientationAllowLandscape(orientation: SCBSceneOrientation): boolean {
    return orientation === SCBSceneOrientation.HORIZONTAL ||
      SCBSceneOrientationUtils.isOrientationAllowCommonLandscape(orientation);
  }

  /**
   * Judge the orientation is allowed inverted portrait.
   */
  public static isOrientationAllowPortraitInverted(orientation: SCBSceneOrientation): boolean {
    return orientation === SCBSceneOrientation.REVERSE_VERTICAL ||
      SCBSceneOrientationUtils.isOrientationAllowCommonPortrait(orientation);
  }

  /**
   * Judge the orientation is allowed inverted landscape.
   */
  public static isOrientationAllowLandscapeInverted(orientation: SCBSceneOrientation): boolean {
    return orientation === SCBSceneOrientation.REVERSE_HORIZONTAL ||
      SCBSceneOrientationUtils.isOrientationAllowCommonLandscape(orientation);
  }

  /**
   * Judge the orientation is allowed landscape or inverted landscape.
   */
  public static isOrientationAllowCommonLandscape(orientation: SCBSceneOrientation): boolean {
    return orientation === SCBSceneOrientation.SENSOR_HORIZONTAL ||
      orientation === SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED ||
      SCBSceneOrientationUtils.isOrientationAllowAllRotation(orientation);
  }

  /**
   * Judge the orientation is allowed portrait or inverted portrait.
   */
  public static isOrientationAllowCommonPortrait(orientation: SCBSceneOrientation): boolean {
    return orientation === SCBSceneOrientation.SENSOR_VERTICAL ||
      orientation === SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED ||
      SCBSceneOrientationUtils.isOrientationAllowAllRotation(orientation);
  }

  /**
   * Judge the orientation is allowed all rotation.
   */
  public static isOrientationAllowAllRotation(orientation: SCBSceneOrientation): boolean {
    return orientation === SCBSceneOrientation.SENSOR || orientation === SCBSceneOrientation.LOCKED ||
      orientation === SCBSceneOrientation.FOLLOW_RECENT || orientation === SCBSceneOrientation.AUTO_ROTATION_RESTRICTED;
  }
}