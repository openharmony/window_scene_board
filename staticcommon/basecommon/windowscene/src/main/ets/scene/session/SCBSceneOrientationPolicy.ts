/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { SCBScreenSession } from '../../screen/session/SCBScreenSession';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBSceneOrientationPolicy';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export abstract class SCBSceneOrientationPolicy {

  public abstract getTargetRotation(sensorRotation: number, currentScreenRotation: number,
    isScreenLocked: boolean, fromUser: boolean, isPlacedRotateFriendlyDevicePlaced: boolean): number;

  /**
   * parse rotation policy into map
   *
   * @param { defaultRotationPolicy } defaultRotationPolicy
   * @returns { Map<number, boolean> }
   */
  public static parseRotationPolicy(defaultRotationPolicy: string): Map<number, boolean> {
    let tmpPolicyMap: Map<number, boolean> = new Map([
      [RotationConstants.ROTATION_0, false],
      [RotationConstants.ROTATION_90, false],
      [RotationConstants.ROTATION_180, false],
      [RotationConstants.ROTATION_270, false]
    ]);
    let rotationPolicyInt: number = parseInt(defaultRotationPolicy, 10);
    if (isNaN(rotationPolicyInt)) {
      return tmpPolicyMap;
    }
    let arr: boolean[] = [];
    for (let idx = 0; idx < tmpPolicyMap.size; idx++) {
      if (rotationPolicyInt > 0) {
        let remainder = rotationPolicyInt % 2;
        if (remainder === 1) {
          arr.push(true);
        } else {
          arr.push(false);
        }
        rotationPolicyInt = Math.floor(rotationPolicyInt / 2);
      } else {
        arr.push(false);
      }
    }
    tmpPolicyMap.set(RotationConstants.ROTATION_0, arr[0]);
    tmpPolicyMap.set(RotationConstants.ROTATION_90, arr[1]);
    tmpPolicyMap.set(RotationConstants.ROTATION_180, arr[2]);
    tmpPolicyMap.set(RotationConstants.ROTATION_270, arr[3]);
    return tmpPolicyMap;
  }

  /**
   * parse orientation is auto-rotation-unspecified rotation policy into map
   * RotationConstants.ROTATION_0 must be true
   * @param { defaultRotationPolicy } defaultRotationPolicy
   * @returns { Map<number, boolean> }
   */
  public static parseAutoRotationUnspecifiedRotationPolicy(defaultRotationPolicy: string): Map<number, boolean> {
    let tmpRotationPolicyMap: Map<number, boolean> = new Map([
      [RotationConstants.ROTATION_0, true],
      [RotationConstants.ROTATION_90, true],
      [RotationConstants.ROTATION_180, false],
      [RotationConstants.ROTATION_270, true]
    ]);
    let policyMap = SCBSceneOrientationPolicy.parseRotationPolicy(defaultRotationPolicy);
    if (!policyMap.get(RotationConstants.ROTATION_0)) {
      return tmpRotationPolicyMap;
    }
    return policyMap;
  }

}

export class SCBFollowDesktopOrientationPolicy extends SCBSceneOrientationPolicy {
  rotationPolicyMap: Map<number, boolean> = new Map([
    [RotationConstants.ROTATION_0, true],
    [RotationConstants.ROTATION_90, false],
    [RotationConstants.ROTATION_180, false],
    [RotationConstants.ROTATION_270, false]
  ]);

  public setRotationPolicy(up: boolean, down: boolean, left: boolean, right: boolean): void {
    this.rotationPolicyMap.set(RotationConstants.ROTATION_0, down);
    this.rotationPolicyMap.set(RotationConstants.ROTATION_90, right);
    this.rotationPolicyMap.set(RotationConstants.ROTATION_180, up);
    this.rotationPolicyMap.set(RotationConstants.ROTATION_270, left);
  }

  public getTargetRotation(sensorRotation: number, currentScreenRotation: number,
    isScreenLocked: boolean, fromUser: boolean = false, isPlacedRotateFriendlyDevicePlaced: boolean = false): number {
    log.showInfo('SCBFollowDesktopOrientationPolicy: ' + ' currentScreenRotation: ' + currentScreenRotation +
      ' sensorRotation: ' + sensorRotation + ' isScreenLocked: ' + isScreenLocked + ' fromUser: ' + fromUser +
      ' isPlacedRotateFriendlyDevicePlaced: ' + isPlacedRotateFriendlyDevicePlaced);
    if (isPlacedRotateFriendlyDevicePlaced) {
      if (this.rotationPolicyMap.get(currentScreenRotation)) {
        return currentScreenRotation;
      }
      if (!isScreenLocked && this.rotationPolicyMap.get(sensorRotation)) {
        return sensorRotation;
      }
    } else {
      if (!isScreenLocked && this.rotationPolicyMap.get(sensorRotation)) {
        return sensorRotation;
      }

      if (this.rotationPolicyMap.get(currentScreenRotation)) {
        return currentScreenRotation;
      }
    }
    return RotationConstants.ROTATION_0;
  }

  public getRotationPolicyMap(): Map<number, boolean> {
    return this.rotationPolicyMap;
  }

  /**
   * Get the singleton of the SCBFollowDesktopOrientationPolicy.
   */
  static getInstance(): SCBFollowDesktopOrientationPolicy {
    if (!globalThis.SCBFollowDesktopPolicyInstance) {
      globalThis.SCBFollowDesktopPolicyInstance = new SCBFollowDesktopOrientationPolicy();
    }
    return globalThis.SCBFollowDesktopPolicyInstance;
  }

}

export class SCBDefaultOrientationPolicy extends SCBSceneOrientationPolicy {
  private rotationPolicyMap: Map<number, boolean> = new Map([
    [RotationConstants.ROTATION_0, true],
    [RotationConstants.ROTATION_90, false],
    [RotationConstants.ROTATION_180, false],
    [RotationConstants.ROTATION_270, false]
  ]);
  private expandRotationPolicyMap: Map<number, boolean> = new Map([
    [RotationConstants.ROTATION_0, true],
    [RotationConstants.ROTATION_90, false],
    [RotationConstants.ROTATION_180, false],
    [RotationConstants.ROTATION_270, false]
  ]);
  private expandDoubleRotationPolicyMap: Map<number, boolean> = new Map([
    [RotationConstants.ROTATION_0, true],
    [RotationConstants.ROTATION_90, false],
    [RotationConstants.ROTATION_180, false],
    [RotationConstants.ROTATION_270, false]
  ]);

  /**
   * Get the singleton of the SCBDefaultOrientationPolicy.
   */
  public static getInstance(): SCBDefaultOrientationPolicy {
    if (!globalThis.SCBDefaultOrientationPolicyInstance) {
      globalThis.SCBDefaultOrientationPolicyInstance = new SCBDefaultOrientationPolicy();
    }
    return globalThis.SCBDefaultOrientationPolicyInstance;
  }

  /**
   * parse default rotation policy (unspecified) config
   *
   * @param { defaultRotationPolicy } defaultRotationPolicy
   */
  public parseDefaultRotationPolicyConfig(defaultRotationPolicy: string): void {
    if (defaultRotationPolicy !== null && defaultRotationPolicy !== undefined && defaultRotationPolicy !== '') {
      let defaultRotationPolicyArray: string[] = defaultRotationPolicy.split(',');
      if (defaultRotationPolicyArray.length === 1) {
        this.rotationPolicyMap = SCBDefaultOrientationPolicy.parseRotationPolicy(defaultRotationPolicyArray[0]);
      } else if (defaultRotationPolicyArray.length === 2) {
        this.rotationPolicyMap = SCBDefaultOrientationPolicy.parseRotationPolicy(defaultRotationPolicyArray[0]);
        this.expandRotationPolicyMap = SCBDefaultOrientationPolicy.parseRotationPolicy(defaultRotationPolicyArray[1]);
      } else if (defaultRotationPolicyArray.length === 3) {
        this.rotationPolicyMap = SCBDefaultOrientationPolicy.parseRotationPolicy(defaultRotationPolicyArray[0]);
        this.expandRotationPolicyMap = SCBDefaultOrientationPolicy.parseRotationPolicy(defaultRotationPolicyArray[1]);
        this.expandDoubleRotationPolicyMap =
          SCBDefaultOrientationPolicy.parseRotationPolicy(defaultRotationPolicyArray[2]);
      }
    }
  }

  /**
   * get default rotation Policy map
   *
   * @returns { Map<number, boolean> }
   */
  public getRotationPolicyMap(): Map<number, boolean> {
    let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, 'getRotationPolicyMap screenSession is null.');
      return this.rotationPolicyMap;
    }
    if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      return this.expandDoubleRotationPolicyMap;
    }
    if (screenSession.isFoldablePhoneExpandStatus()) {
      return this.expandRotationPolicyMap;
    }
    return this.rotationPolicyMap;
  }

  /**
   * get target rotation
   *
   * @param { sensorRotation } sensorRotation
   * @param { currentScreenRotation } currentScreenRotation
   * @param { isScreenLocked } isScreenLocked
   * @param { fromUser } fromUser
   * @returns { number }
   */
  public getTargetRotation(sensorRotation: number, currentScreenRotation: number,
    isScreenLocked: boolean, fromUser: boolean = false, isPlacedRotateFriendlyDevicePlaced: boolean = false): number {
    log.showInfo(`SCBDefaultOrientationPolicy: currentScreenRotation: ${currentScreenRotation}` +
      `, sensorRotation: ${sensorRotation}, isScreenLocked: ${isScreenLocked}, fromUser: ${fromUser}` +
      `, isPlacedRotateFriendlyDevicePlaced: ${isPlacedRotateFriendlyDevicePlaced}`);
    let policyMap: Map<number, boolean> = this.getRotationPolicyMap();
    if (isPlacedRotateFriendlyDevicePlaced) {
      if (policyMap.get(currentScreenRotation)) {
        return currentScreenRotation;
      }
      if (!isScreenLocked && policyMap.get(sensorRotation)) {
        return sensorRotation;
      }
    } else {
      if (!isScreenLocked && policyMap.get(sensorRotation)) {
        return sensorRotation;
      }
      if (policyMap.get(currentScreenRotation)) {
        return currentScreenRotation;
      }
    }
    let defaultRotation = RotationConstants.ROTATION_0;
    let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      log.showError('SCBDefaultOrientationPolicy getMainScreenSession is null');
      return defaultRotation;
    }
    defaultRotation = screenSession.scbScreenProperty.getDefaultRotation();
    if (policyMap.get(defaultRotation)) {
      return defaultRotation;
    }
    for (let rotation of policyMap.keys()) {
      if (policyMap.get(rotation)) {
        return rotation;
      }
    }
    return defaultRotation;
  }

  /**
   * judge if unrelated to rotate locked
   *
   * @returns { boolean }
   */
  public isRotateLockedUnrelated(): boolean {
    let rotationMap: Map<number, boolean> = this.getRotationPolicyMap();
    if (rotationMap.get(RotationConstants.ROTATION_90) ||
      rotationMap.get(RotationConstants.ROTATION_180) ||
      rotationMap.get(RotationConstants.ROTATION_270)) {
      return false;
    }
    return true;
  }

}
