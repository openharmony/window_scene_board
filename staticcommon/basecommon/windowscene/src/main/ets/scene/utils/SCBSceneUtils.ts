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

import { SCBSceneInfo } from '../session/SCBSceneInfo';
import { SCBSceneOrientation } from '../session/SCBSceneOrientation';
import { SCBSceneSession } from '../session/SCBSceneSession';
import { isLargeFoldProductInExpand } from '../session/SCBDividerParam';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { SCBSceneSessionManager } from '../session/SCBSceneSessionManager';
import { LogDomain, Logger } from '@ohos/basicutils';
import { WindowMode } from '../../windowmanager/ASCFWindowManager'
import { RotationConstants } from '@ohos/commonconstants';
import lazy { SCBTriFoldManager } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import lazy { SCBSplitUtils } from './SCBSplitUtils';
import { CommonUtils } from '@ohos/basicutils';
import BundleManager from '@ohos.bundle.bundleManager';
import { bundleManager } from '@kit.AbilityKit';

const TAG = 'SCBSceneUtils';
const log = Logger.getLogHelper(LogDomain.WINDOW);

type NullableSceneSession = SCBSceneSession | null | undefined;

export class SCBSceneUtils {

  /**
   * Judge the scene whether phone call related.
   *
   * @param sceneInfo SCBSceneInfo
   * @returns whether phone call scene
   */
  public static isPhoneCallScene(sceneInfo: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      return false;
    }
    //这里包名错了
    const phoneSceneList = [
      { bundleName: 'com.ohos.emergencycommunication', moduleName: '', abilityName: 'com.ohos.emergencycommunication.EmergencyCallAbility', appIndex: 0 },
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
   * Is landscape app
   *
   * @param sceneSession SCBSceneSession
   * @returns true is landscape app, otherwise not
   */
  public static isLandscapeApp(scene: SCBSceneSession | SCBSceneInfo): boolean {
    if (scene == null) {
      return false;
    }
    let orientation = SCBSceneOrientation.UNSPECIFIED;
    if (scene instanceof SCBSceneSession) {
      orientation = scene.requestOrientation;
    } else if (scene instanceof SCBSceneInfo) {
      orientation = SCBSceneSessionManager.getInstance()
        .getAbilityOrientation(scene.bundleName, scene.moduleName, scene.abilityName);
    }
    log.showInfo(TAG, `isLandscapeApp orientation:${orientation}`);
    return orientation === SCBSceneOrientation.USER_ROTATION_LANDSCAPE ||
      orientation === SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED ||
      orientation === SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED ||
      orientation === SCBSceneOrientation.HORIZONTAL ||
      orientation === SCBSceneOrientation.REVERSE_HORIZONTAL ||
      orientation === SCBSceneOrientation.SENSOR_HORIZONTAL;
  }

  /**
   * Is folded with fixed multi window orientation
   *
   * @param sceneSession SCBSceneSession
   * @returns true is folded with fixed multi window orientation, otherwise not
   */
  public static disableSupportSplitWithFixedMultiWindowOrientation(sceneSession: SCBSceneSession,
    isForceSupport: boolean = false): boolean {
    if (sceneSession == null) {
      return false;
    }
    // 强开应用横屏和应用设置preferMultiWindowOrientation属性为固定LANDSCAPE/PORTRAIT相同效果
    let isForceSupportLandscape = isForceSupport && SCBSceneUtils.isLandscapeApp(sceneSession);
    let isFixedMultiWindowOrientation = sceneSession.isFixedMultiWindowOrientation || isForceSupportLandscape;
    let disableSupportSplit = false;
    if (DeviceHelper.isThreeFoldProduct()) {
      // 直板机形态或者两折叠机折叠态或者三折叠F态 以及三折叠G态横屏 禁用分屏
      // 双折叠展开态 三折叠M态&g态竖屏 三折叠固定分屏比例 不做禁用
      disableSupportSplit = !(isLargeFoldProductInExpand() || this.isSessionInPortraitWithGState(sceneSession) ||
        SCBSplitUtils.isFixedSplitRatioScene(sceneSession.sceneInfo));
    } else {
      // 双折叠展开态
      disableSupportSplit = !(SCBSceneSessionManager.isLargeInFoldProduct() &&
      SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
    }
    log.showInfo(TAG, `disableSupportSplitWithFixedMultiWindowOrientation disableSupportSplit:${disableSupportSplit} ` +
      `isFixedMultiWindowOrientation:${isFixedMultiWindowOrientation}`);
    return isFixedMultiWindowOrientation && disableSupportSplit;
  }

  private static isSessionInPortraitWithGState(sceneSession: SCBSceneSession): boolean {
    if (sceneSession == null) {
      return false;
    }
    if (!DeviceHelper.isThreeFoldProduct()) {
      return false;
    }
    let container = SCBSceneSessionManager.getInstance()
      .getSceneContainerSessionFromScenePanel(sceneSession.persistentId, sceneSession.screenId);
    if (container == null) {
      return false;
    }
    let isPortrait = container.currentRotation === RotationConstants.ROTATION_90 ||
      container.currentRotation === RotationConstants.ROTATION_270;
    log.showDebug(TAG, `isSessionInPortraitWithGState isPortrait:${isPortrait} rotation:${container.currentRotation}`);
    return SCBTriFoldManager.getInstance().isCurGState() && isPortrait;
  }

  /**
   * 应用是否设置PreferMultiWindowOrientation为LANDSCAPE或PORTRAIT 或者强开横屏应用
   *
   * @param sceneSession SCBSceneSession
   * @returns { boolean }
   */
  public static isFixedMultiWindowOrientation(sceneSession: SCBSceneSession): boolean {
    if (sceneSession == null) {
      return false;
    }
    let isForceSupportLandscape =
      SCBSceneSessionManager.getInstance().isOpenInMultiWindowForceSupportList(sceneSession.sceneInfo.bundleName) &&
      SCBSceneUtils.isLandscapeApp(sceneSession);
    return sceneSession.isFixedMultiWindowOrientation || isForceSupportLandscape;
  }

  /**
   * check whether sessions start from virtual ability
   * @param sessions
   * @returns
   */
  public static isStartFromVirtual(...sessions: NullableSceneSession[]): boolean {
    for (let session of sessions) {
      let isVirtual = this.getParamBySceneInfo(session?.sceneInfo?.want?.parameters,
        'isVirtual');
      if (CommonUtils.isBoolean(isVirtual) && isVirtual &&
      this.isSystemApp(session?.sceneInfo?.bundleName)) {
        return true;
      }

    }
    return false;
  }

  private static getParamBySceneInfo(parameters: Record<string, Object> | undefined, key: string): Object | undefined {
    if (!parameters) {
      return undefined;
    }
    if (!this.hasParam(parameters, key)) {
      return undefined;
    }
    let param: Object | undefined = parameters[key];
    return param;
  }

  private static hasParam(parameters: Record<string, Object> | undefined, key: string): boolean {
    return !!parameters && !!parameters[key];
  }


  private static isSystemApp(bundleName: string = ''): boolean {
    try {
      let bundleFlag = BundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
      let applicationInfo = BundleManager.getApplicationInfoSync(bundleName, bundleFlag);
      return !!applicationInfo && applicationInfo.systemApp;
    } catch (error) {
      log.showError(TAG, `isSystemApp getApplicationInfoSync error: ${error}`);
      return false;
    }
  }
}

export class MissionManagementTraceUtil {
  static readonly START_SCENE_FROM_ICON: string = 'startSceneFromIcon';
  static readonly START_SCENE_TRANSITION: string = 'startSceneTransition';
  static readonly START_SCENE_BY_CALL: string = 'startSceneByCall';
  static readonly MINIMIZE_SCENE: string = 'minimizeScene';
  static readonly MINIMIZE_ALL_SCENE: string = 'minimizeAllScene';
  static readonly TERMINATE_SCENE: string = 'terminateScene';
  static readonly SESSION_EXCEPTION: string = 'sessionException';

  static readonly MINIMIZE_SCENE_ON_SPECIAL: string = 'minimizeSceneOnSpecial';
  static readonly MINIMIZE_ALL_SCENE_ON_SPECIAL: string = 'minimizeAllSceneOnSpecial';
  static readonly TERMINATE_SCENE_ON_SPECIAL: string = 'terminateSceneOnSpecial';
  static readonly SESSION_EXCEPTION_ON_SPECIAL: string = 'sessionExceptionOnSpecial';

  static readonly ACTIVE_SCENE: string = 'activeScene';
  static readonly ACTIVE_SCENE_BY_CALL: string = 'activeSceneByCall';
  static readonly BACKGROUND_SCENE: string = 'backgroundScene';
  static readonly DESTRUCT_SCENE: string = 'destructScene';
  static readonly REQUEST_NEW_SESSION: string = 'requestNewSession';
}

export enum CommonResultCode {
  INIT = 0,
  SUCCESS = 1,
  FAIL = 2
}

export class CommonResult {
  static SUCCESS = new CommonResult(CommonResultCode.SUCCESS);
  static FAIL = new CommonResult(CommonResultCode.FAIL);
  private resultCode_: CommonResultCode;
  private resultMessage_: string;

  constructor(resultCode: CommonResultCode = CommonResultCode.INIT, resultMessage: string = '') {
    this.resultCode_ = resultCode;
    this.resultMessage_ = resultMessage;
  }

  get resultCode(): CommonResultCode { return this.resultCode_; }
  get resultMessage(): string { return this.resultMessage_; }
  public isSuccess(): boolean { return this.resultCode_ === CommonResultCode.SUCCESS; }
  public isFail(): boolean { return this.resultCode_ >= CommonResultCode.FAIL; }
}

// 用于方法返回参数已被使用，使用入参作为方法返回结果的情况
export class CommonResultWrapper {
  constructor(result: CommonResult) {
    this.result = result;
  }
  public result : CommonResult;
}